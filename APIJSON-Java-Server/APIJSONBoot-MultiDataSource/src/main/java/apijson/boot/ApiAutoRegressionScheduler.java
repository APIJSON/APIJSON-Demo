package apijson.boot;

import apijson.Log;
import apijson.demo.DemoParser;
import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONObject;
import jakarta.servlet.ServletContext;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.ObjectProvider;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClientResponseException;

import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Enumeration;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicBoolean;

import static org.springframework.http.HttpHeaders.COOKIE;
import static org.springframework.http.HttpHeaders.SET_COOKIE;

@Service
public class ApiAutoRegressionScheduler {
    private static final String TAG = "ApiAutoRegressionScheduler";
    private static final DateTimeFormatter TIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    private final ApiAutoNodeProcessSupervisor nodeProcessSupervisor;
    private final ObjectProvider<JavaMailSender> mailSenderProvider;
    private final AtomicBoolean running = new AtomicBoolean(false);

    @Value("${apijson.auto-test.enabled:true}")
    private boolean enabled;
    @Value("${apijson.auto-test.start-url:http://localhost:3000/test/start}")
    private String startUrl;
    @Value("${apijson.auto-test.status-url:http://localhost:3000/test/status}")
    private String statusUrl;
    @Value("${apijson.auto-test.report-host:http://localhost:8080}")
    private String reportHost;
    @Value("${apijson.auto-test.poll-interval-millis:15000}")
    private long pollIntervalMillis;
    @Value("${apijson.auto-test.timeout-minutes:180}")
    private long timeoutMinutes;
    @Value("${apijson.auto-test.mail.from:}")
    private String mailFrom;
    @Value("${apijson.auto-test.mail.to:}")
    private String mailTo;
    @Value("${apijson.auto-test.mail.subject-prefix:[APIJSON]}")
    private String subjectPrefix;
    @Value("${apijson.auto-test.zone:Asia/Shanghai}")
    private String zone;

    public ApiAutoRegressionScheduler(ApiAutoNodeProcessSupervisor nodeProcessSupervisor,
                                      ObjectProvider<JavaMailSender> mailSenderProvider) {
        this.nodeProcessSupervisor = nodeProcessSupervisor;
        this.mailSenderProvider = mailSenderProvider;
    }

    @Scheduled(cron = "${apijson.auto-test.cron:0 0 10,20 * * *}", zone = "${apijson.auto-test.zone:Asia/Shanghai}")
    public void runScheduledApiRegression() {
        if (!enabled) {
            return;
        }
        if (!running.compareAndSet(false, true)) {
            Log.w(TAG, "已有 API 回归测试任务在执行，跳过本次调度");
            return;
        }

        TestExecutionResult result;
        try {
            nodeProcessSupervisor.ensureRunning();
            result = executeRegressionTest(resolveZoneId());
        } catch (Throwable e) {
            e.printStackTrace();
            result = TestExecutionResult.failed(resolveZoneId(), extractErrorMessage(e));
        }

        try {
            sendReportEmail(result);
        } finally {
            running.set(false);
        }
    }

    private TestExecutionResult executeRegressionTest(ZoneId zoneId) {
        TestExecutionResult result = new TestExecutionResult();
        result.startedAt = LocalDateTime.now(zoneId);
        result.key = buildTestKey();

        BackgroundHttpSession session = new BackgroundHttpSession("auto-api-test-" + UUID.randomUUID());
        DemoParser.KEY_MAP.put(result.key, session);

        try {
            doGet(session, appendQueryParam(startUrl, "key", result.key));

            long deadline = System.currentTimeMillis() + Math.max(timeoutMinutes, 1L) * 60_000L;
            while (System.currentTimeMillis() < deadline) {
                result.statusResponseBody = doGet(session, statusUrl);
                result.status = parseObject(result.statusResponseBody);
                if (result.status != null) {
                    result.progress = readDecimal(result.status, "progress");
                    result.reportId = readLong(result.status, "reportId");
                    if (result.progress != null && result.progress.compareTo(BigDecimal.ONE) >= 0) {
                        break;
                    }
                }
                sleep(Math.max(pollIntervalMillis, 1000L));
            }

            if (result.progress == null || result.progress.compareTo(BigDecimal.ONE) < 0) {
                result.errorMessage = "轮询 /api/test/status 超时，" + timeoutMinutes + " 分钟内 progress 未达到 1";
            }
        } catch (Throwable e) {
            result.errorMessage = extractErrorMessage(e);
            Log.e(TAG, "执行定时 API 回归测试失败: " + result.errorMessage);
        } finally {
            DemoParser.KEY_MAP.remove(result.key);
            try {
                session.invalidate();
            } catch (Throwable ignore) {
            }
            result.finishedAt = LocalDateTime.now(zoneId);
        }

        Log.d(TAG, "定时 API 回归测试结束: " + buildBriefDescription(result));
        return result;
    }

    private String doGet(HttpSession session, String url) {
        HttpHeaders headers = new HttpHeaders();
        headers.setAccept(List.of(MediaType.APPLICATION_JSON, MediaType.TEXT_PLAIN));

        List<String> cookies = currentCookies(session);
        if (!cookies.isEmpty()) {
            headers.put(COOKIE, new ArrayList<>(cookies));
        }

        try {
            ResponseEntity<String> entity = DemoController.CLIENT.exchange(url, HttpMethod.GET, new HttpEntity<>(headers), String.class);
            storeCookies(session, entity.getHeaders());
            return entity.getBody();
        } catch (RestClientResponseException e) {
            storeCookies(session, e.getResponseHeaders());
            String responseBody = e.getResponseBodyAsString();
            throw new IllegalStateException(isBlank(responseBody) ? e.getMessage() : responseBody, e);
        }
    }

    private void storeCookies(HttpSession session, HttpHeaders headers) {
        if (session == null || headers == null) {
            return;
        }
        List<String> setCookies = headers.get(SET_COOKIE);
        if (setCookies != null && !setCookies.isEmpty()) {
            session.setAttribute(COOKIE, new ArrayList<>(setCookies));
        }
    }

    private List<String> currentCookies(HttpSession session) {
        if (session == null) {
            return Collections.emptyList();
        }
        Object cookieObj = session.getAttribute(COOKIE);
        if (!(cookieObj instanceof List<?> rawList)) {
            return Collections.emptyList();
        }

        List<String> cookies = new ArrayList<>();
        for (Object item : rawList) {
            if (item != null) {
                cookies.add(String.valueOf(item));
            }
        }
        return cookies;
    }

    private void sendReportEmail(TestExecutionResult result) {
        String[] recipients = parseRecipients(mailTo);
        if (recipients.length <= 0) {
            Log.w(TAG, "未配置 apijson.auto-test.mail.to，跳过发送测试报告邮件");
            return;
        }

        JavaMailSender mailSender = mailSenderProvider.getIfAvailable();
        if (mailSender == null) {
            Log.e(TAG, "未找到 JavaMailSender，无法发送测试报告邮件");
            return;
        }

        try {
            var message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, false, StandardCharsets.UTF_8.name());
            if (!isBlank(mailFrom)) {
                helper.setFrom(mailFrom.trim());
            }
            helper.setTo(recipients);
            helper.setSubject(buildMailSubject(result));
            helper.setText(buildMailHtml(result), true);
            mailSender.send(message);
        } catch (Throwable e) {
            e.printStackTrace();
            Log.e(TAG, "发送 API 回归测试邮件失败: " + extractErrorMessage(e));
        }
    }

    private String buildMailSubject(TestExecutionResult result) {
        StringBuilder subject = new StringBuilder();
        if (!isBlank(subjectPrefix)) {
            subject.append(subjectPrefix.trim()).append(' ');
        }
        subject.append("API 接口回归测试");
        subject.append(result.errorMessage == null ? "完成" : "失败");
        if (result.reportId != null) {
            subject.append(" - reportId=").append(result.reportId);
        }
        return subject.toString();
    }

    private String buildMailHtml(TestExecutionResult result) {
        StringBuilder html = new StringBuilder();
        html.append("<p>").append(escapeHtml(buildBriefDescription(result))).append("</p>");
        html.append("<ul>");
        appendListItem(html, "开始时间", formatTime(result.startedAt));
        appendListItem(html, "结束时间", formatTime(result.finishedAt));
        appendListItem(html, "耗时", formatDuration(result.duration()));
        appendListItem(html, "progress", formatProgress(result.progress));
        appendListItem(html, "reportId", result.reportId);
        appendListItem(html, "状态消息", firstLine(result.message()));
        appendListItem(html, "异常信息", result.errorMessage);
        html.append("</ul>");

        String reportUrl = buildReportUrl(result);
        if (!isBlank(reportUrl)) {
            html.append("<p><a href=\"")
                    .append(escapeHtml(reportUrl))
                    .append("\">")
                    .append(escapeHtml(reportUrl))
                    .append("</a></p>");
        }

        return html.toString();
    }

    private void appendListItem(StringBuilder html, String label, Object value) {
        if (value == null) {
            return;
        }
        String text = String.valueOf(value);
        if (isBlank(text)) {
            return;
        }
        html.append("<li>")
                .append(escapeHtml(label))
                .append(": ")
                .append(escapeHtml(text))
                .append("</li>");
    }

    private String buildBriefDescription(TestExecutionResult result) {
        StringBuilder description = new StringBuilder(result.errorMessage == null
                ? "定时 API 接口回归测试已完成"
                : "定时 API 接口回归测试执行失败");

        String msg = firstLine(result.message());
        if (!isBlank(msg)) {
            description.append("，").append(msg);
        }
        if (result.progress != null) {
            description.append("，progress=").append(formatProgress(result.progress));
        }
        if (result.reportId != null) {
            description.append("，reportId=").append(result.reportId);
        }
        return description.toString();
    }

    private String buildReportUrl(TestExecutionResult result) {
        if (result.reportId != null && result.reportId > 0) {
            String host = trimTrailingSlash(reportHost);
            return host + "/api/index.html?reportId="
                    + URLEncoder.encode(String.valueOf(result.reportId), StandardCharsets.UTF_8);
        }
        return result.link();
    }

    private String[] parseRecipients(String rawRecipients) {
        if (isBlank(rawRecipients)) {
            return new String[0];
        }

        List<String> recipients = new ArrayList<>();
        String[] arr = rawRecipients.split("[,;\\s]+");
        for (String item : arr) {
            if (!isBlank(item)) {
                recipients.add(item.trim());
            }
        }
        return recipients.toArray(String[]::new);
    }

    private String appendQueryParam(String url, String key, String value) {
        String delimiter = url.contains("?") ? "&" : "?";
        return url + delimiter + key + "=" + URLEncoder.encode(value, StandardCharsets.UTF_8);
    }

    private JSONObject parseObject(String body) {
        if (isBlank(body)) {
            return null;
        }
        try {
            return JSON.parseObject(body);
        } catch (Throwable e) {
            return null;
        }
    }

    private BigDecimal readDecimal(JSONObject object, String key) {
        if (object == null) {
            return null;
        }
        Object value = object.get(key);
        if (value == null) {
            return null;
        }
        try {
            return new BigDecimal(String.valueOf(value));
        } catch (Throwable e) {
            return null;
        }
    }

    private Long readLong(JSONObject object, String key) {
        if (object == null) {
            return null;
        }
        Object value = object.get(key);
        if (value == null) {
            return null;
        }
        try {
            return Long.parseLong(String.valueOf(value));
        } catch (Throwable e) {
            return null;
        }
    }

    private String formatProgress(BigDecimal progress) {
        if (progress == null) {
            return null;
        }
        return progress.multiply(BigDecimal.valueOf(100)).stripTrailingZeros().toPlainString() + "%";
    }

    private String formatTime(LocalDateTime time) {
        return time == null ? null : TIME_FORMATTER.format(time);
    }

    private String formatDuration(Duration duration) {
        if (duration == null || duration.isNegative()) {
            return null;
        }
        long seconds = duration.getSeconds();
        long hours = seconds / 3600;
        long minutes = (seconds % 3600) / 60;
        long remainSeconds = seconds % 60;
        return String.format("%02d:%02d:%02d", hours, minutes, remainSeconds);
    }

    private ZoneId resolveZoneId() {
        try {
            return ZoneId.of(zone);
        } catch (Throwable e) {
            return ZoneId.systemDefault();
        }
    }

    private void sleep(long millis) {
        try {
            Thread.sleep(millis);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new IllegalStateException("轮询 API 回归测试状态时被中断", e);
        }
    }

    private String firstLine(String text) {
        if (isBlank(text)) {
            return null;
        }
        int index = text.indexOf('\n');
        return (index < 0 ? text : text.substring(0, index)).trim();
    }

    private String extractErrorMessage(Throwable throwable) {
        if (throwable == null) {
            return null;
        }
        String message = throwable.getMessage();
        if (isBlank(message) && throwable.getCause() != null) {
            message = throwable.getCause().getMessage();
        }
        return isBlank(message) ? throwable.getClass().getSimpleName() : message.trim();
    }

    private String trimTrailingSlash(String value) {
        if (isBlank(value)) {
            return "";
        }
        String trimmed = value.trim();
        while (trimmed.endsWith("/")) {
            trimmed = trimmed.substring(0, trimmed.length() - 1);
        }
        return trimmed;
    }

    private String buildTestKey() {
        return String.valueOf(100000 + Math.round(899999 * Math.random()));
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private String escapeHtml(String value) {
        if (value == null) {
            return "";
        }
        return value
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }

    private static final class TestExecutionResult {
        private LocalDateTime startedAt;
        private LocalDateTime finishedAt;
        private String key;
        private String statusResponseBody;
        private JSONObject status;
        private BigDecimal progress;
        private Long reportId;
        private String errorMessage;

        static TestExecutionResult failed(ZoneId zoneId, String errorMessage) {
            TestExecutionResult result = new TestExecutionResult();
            result.startedAt = LocalDateTime.now(zoneId);
            result.finishedAt = result.startedAt;
            result.errorMessage = errorMessage;
            return result;
        }

        private Duration duration() {
            if (startedAt == null || finishedAt == null) {
                return null;
            }
            return Duration.between(startedAt, finishedAt);
        }

        private String message() {
            return status == null ? null : status.getString("msg");
        }

        private String link() {
            return status == null ? null : status.getString("link");
        }
    }

    private static final class BackgroundHttpSession implements HttpSession {
        private final String id;
        private final long creationTime;
        private final Map<String, Object> attributes = new ConcurrentHashMap<>();

        private long lastAccessedTime;
        private int maxInactiveInterval;
        private boolean invalidated;
        private boolean isNew = true;

        private BackgroundHttpSession(String id) {
            this.id = id;
            this.creationTime = System.currentTimeMillis();
            this.lastAccessedTime = this.creationTime;
        }

        @Override
        public long getCreationTime() {
            checkValid();
            return creationTime;
        }

        @Override
        public String getId() {
            return id;
        }

        @Override
        public long getLastAccessedTime() {
            checkValid();
            return lastAccessedTime;
        }

        @Override
        public ServletContext getServletContext() {
            return null;
        }

        @Override
        public void setMaxInactiveInterval(int interval) {
            this.maxInactiveInterval = interval;
        }

        @Override
        public int getMaxInactiveInterval() {
            return maxInactiveInterval;
        }

        @Override
        public Object getAttribute(String name) {
            touch();
            return attributes.get(name);
        }

        @Override
        public Enumeration<String> getAttributeNames() {
            touch();
            return Collections.enumeration(attributes.keySet());
        }

        @Override
        public void setAttribute(String name, Object value) {
            touch();
            if (value == null) {
                attributes.remove(name);
                return;
            }
            attributes.put(name, value);
        }

        @Override
        public void removeAttribute(String name) {
            touch();
            attributes.remove(name);
        }

        @Override
        public void invalidate() {
            invalidated = true;
            attributes.clear();
        }

        @Override
        public boolean isNew() {
            checkValid();
            return isNew;
        }

        private void touch() {
            checkValid();
            lastAccessedTime = System.currentTimeMillis();
            isNew = false;
        }

        private void checkValid() {
            if (invalidated) {
                throw new IllegalStateException("BackgroundHttpSession 已失效");
            }
        }
    }
}

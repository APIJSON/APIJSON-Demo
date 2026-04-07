package apijson.boot;

import apijson.Log;
import jakarta.annotation.PreDestroy;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@Service
public class ApiAutoNodeProcessSupervisor {
    private static final String TAG = "ApiAutoNodeSupervisor";

    private final Object lock = new Object();
    private volatile Process process;
    private volatile Path logFilePath;

    @Value("${apijson.auto-test.enabled:true}")
    private boolean autoTestEnabled;
    @Value("${apijson.auto-test.node.enabled:true}")
    private boolean enabled;
    @Value("${apijson.auto-test.node.command:node}")
    private String nodeCommand;
    @Value("${apijson.auto-test.node.script:js/server.js}")
    private String nodeScript;
    @Value("${apijson.auto-test.node.working-directory:src/main/resources/static/api}")
    private String nodeWorkingDirectory;
    @Value("${apijson.auto-test.node.startup-timeout-millis:60000}")
    private long startupTimeoutMillis;
    @Value("${apijson.auto-test.status-url:http://localhost:3000/test/status}")
    private String statusUrl;

    @EventListener(ApplicationReadyEvent.class)
    public void startWhenApplicationReady() {
        if (!autoTestEnabled || !enabled) {
            return;
        }
        try {
            ensureRunning();
        } catch (Throwable e) {
            e.printStackTrace();
            Log.e(TAG, "启动 APIAuto Node 守护进程失败: " + e.getMessage());
        }
    }

    @Scheduled(
            fixedDelayString = "${apijson.auto-test.node.health-check-interval-millis:30000}",
            initialDelayString = "${apijson.auto-test.node.health-check-interval-millis:30000}"
    )
    public void keepAlive() {
        if (!autoTestEnabled || !enabled) {
            return;
        }
        try {
            ensureRunning();
        } catch (Throwable e) {
            e.printStackTrace();
            Log.e(TAG, "检查 APIAuto Node 守护进程失败: " + e.getMessage());
        }
    }

    public void ensureRunning() {
        if (!autoTestEnabled || !enabled || isNodeServiceReachable()) {
            return;
        }

        synchronized (lock) {
            if (isNodeServiceReachable()) {
                return;
            }

            Process current = process;
            if (current != null && current.isAlive()) {
                waitUntilReachable();
                return;
            }

            startProcess();
            waitUntilReachable();
        }
    }

    public boolean isNodeServiceReachable() {
        try {
            ResponseEntity<String> response = DemoController.CLIENT.exchange(statusUrl, HttpMethod.GET, HttpEntity.EMPTY, String.class);
            return response.getStatusCode().is2xxSuccessful();
        } catch (Throwable e) {
            return false;
        }
    }

    private void startProcess() {
        Path workingDirectory = resolveWorkingDirectory();
        if (!Files.isDirectory(workingDirectory)) {
            throw new IllegalStateException("Node 工作目录不存在: " + workingDirectory);
        }

        Path scriptPath = workingDirectory.resolve(nodeScript).normalize();
        if (!Files.exists(scriptPath)) {
            throw new IllegalStateException("Node 启动脚本不存在: " + scriptPath);
        }

        if (!Files.isDirectory(workingDirectory.resolve("node_modules"))) {
            Log.w(TAG, "Node 依赖目录不存在，若启动失败请先在 " + workingDirectory + " 下执行 npm install");
        }

        logFilePath = prepareLogFile(workingDirectory);

        ProcessBuilder builder = new ProcessBuilder(nodeCommand, nodeScript);
        builder.directory(workingDirectory.toFile());
        builder.redirectErrorStream(true);
        builder.redirectOutput(ProcessBuilder.Redirect.appendTo(logFilePath.toFile()));

        try {
            process = builder.start();
            Log.d(TAG, "已启动 APIAuto Node 守护进程，pid = " + process.pid());
        } catch (IOException e) {
            throw new IllegalStateException("启动 Node 守护进程失败，请确认已安装 node 并可执行 `" + nodeCommand + " " + nodeScript + "`", e);
        }
    }

    private void waitUntilReachable() {
        long deadline = System.currentTimeMillis() + Math.max(startupTimeoutMillis, 1000L);
        while (System.currentTimeMillis() < deadline) {
            if (isNodeServiceReachable()) {
                return;
            }

            Process current = process;
            if (current != null && !current.isAlive()) {
                process = null;
                throw new IllegalStateException("Node 守护进程启动后立即退出，请检查日志: " + logFilePath);
            }

            sleep(1000L);
        }

        Process current = process;
        if (current != null && current.isAlive()) {
            current.destroy();
        }
        process = null;
        throw new IllegalStateException("等待 Node 守护进程就绪超时，请检查日志: " + logFilePath);
    }

    private Path resolveWorkingDirectory() {
        Path workingDirectory = Paths.get(nodeWorkingDirectory);
        if (!workingDirectory.isAbsolute()) {
            workingDirectory = Paths.get(System.getProperty("user.dir", ".")).resolve(workingDirectory);
        }
        return workingDirectory.normalize();
    }

    private Path prepareLogFile(Path workingDirectory) {
        try {
            Path logDirectory = workingDirectory.resolve("logs");
            Files.createDirectories(logDirectory);
            return logDirectory.resolve("api-auto-node.log");
        } catch (IOException e) {
            throw new IllegalStateException("创建 Node 日志目录失败: " + workingDirectory.resolve("logs"), e);
        }
    }

    private void sleep(long millis) {
        try {
            Thread.sleep(millis);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new IllegalStateException("等待 Node 守护进程启动时被中断", e);
        }
    }

    @PreDestroy
    public void stopManagedProcess() {
        synchronized (lock) {
            Process current = process;
            if (current != null && current.isAlive()) {
                current.destroy();
            }
            process = null;
        }
    }
}

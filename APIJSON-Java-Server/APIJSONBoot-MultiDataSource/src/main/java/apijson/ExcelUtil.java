package apijson;

import com.alibaba.excel.EasyExcel;
import com.alibaba.excel.ExcelWriter;
import com.alibaba.excel.context.AnalysisContext;
import com.alibaba.excel.event.AnalysisEventListener;
import com.alibaba.excel.exception.ExcelGenerateException;
import com.alibaba.excel.support.ExcelTypeEnum;
import com.alibaba.excel.write.metadata.WriteSheet;
import com.alibaba.excel.write.metadata.fill.FillConfig;
import com.alibaba.excel.write.style.column.LongestMatchColumnWidthStyleStrategy;
import org.apache.poi.ss.usermodel.*;

import java.io.File;
import java.io.IOException;
import java.text.DateFormat;
import java.util.*;

import com.alibaba.excel.metadata.data.FormulaData;
import com.alibaba.excel.metadata.data.WriteCellData;
import com.alibaba.excel.write.handler.CellWriteHandler;
import com.alibaba.excel.write.handler.context.CellWriteHandlerContext;
import com.alibaba.excel.write.metadata.style.WriteCellStyle;
import com.alibaba.excel.write.metadata.style.WriteFont;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.ss.util.CellRangeAddressList;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import com.alibaba.excel.write.handler.SheetWriteHandler;
import com.alibaba.excel.write.metadata.holder.WriteSheetHolder;
import com.alibaba.excel.write.metadata.holder.WriteWorkbookHolder;
import org.apache.poi.ss.usermodel.DataValidation;
import org.apache.poi.ss.usermodel.DataValidationConstraint;
import org.apache.poi.ss.usermodel.DataValidationHelper;
import org.apache.poi.ss.usermodel.Sheet;

import java.util.Map;

/**
 * CV AI 图片预测指标报告生成器 (功能增强最终版)
 * - 新增 "核对" 列
 * - 新增 最小、平均、中位、最大 统计
 * - 总览区域与详情数据全公式联动
 */
public class ExcelUtil {

    public static void main(String[] args) throws IOException {
        String fileName = "CVAuto_Report_Enhanced_" + System.currentTimeMillis() + ".xlsx";
        generateCVAutoReport(getMockDetailData(), "", fileName);
        System.out.println("报告生成成功！文件路径: " + fileName);
    }

    // --- 配置常量 ---
    private static final String MAIN_TITLE = "CVAuto 图片预测推理结果导出报告";
    private static final List<String> SUMMARY_HEADERS = Arrays.asList(
            "标签", "目标数", "正确数", "误报数", "漏检数", "召回率", "精准率", "F1 Score", "准确率", "误报率", "漏检率"
    );
    private static final List<Object> DETAIL_HEADERS = Arrays.asList(
            "原图", "渲染图", "目标数", "正确数", "误报数", "漏检数", "JSON 结果", null, null, "核对", "备注"
    );
    // 由于新增了“核对”列，JSON列的索引右移一位
    private static final int JSON_COLUMN_INDEX = 11;


    public static String newCVAutoReportWithTemplate(List<DetailItem> list) throws IOException {
        return newCVAutoReportWithTemplate(list, null);
    }
    public static String newCVAutoReportWithTemplate(List<DetailItem> list, String dir) throws IOException {
        return newCVAutoReportWithTemplate(list, dir,null);
    }
    public static String newCVAutoReportWithTemplate(List<DetailItem> list, String dir, String outputFile) throws IOException {
        return newCVAutoReportWithTemplate(list, dir, outputFile, null);
    }
    public static String newCVAutoReportWithTemplate(List<DetailItem> list, String dir, String outputFile, String templateFile) throws IOException {
//        try {
//            return fillCVAutoReport(list, dir, outputFile, templateFile);
//        } catch (Exception e) {
//            e.printStackTrace();
            return generateCVAutoReport(list, dir, outputFile);
//        }
    }

    public static String fillCVAutoReport(List<DetailItem> list, String dir, String outputFile, String templateFile) throws IOException {
        if (StringUtil.isNotEmpty(dir, false) && ! dir.endsWith(File.separator)) {
            dir += File.separator;
        }

        templateFile = StringUtil.isEmpty(templateFile) ? (dir == null ? "" : dir) + "CVAuto_report_template_separate_sheet.xlsx" : templateFile;   // 事先准备好的模板
        if (StringUtil.isEmpty(outputFile)) {
            outputFile = "CVAuto_report_filled_" + DateFormat.getDateTimeInstance()
                    .format(new Date()).replaceAll(":", "_").replaceAll(",", "_").replaceAll("  ", " ").replaceAll(" ", "_")
                    + ".xlsx"; // 输出结果文件
        }

        File templateObj = new File(templateFile);
        if (!templateObj.exists()) {
            throw new RuntimeException("模板文件不存在: " + templateFile);
        }

        // 第一部分：标签统计数据
        List<LinkedHashMap<String, Object>> summaryList = new ArrayList<>();
        summaryList.add(new LinkedHashMap<String, Object>() {{
            put("标签", "person");
//            put("目标数", Math.round(100*Math.random()));
//            put("正确数", Math.round(70*Math.random()));
//            put("误报数", Math.round(20*Math.random()));
        }});
        summaryList.add(new LinkedHashMap<String, Object>() {{
            put("标签", "car");
//            put("目标数", Math.round(22*Math.random()));
//            put("正确数", Math.round(17*Math.random()));
//            put("误报数", Math.round(0*Math.random()));
        }});
        summaryList.add(new LinkedHashMap<String, Object>() {{
            put("标签", "bike");
//            put("目标数", Math.round(50*Math.random()));
//            put("正确数", Math.round(24*Math.random()));
//            put("误报数", Math.round(13*Math.random()));
        }});

        // 第二部分：图片详情
        List<Map<String, Object>> detailList = new ArrayList<>();
        detailList.add(new LinkedHashMap<String, Object>() {{
            put("原图", "img0.jpg");
            put("渲染图", "img0_res.jpg");
//            put("目标数", Math.round(20*Math.random()));
//            put("正确数", Math.round(10*Math.random()));
//            put("误报数", Math.round(3*Math.random()));
//            put("漏检数", Math.round(10*Math.random()));
            put("JSON 结果", "{\"bboxes\":[{\"id\":1,\"label\":\"person\",\"score\":0.92}]}");
            put("核对", "✔");
            put("备注", "");
        }});
        detailList.add(new LinkedHashMap<String, Object>() {{
            put("原图", "img1.jpg");
            put("渲染图", "img1_res.jpg");
//            put("目标数", Math.round(5*Math.random()));
//            put("正确数", Math.round(4*Math.random()));
//            put("误报数", Math.round(2*Math.random()));
//            put("漏检数", Math.round(1*Math.random()));
            put("JSON 结果", "{\"bboxes\":[{\"id\":1,\"label\":\"person\",\"score\":0.85}]}");
            put("核对", "×");
            put("备注", "");
        }});

        // 读取模板列名（第一行）来保证顺序
        List<String> templateColumns = new ArrayList<>();
        // 读取模板列名
        EasyExcel.read(templateFile)
                .excelType(ExcelTypeEnum.XLSX)  // 强制指定格式
                .sheet(0)
                .headRowNumber(1) // 不使用对象映射，直接按行读取
                .registerReadListener(new AnalysisEventListener<Map<Integer, String>>() {
                    boolean firstRow = true;
                    @Override
                    public void invoke(Map<Integer, String> data, AnalysisContext context) {
                        if (firstRow) {
                            for (int i = 0; i < data.size(); i++) {
                                templateColumns.add(data.get(i));
                            }
                            firstRow = false;
                        }
                    }
                    @Override
                    public void doAfterAllAnalysed(AnalysisContext context) {}
                })
                .doRead();

        // 调整数据顺序
        List<LinkedHashMap<String, Object>> orderedData = new ArrayList<>();
        for (Map<String, Object> row : detailList) {
            LinkedHashMap<String, Object> orderedRow = new LinkedHashMap<>();
            for (String col : templateColumns) {
                orderedRow.put(col, row.getOrDefault(col, ""));
            }
            orderedData.add(orderedRow);
        }

        // 强制新建行
        FillConfig fillConfig = FillConfig.builder().forceNewRow(Boolean.TRUE).build();

        // 使用模板填充
        try (ExcelWriter writer = EasyExcel.write((dir == null ? "" : dir) + outputFile).withTemplate(templateObj).build()) {
            WriteSheet sheet = EasyExcel.writerSheet(0).build();
            WriteSheet sheet2 = EasyExcel.writerSheet(1).build();
            writer.fill(summaryList, fillConfig, sheet);
            writer.fill(orderedData, fillConfig, sheet);
            writer.fill(orderedData, fillConfig, sheet2);
            writer.finish();

            outputFile = (dir == null ? "" : dir) + outputFile;
        } catch (Throwable e) {
            e.printStackTrace();
            String msg = Objects.equals(dir, "") ? null : StringUtil.noBlank(e.getMessage()).toLowerCase();
            if (msg == null || ! (msg.contains("copytemplatefailed") || msg.contains("nosuchfile"))) {
                throw e;
            }

            try {
                // 设置临时目录，避免 macOS 沙盒问题
                System.setProperty("java.io.tmpdir", File.separator + "tmp");
                return fillCVAutoReport(list, Objects.equals(dir, File.separator + "tmp") ? "" : File.separator + "tmp", outputFile, templateFile);
            } catch (Throwable e2) {
                e2.printStackTrace();
                String msg2 = Objects.equals(dir, "") ? null : StringUtil.noBlank(e2.getMessage()).toLowerCase();
                if (msg2 == null || ! (msg2.contains("copytemplatefailed") || msg2.contains("nosuchfile"))) {
                    throw new ExcelGenerateException(e.getMessage(), e2);
                }

                try {
                    return fillCVAutoReport(list, "", outputFile, templateFile);
                } catch (Throwable e3) {
                    e3.printStackTrace();
                    throw new ExcelGenerateException(e.getMessage() + ";  \n" + e2.getMessage(), e3);
                }
            }
        }

        System.out.println("✅ Excel 填充完成: " + outputFile);
        return outputFile;
    }

    public static String generateCVAutoReport(List<DetailItem> list, String dir, String fileName) throws IOException {
        if (StringUtil.isNotEmpty(dir, false) && ! dir.endsWith(File.separator)) {
            dir += File.separator;
        }

        if (StringUtil.isEmpty(fileName)) {
            fileName = (dir == null ? "" : dir) + "CVAuto_report_"
                    + DateFormat.getDateTimeInstance().format(new Date()).replaceAll(":", "_").replaceAll(",", "_").replaceAll("  ", " ").replaceAll(" ", "_")
                    + ".xlsx"; // 输出结果文件
        }

        // 模拟从数据库或服务获取的详情数据
        List<DetailItem> detailItems = list; // getMockDetailData();

        // 动态计算详情区域的表头行索引
        int detailHeaderRowIndex = 1 + 6 + 10; // 标题区(1) + 统计区(标题+6行数据) + 空白行(1) = 17

        List<List<Object>> data = prepareData(detailItems, detailHeaderRowIndex + 2, dir);

        try {
            EasyExcel.write(fileName)
                    .sheet("预测结果报告")
                    .registerWriteHandler(new LongestMatchColumnWidthStyleStrategy())
                    .registerWriteHandler(new CustomMergeAndStyleHandler(detailHeaderRowIndex))
                    .registerWriteHandler(new CheckHandler())
                    .doWrite(data);
        } catch (Throwable e) {
            e.printStackTrace();
            String msg = Objects.equals(dir, "") ? null : StringUtil.noBlank(e.getMessage()).toLowerCase();
            if (msg == null || ! (msg.contains("copytemplatefailed") || msg.contains("nosuchfile"))) {
                throw e;
            }

            try {
                // 设置临时目录，避免 macOS 沙盒问题
                System.setProperty("java.io.tmpdir", File.separator + "tmp");
                return generateCVAutoReport(list, Objects.equals(dir, File.separator + "tmp") ? "" : File.separator + "tmp", fileName);
            } catch (Throwable e2) {
                e2.printStackTrace();
                String msg2 = Objects.equals(dir, "") ? null : StringUtil.noBlank(e2.getMessage()).toLowerCase();
                if (msg2 == null || ! (msg2.contains("copytemplatefailed") || msg2.contains("nosuchfile"))) {
                    throw new ExcelGenerateException(e.getMessage(), e2);
                }

                try {
                    return generateCVAutoReport(list, "", fileName);
                } catch (Throwable e3) {
                    e3.printStackTrace();
                    throw new ExcelGenerateException(e.getMessage() + ";  \n" + e2.getMessage(), e3);
                }
            }
        }

        System.out.println("✅ Excel 已生成：" + fileName);
        return fileName;
    }

    /**
     * 准备报告的所有行数据
     * @param detailItems 详情列表数据
     * @param detailDataStartRow 详情数据在Excel中的起始行号 (1-based)
     * @return 包含所有报告数据的列表
     */
    private static List<List<Object>> prepareData(List<DetailItem> detailItems, int detailDataStartRow, String dir) {
        List<List<Object>> list = new ArrayList<>();

        // --- 第 1 部分：主标题 ---
        list.add(Arrays.asList(MAIN_TITLE));

        // --- 第 2 部分：统计总览 ---
        list.add(new ArrayList<>(SUMMARY_HEADERS));

        // 定义详情数据区域范围，用于统计公式
        int detailDataEndRow = detailDataStartRow + detailItems.size() - 1;
        // 注意：因为新增了“核对”列，详情数据列向右平移
        String targetRange = String.format("C%d:C%d", detailDataStartRow, detailDataEndRow); // 目标数范围
        String correctRange = String.format("D%d:D%d", detailDataStartRow, detailDataEndRow); // 正确数范围
        String fpRange = String.format("E%d:E%d", detailDataStartRow, detailDataEndRow);      // 误报数范围

        // 动态生成每一行统计数据
        list.add(createSummaryRow("总计", "SUM", 3, targetRange, correctRange, fpRange));
        list.add(createSummaryRow("最小", "MIN", 4, targetRange, correctRange, fpRange));
        list.add(createSummaryRow("平均", "AVERAGE", 5, targetRange, correctRange, fpRange));
        list.add(createSummaryRow("中位", "MEDIAN", 6, targetRange, correctRange, fpRange));
        list.add(createSummaryRow("最大", "MAX", 7, targetRange, correctRange, fpRange));

        for (int i = 0; i < 10; i++) {
            list.add(new ArrayList<>()); // 空行
        }

        // --- 第 3 部分：详情列表 ---
        list.add(DETAIL_HEADERS);

        for (int i = 0; i < detailItems.size(); i++) {
            DetailItem item = detailItems.get(i);
            int currentRow = detailDataStartRow + i;

            List<Object> detailRow = new ArrayList<>();
            // A-C: 基础信息
            File imgFile = new File(item.getImageName()); // dir + item.getImageName());
            File renderFile = new File(item.getRenderName()); // dir + item.getRenderName());

            detailRow.add(imgFile.exists() ? imgFile : imgFile.getAbsolutePath());
            detailRow.add(renderFile.exists() ? renderFile : renderFile.getAbsolutePath());
            // D-F: 手动输入数据
            detailRow.add(item.getTargetCount());
            detailRow.add(item.getCorrectCount());
            detailRow.add(item.getFalsePositiveCount());
            // G-M: 公式计算列 (注意所有列号都已更新)
            detailRow.add(createFormulaCell(String.format("C%d-D%d", currentRow, currentRow))); // G: 漏检数
//            detailRow.add(createFormulaCell(String.format("IFERROR(E%d/D%d,0)", currentRow, currentRow))); // H: 召回率
//            detailRow.add(createFormulaCell(String.format("IFERROR(E%d/(E%d+F%d),0)", currentRow, currentRow, currentRow))); // I: 精准率
//            detailRow.add(createFormulaCell(String.format("IFERROR(2*I%d*H%d/(I%d+H%d),0)", currentRow, currentRow, currentRow, currentRow))); // J: F1 Score
//            detailRow.add(createFormulaCell(String.format("H%d", currentRow))); // K: 准确率
//            detailRow.add(createFormulaCell(String.format("IFERROR(F%d/D%d,0)", currentRow, currentRow))); // L: 误报率
//            detailRow.add(createFormulaCell(String.format("IFERROR(G%d/D%d,0)", currentRow, currentRow))); // M: 漏检率
            detailRow.add(item.getJsonResult()); // N-O: JSON结果
            detailRow.add(null);
            detailRow.add(null);

            detailRow.add(item.getCheckMark()); // 新增：核对列
            detailRow.add(item.getRemark());
            list.add(detailRow);
        }
        return list;
    }

    /**
     * 辅助方法：创建一行统计数据
     */
    private static List<Object> createSummaryRow(String label, String function, int currentRow, String targetRange, String correctRange, String fpRange) {
        List<Object> row = new ArrayList<>();
        row.add(label);
        // B, C, D: 使用公式从详情区域统计
        row.add(createFormulaCell(String.format("%s(%s)", function, targetRange)));
        row.add(createFormulaCell(String.format("%s(%s)", function, correctRange)));
        row.add(createFormulaCell(String.format("%s(%s)", function, fpRange)));
        // E-K: 基于本行B,C,D列数据进行计算
        row.add(createFormulaCell(String.format("B%d-C%d", currentRow, currentRow))); // 漏检数
        row.add(createFormulaCell(String.format("IFERROR(C%d/B%d,0)", currentRow, currentRow))); // 召回率
        row.add(createFormulaCell(String.format("IFERROR(C%d/(C%d+D%d),0)", currentRow, currentRow, currentRow))); // 精准率
        row.add(createFormulaCell(String.format("IFERROR(2*G%d*F%d/(G%d+F%d),0)", currentRow, currentRow, currentRow, currentRow))); // F1
        row.add(createFormulaCell(String.format("F%d", currentRow))); // 准确率
        row.add(createFormulaCell(String.format("IFERROR(D%d/B%d,0)", currentRow, currentRow))); // 误报率
        row.add(createFormulaCell(String.format("IFERROR(E%d/B%d,0)", currentRow, currentRow))); // 漏检率
        return row;
    }

    private static WriteCellData<String> createFormulaCell(String formula) {
        WriteCellData<String> cellData = new WriteCellData<>();
        FormulaData formulaData = new FormulaData();
        formulaData.setFormulaValue(formula);
        cellData.setFormulaData(formulaData);
        return cellData;
    }

    private static List<DetailItem> getMockDetailData() {
        List<DetailItem> list = new ArrayList<>();
        list.add(new DetailItem("image_001.jpg", "image_001_render.jpg", 5, 4, 1, "{ \"predictions\": [...] }", "✅", ""));
        list.add(new DetailItem("image_002.jpg", "image_002_render.jpg", 3, 3, 0, "{ \"predictions\": [...] }", "✅", ""));
        list.add(new DetailItem("image_003.jpg", "image_003_render.jpg", 8, 6, 3, "{ \"predictions\": [...] }", "❌", ""));
        list.add(new DetailItem("image_004.jpg", "image_004_render.jpg", 1, 0, 1, "{ \"predictions\": [...] }" ,"❌", ""));
        list.add(new DetailItem("image_005.jpg", "image_005_render.jpg", 10, 10, 0, "{ \"predictions\": [...] }", "✅", ""));
        return list;
    }

    public static class DetailItem {
        private final String imageName;
        private final String renderName;
        private final int targetCount;
        private final int correctCount;
        private final int falsePositiveCount;
        private final String jsonResult;
        private final String checkMark; // 新增
        private final String remark; // 新增

        public DetailItem(String imageName, String renderName, int targetCount, int correctCount, int falsePositiveCount, String jsonResult, String checkMark, String remark) {
            this.imageName = imageName;
            this.renderName = renderName;
            this.targetCount = targetCount;
            this.correctCount = correctCount;
            this.falsePositiveCount = falsePositiveCount;
            this.jsonResult = jsonResult;
            this.checkMark = checkMark;
            this.remark = remark;
        }

        // Getters
        public String getImageName() { return imageName; }
        public String getRenderName() {
            return renderName;
        }
        public int getTargetCount() { return targetCount; }
        public int getCorrectCount() { return correctCount; }
        public int getFalsePositiveCount() { return falsePositiveCount; }
        public String getJsonResult() { return jsonResult; }
        public String getCheckMark() { return checkMark; }
        public String getRemark() {
            return remark;
        }
    }

    /**
     * 自定义处理器，用于样式和合并
     */
    public static class CustomMergeAndStyleHandler implements CellWriteHandler {
        // ... (该类无需修改，内容和之前一样，此处省略以保持最终代码的简洁)
        private final int detailHeaderRowIndex;
        private final WriteCellStyle titleStyle;
        private final WriteCellStyle headerStyle;

        public CustomMergeAndStyleHandler(int detailHeaderRowIndex) {
            this.detailHeaderRowIndex = detailHeaderRowIndex;
            this.titleStyle = createTitleStyle();
            this.headerStyle = createHeaderStyle();
        }

        private WriteCellStyle createTitleStyle() {
            WriteCellStyle style = new WriteCellStyle();
            WriteFont font = new WriteFont();
            font.setFontName("Arial");
            font.setFontHeightInPoints((short) 16);
            font.setBold(true);
            style.setWriteFont(font);
            return style;
        }

        private WriteCellStyle createHeaderStyle() {
            WriteCellStyle style = new WriteCellStyle();
            WriteFont font = new WriteFont();
            font.setFontName("Arial");
            font.setFontHeightInPoints((short) 12);
            font.setBold(true);
            style.setWriteFont(font);
            style.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
            style.setFillPatternType(FillPatternType.SOLID_FOREGROUND);
            return style;
        }

        @Override
        public void afterCellDispose(CellWriteHandlerContext context) {
            Cell cell = context.getCell();
            int rowIndex = cell.getRowIndex();
            int colIndex = cell.getColumnIndex();

            if (rowIndex == 0) {
                if (!context.getCellDataList().isEmpty()) {
                    context.getCellDataList().get(0).setWriteCellStyle(titleStyle);
                }
            } else if ((rowIndex >= 1 && rowIndex <= 7) || rowIndex == detailHeaderRowIndex) {
                if (!context.getCellDataList().isEmpty()) {
                    context.getCellDataList().get(0).setWriteCellStyle(headerStyle);
                }
            }

            if (colIndex == 0) {
                if (rowIndex == 0) {
                    CellRangeAddress region = new CellRangeAddress(rowIndex, rowIndex, 0, DETAIL_HEADERS.size() - 1);
                    context.getWriteSheetHolder().getSheet().addMergedRegionUnsafe(region);
                } else if (rowIndex == detailHeaderRowIndex) {
                    CellRangeAddress region = new CellRangeAddress(rowIndex, rowIndex, JSON_COLUMN_INDEX, JSON_COLUMN_INDEX + 1);
                    context.getWriteSheetHolder().getSheet().addMergedRegionUnsafe(region);
                }
            }

            if (rowIndex > detailHeaderRowIndex && colIndex == JSON_COLUMN_INDEX) {
                CellRangeAddress region = new CellRangeAddress(rowIndex, rowIndex, JSON_COLUMN_INDEX, JSON_COLUMN_INDEX + 1);
                context.getWriteSheetHolder().getSheet().addMergedRegionUnsafe(region);
            }
        }
    }


    public static class CheckHandler implements SheetWriteHandler {
        /**
         * 下拉框值
         */
        String[] options = new String[]{"✅", "❌"};
        private int startIndex = 18;

        /**
         * 多少行有下拉
         */
        private final static Integer rowSize = 1000;

        public CheckHandler() {
        }
        public CheckHandler(int startIndex) {
            this.startIndex = startIndex;
        }

        @Override
        public void beforeSheetCreate(WriteWorkbookHolder writeWorkbookHolder, WriteSheetHolder writeSheetHolder) {

        }

        @Override
        public void afterSheetCreate(WriteWorkbookHolder writeWorkbookHolder, WriteSheetHolder writeSheetHolder) {
            Sheet sheet = writeSheetHolder.getSheet();
            DataValidationHelper helper = sheet.getDataValidationHelper();

            CellRangeAddressList cellRangeAddressList = new CellRangeAddressList(startIndex, rowSize, 9, 9);
            // 下拉内容
            DataValidationConstraint constraint = helper.createExplicitListConstraint(options);
            DataValidation dataValidation = helper.createValidation(constraint, cellRangeAddressList);
            sheet.addValidationData(dataValidation);
        }
    }

}
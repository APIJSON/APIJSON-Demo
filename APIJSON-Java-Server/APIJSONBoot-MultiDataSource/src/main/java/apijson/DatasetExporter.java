/*Copyright ©2025 APIJSON(https://github.com/APIJSON)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.*/

package apijson;

import com.alibaba.fastjson2.JSONArray;
import com.alibaba.fastjson2.JSONObject;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.*;

public class DatasetExporter {

    /**
     * 验证COCO数据集类型
     */
    public static boolean isValidCocoType(String type) {
        return Arrays.asList("detection", "classification", "segmentation",
                "keypoints", "face_keypoints", "rotated", "ocr").contains(type);
    }

    /**
     * 创建COCO数据集目录结构
     */
    public static void createCocoDirectoryStructure(String baseDir, String type) throws IOException {
        // 创建基础目录
        Files.createDirectories(Paths.get(baseDir + "annotations"));
        Files.createDirectories(Paths.get(baseDir + "images"));

        // 根据类型创建特定目录
        switch (type) {
            case "rotated":
            case "ocr":
                Files.createDirectories(Paths.get(baseDir + "labels"));
                break;
            default:
                // detection, classification, segmentation, keypoints, face_keypoints使用标准结构
                break;
        }
    }

    /**
     * 生成COCO数据集文件
     */
    public static void generateCocoDataset(String baseDir, String type, String datasetName) throws IOException {
        switch (type) {
            case "detection":
                generateDetectionDataset(baseDir, datasetName);
                break;
            case "classification":
                generateClassificationDataset(baseDir, datasetName);
                break;
            case "segmentation":
                generateSegmentationDataset(baseDir, datasetName);
                break;
            case "keypoints":
                generateKeypointsDataset(baseDir, datasetName);
                break;
            case "face_keypoints":
                generateFaceKeypointsDataset(baseDir, datasetName);
                break;
            case "rotated":
                generateRotatedDataset(baseDir, datasetName);
                break;
            case "ocr":
                generateOCRDataset(baseDir, datasetName);
                break;
        }
    }

    /**
     * 生成检测数据集
     */
    public static void generateDetectionDataset(String baseDir, String datasetName) throws IOException {
        // 创建annotations JSON文件
        JSONObject root = new JSONObject();
        root.put("info", createCocoInfo(datasetName));
        root.put("licenses", new JSONArray());
        root.put("categories", createDetectionCategories());
        root.put("images", createMockImages(10));
        root.put("annotations", createDetectionAnnotations(10));

        writeJsonFile(baseDir + "annotations/instances_" + datasetName + ".json", root);

        // 创建README
        createReadmeFile(baseDir, datasetName, "detection");
    }

    /**
     * 生成分类数据集
     */
    public static void generateClassificationDataset(String baseDir, String datasetName) throws IOException {
        JSONObject root = new JSONObject();
        root.put("info", createCocoInfo(datasetName));
        root.put("licenses", new JSONArray());
        root.put("categories", createClassificationCategories());
        root.put("images", createMockImages(10));
        root.put("annotations", createClassificationAnnotations(10));

        writeJsonFile(baseDir + "annotations/instances_" + datasetName + ".json", root);
        createReadmeFile(baseDir, datasetName, "classification");
    }

    /**
     * 生成分割数据集
     */
    public static void generateSegmentationDataset(String baseDir, String datasetName) throws IOException {
        JSONObject root = new JSONObject();
        root.put("info", createCocoInfo(datasetName));
        root.put("licenses", new JSONArray());
        root.put("categories", createSegmentationCategories());
        root.put("images", createMockImages(10));
        root.put("annotations", createSegmentationAnnotations(10));

        writeJsonFile(baseDir + "annotations/instances_" + datasetName + ".json", root);
        createReadmeFile(baseDir, datasetName, "segmentation");
    }

    /**
     * 生成姿态关键点数据集
     */
    public static void generateKeypointsDataset(String baseDir, String datasetName) throws IOException {
        JSONObject root = new JSONObject();
        root.put("info", createCocoInfo(datasetName));
        root.put("licenses", new JSONArray());
        root.put("categories", createKeypointsCategories());
        root.put("images", createMockImages(10));
        root.put("annotations", createKeypointsAnnotations(10));

        writeJsonFile(baseDir + "annotations/person_keypoints_" + datasetName + ".json", root);
        createReadmeFile(baseDir, datasetName, "keypoints");
    }

    /**
     * 生成人脸关键点数据集
     */
    public static void generateFaceKeypointsDataset(String baseDir, String datasetName) throws IOException {
        JSONObject root = new JSONObject();
        root.put("info", createCocoInfo(datasetName));
        root.put("licenses", new JSONArray());
        root.put("categories", createFaceKeypointsCategories());
        root.put("images", createMockImages(10));
        root.put("annotations", createFaceKeypointsAnnotations(10));

        writeJsonFile(baseDir + "annotations/face_keypoints_" + datasetName + ".json", root);
        createReadmeFile(baseDir, datasetName, "face_keypoints");
    }

    /**
     * 生成旋转检测数据集
     */
    public static void generateRotatedDataset(String baseDir, String datasetName) throws IOException {
        // JSON格式
        JSONObject root = new JSONObject();
        root.put("info", createCocoInfo(datasetName));
        root.put("licenses", new JSONArray());
        root.put("categories", createRotatedCategories());
        root.put("images", createMockImages(10));
        root.put("annotations", createRotatedAnnotations(10));

        writeJsonFile(baseDir + "annotations/instances_" + datasetName + ".json", root);

        // TXT格式标签文件
        for (int i = 1; i <= 10; i++) {
            String txtContent = "320 240 200 100 30 1\n280 180 150 80 45 2\n";
            writeTextFile(baseDir + "labels/000" + i + ".txt", txtContent);
        }

        createReadmeFile(baseDir, datasetName, "rotated");
    }

    /**
     * 生成OCR数据集
     */
    public static void generateOCRDataset(String baseDir, String datasetName) throws IOException {
        // JSON格式
        JSONObject root = new JSONObject();
        root.put("info", createCocoInfo(datasetName));
        root.put("licenses", new JSONArray());
        root.put("images", createMockImages(10));
        root.put("annotations", createOCRAnnotations(10));

        writeJsonFile(baseDir + "annotations/instances_" + datasetName + ".json", root);

        // TXT格式标签文件
        for (int i = 1; i <= 10; i++) {
            String txtContent = "100,200,220,200,220,240,100,240,Hello World\n";
            writeTextFile(baseDir + "labels/000" + i + ".txt", txtContent);
        }

        createReadmeFile(baseDir, datasetName, "ocr");
    }

    /**
     * 从APIJSON查询结果生成COCO数据集
     * @param baseDir 基础目录
     * @param type 数据集类型
     * @param datasetName 数据集名称
     * @param apijsonData APIJSON查询结果数据列表
     * @throws IOException
     */
    public static void generateCocoDatasetFromApiJson(String baseDir, String type, String datasetName, List<JSONObject> apijsonData) throws IOException {
        switch (type) {
            case "detection":
                generateDetectionDatasetFromApiJson(baseDir, datasetName, apijsonData);
                break;
            case "classification":
                generateClassificationDatasetFromApiJson(baseDir, datasetName, apijsonData);
                break;
            case "segmentation":
                generateSegmentationDatasetFromApiJson(baseDir, datasetName, apijsonData);
                break;
            case "keypoints":
                generateKeypointsDatasetFromApiJson(baseDir, datasetName, apijsonData);
                break;
            case "face_keypoints":
                generateFaceKeypointsDatasetFromApiJson(baseDir, datasetName, apijsonData);
                break;
            case "rotated":
                generateRotatedDatasetFromApiJson(baseDir, datasetName, apijsonData);
                break;
            case "ocr":
                generateOCRDatasetFromApiJson(baseDir, datasetName, apijsonData);
                break;
            default:
                // 默认使用检测格式
                generateDetectionDatasetFromApiJson(baseDir, datasetName, apijsonData);
                break;
        }
    }

    /**
     * 从APIJSON数据生成检测数据集
     */
    private static void generateDetectionDatasetFromApiJson(String baseDir, String datasetName, List<JSONObject> apijsonData) throws IOException {
        JSONObject root = new JSONObject();
        root.put("info", createCocoInfo(datasetName));
        root.put("licenses", new JSONArray());
        
        // 从数据中提取类别信息
        JSONArray categories = extractCategoriesFromApiJson(apijsonData);
        root.put("categories", categories);
        
        // 转换图片信息
        JSONArray images = convertApiJsonToImages(apijsonData);
        root.put("images", images);
        
        // 转换标注信息
        JSONArray annotations = convertApiJsonToDetectionAnnotations(apijsonData);
        root.put("annotations", annotations);

        writeJsonFile(baseDir + "annotations/instances_" + datasetName + ".json", root);
        createReadmeFile(baseDir, datasetName, "detection");
    }

    /**
     * 从APIJSON数据生成分类数据集
     */
    private static void generateClassificationDatasetFromApiJson(String baseDir, String datasetName, List<JSONObject> apijsonData) throws IOException {
        JSONObject root = new JSONObject();
        root.put("info", createCocoInfo(datasetName));
        root.put("licenses", new JSONArray());
        
        JSONArray categories = extractCategoriesFromApiJson(apijsonData);
        root.put("categories", categories);
        
        JSONArray images = convertApiJsonToImages(apijsonData);
        root.put("images", images);
        
        JSONArray annotations = convertApiJsonToClassificationAnnotations(apijsonData);
        root.put("annotations", annotations);

        writeJsonFile(baseDir + "annotations/instances_" + datasetName + ".json", root);
        createReadmeFile(baseDir, datasetName, "classification");
    }

    /**
     * 从APIJSON数据生成分割数据集
     */
    private static void generateSegmentationDatasetFromApiJson(String baseDir, String datasetName, List<JSONObject> apijsonData) throws IOException {
        JSONObject root = new JSONObject();
        root.put("info", createCocoInfo(datasetName));
        root.put("licenses", new JSONArray());
        
        JSONArray categories = extractCategoriesFromApiJson(apijsonData);
        root.put("categories", categories);
        
        JSONArray images = convertApiJsonToImages(apijsonData);
        root.put("images", images);
        
        JSONArray annotations = convertApiJsonToSegmentationAnnotations(apijsonData);
        root.put("annotations", annotations);

        writeJsonFile(baseDir + "annotations/instances_" + datasetName + ".json", root);
        createReadmeFile(baseDir, datasetName, "segmentation");
    }

    /**
     * 从APIJSON数据生成关键点数据集
     */
    private static void generateKeypointsDatasetFromApiJson(String baseDir, String datasetName, List<JSONObject> apijsonData) throws IOException {
        JSONObject root = new JSONObject();
        root.put("info", createCocoInfo(datasetName));
        root.put("licenses", new JSONArray());
        
        JSONArray categories = createKeypointsCategories();
        root.put("categories", categories);
        
        JSONArray images = convertApiJsonToImages(apijsonData);
        root.put("images", images);
        
        JSONArray annotations = convertApiJsonToKeypointsAnnotations(apijsonData);
        root.put("annotations", annotations);

        writeJsonFile(baseDir + "annotations/person_keypoints_" + datasetName + ".json", root);
        createReadmeFile(baseDir, datasetName, "keypoints");
    }

    /**
     * 从APIJSON数据生成人脸关键点数据集
     */
    private static void generateFaceKeypointsDatasetFromApiJson(String baseDir, String datasetName, List<JSONObject> apijsonData) throws IOException {
        JSONObject root = new JSONObject();
        root.put("info", createCocoInfo(datasetName));
        root.put("licenses", new JSONArray());
        
        JSONArray categories = createFaceKeypointsCategories();
        root.put("categories", categories);
        
        JSONArray images = convertApiJsonToImages(apijsonData);
        root.put("images", images);
        
        JSONArray annotations = convertApiJsonToFaceKeypointsAnnotations(apijsonData);
        root.put("annotations", annotations);

        writeJsonFile(baseDir + "annotations/face_keypoints_" + datasetName + ".json", root);
        createReadmeFile(baseDir, datasetName, "face_keypoints");
    }

    /**
     * 从APIJSON数据生成旋转检测数据集
     */
    private static void generateRotatedDatasetFromApiJson(String baseDir, String datasetName, List<JSONObject> apijsonData) throws IOException {
        JSONObject root = new JSONObject();
        root.put("info", createCocoInfo(datasetName));
        root.put("licenses", new JSONArray());
        
        JSONArray categories = extractCategoriesFromApiJson(apijsonData);
        root.put("categories", categories);
        
        JSONArray images = convertApiJsonToImages(apijsonData);
        root.put("images", images);
        
        JSONArray annotations = convertApiJsonToRotatedAnnotations(apijsonData);
        root.put("annotations", annotations);

        writeJsonFile(baseDir + "annotations/instances_" + datasetName + ".json", root);
        
        // 生成TXT格式的标签文件
        generateRotatedLabelFiles(baseDir, apijsonData);
        
        createReadmeFile(baseDir, datasetName, "rotated");
    }

    /**
     * 从APIJSON数据生成OCR数据集
     */
    private static void generateOCRDatasetFromApiJson(String baseDir, String datasetName, List<JSONObject> apijsonData) throws IOException {
        JSONObject root = new JSONObject();
        root.put("info", createCocoInfo(datasetName));
        root.put("licenses", new JSONArray());
        
        JSONArray images = convertApiJsonToImages(apijsonData);
        root.put("images", images);
        
        JSONArray annotations = convertApiJsonToOCRAnnotations(apijsonData);
        root.put("annotations", annotations);

        writeJsonFile(baseDir + "annotations/instances_" + datasetName + ".json", root);
        
        // 生成TXT格式的标签文件
        generateOCRLabelFiles(baseDir, apijsonData);
        
        createReadmeFile(baseDir, datasetName, "ocr");
    }

    // ===== 辅助方法 =====

    public static JSONObject createCocoInfo(String datasetName) {
        JSONObject info = new JSONObject();
        info.put("description", datasetName + " Dataset");
        info.put("url", "https://github.com/TommyLemon/CVAuto");
        info.put("version", "1.0");
        info.put("year", 2025);
        info.put("contributor", "TommyLemon");
        info.put("date_created", new SimpleDateFormat("yyyy-MM-dd").format(new Date()));
        return info;
    }

    public static JSONArray createDetectionCategories() {
        JSONArray categories = new JSONArray();
        JSONObject cat1 = new JSONObject();
        cat1.put("id", 1);
        cat1.put("name", "car");
        cat1.put("supercategory", "vehicle");
        categories.add(cat1);

        JSONObject cat2 = new JSONObject();
        cat2.put("id", 2);
        cat2.put("name", "person");
        cat2.put("supercategory", "human");
        categories.add(cat2);

        return categories;
    }

    public static JSONArray createClassificationCategories() {
        JSONArray categories = new JSONArray();
        JSONObject cat1 = new JSONObject();
        cat1.put("id", 1);
        cat1.put("name", "dog");
        categories.add(cat1);

        JSONObject cat2 = new JSONObject();
        cat2.put("id", 2);
        cat2.put("name", "cat");
        categories.add(cat2);

        return categories;
    }

    public static JSONArray createSegmentationCategories() {
        return createDetectionCategories(); // 复用检测的类别定义
    }

    public static JSONArray createKeypointsCategories() {
        JSONArray categories = new JSONArray();
        JSONObject cat = new JSONObject();
        cat.put("id", 1);
        cat.put("name", "person");
        cat.put("keypoints", Arrays.asList("nose", "left_eye", "right_eye", "left_ear", "right_ear",
                "left_shoulder", "right_shoulder", "left_elbow", "right_elbow",
                "left_wrist", "right_wrist", "left_hip", "right_hip",
                "left_knee", "right_knee", "left_ankle", "right_ankle"));
        cat.put("skeleton", new JSONArray()); // 骨架连接关系
        categories.add(cat);
        return categories;
    }

    public static JSONArray createFaceKeypointsCategories() {
        JSONArray categories = new JSONArray();
        JSONObject cat = new JSONObject();
        cat.put("id", 1);
        cat.put("name", "face");

        // 68个脸部关键点名称
        List<String> keypoints = new ArrayList<>();
        for (int i = 1; i <= 68; i++) {
            keypoints.add("p" + i);
        }
        cat.put("keypoints", keypoints);
        cat.put("skeleton", new JSONArray());
        categories.add(cat);
        return categories;
    }

    public static JSONArray createRotatedCategories() {
        JSONArray categories = new JSONArray();
        JSONObject cat1 = new JSONObject();
        cat1.put("id", 1);
        cat1.put("name", "plane");
        categories.add(cat1);

        JSONObject cat2 = new JSONObject();
        cat2.put("id", 2);
        cat2.put("name", "ship");
        categories.add(cat2);

        return categories;
    }

    public static JSONArray createMockImages(int count) {
        JSONArray images = new JSONArray();
        for (int i = 1; i <= count; i++) {
            JSONObject img = new JSONObject();
            img.put("id", i);
            img.put("file_name", String.format("000%03d.jpg", i));
            img.put("height", 480 + (i % 3) * 100); // 变化的高度
            img.put("width", 640 + (i % 2) * 200);  // 变化的宽度
            images.add(img);
        }
        return images;
    }

    public static JSONArray createDetectionAnnotations(int imageCount) {
        JSONArray annotations = new JSONArray();
        int annId = 1;

        for (int i = 1; i <= imageCount; i++) {
            // 每张图片1-3个标注
            int annCount = 1 + (i % 3);
            for (int j = 0; j < annCount; j++) {
                JSONObject ann = new JSONObject();
                ann.put("id", annId++);
                ann.put("image_id", i);
                ann.put("category_id", (j % 2) + 1);
                ann.put("bbox", Arrays.asList(100 + j*50, 150 + j*30, 200, 100));
                ann.put("area", 20000);
                ann.put("iscrowd", 0);
                annotations.add(ann);
            }
        }
        return annotations;
    }

    public static JSONArray createClassificationAnnotations(int imageCount) {
        JSONArray annotations = new JSONArray();
        for (int i = 1; i <= imageCount; i++) {
            JSONObject ann = new JSONObject();
            ann.put("id", i);
            ann.put("image_id", i);
            ann.put("category_id", (i % 2) + 1);
            annotations.add(ann);
        }
        return annotations;
    }

    public static JSONArray createSegmentationAnnotations(int imageCount) {
        JSONArray annotations = new JSONArray();
        int annId = 1;

        for (int i = 1; i <= imageCount; i++) {
            JSONObject ann = new JSONObject();
            ann.put("id", annId++);
            ann.put("image_id", i);
            ann.put("category_id", (i % 2) + 1);

            // 多边形分割
            JSONArray segmentation = new JSONArray();
            segmentation.add(Arrays.asList(100, 150, 300, 150, 300, 250, 100, 250));
            ann.put("segmentation", segmentation);

            ann.put("bbox", Arrays.asList(100, 150, 200, 100));
            ann.put("area", 20000);
            ann.put("iscrowd", 0);
            annotations.add(ann);
        }
        return annotations;
    }

    public static JSONArray createKeypointsAnnotations(int imageCount) {
        JSONArray annotations = new JSONArray();
        int annId = 1;

        for (int i = 1; i <= imageCount; i++) {
            JSONObject ann = new JSONObject();
            ann.put("id", annId++);
            ann.put("image_id", i);
            ann.put("category_id", 1);
            ann.put("bbox", Arrays.asList(100, 150, 200, 400));
            ann.put("num_keypoints", 17);

            // 17个关键点 (x, y, visibility)
            List<Integer> keypoints = new ArrayList<>();
            for (int k = 0; k < 17; k++) {
                keypoints.add(120 + k * 10); // x
                keypoints.add(200 + k * 15); // y
                keypoints.add(2); // visibility
            }
            ann.put("keypoints", keypoints);
            annotations.add(ann);
        }
        return annotations;
    }

    public static JSONArray createFaceKeypointsAnnotations(int imageCount) {
        JSONArray annotations = new JSONArray();
        int annId = 1;

        for (int i = 1; i <= imageCount; i++) {
            JSONObject ann = new JSONObject();
            ann.put("id", annId++);
            ann.put("image_id", i);
            ann.put("category_id", 1);
            ann.put("bbox", Arrays.asList(120, 150, 200, 200));
            ann.put("num_keypoints", 68);

            // 68个脸部关键点
            List<Integer> keypoints = new ArrayList<>();
            for (int k = 0; k < 68; k++) {
                keypoints.add(100 + k * 2); // x
                keypoints.add(150 + k * 1); // y
                keypoints.add(2); // visibility
            }
            ann.put("keypoints", keypoints);
            annotations.add(ann);
        }
        return annotations;
    }

    public static JSONArray createRotatedAnnotations(int imageCount) {
        JSONArray annotations = new JSONArray();
        int annId = 1;

        for (int i = 1; i <= imageCount; i++) {
            JSONObject ann = new JSONObject();
            ann.put("id", annId++);
            ann.put("image_id", i);
            ann.put("category_id", (i % 2) + 1);
            // 旋转框: [cx, cy, w, h, angle]
            ann.put("bbox", Arrays.asList(320, 240, 200, 100, 30));
            annotations.add(ann);
        }
        return annotations;
    }

    public static JSONArray createOCRAnnotations(int imageCount) {
        JSONArray annotations = new JSONArray();
        int annId = 1;

        for (int i = 1; i <= imageCount; i++) {
            JSONObject ann = new JSONObject();
            ann.put("id", annId++);
            ann.put("image_id", i);

            // 多边形边界框
            JSONArray segmentation = new JSONArray();
            segmentation.add(Arrays.asList(100, 200, 220, 200, 220, 240, 100, 240));
            ann.put("segmentation", segmentation);

            ann.put("bbox", Arrays.asList(100, 200, 120, 40));
            ann.put("text", "Hello World");
            ann.put("language", "en");
            ann.put("legibility", "legible");
            annotations.add(ann);
        }
        return annotations;
    }

    public static void writeJsonFile(String filePath, JSONObject content) throws IOException {
        try (FileWriter writer = new FileWriter(filePath)) {
            writer.write(content.toJSONString());
        }
    }

    public static void writeTextFile(String filePath, String content) throws IOException {
        try (FileWriter writer = new FileWriter(filePath)) {
            writer.write(content);
        }
    }

    public static void createReadmeFile(String baseDir, String datasetName, String type) throws IOException {
        String content = "# " + datasetName + " Dataset\n\n" +
                "Type: " + type + "\n" +
                "Generated: " + new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()) + "\n\n" +
                "## Directory Structure:\n" +
                "- annotations/: JSON annotation files\n" +
                "- images/: Image files (placeholder)\n" +
                "- labels/: TXT label files (for rotated/ocr types)\n\n" +
                "## Usage:\n" +
                "1. Replace placeholder images in images/ directory\n" +
                "2. Update annotation files with real data\n" +
                "3. Train your model with this dataset\n";

        writeTextFile(baseDir + "README.md", content);
    }

    public static void createZipFromDirectory(String sourceDir, String zipPath) throws IOException {
        // 使用Java原生ZIP压缩
        try (FileOutputStream fos = new FileOutputStream(zipPath);
             java.util.zip.ZipOutputStream zos = new java.util.zip.ZipOutputStream(fos)) {

            File sourceFile = new File(sourceDir);
            addFilesToZip(sourceFile, sourceFile.getName(), zos);
        }
    }

    public static void addFilesToZip(File file, String fileName, java.util.zip.ZipOutputStream zos) throws IOException {
        if (file.isDirectory()) {
            if (!fileName.endsWith("/")) {
                fileName += "/";
            }
            zos.putNextEntry(new java.util.zip.ZipEntry(fileName));
            zos.closeEntry();

            File[] files = file.listFiles();
            if (files != null) {
                for (File childFile : files) {
                    addFilesToZip(childFile, fileName + childFile.getName(), zos);
                }
            }
        } else {
            zos.putNextEntry(new java.util.zip.ZipEntry(fileName));
            try (FileInputStream fis = new FileInputStream(file)) {
                byte[] buffer = new byte[1024];
                int len;
                while ((len = fis.read(buffer)) > 0) {
                    zos.write(buffer, 0, len);
                }
            }
            zos.closeEntry();
        }
    }

    public static void deleteDirectory(File directory) throws IOException {
        if (directory.exists()) {
            File[] files = directory.listFiles();
            if (files != null) {
                for (File file : files) {
                    if (file.isDirectory()) {
                        deleteDirectory(file);
                    } else {
                        file.delete();
                    }
                }
            }
            directory.delete();
        }
    }

    // ===== 数据转换辅助方法 =====

    /**
     * 从APIJSON数据中提取类别信息
     */
    public static JSONArray extractCategoriesFromApiJson(List<JSONObject> apijsonData) {
        JSONArray categories = new JSONArray();
        Set<String> categorySet = new HashSet<>();
        
        for (JSONObject item : apijsonData) {
            if (item == null) continue;
            
            JSONObject testRecord = item.getJSONObject("TestRecord");
            if (testRecord == null) continue;
            
            String responseStr = testRecord.getString("response");
            if (responseStr == null) continue;
            
            try {
                JSONObject responseObj = JSONObject.parseObject(responseStr);
                JSONArray bboxes = responseObj.getJSONArray("bboxes");
                
                if (bboxes != null) {
                    for (int i = 0; i < bboxes.size(); i++) {
                        JSONObject bbox = bboxes.getJSONObject(i);
                        if (bbox != null) {
                            String label = bbox.getString("label");
                            if (label != null && !categorySet.contains(label)) {
                                categorySet.add(label);
                                
                                JSONObject category = new JSONObject();
                                category.put("id", categories.size() + 1);
                                category.put("name", label);
                                category.put("supercategory", "object");
                                categories.add(category);
                            }
                        }
                    }
                }
            } catch (Exception e) {
                // 解析失败，跳过
                continue;
            }
        }
        
        // 如果没有找到类别，使用默认类别
        if (categories.isEmpty()) {
            JSONObject defaultCategory = new JSONObject();
            defaultCategory.put("id", 1);
            defaultCategory.put("name", "object");
            defaultCategory.put("supercategory", "object");
            categories.add(defaultCategory);
        }
        
        return categories;
    }

    /**
     * 将APIJSON数据转换为COCO格式的images数组
     */
    private static JSONArray convertApiJsonToImages(List<JSONObject> apijsonData) {
        JSONArray images = new JSONArray();
        
        for (int i = 0; i < apijsonData.size(); i++) {
            JSONObject item = apijsonData.get(i);
            if (item == null) continue;
            
            JSONObject random = item.getJSONObject("Random");
            if (random == null) continue;
            
            JSONObject image = new JSONObject();
            image.put("id", i + 1);
            image.put("file_name", random.getString("file"));
            image.put("width", random.getIntValue("width"));
            image.put("height", random.getIntValue("height"));
            
            images.add(image);
        }
        
        return images;
    }

    /**
     * 将APIJSON数据转换为检测标注
     */
    private static JSONArray convertApiJsonToDetectionAnnotations(List<JSONObject> apijsonData) {
        JSONArray annotations = new JSONArray();
        int annId = 1;
        
        for (int imageId = 0; imageId < apijsonData.size(); imageId++) {
            JSONObject item = apijsonData.get(imageId);
            if (item == null) continue;
            
            JSONObject testRecord = item.getJSONObject("TestRecord");
            if (testRecord == null) continue;
            
            String responseStr = testRecord.getString("response");
            if (responseStr == null) continue;
            
            try {
                JSONObject responseObj = JSONObject.parseObject(responseStr);
                JSONArray bboxes = responseObj.getJSONArray("bboxes");
                
                if (bboxes != null) {
                    for (int j = 0; j < bboxes.size(); j++) {
                        JSONObject bboxData = bboxes.getJSONObject(j);
                        if (bboxData == null) continue;
                        
                        JSONObject ann = new JSONObject();
                        ann.put("id", annId++);
                        ann.put("image_id", imageId + 1);
                        
                        // 查找类别ID
                        String label = bboxData.getString("label");
                        int categoryId = findCategoryId(label, apijsonData);
                        ann.put("category_id", categoryId);
                        
                        // 设置bbox
                        JSONArray bbox = bboxData.getJSONArray("bbox");
                        if (bbox != null && bbox.size() >= 4) {
                            ann.put("bbox", Arrays.asList(
                                bbox.getDouble(0), bbox.getDouble(1),
                                bbox.getDouble(2), bbox.getDouble(3)
                            ));
                            ann.put("area", bbox.getDouble(2) * bbox.getDouble(3));
                        }
                        
                        ann.put("iscrowd", 0);
                        annotations.add(ann);
                    }
                }
            } catch (Exception e) {
                // 解析失败，跳过
                continue;
            }
        }
        
        return annotations;
    }

    /**
     * 将APIJSON数据转换为分类标注
     */
    private static JSONArray convertApiJsonToClassificationAnnotations(List<JSONObject> apijsonData) {
        JSONArray annotations = new JSONArray();
        
        for (int imageId = 0; imageId < apijsonData.size(); imageId++) {
            JSONObject item = apijsonData.get(imageId);
            if (item == null) continue;
            
            JSONObject testRecord = item.getJSONObject("TestRecord");
            if (testRecord == null) continue;
            
            String responseStr = testRecord.getString("response");
            if (responseStr == null) continue;
            
            try {
                JSONObject responseObj = JSONObject.parseObject(responseStr);
                JSONArray bboxes = responseObj.getJSONArray("bboxes");
                
                if (bboxes != null && !bboxes.isEmpty()) {
                    JSONObject bboxData = bboxes.getJSONObject(0); // 取第一个检测结果
                    if (bboxData != null) {
                        JSONObject ann = new JSONObject();
                        ann.put("id", imageId + 1);
                        ann.put("image_id", imageId + 1);
                        
                        String label = bboxData.getString("label");
                        int categoryId = findCategoryId(label, apijsonData);
                        ann.put("category_id", categoryId);
                        
                        annotations.add(ann);
                    }
                }
            } catch (Exception e) {
                continue;
            }
        }
        
        return annotations;
    }

    /**
     * 将APIJSON数据转换为分割标注
     */
    private static JSONArray convertApiJsonToSegmentationAnnotations(List<JSONObject> apijsonData) {
        JSONArray annotations = new JSONArray();
        int annId = 1;
        
        for (int imageId = 0; imageId < apijsonData.size(); imageId++) {
            JSONObject item = apijsonData.get(imageId);
            if (item == null) continue;
            
            JSONObject testRecord = item.getJSONObject("TestRecord");
            if (testRecord == null) continue;
            
            String responseStr = testRecord.getString("response");
            if (responseStr == null) continue;
            
            try {
                JSONObject responseObj = JSONObject.parseObject(responseStr);
                
                // 处理多边形分割
                JSONArray polygons = responseObj.getJSONArray("polygons");
                if (polygons != null) {
                    for (int j = 0; j < polygons.size(); j++) {
                        JSONObject polygonData = polygons.getJSONObject(j);
                        if (polygonData == null) continue;
                        
                        JSONObject ann = new JSONObject();
                        ann.put("id", annId++);
                        ann.put("image_id", imageId + 1);
                        
                        String label = polygonData.getString("label");
                        int categoryId = findCategoryId(label, apijsonData);
                        ann.put("category_id", categoryId);
                        
                        // 设置分割多边形
                        JSONArray points = polygonData.getJSONArray("points");
                        if (points != null) {
                            JSONArray segmentation = new JSONArray();
                            segmentation.add(points);
                            ann.put("segmentation", segmentation);
                            
                            // 计算bbox
                            double[] bbox = calculatePolygonBbox(points);
                            ann.put("bbox", Arrays.asList(bbox[0], bbox[1], bbox[2], bbox[3]));
                            ann.put("area", bbox[2] * bbox[3]);
                        }
                        
                        ann.put("iscrowd", 0);
                        annotations.add(ann);
                    }
                }
                
                // 如果没有多边形数据，使用bbox数据
                else {
                    JSONArray bboxes = responseObj.getJSONArray("bboxes");
                    if (bboxes != null) {
                        for (int j = 0; j < bboxes.size(); j++) {
                            JSONObject bboxData = bboxes.getJSONObject(j);
                            if (bboxData == null) continue;
                            
                            JSONObject ann = new JSONObject();
                            ann.put("id", annId++);
                            ann.put("image_id", imageId + 1);
                            
                            String label = bboxData.getString("label");
                            int categoryId = findCategoryId(label, apijsonData);
                            ann.put("category_id", categoryId);
                            
                            JSONArray bbox = bboxData.getJSONArray("bbox");
                            if (bbox != null && bbox.size() >= 4) {
                                ann.put("bbox", Arrays.asList(
                                    bbox.getDouble(0), bbox.getDouble(1),
                                    bbox.getDouble(2), bbox.getDouble(3)
                                ));
                                ann.put("area", bbox.getDouble(2) * bbox.getDouble(3));
                            }
                            
                            ann.put("iscrowd", 0);
                            annotations.add(ann);
                        }
                    }
                }
            } catch (Exception e) {
                continue;
            }
        }
        
        return annotations;
    }

    /**
     * 将APIJSON数据转换为关键点标注
     */
    private static JSONArray convertApiJsonToKeypointsAnnotations(List<JSONObject> apijsonData) {
        JSONArray annotations = new JSONArray();
        int annId = 1;
        
        for (int imageId = 0; imageId < apijsonData.size(); imageId++) {
            JSONObject item = apijsonData.get(imageId);
            if (item == null) continue;
            
            JSONObject testRecord = item.getJSONObject("TestRecord");
            if (testRecord == null) continue;
            
            String responseStr = testRecord.getString("response");
            if (responseStr == null) continue;
            
            try {
                JSONObject responseObj = JSONObject.parseObject(responseStr);
                JSONArray bboxes = responseObj.getJSONArray("bboxes");
                
                if (bboxes != null) {
                    for (int j = 0; j < bboxes.size(); j++) {
                        JSONObject bboxData = bboxes.getJSONObject(j);
                        if (bboxData == null) continue;
                        
                        JSONObject ann = new JSONObject();
                        ann.put("id", annId++);
                        ann.put("image_id", imageId + 1);
                        ann.put("category_id", 1); // 人体的关键点
                        
                        JSONArray bbox = bboxData.getJSONArray("bbox");
                        if (bbox != null && bbox.size() >= 4) {
                            ann.put("bbox", Arrays.asList(
                                bbox.getDouble(0), bbox.getDouble(1),
                                bbox.getDouble(2), bbox.getDouble(3)
                            ));
                            ann.put("area", bbox.getDouble(2) * bbox.getDouble(3));
                        }
                        
                        // 提取关键点
                        JSONArray points = bboxData.getJSONArray("points");
                        if (points != null) {
                            List<Integer> keypoints = convertPointsToKeypoints(points);
                            ann.put("keypoints", keypoints);
                            ann.put("num_keypoints", keypoints.size() / 3);
                        } else {
                            ann.put("keypoints", new ArrayList<>());
                            ann.put("num_keypoints", 0);
                        }
                        
                        annotations.add(ann);
                    }
                }
            } catch (Exception e) {
                continue;
            }
        }
        
        return annotations;
    }

    /**
     * 将APIJSON数据转换为人脸关键点标注
     */
    private static JSONArray convertApiJsonToFaceKeypointsAnnotations(List<JSONObject> apijsonData) {
        JSONArray annotations = new JSONArray();
        int annId = 1;
        
        for (int imageId = 0; imageId < apijsonData.size(); imageId++) {
            JSONObject item = apijsonData.get(imageId);
            if (item == null) continue;
            
            JSONObject testRecord = item.getJSONObject("TestRecord");
            if (testRecord == null) continue;
            
            String responseStr = testRecord.getString("response");
            if (responseStr == null) continue;
            
            try {
                JSONObject responseObj = JSONObject.parseObject(responseStr);
                JSONArray bboxes = responseObj.getJSONArray("bboxes");
                
                if (bboxes != null) {
                    for (int j = 0; j < bboxes.size(); j++) {
                        JSONObject bboxData = bboxes.getJSONObject(j);
                        if (bboxData == null) continue;
                        
                        JSONObject ann = new JSONObject();
                        ann.put("id", annId++);
                        ann.put("image_id", imageId + 1);
                        ann.put("category_id", 1); // 人脸的关键点
                        
                        JSONArray bbox = bboxData.getJSONArray("bbox");
                        if (bbox != null && bbox.size() >= 4) {
                            ann.put("bbox", Arrays.asList(
                                bbox.getDouble(0), bbox.getDouble(1),
                                bbox.getDouble(2), bbox.getDouble(3)
                            ));
                            ann.put("area", bbox.getDouble(2) * bbox.getDouble(3));
                        }
                        
                        // 提取人脸关键点（通常是68个点）
                        JSONArray points = bboxData.getJSONArray("points");
                        if (points != null) {
                            List<Integer> keypoints = convertPointsToFaceKeypoints(points);
                            ann.put("keypoints", keypoints);
                            ann.put("num_keypoints", keypoints.size() / 3);
                        } else {
                            ann.put("keypoints", new ArrayList<>());
                            ann.put("num_keypoints", 0);
                        }
                        
                        annotations.add(ann);
                    }
                }
            } catch (Exception e) {
                continue;
            }
        }
        
        return annotations;
    }

    /**
     * 将APIJSON数据转换为旋转标注
     */
    private static JSONArray convertApiJsonToRotatedAnnotations(List<JSONObject> apijsonData) {
        JSONArray annotations = new JSONArray();
        int annId = 1;
        
        for (int imageId = 0; imageId < apijsonData.size(); imageId++) {
            JSONObject item = apijsonData.get(imageId);
            if (item == null) continue;
            
            JSONObject testRecord = item.getJSONObject("TestRecord");
            if (testRecord == null) continue;
            
            String responseStr = testRecord.getString("response");
            if (responseStr == null) continue;
            
            try {
                JSONObject responseObj = JSONObject.parseObject(responseStr);
                JSONArray bboxes = responseObj.getJSONArray("bboxes");
                
                if (bboxes != null) {
                    for (int j = 0; j < bboxes.size(); j++) {
                        JSONObject bboxData = bboxes.getJSONObject(j);
                        if (bboxData == null) continue;
                        
                        JSONObject ann = new JSONObject();
                        ann.put("id", annId++);
                        ann.put("image_id", imageId + 1);
                        
                        String label = bboxData.getString("label");
                        int categoryId = findCategoryId(label, apijsonData);
                        ann.put("category_id", categoryId);
                        
                        // 旋转框格式: [cx, cy, w, h, angle]
                        JSONArray bbox = bboxData.getJSONArray("bbox");
                        if (bbox != null && bbox.size() >= 4) {
                            // 计算中心点
                            double cx = bbox.getDouble(0) + bbox.getDouble(2) / 2;
                            double cy = bbox.getDouble(1) + bbox.getDouble(3) / 2;
                            double w = bbox.getDouble(2);
                            double h = bbox.getDouble(3);
                            
                            // 尝试获取角度，如果没有则默认为0
                            Double angle = bboxData.getDouble("angle");
                            if (angle == null) angle = 0.0;
                            
                            ann.put("bbox", Arrays.asList(cx, cy, w, h, angle));
                        }
                        
                        annotations.add(ann);
                    }
                }
            } catch (Exception e) {
                continue;
            }
        }
        
        return annotations;
    }

    /**
     * 将APIJSON数据转换为OCR标注
     */
    private static JSONArray convertApiJsonToOCRAnnotations(List<JSONObject> apijsonData) {
        JSONArray annotations = new JSONArray();
        int annId = 1;
        
        for (int imageId = 0; imageId < apijsonData.size(); imageId++) {
            JSONObject item = apijsonData.get(imageId);
            if (item == null) continue;
            
            JSONObject testRecord = item.getJSONObject("TestRecord");
            if (testRecord == null) continue;
            
            String responseStr = testRecord.getString("response");
            if (responseStr == null) continue;
            
            try {
                JSONObject responseObj = JSONObject.parseObject(responseStr);
                JSONArray bboxes = responseObj.getJSONArray("bboxes");
                
                if (bboxes != null) {
                    for (int j = 0; j < bboxes.size(); j++) {
                        JSONObject bboxData = bboxes.getJSONObject(j);
                        if (bboxData == null) continue;
                        
                        JSONObject ann = new JSONObject();
                        ann.put("id", annId++);
                        ann.put("image_id", imageId + 1);
                        
                        JSONArray bbox = bboxData.getJSONArray("bbox");
                        if (bbox != null && bbox.size() >= 4) {
                            ann.put("bbox", Arrays.asList(
                                bbox.getDouble(0), bbox.getDouble(1),
                                bbox.getDouble(2), bbox.getDouble(3)
                            ));
                        }
                        
                        // 设置分割多边形（文字区域轮廓）
                        JSONArray points = bboxData.getJSONArray("points");
                        if (points != null) {
                            JSONArray segmentation = new JSONArray();
                            segmentation.add(points);
                            ann.put("segmentation", segmentation);
                        }
                        
                        // 设置识别结果
                        ann.put("text", bboxData.getString("text"));
                        ann.put("language", "en"); // 默认英文，可根据需要调整
                        ann.put("legibility", "legible");
                        
                        annotations.add(ann);
                    }
                }
            } catch (Exception e) {
                continue;
            }
        }
        
        return annotations;
    }

    // ===== 辅助方法 =====

    /**
     * 查找类别ID
     */
    private static int findCategoryId(String label, List<JSONObject> apijsonData) {
        JSONArray categories = extractCategoriesFromApiJson(apijsonData);
        for (int i = 0; i < categories.size(); i++) {
            JSONObject category = categories.getJSONObject(i);
            if (category != null && label.equals(category.getString("name"))) {
                return category.getIntValue("id");
            }
        }
        return 1; // 默认类别ID
    }

    /**
     * 将点数组转换为关键点格式 (x,y,v,x,y,v,...)
     */
    private static List<Integer> convertPointsToKeypoints(JSONArray points) {
        List<Integer> keypoints = new ArrayList<>();
        
        for (int i = 0; i < points.size() && i < 51; i += 2) { // COCO格式最多17个关键点
            if (i + 1 < points.size()) {
                keypoints.add(points.getIntValue(i));     // x
                keypoints.add(points.getIntValue(i + 1)); // y
                keypoints.add(2);                         // visibility
            }
        }
        
        // 填充到17个关键点
        while (keypoints.size() < 51) { // 17 * 3 = 51
            keypoints.add(0);
        }
        
        return keypoints;
    }

    /**
     * 将点数组转换为人脸关键点格式 (x,y,v,x,y,v,...)
     */
    private static List<Integer> convertPointsToFaceKeypoints(JSONArray points) {
        List<Integer> keypoints = new ArrayList<>();
        
        for (int i = 0; i < points.size() && i < 408; i += 2) { // 人脸关键点最多68个
            if (i + 1 < points.size()) {
                keypoints.add(points.getIntValue(i));     // x
                keypoints.add(points.getIntValue(i + 1)); // y
                keypoints.add(2);                         // visibility
            }
        }
        
        // 填充到68个关键点
        while (keypoints.size() < 204) { // 68 * 3 = 204
            keypoints.add(0);
        }
        
        return keypoints;
    }

    /**
     * 计算多边形的包围框
     */
    private static double[] calculatePolygonBbox(JSONArray points) {
        double minX = Double.MAX_VALUE, minY = Double.MAX_VALUE;
        double maxX = Double.MIN_VALUE, maxY = Double.MIN_VALUE;
        
        for (int i = 0; i < points.size(); i += 2) {
            if (i + 1 < points.size()) {
                double x = points.getDouble(i);
                double y = points.getDouble(i + 1);
                
                minX = Math.min(minX, x);
                minY = Math.min(minY, y);
                maxX = Math.max(maxX, x);
                maxY = Math.max(maxY, y);
            }
        }
        
        return new double[]{minX, minY, maxX - minX, maxY - minY};
    }

    /**
     * 生成旋转检测的TXT标签文件
     */
    private static void generateRotatedLabelFiles(String baseDir, List<JSONObject> apijsonData) throws IOException {
        for (int imageId = 0; imageId < apijsonData.size(); imageId++) {
            JSONObject item = apijsonData.get(imageId);
            if (item == null) continue;
            
            JSONObject random = item.getJSONObject("Random");
            if (random == null) continue;
            
            String fileName = random.getString("file");
            if (fileName == null) continue;
            
            String baseName = fileName.substring(0, fileName.lastIndexOf('.'));
            String txtFileName = String.format("%s.txt", baseName);
            
            StringBuilder content = new StringBuilder();
            
            JSONObject testRecord = item.getJSONObject("TestRecord");
            if (testRecord != null) {
                String responseStr = testRecord.getString("response");
                if (responseStr != null) {
                    try {
                        JSONObject responseObj = JSONObject.parseObject(responseStr);
                        JSONArray bboxes = responseObj.getJSONArray("bboxes");
                        
                        if (bboxes != null) {
                            for (int j = 0; j < bboxes.size(); j++) {
                                JSONObject bboxData = bboxes.getJSONObject(j);
                                if (bboxData == null) continue;
                                
                                JSONArray bbox = bboxData.getJSONArray("bbox");
                                if (bbox != null && bbox.size() >= 4) {
                                    double cx = bbox.getDouble(0) + bbox.getDouble(2) / 2;
                                    double cy = bbox.getDouble(1) + bbox.getDouble(3) / 2;
                                    double w = bbox.getDouble(2);
                                    double h = bbox.getDouble(3);
                                    
                                    Double angle = bboxData.getDouble("angle");
                                    if (angle == null) angle = 0.0;
                                    
                                    int categoryId = findCategoryId(bboxData.getString("label"), apijsonData);
                                    
                                    content.append(String.format("%.1f %.1f %.1f %.1f %.1f %d\n", 
                                        cx, cy, w, h, angle, categoryId));
                                }
                            }
                        }
                    } catch (Exception e) {
                        continue;
                    }
                }
            }
            
            if (content.length() > 0) {
                writeTextFile(baseDir + "labels/" + txtFileName, content.toString());
            }
        }
    }

    /**
     * 生成OCR的TXT标签文件
     */
    private static void generateOCRLabelFiles(String baseDir, List<JSONObject> apijsonData) throws IOException {
        for (int imageId = 0; imageId < apijsonData.size(); imageId++) {
            JSONObject item = apijsonData.get(imageId);
            if (item == null) continue;
            
            JSONObject random = item.getJSONObject("Random");
            if (random == null) continue;
            
            String fileName = random.getString("file");
            if (fileName == null) continue;
            
            String baseName = fileName.substring(0, fileName.lastIndexOf('.'));
            String txtFileName = String.format("%s.txt", baseName);
            
            StringBuilder content = new StringBuilder();
            
            JSONObject testRecord = item.getJSONObject("TestRecord");
            if (testRecord != null) {
                String responseStr = testRecord.getString("response");
                if (responseStr != null) {
                    try {
                        JSONObject responseObj = JSONObject.parseObject(responseStr);
                        JSONArray bboxes = responseObj.getJSONArray("bboxes");
                        
                        if (bboxes != null) {
                            for (int j = 0; j < bboxes.size(); j++) {
                                JSONObject bboxData = bboxes.getJSONObject(j);
                                if (bboxData == null) continue;
                                
                                JSONArray points = bboxData.getJSONArray("points");
                                String text = bboxData.getString("text");
                                
                                if (points != null && text != null) {
                                    // 构建多边形坐标字符串
                                    StringBuilder coords = new StringBuilder();
                                    for (int k = 0; k < points.size(); k++) {
                                        if (k > 0) coords.append(",");
                                        coords.append(points.getString(k));
                                    }
                                    
                                    content.append(String.format("%s,%s\n", coords.toString(), text));
                                }
                            }
                        }
                    } catch (Exception e) {
                        continue;
                    }
                }
            }
            
            if (content.length() > 0) {
                writeTextFile(baseDir + "labels/" + txtFileName, content.toString());
            }
        }
    }

}

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

import com.alibaba.fastjson2.annotation.JSONField;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.annotations.Expose;

import java.io.*;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.Base64;

// 添加 JSONObject 支持
import com.alibaba.fastjson2.JSONObject;
import com.alibaba.fastjson2.JSONArray;

public class DatasetUtil {

    public static void main(String[] args) {
        try {
            // --- 调用示例 ---

            // 示例1：只生成检测数据集
            System.out.println("Generating DETECTION dataset...");
            Set<TaskType> detectionTasks = new HashSet<>(Collections.singletonList(TaskType.DETECTION));
            generate("./output/detection_dataset", detectionTasks);

            // 示例2：生成分割数据集
            System.out.println("\nGenerating SEGMENTATION dataset...");
            Set<TaskType> segTasks = new HashSet<>(Collections.singletonList(TaskType.SEGMENTATION));
            generate("./output/segmentation_dataset", segTasks);

            // 示例3：生成姿态关键点数据集
            System.out.println("\nGenerating POSE_KEYPOINTS dataset...");
            Set<TaskType> keypointTasks = new HashSet<>(Collections.singletonList(TaskType.POSE_KEYPOINTS));
            generate("./output/keypoints_dataset", keypointTasks);

            // 示例4：生成OCR数据集
            System.out.println("\nGenerating OCR dataset...");
            Set<TaskType> ocrTasks = new HashSet<>(Collections.singletonList(TaskType.OCR));
            generate("./output/ocr_dataset", ocrTasks);

            // 示例5：在一个JSON中同时包含检测和关键点标注
            System.out.println("\nGenerating combined DETECTION and KEYPOINTS dataset...");
            Set<TaskType> combinedTasks = new HashSet<>(Arrays.asList(TaskType.DETECTION, TaskType.POSE_KEYPOINTS));
            generate("./output/combined_dataset", combinedTasks);

            // 示例6：从 List<JSONObject> 数据生成数据集
            System.out.println("\nGenerating dataset from JSONObject data...");
            List<JSONObject> sampleData = createSampleJSONObjectData();
            Set<TaskType> jsonTasks = new HashSet<>(Collections.singletonList(TaskType.DETECTION));
            generate(sampleData, jsonTasks, "./output/detection_dataset/", "train");

        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 验证COCO数据集类型
     */
    public static void validateCocoType(String type) {
        List<String> types = TaskType.getTypes();
        if (! types.contains(type)) {
            throw new IllegalArgumentException("不支持的数据集类型: " + type
                    + ", 只能是 [" + StringUtil.get(types.toArray()) + "] 中的一种！");
        }
    }

    public static boolean isValidCocoType(String type) {
        return TaskType.getTypes().contains(type);
    }

    /**
     * 创建COCO数据集目录结构
     */
    public static void createCocoDirectoryStructure(String baseDir, String type) throws IOException {
        // 创建基础目录
        Files.createDirectories(Paths.get(baseDir + "annotations"));
        Files.createDirectories(Paths.get(baseDir + "images"));

        // 根据类型创建特定目录 detection, classification, segmentation, keypoints, face_keypoints 使用标准结构
        if (TaskType.OCR.getType().equals(type) || TaskType.ROTATED_DETECTION.getType().equals(type)) {
            Files.createDirectories(Paths.get(baseDir + "labels"));
        }
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

    /**
     * 创建示例 JSONObject 数据（用于测试新方法）
     */
    private static List<JSONObject> createSampleJSONObjectData() {
        List<JSONObject> data = new ArrayList<>();
        
        // 创建示例数据
        JSONObject item1 = new JSONObject();
        
        // Random 部分
        JSONObject random = new JSONObject();
        random.put("id", 1756787718589L);
        random.put("file", "APIJSONisOneOfTheGVPsIn2019-small.jpg");
        random.put("width", 1280);
        random.put("height", 853);
        random.put("img", "http://apijson.cn:8080/download/APIJSONisOneOfTheGVPsIn2019-small.jpg");
        item1.put("Random", random);
        
        // TestRecord 部分
        JSONObject testRecord = new JSONObject();
        testRecord.put("id", 1756792348548L);
        testRecord.put("total", 13);
        testRecord.put("wrongs", Arrays.asList(14, 13));
        
        // response JSON 字符串
        String responseJson = "{\"bboxes\":[{\"id\":13,\"label\":\"person\",\"score\":0.5378538966178894,\"color\":[4,42,255],\"bbox\":[853,428,72,240],\"points\":[[871.6951293945312,451.89715576171875],[876.0582885742188,446.989501953125],[867.4796752929688,447.6239929199219],[885.4673461914062,448.6053161621094],[863.2174072265625,450.231201171875],[899.7001342773438,472.1517028808594],[857.8172607421875,474.7442626953125],[917.5662231445312,499.2178955078125],[855.7079467773438,503.6971435546875],[916.1815185546875,513.849365234375],[870.5646362304688,512.5989379882812],[897.6688842773438,536.5700073242188],[870.5701904296875,537.7681274414062],[899.3941650390625,589.7494506835938],[871.3021240234375,590.5899047851562],[901.5574951171875,640.5718994140625],[876.8245849609375,641.290283203125]],\"lines\":[]}],\"polygons\":[],\"ok\":true,\"msg\":\"success\",\"code\":200}";
        testRecord.put("response", responseJson);
        
        item1.put("TestRecord", testRecord);
        data.add(item1);
        
        return data;
    }

    /**
     * 定义支持的任务类型
     */
    public static enum TaskType {
        CLASSIFICATION("cls"),
        DETECTION("det"),
        SEGMENTATION("seg"),
        POSE_KEYPOINTS("pose"),
        FACE_KEYPOINTS("face"),
        ROTATED_DETECTION("obb"),
        OCR("ocr");

        private final String type;
        TaskType(String type) {
            this.type = type;
        }
        public String getType() {
            return type;
        }

        public static final List<String> TYPES = Arrays.asList(
                CLASSIFICATION.getType(),
                DETECTION.getType(),
                SEGMENTATION.getType(),
                POSE_KEYPOINTS.getType(),
                FACE_KEYPOINTS.getType(),
                ROTATED_DETECTION.getType(),
                OCR.getType()
        );
        public static List<String> getTypes() {
            return TYPES;
        }

    }

    /**
     * 数据集构建器
     */
    public static class DatasetBuilder {
        private final CocoDataset dataset;
        private int imageIdCounter = 1;
        private int annotationIdCounter = 1;

        public DatasetBuilder() {
            this.dataset = new CocoDataset();
            this.dataset.setInfo(new HashMap<>());
            this.dataset.setLicenses(new ArrayList<>());
            this.dataset.setImages(new ArrayList<>());
            this.dataset.setCategories(new ArrayList<>());
            this.dataset.setAnnotations(new ArrayList<>());
        }

        public DatasetBuilder withInfo(String description, String version, String year) {
            Map<String, String> info = new HashMap<>();
            info.put("description", description);
            info.put("version", version);
            info.put("year", year);
            info.put("date_created", new SimpleDateFormat("yyyy-MM-dd").format(new Date()));
            this.dataset.setInfo(info);
            return this;
        }

        public DatasetBuilder withCategory(int id, String name, String supercategory) {
            Category cat = new Category();
            cat.setId(id);
            cat.setName(name);
            cat.setSupercategory(supercategory);
            this.dataset.getCategories().add(cat);
            return this;
        }

        // 可为关键点任务添加专门的 category 方法
        public DatasetBuilder withKeypointCategory(int id, String name, String supercategory, List<String> keypoints, List<List<Integer>> skeleton) {
            Category cat = new Category();
            cat.setId(id);
            cat.setName(name);
            cat.setSupercategory(supercategory);
            cat.setKeypoints(keypoints);
            cat.setSkeleton(skeleton);
            this.dataset.getCategories().add(cat);
            return this;
        }

        public DatasetBuilder addImage(String fileName, int width, int height) {
            ImageInfo img = new ImageInfo();
            img.setId(imageIdCounter++);
            img.setFile_name(fileName);
            img.setWidth(width);
            img.setHeight(height);
            this.dataset.getImages().add(img);
            return this;
        }

        public DatasetBuilder addImage(String fileName, int width, int height, String imgSource) {
            ImageInfo img = new ImageInfo();
            img.setId(imageIdCounter++);
            img.setFile_name(fileName);
            img.setWidth(width);
            img.setHeight(height);
            img.setImg(imgSource);
            this.dataset.getImages().add(img);
            return this;
        }

        public DatasetBuilder addAnnotation(Annotation annotation) {
            // 确保设置了唯一的 ID
            annotation.setId(annotationIdCounter++);
            this.dataset.getAnnotations().add(annotation);
            return this;
        }

        public CocoDataset build() {
            return this.dataset;
        }
    }

    /**
     * 将 COCO 数据集对象写入 JSON 文件
     * @param dataset COCO 数据集对象
     * @param outputPath 输出文件路径 (e.g., /path/to/annotations/instances_train2017.json)
     */
    public static void writeToFile(CocoDataset dataset, String outputPath) throws IOException {
        Path parentDir = Paths.get(outputPath).getParent();
        if (parentDir != null && !Files.exists(parentDir)) {
            Files.createDirectories(parentDir);
        }

        FileOutputStream fos = new FileOutputStream(outputPath);
        fos.write(JSON.toJSONString(dataset, true).getBytes(StandardCharsets.UTF_8));

        //Gson gson = new GsonBuilder().setPrettyPrinting().create();
        //try (FileWriter writer = new FileWriter(outputPath)) {
        //    gson.toJson(dataset, writer);
        //}
        System.out.println("Successfully generated COCO JSON file at: " + outputPath);
    }


    /**
     * 复制图片文件到指定目录，按类别分目录存放，支持URL和base64两种格式
     * @param images 图片信息列表
     * @param imageDir 目标图片根目录
     * @param categories 类别列表
     * @param annotations 标注列表
     * @throws IOException
     */
    public static void copyImagesToDirectory(
            List<ImageInfo> images, String imageDir, List<Category> categories, List<Annotation> annotations
    ) throws IOException {
        // 创建图片根目录
        Path imageDirPath = Paths.get(imageDir);
        if (!Files.exists(imageDirPath)) {
            Files.createDirectories(imageDirPath);
        }

        // 创建类别ID到名称的映射
        Map<Integer, String> categoryIdToName = new HashMap<>();
        if (categories != null) {
            for (Category category : categories) {
                categoryIdToName.put(category.getId(), category.getName());
            }
        }

        // 创建类别目录
        for (String categoryName : categoryIdToName.values()) {
            Path categoryDir = Paths.get(imageDir, categoryName);
            if (!Files.exists(categoryDir)) {
                Files.createDirectories(categoryDir);
            }
        }

        // 创建图片ID到标注类别的映射
        Map<Integer, Set<String>> imageIdToCategories = new HashMap<>();
        if (annotations != null) {
            for (Annotation annotation : annotations) {
                int imageId = annotation.getImage_id();
                int categoryId = annotation.getCategory_id();
                String categoryName = categoryIdToName.get(categoryId);
                
                if (categoryName != null) {
                    imageIdToCategories.computeIfAbsent(imageId, k -> new HashSet<>()).add(categoryName);
                }
            }
        }

        for (ImageInfo image : images) {
            String imgSource = image.getImg();
            String fileName = image.getFile_name();
            
            if (imgSource == null || imgSource.trim().isEmpty()) {
                System.out.println("Warning: No image source specified for " + fileName + ", skipping...");
                continue;
            }

            // 获取这张图片的所有相关类别
            Set<String> imageCategories = imageIdToCategories.get(image.getId());
            if (imageCategories == null || imageCategories.isEmpty()) {
                // 如果没有标注信息，放到一个默认目录
                Path targetPath = Paths.get(imageDir, fileName);
                Files.createDirectories(targetPath.getParent());
                
                try {
                    copyImageToPath(imgSource, targetPath);
                    System.out.println("Successfully copied unlabeled image: " + fileName);
                } catch (Exception e) {
                    System.err.println("Failed to copy image " + fileName + ": " + e.getMessage());
                }
            } else {
                // 将图片复制到所有相关类别的目录
                for (String categoryName : imageCategories) {
                    Path targetPath = Paths.get(imageDir, categoryName, fileName);
                    
                    try {
                        copyImageToPath(imgSource, targetPath);
                        System.out.println("Successfully copied image " + fileName + " to category: " + categoryName);
                    } catch (Exception e) {
                        System.err.println("Failed to copy image " + fileName + " to category " + categoryName + ": " + e.getMessage());
                    }
                }
            }
        }
    }

    /**
     * 复制图片到指定路径的辅助方法
     */
    private static void copyImageToPath(String imgSource, Path targetPath) throws IOException {
        // 确保目标目录存在
        Files.createDirectories(targetPath.getParent());
        
        if (imgSource.startsWith("data:image/")) {
            // 处理base64格式
            copyBase64Image(imgSource, targetPath);
        } else if (imgSource.startsWith("http://") || imgSource.startsWith("https://")) {
            // 处理URL格式
            copyUrlImage(imgSource, targetPath);
        } else {
            // 处理本地文件路径
            copyLocalImage(imgSource, targetPath);
        }
    }

    /**
     * 从base64数据复制图片
     */
    private static void copyBase64Image(String base64Data, Path targetPath) throws IOException {
        // 查找base64数据开始的位置
        int commaIndex = base64Data.indexOf(",");
        if (commaIndex < 0) {
            throw new IllegalArgumentException("Invalid base64 image data format");
        }
        
        String base64String = base64Data.substring(commaIndex + 1);
        byte[] imageBytes = Base64.getDecoder().decode(base64String);
        
        try (FileOutputStream fos = new FileOutputStream(targetPath.toFile())) {
            fos.write(imageBytes);
        }
    }

    /**
     * 从URL下载图片
     */
    private static void copyUrlImage(String imageUrl, Path targetPath) throws IOException {
        URL url = new URL(imageUrl);
        try (InputStream in = url.openStream();
            FileOutputStream fos = new FileOutputStream(targetPath.toFile())) {
            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                fos.write(buffer, 0, bytesRead);
            }
        }
    }

    /**
     * 复制本地图片文件
     */
    private static void copyLocalImage(String sourcePath, Path targetPath) throws IOException {
        Path source = Paths.get(sourcePath);
        Files.copy(source, targetPath);
    }


    
    /**
     * 主生成方法（示例）
     * 实际使用中，你需要从你的数据源（如XML, CSV）读取数据来填充这些 Annotation
     */
    public static void generate(String outputDir, Set<TaskType> tasks) throws IOException {

        // --- 1. 初始化构建器和通用信息 ---
        DatasetBuilder builder = new DatasetBuilder()
                .withInfo("My Custom Dataset", "1.0", "2025")
                .withCategory(1, "person", "person")
                .withCategory(2, "car", "vehicle")
                .withCategory(3, "dog", "animal")
                .withKeypointCategory(1, "person", "person",
                        Arrays.asList("nose", "left_eye", "right_eye"), // 简化版关键点
                        Arrays.asList(Arrays.asList(1, 2), Arrays.asList(1, 3))
                );

        // --- 2. 添加图片信息 ---
        // 假设我们有两张图片
        // builder.addImage("00001.jpg", 640, 480); // image_id 将是 1
        // builder.addImage("00002.jpg", 800, 600); // image_id 将是 2
        // 假设我们有两张图片（这里是示例，你可以从数据库或配置文件中获取真实的图片信息）
        builder.addImage("00001.jpg", 640, 480, "http://apijson.cn/images/APIJSON_QECon_small.jpg"); // URL格式
        builder.addImage("00002.jpg", 800, 600, "data:image/jpeg;base64,iVBORw0KGgoAAAANSUhEUgAAAPkAAABGCAIAAACBsaVnAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyhpVFh0WE1MO+1snR1vta8c6NaVSmZCQkJiYmKK1e/fuAfoZGRlkjIStra29vSYSD5XiobU6derUrVvX+lZ1q/0D9v8CDADVjlUTLSL53QAAAABJRU5ErkJggg=="); // base64格式

        // --- 3. 根据任务类型添加标注 (核心部分) ---
        // 这是示例数据，你需要替换成你自己的真实数据加载逻辑

        // 为 image 1 添加标注
        if (tasks.contains(TaskType.DETECTION) || tasks.contains(TaskType.SEGMENTATION) || tasks.contains(TaskType.ROTATED_DETECTION)) {
            DetectionAnnotation detAnn = new DetectionAnnotation();
            detAnn.setImage_id(1);
            detAnn.setCategory_id(3); // dog
            detAnn.setBbox(Arrays.asList(100.0, 50.0, 80.0, 120.0));
            detAnn.setArea(80.0 * 120.0);

            if (tasks.contains(TaskType.SEGMENTATION)) {
                detAnn.setSegmentation(Arrays.asList(
                        Arrays.asList(100.0, 50.0, 180.0, 50.0, 180.0, 170.0, 100.0, 170.0)
                ));
            }
            if(tasks.contains(TaskType.ROTATED_DETECTION)){
                // 旋转检测通常用四点表示，这里也放在segmentation里
                detAnn.setSegmentation(Arrays.asList(
                        Arrays.asList(110.0, 55.0, 175.0, 60.0, 170.0, 165.0, 105.0, 160.0)
                ));
            }
            builder.addAnnotation(detAnn);
        }

        if (tasks.contains(TaskType.POSE_KEYPOINTS)) {
            KeypointAnnotation kpAnn = new KeypointAnnotation();
            kpAnn.setImage_id(1);
            kpAnn.setCategory_id(1); // person
            kpAnn.setBbox(Arrays.asList(200.0, 100.0, 50.0, 150.0));
            kpAnn.setArea(50.0 * 150.0);
            kpAnn.setNum_keypoints(3);
            kpAnn.setKeypoints(Arrays.asList(225.0, 110.0, 2.0, 215.0, 105.0, 2.0, 235.0, 105.0, 2.0)); // [x,y,v, x,y,v, ...]
            builder.addAnnotation(kpAnn);
        }

        // 为 image 2 添加标注
        if (tasks.contains(TaskType.OCR)) {
            OcrAnnotation ocrAnn = new OcrAnnotation();
            ocrAnn.setImage_id(2);
            ocrAnn.setCategory_id(2); // car, 假设车牌是OCR目标
            ocrAnn.setBbox(Arrays.asList(300.0, 400.0, 120.0, 30.0));
            ocrAnn.setArea(120.0 * 30.0);
            // OCR通常用四边形表示位置
            ocrAnn.setSegmentation(Arrays.asList(
                    Arrays.asList(300.0, 400.0, 420.0, 400.0, 420.0, 430.0, 300.0, 430.0)
            ));
            Map<String, Object> attrs = new HashMap<>();
            attrs.put("transcription", "AB-1234");
            attrs.put("legible", true);
            ocrAnn.setAttributes(attrs);
            builder.addAnnotation(ocrAnn);
        }

        // --- 4. 构建并写入文件 ---
        CocoDataset cocoDataset = builder.build();

        // 为不同任务生成不同的文件名
        String taskName = tasks.iterator().next().toString().toLowerCase(); // 用第一个任务命名
        String outputJsonPath = Paths.get(outputDir, "annotations", "instances_" + taskName + ".json").toString();

        writeToFile(cocoDataset, outputJsonPath);

        // 复制图片文件到指定目录 outputDir/images/
        copyImagesToDirectory(cocoDataset.getImages(), outputDir + "/images/", null, null);
        copyImagesToDirectory(cocoDataset.getImages(), outputDir + "/images/", cocoDataset.getCategories(), cocoDataset.getAnnotations());

        System.out.println("Successfully generated dataset at: " + outputDir);
    }

    
    /**
     * 从 List<JSONObject> 数据生成 COCO 数据集
     * @param data 包含图片和标注信息的 JSONObject 列表
     * @param tasks 任务类型集合
     * @param outputDir 输出目录
     * @param part train/val
     * @throws IOException
     */
    public static void generate(List<JSONObject> data, Set<TaskType> tasks, String outputDir, String part) throws IOException {
        if (data == null || data.isEmpty()) {
            throw new IllegalArgumentException("Data list cannot be null or empty");
        }

        // --- 1. 初始化构建器和通用信息 ---
        DatasetBuilder builder = new DatasetBuilder()
                .withInfo("Dataset from JSONObject", "1.0", "2025");

        // 从数据中提取实际的categories
        JSONArray extractedCategories = extractCategoriesFromApiJson(data);

        // 动态添加categories到builder
        if (extractedCategories != null) {
            boolean hasPose = tasks.contains(TaskType.POSE_KEYPOINTS);

            for (int i = 0; i < extractedCategories.size(); i++) {
                JSONObject categoryObj = extractedCategories.getJSONObject(i);
                int id = categoryObj.getIntValue("id");
                String name = categoryObj.getString("name");
                String supercategory = categoryObj.getString("supercategory");

                // 如果是关键点任务且包含person类别，添加关键点信息
                if (hasPose && ("person".equals(name) || name.contains("人"))) {
                    builder.withKeypointCategory(id, name, supercategory,
                            Arrays.asList("nose", "left_eye", "right_eye"),
                            Arrays.asList(Arrays.asList(1, 2), Arrays.asList(1, 3))
                    );
                } else {
                    builder.withCategory(id, name, supercategory);
                }
            }
        }

        // 用于跟踪图片ID映射
        Map<String, Integer> imgNameIdMap = new HashMap<>();

        // --- 2. 解析数据并添加图片和标注 ---
        for (JSONObject item : data) {
            if (item == null) continue;

            // 解析 Random 部分（图片信息）
            JSONObject randomObj = item.getJSONObject("Random");
            if (randomObj != null) {
                String fileName = randomObj.getString("file");
                Integer width = randomObj.getInteger("width");
                Integer height = randomObj.getInteger("height");
                String imgUrl = randomObj.getString("img");

                if (fileName != null && width != null && height != null) {
                    int imageId = builder.addImage(fileName, width, height, imgUrl).dataset.getImages().size();
                    imgNameIdMap.put(fileName, imageId);
                }
            }

            // 解析 TestRecord.response 部分（标注信息）
            JSONObject testRecord = item.getJSONObject("TestRecord");
            if (testRecord != null) {
                try {
                    JSONObject response = testRecord.getJSONObject("response");
                    JSONArray wrongs = testRecord.getJSONArray("wrongs");
                    JSONObject missTruth = testRecord.getJSONObject("missTruth");

                    // 解析 bboxes（检测标注）
                    JSONArray bboxes = missTruth == null ? null : missTruth.getJSONArray("bboxes");
                    JSONArray resBboxes = response == null ? null : response.getJSONArray("bboxes");
                    if (resBboxes != null && ! resBboxes.isEmpty()) {
                        if (bboxes == null) {
                            bboxes = new JSONArray();
                        }

                        if (wrongs == null || wrongs.isEmpty()) {
                            bboxes.addAll(resBboxes);
                        } else {
                            for (int i = 0; i < resBboxes.size(); i++) {
                                JSONObject bbox = wrongs.contains(i) ? null : resBboxes.getJSONObject(i);
                                if (bbox == null || bbox.isEmpty()) {
                                    continue;
                                }

                                bboxes.add(bbox);
                            }
                        }
                    }

                    Map<String, Integer> categoryNameIdMap = new HashMap<>();

                    processBboxes(bboxes, builder, tasks, imgNameIdMap, randomObj, categoryNameIdMap);

                    // 解析 polygons（分割标注）
                    JSONArray polygons = response.getJSONArray("polygons");
                    processPolygons(polygons, builder, tasks, imgNameIdMap, randomObj, categoryNameIdMap);

                } catch (Exception e) {
                    System.err.println("Failed to parse bboxes: " + e.getMessage());
                    e.printStackTrace();
                }

            }
        }

        // --- 3. 构建并写入文件 ---
        CocoDataset cocoDataset = builder.build();

        // 为不同任务生成不同的文件名
        String[] keys = StringUtil.split(outputDir, "/");
        String taskName = StringUtil.isNotEmpty(part) ? part : (keys != null && keys.length >= 1 ? keys[keys.length - 1] : tasks.iterator().next().toString().toLowerCase());

        String outputJsonPath = Paths.get(outputDir, "annotations", taskName + ".json").toString();
        writeToFile(cocoDataset, outputJsonPath);
        writeToFile(cocoDataset, Paths.get(outputDir, taskName + ".json").toString());

        // 复制图片文件到指定目录 outputDir/images/ train/val
        copyImagesToDirectory(cocoDataset.getImages(), outputDir + taskName + File.separator, cocoDataset.getCategories(), cocoDataset.getAnnotations());
        //if (Log.DEBUG || tasks.contains(TaskType.CLASSIFICATION)) {
            copyImagesToDirectory(cocoDataset.getImages(), outputDir + "images" + File.separator + taskName + File.separator, null, null);
        //}

        System.out.println("Successfully generated dataset from JSONObject data at: " + outputDir);
    }

    /**
     * 处理 bboxes 数据
     */
    private static void processBboxes(
            JSONArray bboxes, DatasetBuilder builder, Set<TaskType> tasks,
            Map<String, Integer> imgNameIdMap, JSONObject randomObj, Map<String, Integer> categoryNameIdMap
    ) {
        if (bboxes == null || bboxes.isEmpty()) {
            return;
        }

        String fileName = randomObj.getString("file");
        Integer imageId = imgNameIdMap.get(fileName);
        if (imageId == null) {
            return;
        }

        for (int i = 0; i < bboxes.size(); i++) {
            JSONObject bboxObj = bboxes.getJSONObject(i);
            if (bboxObj == null) continue;

            String label = bboxObj.getString("label");
            Double score = bboxObj.getDouble("score");
            JSONArray bbox = bboxObj.getJSONArray("bbox");
            JSONArray points = bboxObj.getJSONArray("points");

            if (bbox != null && bbox.size() >= 4) {
                DetectionAnnotation detAnn = new DetectionAnnotation();
                detAnn.setImage_id(imageId);
                
                // 根据标签设置类别ID
                int categoryId = getCategoryIdByLabel(label, categoryNameIdMap);
                detAnn.setCategory_id(categoryId);

                // 设置边界框 [x, y, width, height]
                List<Double> bboxList = new ArrayList<>();
                for (int j = 0; j < 4; j++) {
                    bboxList.add(bbox.getDouble(j));
                }
                detAnn.setBbox(bboxList);

                // 计算面积
                double width = bboxList.get(2);
                double height = bboxList.get(3);
                detAnn.setArea(width * height);

                // 如果有分割信息，添加到 segmentation
                if (points != null && !points.isEmpty()) {
                    List<List<Double>> segmentation = new ArrayList<>();
                    List<Double> pointList = new ArrayList<>();
                    
                    for (int j = 0; j < points.size(); j++) {
                        JSONArray point = points.getJSONArray(j);
                        if (point != null && point.size() >= 2) {
                            pointList.add(point.getDouble(0));
                            pointList.add(point.getDouble(1));
                        }
                    }
                    
                    if (!pointList.isEmpty()) {
                        segmentation.add(pointList);
                        detAnn.setSegmentation(segmentation);
                    }
                }

                builder.addAnnotation(detAnn);
            }
        }
    }

    /**
     * 处理 polygons 数据（用于分割任务）
     */
    private static void processPolygons(
            JSONArray polygons, DatasetBuilder builder, Set<TaskType> tasks,
            Map<String, Integer> imgNameIdMap, JSONObject randomObj, Map<String, Integer> categoryNameIdMap) {
        // 处理多边形数据的逻辑可以在这里扩展
        // 目前主要通过 bboxes 处理，polygons 可以作为额外信息
        if (polygons == null || polygons.isEmpty()) {
            return;
        }
        
    }

    /**
     * 根据标签获取类别ID
     */
    private static int getCategoryIdByLabel(String label, Map<String, Integer> categoryNameIdMap) {
        //if (label == null) return 1;
        
        //switch (label.toLowerCase()) {
        //    case "person":
        //        return 1;
        //    case "car":
        //    case "vehicle":
        //        return 2;
        //    case "dog":
        //    case "animal":
        //        return 3;
        //    default:
        //        return 1; // 默认类别
        //}
        Integer id = categoryNameIdMap.get(label);
        if (id == null) {
            id = categoryNameIdMap.size() + 1;
            categoryNameIdMap.put(label, id);
        }
        return id;
        //return findCategoryId(label, apijsonData);
    }
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



    public static class ImageInfo {
        private int id;
        private String file_name;
        private int width;
        private int height;
        @Expose(serialize=false)
        @JSONField(serialize = false)
        private String img; // 图片来源，支持URL或base64格式

        public int getId() {
            return id;
        }

        public void setId(int id) {
            this.id = id;
        }

        public String getFile_name() {
            return file_name;
        }

        public void setFile_name(String file_name) {
            this.file_name = file_name;
        }

        public int getWidth() {
            return width;
        }

        public void setWidth(int width) {
            this.width = width;
        }

        public int getHeight() {
            return height;
        }

        public void setHeight(int height) {
            this.height = height;
        }

        public String getImg() {
            return img;
        }

        public void setImg(String img) {
            this.img = img;
        }
    }

    public static class Category {
        private int id;
        private String name;
        private String supercategory;
        // For Keypoints
        private List<String> keypoints;
        private List<List<Integer>> skeleton;

        public int getId() {
            return id;
        }

        public void setId(int id) {
            this.id = id;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getSupercategory() {
            return supercategory;
        }

        public void setSupercategory(String supercategory) {
            this.supercategory = supercategory;
        }

        public List<String> getKeypoints() {
            return keypoints;
        }

        public void setKeypoints(List<String> keypoints) {
            this.keypoints = keypoints;
        }

        public List<List<Integer>> getSkeleton() {
            return skeleton;
        }

        public void setSkeleton(List<List<Integer>> skeleton) {
            this.skeleton = skeleton;
        }
    }

    public static class Annotation {
        private int id;
        private int image_id;
        private int category_id;

        public int getId() {
            return id;
        }

        public void setId(int id) {
            this.id = id;
        }

        public int getImage_id() {
            return image_id;
        }

        public void setImage_id(int image_id) {
            this.image_id = image_id;
        }

        public int getCategory_id() {
            return category_id;
        }

        public void setCategory_id(int category_id) {
            this.category_id = category_id;
        }
    }

    public static class DetectionAnnotation extends Annotation {
        private List<Double> bbox; // [x, y, width, height]
        private double area;
        private int iscrowd = 0;
        private List<List<Double>> segmentation; // for segmentation & rotated box

        public List<Double> getBbox() {
            return bbox;
        }

        public void setBbox(List<Double> bbox) {
            this.bbox = bbox;
        }

        public double getArea() {
            return area;
        }

        public void setArea(double area) {
            this.area = area;
        }

        public int getIscrowd() {
            return iscrowd;
        }

        public void setIscrowd(int iscrowd) {
            this.iscrowd = iscrowd;
        }

        public List<List<Double>> getSegmentation() {
            return segmentation;
        }

        public void setSegmentation(List<List<Double>> segmentation) {
            this.segmentation = segmentation;
        }
    }

    public static class KeypointAnnotation extends DetectionAnnotation {
        private int num_keypoints;
        private List<Double> keypoints; // [x1, y1, v1, x2, y2, v2, ...]

        public int getNum_keypoints() {
            return num_keypoints;
        }

        public void setNum_keypoints(int num_keypoints) {
            this.num_keypoints = num_keypoints;
        }

        public List<Double> getKeypoints() {
            return keypoints;
        }

        public void setKeypoints(List<Double> keypoints) {
            this.keypoints = keypoints;
        }

    }

    public static class OcrAnnotation extends DetectionAnnotation {
        private Map<String, Object> attributes; // {"transcription": "TEXT", "legible": true}

        public Map<String, Object> getAttributes() {
            return attributes;
        }
        public void setAttributes(Map<String, Object> attributes) {
            this.attributes = attributes;
        }
    }

    public static class CocoDataset {
        private Map<String, String> info;
        private List<Map<String, String>> licenses;
        private List<ImageInfo> images;
        private List<Category> categories;
        private List<Annotation> annotations; // 使用基类，实现多态

        public Map<String, String> getInfo() {
            return info;
        }

        public void setInfo(Map<String, String> info) {
            this.info = info;
        }

        public List<Map<String, String>> getLicenses() {
            return licenses;
        }

        public void setLicenses(List<Map<String, String>> licenses) {
            this.licenses = licenses;
        }

        public List<ImageInfo> getImages() {
            return images;
        }

        public void setImages(List<ImageInfo> images) {
            this.images = images;
        }

        public List<Category> getCategories() {
            return categories;
        }

        public void setCategories(List<Category> categories) {
            this.categories = categories;
        }

        public List<Annotation> getAnnotations() {
            return annotations;
        }

        public void setAnnotations(List<Annotation> annotations) {
            this.annotations = annotations;
        }

    }

}
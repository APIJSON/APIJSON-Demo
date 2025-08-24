package apijson;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Arrays;

public class CocoExporter {

    public static void main(String[] args) throws Exception {
        CocoExporter exporter = new CocoExporter();

        exporter.exportDetection("annotations/detection_train.json");
        exporter.exportClassification("annotations/classification_train.json");
        exporter.exportSegmentation("annotations/segmentation_train.json");
        exporter.exportKeypoints("annotations/keypoints_train.json");
        exporter.exportFaceKeypoints("annotations/face_keypoints_train.json");
        exporter.exportRotated("annotations/rotated_train.txt", true);
        exporter.exportRotated("annotations/rotated_train.json", false);
        exporter.exportOCR("annotations/ocr_train.txt", true);
        exporter.exportOCR("annotations/ocr_train.json", false);
    }

    private final ObjectMapper mapper = new ObjectMapper();

    /**
     * Detection
     */
    public void exportDetection(String outFile) throws IOException {
        ObjectNode root = mapper.createObjectNode();

        ArrayNode images = mapper.createArrayNode();
        ObjectNode img = mapper.createObjectNode();
        img.put("id", 1);
        img.put("file_name", "0001.jpg");
        img.put("height", 480);
        img.put("width", 640);
        images.add(img);

        ArrayNode annos = mapper.createArrayNode();
        ObjectNode anno = mapper.createObjectNode();
        anno.put("id", 1);
        anno.put("image_id", 1);
        anno.put("category_id", 1);
        anno.putArray("bbox").addAll(Arrays.asList(
                mapper.getNodeFactory().numberNode(100),
                mapper.getNodeFactory().numberNode(150),
                mapper.getNodeFactory().numberNode(200),
                mapper.getNodeFactory().numberNode(100)
        ));
        anno.put("area", 20000);
        anno.put("iscrowd", 0);
        annos.add(anno);

        ArrayNode cats = mapper.createArrayNode();
        ObjectNode cat = mapper.createObjectNode();
        cat.put("id", 1);
        cat.put("name", "car");
        cat.put("supercategory", "vehicle");
        cats.add(cat);

        root.set("images", images);
        root.set("annotations", annos);
        root.set("categories", cats);

        mapper.writerWithDefaultPrettyPrinter().writeValue(new File(outFile), root);
    }

    /**
     * Classification
     */
    public void exportClassification(String outFile) throws IOException {
        ObjectNode root = mapper.createObjectNode();

        ArrayNode images = mapper.createArrayNode();
        ObjectNode img = mapper.createObjectNode();
        img.put("id", 1);
        img.put("file_name", "0001.jpg");
        images.add(img);

        ArrayNode annos = mapper.createArrayNode();
        ObjectNode anno = mapper.createObjectNode();
        anno.put("image_id", 1);
        anno.put("category_id", 1);
        annos.add(anno);

        ArrayNode cats = mapper.createArrayNode();
        ObjectNode cat = mapper.createObjectNode();
        cat.put("id", 1);
        cat.put("name", "dog");
        cats.add(cat);

        root.set("images", images);
        root.set("annotations", annos);
        root.set("categories", cats);

        mapper.writerWithDefaultPrettyPrinter().writeValue(new File(outFile), root);
    }

    /**
     * Segmentation
     */
    public void exportSegmentation(String outFile) throws IOException {
        ObjectNode root = mapper.createObjectNode();

        ArrayNode images = mapper.createArrayNode();
        ObjectNode img = mapper.createObjectNode();
        img.put("id", 1);
        img.put("file_name", "0001.jpg");
        img.put("height", 480);
        img.put("width", 640);
        images.add(img);

        ArrayNode annos = mapper.createArrayNode();
        ObjectNode anno = mapper.createObjectNode();
        anno.put("id", 1);
        anno.put("image_id", 1);
        anno.put("category_id", 1);
        anno.putArray("segmentation").addArray().addAll(Arrays.asList(
                mapper.getNodeFactory().numberNode(100),
                mapper.getNodeFactory().numberNode(150),
                mapper.getNodeFactory().numberNode(300),
                mapper.getNodeFactory().numberNode(150),
                mapper.getNodeFactory().numberNode(300),
                mapper.getNodeFactory().numberNode(250),
                mapper.getNodeFactory().numberNode(100),
                mapper.getNodeFactory().numberNode(250)
        ));
        anno.putArray("bbox").addAll(Arrays.asList(
                mapper.getNodeFactory().numberNode(100),
                mapper.getNodeFactory().numberNode(150),
                mapper.getNodeFactory().numberNode(200),
                mapper.getNodeFactory().numberNode(100)
        ));
        anno.put("area", 20000);
        anno.put("iscrowd", 0);
        annos.add(anno);

        ArrayNode cats = mapper.createArrayNode();
        ObjectNode cat = mapper.createObjectNode();
        cat.put("id", 1);
        cat.put("name", "car");
        cats.add(cat);

        root.set("images", images);
        root.set("annotations", annos);
        root.set("categories", cats);

        mapper.writerWithDefaultPrettyPrinter().writeValue(new File(outFile), root);
    }

    /**
     * Pose Keypoints
     */
    public void exportKeypoints(String outFile) throws IOException {
        ObjectNode root = mapper.createObjectNode();

        ArrayNode images = mapper.createArrayNode();
        ObjectNode img = mapper.createObjectNode();
        img.put("id", 1);
        img.put("file_name", "0001.jpg");
        img.put("height", 480);
        img.put("width", 640);
        images.add(img);

        ArrayNode annos = mapper.createArrayNode();
        ObjectNode anno = mapper.createObjectNode();
        anno.put("id", 1);
        anno.put("image_id", 1);
        anno.put("category_id", 1);
        anno.putArray("bbox").addAll(Arrays.asList(
                mapper.getNodeFactory().numberNode(100),
                mapper.getNodeFactory().numberNode(150),
                mapper.getNodeFactory().numberNode(200),
                mapper.getNodeFactory().numberNode(400)
        ));
        anno.put("num_keypoints", 17);
        ArrayNode keypoints = anno.putArray("keypoints");
        // 简化示例：只放前3个点
        keypoints.addAll(Arrays.asList(
                mapper.getNodeFactory().numberNode(120), mapper.getNodeFactory().numberNode(200), mapper.getNodeFactory().numberNode(2),
                mapper.getNodeFactory().numberNode(150), mapper.getNodeFactory().numberNode(210), mapper.getNodeFactory().numberNode(2),
                mapper.getNodeFactory().numberNode(180), mapper.getNodeFactory().numberNode(250), mapper.getNodeFactory().numberNode(2)
        ));
        annos.add(anno);

        ArrayNode cats = mapper.createArrayNode();
        ObjectNode cat = mapper.createObjectNode();
        cat.put("id", 1);
        cat.put("name", "person");
        cat.putArray("keypoints").addAll(Arrays.asList(
                mapper.getNodeFactory().textNode("nose"),
                mapper.getNodeFactory().textNode("left_eye"),
                mapper.getNodeFactory().textNode("right_eye")
        ));
        cats.add(cat);

        root.set("images", images);
        root.set("annotations", annos);
        root.set("categories", cats);

        mapper.writerWithDefaultPrettyPrinter().writeValue(new File(outFile), root);
    }

    /**
     * Face Keypoints (68 点)
     */
    public void exportFaceKeypoints(String outFile) throws IOException {
        ObjectNode root = mapper.createObjectNode();

        ArrayNode images = mapper.createArrayNode();
        ObjectNode img = mapper.createObjectNode();
        img.put("id", 1);
        img.put("file_name", "0001.jpg");
        images.add(img);

        ArrayNode annos = mapper.createArrayNode();
        ObjectNode anno = mapper.createObjectNode();
        anno.put("id", 1);
        anno.put("image_id", 1);
        anno.put("category_id", 1);
        anno.putArray("bbox").addAll(Arrays.asList(
                mapper.getNodeFactory().numberNode(120),
                mapper.getNodeFactory().numberNode(150),
                mapper.getNodeFactory().numberNode(200),
                mapper.getNodeFactory().numberNode(200)
        ));
        anno.put("num_keypoints", 68);
        ArrayNode kps = anno.putArray("keypoints");
        for (int i = 1; i <= 68; i++) {
            kps.addAll(Arrays.asList(
                    mapper.getNodeFactory().numberNode(100 + i),
                    mapper.getNodeFactory().numberNode(150 + i),
                    mapper.getNodeFactory().numberNode(2)
            ));
        }
        annos.add(anno);

        ArrayNode cats = mapper.createArrayNode();
        ObjectNode cat = mapper.createObjectNode();
        cat.put("id", 1);
        cat.put("name", "face");
        ArrayNode kpNames = cat.putArray("keypoints");
        for (int i = 1; i <= 68; i++) {
            kpNames.add("p" + i);
        }
        cats.add(cat);

        root.set("images", images);
        root.set("annotations", annos);
        root.set("categories", cats);

        mapper.writerWithDefaultPrettyPrinter().writeValue(new File(outFile), root);
    }

    /**
     * Rotated Detection
     */
    public void exportRotated(String outFile, boolean txtFormat) throws IOException {
        if (txtFormat) {
            try (FileWriter writer = new FileWriter(outFile)) {
                writer.write("320 240 200 100 30 1\n");
            }
        } else {
            ObjectNode root = mapper.createObjectNode();
            ArrayNode images = mapper.createArrayNode();
            ObjectNode img = mapper.createObjectNode();
            img.put("id", 1);
            img.put("file_name", "0001.jpg");
            images.add(img);

            ArrayNode annos = mapper.createArrayNode();
            ObjectNode anno = mapper.createObjectNode();
            anno.put("id", 1);
            anno.put("image_id", 1);
            anno.put("category_id", 1);
            anno.putArray("bbox").addAll(Arrays.asList(
                    mapper.getNodeFactory().numberNode(320),
                    mapper.getNodeFactory().numberNode(240),
                    mapper.getNodeFactory().numberNode(200),
                    mapper.getNodeFactory().numberNode(100),
                    mapper.getNodeFactory().numberNode(30)
            ));
            annos.add(anno);

            ArrayNode cats = mapper.createArrayNode();
            ObjectNode cat = mapper.createObjectNode();
            cat.put("id", 1);
            cat.put("name", "plane");
            cats.add(cat);

            root.set("images", images);
            root.set("annotations", annos);
            root.set("categories", cats);

            mapper.writerWithDefaultPrettyPrinter().writeValue(new File(outFile), root);
        }
    }

    /**
     * OCR
     */
    public void exportOCR(String outFile, boolean txtFormat) throws IOException {
        if (txtFormat) {
            try (FileWriter writer = new FileWriter(outFile)) {
                writer.write("100,200,220,200,220,240,100,240,Hello\n");
                writer.write("50,100,150,100,150,130,50,130,World\n");
            }
        } else {
            ObjectNode root = mapper.createObjectNode();
            ArrayNode images = mapper.createArrayNode();
            ObjectNode img = mapper.createObjectNode();
            img.put("id", 1);
            img.put("file_name", "0001.jpg");
            images.add(img);

            ArrayNode annos = mapper.createArrayNode();
            ObjectNode anno = mapper.createObjectNode();
            anno.put("id", 1);
            anno.put("image_id", 1);
            anno.putArray("bbox").addAll(Arrays.asList(
                    mapper.getNodeFactory().numberNode(100),
                    mapper.getNodeFactory().numberNode(200),
                    mapper.getNodeFactory().numberNode(120),
                    mapper.getNodeFactory().numberNode(40)
            ));
            anno.putArray("segmentation").addArray().addAll(Arrays.asList(
                    mapper.getNodeFactory().numberNode(100),
                    mapper.getNodeFactory().numberNode(200),
                    mapper.getNodeFactory().numberNode(220),
                    mapper.getNodeFactory().numberNode(200),
                    mapper.getNodeFactory().numberNode(220),
                    mapper.getNodeFactory().numberNode(240),
                    mapper.getNodeFactory().numberNode(100),
                    mapper.getNodeFactory().numberNode(240)
            ));
            anno.put("text", "Hello");
            anno.put("language", "en");
            anno.put("legibility", "legible");
            annos.add(anno);

            root.set("images", images);
            root.set("annotations", annos);

            mapper.writerWithDefaultPrettyPrinter().writeValue(new File(outFile), root);
        }
    }


}

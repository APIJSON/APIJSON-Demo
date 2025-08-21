package apijson.boot;

import java.io.*;
import java.net.URLEncoder;
import java.text.DateFormat;
import java.util.*;

//import javax.annotation.PostConstruct;

import apijson.ExcelUtil;
import apijson.RequestMethod;
import apijson.StringUtil;
import com.alibaba.fastjson2.JSONArray;
import org.apache.commons.io.FileUtils;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.alibaba.fastjson2.JSONObject;

import apijson.demo.DemoParser;

import static com.google.common.io.Files.getFileExtension;

/**文件相关的控制器，包括上传、下载、浏览等
 * @author : ramostear
 * @modifier : Lemon
 * @date : 2019/3/8 0008-15:35
 */
@Controller
public class FileController {

	public static final String HOME_DIR = System.getProperty("user.home");

	private static final String WINDOWS_DIR = HOME_DIR+ "\\upload\\";

	private static final String MAC_DIR = HOME_DIR + "/upload/";

	private static final String LINUX_DIR = HOME_DIR + "/upload/";

	private static String fileUploadRootDir = null;

    static {
		// 判断文件夹是否存在，不存在就创建
		String osName = System.getProperty("os.name");
		if (osName.startsWith("Mac OS")) {
			// 苹果
			fileUploadRootDir = MAC_DIR;
		} else if (osName.startsWith("Windows")) {
			// windows
			fileUploadRootDir = WINDOWS_DIR;
		} else {
			// unix or linux
			fileUploadRootDir = LINUX_DIR;
		}

		File directories = new File(fileUploadRootDir);
		if (directories.exists()) {
			System.out.println("文件上传根目录已存在");
		} else { // 如果目录不存在就创建目录
			if (directories.mkdirs()) {
				System.out.println("创建多级目录成功");
			} else {
				System.out.println("创建多级目录失败");
			}
		}
	}

	public static final List<String> VIDEO_SUFFIXES = Arrays.asList("mp4");
	public static final List<String> IMG_SUFFIXES = Arrays.asList("jpg", "jpeg", "png");
	private static List<String> fileNames = null;
	@GetMapping("/files")
	@ResponseBody
	public JSONObject files() {
		File dir = new File(fileUploadRootDir);
		if (fileNames == null || fileNames.isEmpty()) {
			List<String> names = new ArrayList<>();
			File[] files = dir.listFiles(new FileFilter() {
				@Override
				public boolean accept(File file) {
					String name = file == null ? null : file.getName();
					int ind = name == null ? -1 : name.lastIndexOf(".");
					String suffix = ind < 0 ? null : name.substring(ind + 1);
					boolean isImg = suffix != null;
					if (isImg) {
						names.add(name);
					}
					return isImg;
				}
			});

			fileNames = names;
		}

		JSONObject res = new JSONObject();
		res.put("data", fileNames);
		return new DemoParser().extendSuccessResult(res);
	}

	@PostMapping(value = "/upload", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
	@ResponseBody
	public JSONObject upload(@RequestParam("file") MultipartFile file) {
		try {
			String name = file.getOriginalFilename();
			name = (StringUtil.isEmpty(name) ? DateFormat.getDateInstance().format(new Date()) : name)
					.replaceAll("[^a-zA-Z0-9._-]", String.valueOf(Math.round(1100*Math.random())));
			File convertFile = new File(fileUploadRootDir + name);
			FileOutputStream fileOutputStream;
			fileOutputStream = new FileOutputStream(convertFile);
			fileOutputStream.write(file.getBytes());
			fileOutputStream.close();

			if (fileNames != null && ! fileNames.isEmpty()) {
				fileNames.add(name);
			}

			JSONObject res = new JSONObject();
			res.put("path", "/download/" + name);
			res.put("size", file.getBytes().length);
			return new DemoParser().extendSuccessResult(res);
		} 
		catch (Exception e) {
			e.printStackTrace();
			return new DemoParser().newErrorResult(e);
		}
	}

	@GetMapping("/download/{fileName}")
	@ResponseBody
	public ResponseEntity<Object> download(@PathVariable(name = "fileName") String fileName) throws FileNotFoundException {

		File file = new File(fileUploadRootDir + fileName);
		InputStreamResource resource = new InputStreamResource(new FileInputStream(file));

		String encodedFileName = fileName;
		try {
			encodedFileName = URLEncoder.encode(fileName, StringUtil.UTF_8);
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}

		HttpHeaders headers = new HttpHeaders();
//		headers.add("Content-Disposition", String.format("attachment;filename=\"%s;filename*=UTF_8''%s", fileName, encodedFileName));
		headers.add("Content-Disposition", String.format("attachment;filename=\"%s", fileName));
		headers.add("Cache-Control", "public, max-age=86400");
//		headers.add("Cache-Control", "no-cache,no-store,must-revalidate");
//		headers.add("Pragma", "no-cache");
//		headers.add("Expires", "0");

		ResponseEntity<Object> responseEntity = ResponseEntity.ok()
				.headers(headers)
				.contentLength(file.length())
				.contentType(determineContentType(fileName))
				.body(resource);

		return responseEntity;
	}

	private MediaType determineContentType(String fileName) {
		String extension = getFileExtension(fileName).toLowerCase();
		switch (extension) {
			case "jpg":
			case "jpeg":
				return MediaType.IMAGE_JPEG;
			case "png":
				return MediaType.IMAGE_PNG;
			case "gif":
				return MediaType.IMAGE_GIF;
			case "pdf":
				return MediaType.APPLICATION_PDF;
			case "json":
				return MediaType.APPLICATION_JSON;
			case "xml":
				return MediaType.APPLICATION_XML;
			case "txt":
				return MediaType.TEXT_PLAIN;
			case "css":
				return MediaType.valueOf("text/css");
			case "js":
				return MediaType.valueOf("application/javascript");
			default:
				return MediaType.APPLICATION_OCTET_STREAM;
		}
	}

	@GetMapping("/download/cv/report/{reportId}")
	@ResponseBody
	public ResponseEntity<Object> downloadCVReport(@PathVariable(name = "reportId") String reportId) throws FileNotFoundException, IOException {
		String name = "CVAuto_report_" + reportId + ".xlsx";
		String path = fileUploadRootDir + name;
		File file = new File(path);
		long size = file.exists() ? file.length() : 0;
		if (size < 10*1024) {
			file.delete();
		}

		if ((file.exists() ? file.length() : 0) < 10*1024) {
			JSONObject request = new JSONObject();

			{   // TestRecord <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
				JSONObject testRecord = new JSONObject();
				testRecord.put("reportId", reportId);
				testRecord.put("@column", "documentId");
				request.put("TestRecord", testRecord);
			}   // TestRecord >>>>>>>>>>>>>>>>>>>>>>>>>>>>>

			{   // [] <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
				JSONObject item = new JSONObject();
				item.put("count", 3);
				item.put("join", "&/TestRecord");

				{   // Random <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
					JSONObject random = new JSONObject();
					random.put("documentId@", "TestRecord/documentId");
					random.put("@column", "id,file,img");
					random.put("@order", "date-");
					random.put("@combine", "file[>,img[>");
					random.put("file[>", 0);
					random.put("img[>", 0);
					item.put("Random", random);
				}   // Random >>>>>>>>>>>>>>>>>>>>>>>>>>>>>

				{   // TestRecord <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
					JSONObject testRecord = new JSONObject();
					testRecord.put("randomId@", "/Random/id");
					testRecord.put("@column", "id,total,correct,wrong,compare,response");
					testRecord.put("reportId", reportId);
					testRecord.put("total>=", 0);
					testRecord.put("correct>=", 0);
					testRecord.put("wrong>=", 0);
					testRecord.put("@order", "date-");
					item.put("TestRecord", testRecord);
				}   // TestRecord >>>>>>>>>>>>>>>>>>>>>>>>>>>>>

				request.put("[]", item);
			}   // [] >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

			DemoParser parser = new DemoParser(RequestMethod.GET, false);
			JSONObject response = parser.parseResponse(request);
			JSONArray array = response.getJSONArray("[]");

			List<ExcelUtil.DetailItem> list = new ArrayList<>();
			if (array != null) {
				for (int i = 0; i < array.size(); i++) {
					JSONObject item = array.getJSONObject(i);
					JSONObject random = item == null ? null : item.getJSONObject("Random");
					JSONObject testRecord = item == null ? null : item.getJSONObject("TestRecord");
					if (random == null) {
						random = new JSONObject();
					}
					if (testRecord == null) {
						testRecord = new JSONObject();
					}

					String fn = random.getString("file");
					int ind = fn.lastIndexOf(".");
					String nfn = fn.substring(0, ind) + "_render" + fn.substring(ind);
					list.add(new ExcelUtil.DetailItem(
							fn,
							nfn, // TODO 调用 JSONResponse.js 来渲染
							testRecord.getIntValue("total"),
							testRecord.getIntValue("correct"),
							testRecord.getIntValue("wrong"),
							testRecord.getString("response"),
							"✅",
							testRecord.getString("compare")
					));
				}
			}

			String filePath = ExcelUtil.newCVAutoReportWithTemplate(list, fileUploadRootDir, name);
			if (! Objects.equals(filePath, path)) {
				try {
					File sourceFile = new File(filePath);
					File destFile = new File(path);
					if (! destFile.getAbsolutePath().equals(sourceFile.getAbsolutePath())) {
						FileUtils.copyFile(sourceFile, destFile);
						System.out.println("文件复制完成 (Commons IO): " + filePath + " -> " + path);
					}
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}

		return download(name);
	}

}

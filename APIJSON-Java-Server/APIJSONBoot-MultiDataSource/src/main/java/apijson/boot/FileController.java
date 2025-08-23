package apijson.boot;

import java.io.*;
import java.net.URLEncoder;
import java.text.DateFormat;
import java.util.*;

//import javax.annotation.PostConstruct;

import apijson.ExcelUtil;
import apijson.RequestMethod;
import apijson.StringUtil;
import apijson.fastjson2.JSON;
import apijson.JSONResponse;
import com.alibaba.fastjson2.JSONArray;
import jakarta.servlet.http.HttpSession;
import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
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

import javax.imageio.ImageIO;

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
		} catch (Exception e) {
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

	@Autowired
	DemoController demoController;

	@GetMapping("/download/cv/report/{id}")
	@ResponseBody
	public ResponseEntity<Object> downloadCVReport(@PathVariable(name = "id") String idStr, HttpSession session) throws FileNotFoundException, IOException {
		long reportId = Long.parseLong(idStr);
		boolean isLast = reportId <= 0;
		String name = "CVAuto_report_" + (isLast ? "last" : reportId) + ".xlsx";
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
				if (isLast) {
					testRecord.put("@order", "reportId-");
				} else {
					testRecord.put("reportId", reportId);
				}
				testRecord.put("@column", "reportId,documentId,randomId,sameIds");

				request.put("TestRecord", testRecord);
			}   // TestRecord >>>>>>>>>>>>>>>>>>>>>>>>>>>>>

			{   // [] <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
				JSONObject item = new JSONObject();
				item.put("count", 3);
				//item.put("count", 0);
				item.put("join", "&/TestRecord");
				//item.put("join", "@/TestRecord");

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
					testRecord.put("@column", "id,total,correct,wrong,compare,response");
					testRecord.put("randomId@", "/Random/id");
					testRecord.put("documentId@", "TestRecord/documentId");

					//testRecord.put("idx{}@", "TestRecord/sameIds");
					if (isLast) {
						testRecord.put("reportId@", "TestRecord/reportId");
						//testRecord.put("@combine", "idx | reportId@");
					} else {
						testRecord.put("reportId", reportId);
						//testRecord.put("@combine", "idx | reportId");
					}
					//testRecord.put("@key", "idx:(id)");
					//testRecord.put("@combine", "idx | reportId");

					testRecord.put("total>=", 0);
					testRecord.put("correct>=", 0);
					testRecord.put("wrong>=", 0);
					testRecord.put("@order", "date-");

					item.put("TestRecord", testRecord);
				}   // TestRecord >>>>>>>>>>>>>>>>>>>>>>>>>>>>>

				request.put("[]", item);
			}   // [] >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

			{   // TestRecord[] <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
				JSONObject item = new JSONObject();

				{   // TestRecord <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
					JSONObject testRecord = new JSONObject();
					testRecord.put("@column", "id,randomId,total,correct,wrong,compare,response");
					testRecord.put("id{}@", "TestRecord/sameIds");
					testRecord.put("documentId@", "TestRecord/documentId");
					if (isLast) {
						testRecord.put("reportId@", "TestRecord/reportId");
					} else {
						testRecord.put("reportId", reportId);
					}
					testRecord.put("total>=", 0);
					testRecord.put("correct>=", 0);
					testRecord.put("wrong>=", 0);
					testRecord.put("@order", "date-");

					item.put("TestRecord", testRecord);
				}   // TestRecord >>>>>>>>>>>>>>>>>>>>>>>>>>>>>

				request.put("TestRecord[]", item);

			}   // TestRecord[] >>>>>>>>>>>>>>>>>>>>>>>>>>>>>

			DemoParser parser = new DemoParser(RequestMethod.GET, false);
			JSONObject response = parser.parseResponse(request);
			if (! JSONResponse.isSuccess(response)) {
				throw new IOException(JSONResponse.getMsg(response));
			}

			// JSONObject lastTr = response.getJSONObject("TestRecord");
			// long documentId = lastTr == null ? 0 : lastTr.getLongValue("documentId");
			// long randomId = lastTr == null ? 0 : lastTr.getLongValue("randomId");
			if (isLast) {
				JSONObject lastTr = response.getJSONObject("TestRecord");
				reportId = lastTr == null ? 0 : lastTr.getLongValue("reportId");
				if (reportId > 0) {
					name = "CVAuto_report_" + reportId + ".xlsx";
					path = fileUploadRootDir + name;
				}
			}

			JSONArray array = response.getJSONArray("[]");
			JSONArray trArr = response.getJSONArray("TestRecord[]");

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
						if (trArr != null) {
							int found = -1;
							for (int j = 0; j < trArr.size(); j++) {
								JSONObject tr = trArr.getJSONObject(j);
								long randomId = tr == null ? 0 : tr.getLongValue("randomId");
								if (randomId <= 0 || ! Objects.equals(randomId, random.getLongValue("id"))) {
									continue;
								}

								testRecord = tr;
								found = j;
								break;
							}

							if (found >= 0) {
								trArr.remove(found);
							}
						}
					}

					String fn = random.getString("file");
					int ind = fn.lastIndexOf(".");
					String nfn = fn.substring(0, ind) + "_render" + fn.substring(ind);

					String resStr = testRecord.getString("response");

					String img = random.getString("img");
					JSONObject resObj = StringUtil.isEmpty(img) ? null : JSON.parseObject(resStr);

					int l = resStr == null ? 0 : resStr.length();
					if (l > 32767) { // EasyExcel 单元格最长字符数限制
						resStr = resStr.substring(0, 20000) + " ... " + resStr.substring(l - 12760);
					}

					boolean hasResult = resObj != null && ! resObj.isEmpty();
					if (hasResult) {
						try {
							JSONObject renderReq = new JSONObject();
							renderReq.put("img", img);
							renderReq.put("data", resObj);
							String body = renderReq.toJSONString();
							HttpHeaders headers = new HttpHeaders();
							String renderStr = demoController.sendRequest(session, HttpMethod.POST, "http://localhost:3003/cv/render", body, headers);
							renderStr = StringUtil.trim(renderStr);
							if (renderStr.length() > 100) {
								File renderFile = new File(fileUploadRootDir + nfn);
								try (FileOutputStream fos = new FileOutputStream(renderFile)) {
									int commaInd = renderStr.startsWith("data:image/") ? -1 : renderStr.indexOf("base64,");
									String base64 = commaInd < 0 ? renderStr : renderStr.substring(commaInd + "base64,".length());
									byte[] bytes = Base64.getDecoder().decode(base64);
									fos.write(bytes);
									fos.flush();
								} catch (Throwable e) {
									e.printStackTrace();
								}
							}
						} catch (Throwable e) {
							e.printStackTrace();
						}
					}

					list.add(new ExcelUtil.DetailItem(
							fileUploadRootDir + fn,
							fileUploadRootDir + nfn, // TODO 调用 JSONResponse.js 来渲染
							testRecord.getIntValue("total"),
							testRecord.getIntValue("correct"),
							testRecord.getIntValue("wrong"),
							resStr,
							hasResult ? "✅" : "❌",
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

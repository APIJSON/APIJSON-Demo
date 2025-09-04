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

package apijson.boot;

import java.io.*;
import java.net.URLEncoder;
import java.text.DateFormat;
import java.util.*;

//import javax.annotation.PostConstruct;

import apijson.*;
import apijson.fastjson2.JSON;
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

import static apijson.DatasetUtil.*;
import static com.google.common.io.Files.getFileExtension;

import java.text.SimpleDateFormat;

/**文件相关的控制器，包括上传、下载、浏览等
 * @author Lemon
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

	public static final int MIN_EXCEL_SIZE = 10*1024*8;

	@Autowired
	DemoController demoController;

	@GetMapping("/download/cv/report/{id}")
	@ResponseBody
	public ResponseEntity<Object> downloadCVReport(@PathVariable(name = "id") String idStr, HttpSession session) throws FileNotFoundException, IOException {
		long repOrDocId = Long.parseLong(idStr);
		if (repOrDocId <= 0) {
			throw new IllegalArgumentException("id 必须为 > 0 的 reportId 或 documentId 有效整数！");
		}

		String name = "CVAuto_report_" + repOrDocId + ".xlsx";
		String path = fileUploadRootDir + name;
		File file = new File(path);
		long size = file.exists() ? file.length() : 0;
		if (size < MIN_EXCEL_SIZE) {
			file.delete();
		}

		if ((file.exists() ? file.length() : 0) < MIN_EXCEL_SIZE) {
			JSONObject request = new JSONObject();

			{   // TestRecord <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
				JSONObject testRecord = new JSONObject();
				testRecord.put("reportId", repOrDocId);
				testRecord.put("documentId", repOrDocId);
				testRecord.put("@combine", "reportId,documentId");
				testRecord.put("@column", "reportId,documentId,randomId,sameIds");
				testRecord.put("@order", "reportId-");

				request.put("TestRecord", testRecord);
			}   // TestRecord >>>>>>>>>>>>>>>>>>>>>>>>>>>>>

			{   // [] <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
				JSONObject item = new JSONObject();
				item.put("count", Log.DEBUG ? 10 : 0);
				item.put("join", Log.DEBUG ? "&/TestRecord" : "@/TestRecord");

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
					testRecord.put("@column", "id,total,correct,wrong,wrongs,compare,response");
					testRecord.put("randomId@", "/Random/id");
					testRecord.put("documentId@", "TestRecord/documentId");
					testRecord.put("reportId@", "TestRecord/reportId");

					//testRecord.put("idx{}@", "TestRecord/sameIds");
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
					testRecord.put("@column", "id,randomId,total,correct,wrong,wrongs,compare,response");
					testRecord.put("id{}@", "TestRecord/sameIds");
					testRecord.put("documentId@", "TestRecord/documentId");
//					testRecord.put("reportId@", "TestRecord/reportId");
					testRecord.put("total>=", 0);
					testRecord.put("correct>=", 0);
					testRecord.put("wrong>=", 0);
					testRecord.put("@order", "date-");

					item.put("TestRecord", testRecord);
					item.put("count", 0);
				}   // TestRecord >>>>>>>>>>>>>>>>>>>>>>>>>>>>>

				request.put("TestRecord[]", item);

			}   // TestRecord[] >>>>>>>>>>>>>>>>>>>>>>>>>>>>>

			DemoParser parser = new DemoParser(RequestMethod.GET, false);
			JSONObject response = parser.parseResponse(request);
			if (! JSONResponse.isSuccess(response)) {
				throw new IOException(JSONResponse.getMsg(response));
			}

			JSONObject lastTr = response.getJSONObject("TestRecord");
			long reportId = lastTr == null ? 0 : lastTr.getLongValue("reportId");
//			long documentId = lastTr == null ? 0 : lastTr.getLongValue("documentId");
//			long randomId = lastTr == null ? 0 : lastTr.getLongValue("randomId");
			if (reportId != repOrDocId) {
				name = "CVAuto_report_" + (reportId > 0 ? reportId : repOrDocId + "_last") + ".xlsx";
				path = fileUploadRootDir + name;
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
							renderReq.put("wrongs", testRecord.get("wrongs"));
							String body = renderReq.toJSONString();
							
							// 设置完整的HTTP headers
							HttpHeaders headers = new HttpHeaders();
							headers.setContentType(MediaType.APPLICATION_JSON);
							headers.setAccept(Arrays.asList(MediaType.APPLICATION_JSON));
							headers.set("User-Agent", "APIJSON-Server/1.0");
							headers.set("X-Requested-With", "XMLHttpRequest");
							
							// 如果body很大，设置适当的headers来支持大文件传输
							if (body.length() > 1024 * 1024) { // 超过1MB
								headers.set("Transfer-Encoding", "chunked");
							} else {
								headers.setContentLength(body.length());
							}
							
							String renderStr = demoController.sendRequest(session, HttpMethod.POST, "http://localhost:3003/cv/render", body, headers);
							renderStr = StringUtil.trim(renderStr);
							if (renderStr.length() > 100) {
								File renderFile = new File(fileUploadRootDir + nfn);
								try (FileOutputStream fos = new FileOutputStream(renderFile)) {
									int commaInd = renderStr.startsWith("data:image/") ? renderStr.indexOf("base64,") : -1;
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

	public static final int MIN_DATASET_SIZE = 10*1024*8;

	/**
	 * COCO数据集导出接口
	 * 支持类型: detection, classification, segmentation, keypoints, face_keypoints, rotated, ocr
	 * @param type 数据集类型
	 * @param datasetName 数据集名称(可选)
	 * @return 压缩包下载响应
	 */
	@GetMapping("/download/dataset/{id}")
	@ResponseBody
	public ResponseEntity<Object> downloadDataset(
			@PathVariable("id") String idStr,
			@RequestParam(name = "type", required = false) String type,
			@RequestParam(name = "ratio", required = false) String ratioStr,
			@RequestParam(name = "name", required = false) String datasetName
	) throws IOException {
		try {
			long repOrDocId = Long.parseLong(idStr);
			if (repOrDocId <= 0) {
				throw new IllegalArgumentException("id 必须为 > 0 的 reportId 或 documentId 有效整数！");
			}

			if (StringUtil.isNotEmpty(type)) {
				validateCocoType(type);
			} else {
				type = "";
			}

			int ratio = StringUtil.isEmpty(ratioStr) ? 20 : Integer.parseInt(ratioStr);
			if (ratio < 0 || ratio > 100) {
				throw new IllegalArgumentException("测试集比例 ratio 必须为 0 ~ 100 范围内的有效整数！");
			}

			String dataset = StringUtil.isNotEmpty(datasetName) ? datasetName
					: "CVAuto_" + (StringUtil.isNotEmpty(type) ? type + "_" : "") + "dataset_" + repOrDocId;
			String exportDir = fileUploadRootDir + dataset + File.separator;
			String name = dataset + ".zip";
			String path = fileUploadRootDir + name;

			File file = new File(path);
			long size = file.exists() ? file.length() : 0;
			//if (size < MIN_DATASET_SIZE) {
				file.delete();
			//}

			if ((file.exists() ? file.length() : 0) < MIN_DATASET_SIZE) {
				JSONObject request = new JSONObject();

				//{   // TestRecord <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
				//	JSONObject testRecord = new JSONObject();
				//	testRecord.put("reportId", repOrDocId);
				//	testRecord.put("documentId", repOrDocId);
				//	testRecord.put("@combine", "reportId,documentId");
				//	testRecord.put("@column", "reportId,documentId,randomId,sameIds");
				//	testRecord.put("@order", "reportId-");
				//
				//	request.put("TestRecord", testRecord);
				//}   // TestRecord >>>>>>>>>>>>>>>>>>>>>>>>>>>>>

				{   // [] <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
					JSONObject item = new JSONObject();
					item.put("count", Log.DEBUG ? 10 : 0);
					item.put("join", Log.DEBUG ? "&/TestRecord" : "@/TestRecord");

					{   // Random <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
						JSONObject random = new JSONObject();
						//random.put("documentId@", "TestRecord/documentId");
						random.put("@column", "id,file,width,height,img");
						random.put("@order", "date-");
						random.put("@combine", "file[>,img[>");
						random.put("file[>", 0);
						random.put("img[>", 0);

						item.put("Random", random);
					}   // Random >>>>>>>>>>>>>>>>>>>>>>>>>>>>>

					{   // TestRecord <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
						JSONObject testRecord = new JSONObject();
						testRecord.put("@column", "id,total,wrongs,missTruth,response");
						testRecord.put("randomId@", "/Random/id");
						//testRecord.put("documentId@", "TestRecord/documentId");
						//testRecord.put("reportId@", "TestRecord/reportId");
						//testRecord.put("@combine", "reportId,documentId");

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
				if (! JSONResponse.isSuccess(response)) {
					throw new IOException(JSONResponse.getMsg(response));
				}

				JSONObject lastTr = response.getJSONObject("TestRecord");
				long reportId = lastTr == null ? 0 : lastTr.getLongValue("reportId");
				//long documentId = lastTr == null ? 0 : lastTr.getLongValue("documentId");
				//long randomId = lastTr == null ? 0 : lastTr.getLongValue("randomId");
				if (reportId != repOrDocId) {
					dataset = StringUtil.isNotEmpty(datasetName) ? datasetName : "CVAuto_"
							+ (StringUtil.isNotEmpty(type) ? type + "_" : "") + "dataset_"
							+ (reportId > 0 ? reportId : repOrDocId + "_last");
					exportDir = fileUploadRootDir + dataset + "/";
					name = dataset + ".zip";
					path = fileUploadRootDir + name;
				}

				JSONArray array = response.getJSONArray("[]");

				List<JSONObject> trainList = new ArrayList<>();
				List<JSONObject> validList = new ArrayList<>();
				if (array != null) {
					int len = array.size();
					for (int i = 0; i < len; i++) {
						JSONObject item = array.getJSONObject(i);
						if (item == null || item.isEmpty()) {
							continue;
						}

						if (ratio <= 0 || ratio <= 100 - 100.0*i/len) {
							trainList.add(item);
						} else {
							validList.add(item);
						}

						//JSONObject random = item == null ? null : item.getJSONObject("Random");
						//JSONObject testRecord = item == null ? null : item.getJSONObject("TestRecord");
						//if (random == null) {
						//	random = new JSONObject();
						//}
						//if (testRecord == null) {
						//	testRecord = new JSONObject();
						//}
						//
						//String fn = random.getString("file");
						//int ind = fn.lastIndexOf(".");
						//String nfn = fn.substring(0, ind) + "_render" + fn.substring(ind);
						//
						//String resStr = testRecord.getString("response");
						//
						//String img = random.getString("img");
						//JSONObject resObj = StringUtil.isEmpty(img) ? null : JSON.parseObject(resStr);

						// TODO
					}
				}

				// 创建导出目录结构
				createCocoDirectoryStructure(exportDir, type);

				// 生成mock数据并创建文件
				//generateCocoDatasetFromApiJson(exportDir, type, dataset, list);

				Set<DatasetUtil.TaskType> detectionTasks = new HashSet<>(Collections.singletonList(DatasetUtil.TaskType.DETECTION));

				DatasetUtil.generate(trainList, detectionTasks, exportDir, "train");
				DatasetUtil.generate(validList, detectionTasks, exportDir, "val");

				createZipFromDirectory(exportDir, path);

				// 清理临时目录
				deleteDirectory(new File(exportDir));

				//if (! Objects.equals(filePath, path)) {
				//	try {
				//		File sourceFile = new File(filePath);
				//		File destFile = new File(path);
				//		if (! destFile.getAbsolutePath().equals(sourceFile.getAbsolutePath())) {
				//			FileUtils.copyFile(sourceFile, destFile);
				//			System.out.println("文件复制完成 (Commons IO): " + filePath + " -> " + path);
				//		}
				//	} catch (IOException e) {
				//		e.printStackTrace();
				//	}
				//}
			}

			// 返回压缩包下载
			return download(name);
			
		} catch (Exception e) {
			e.printStackTrace();
			throw new IOException("导出 COCO 数据集失败: " + e.getMessage());
		}
	}

}

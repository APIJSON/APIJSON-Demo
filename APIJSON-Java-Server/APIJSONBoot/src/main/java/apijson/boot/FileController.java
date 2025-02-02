package apijson.boot;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.List;

import jakarta.annotation.PostConstruct;

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

import com.alibaba.fastjson.JSONObject;

import apijson.demo.DemoParser;

/**文件相关的控制器，包括上传、下载、浏览等
 * @author : ramostear
 * @modifier : Lemon
 * @date : 2019/3/8 0008-15:35
 */
@Controller
public class FileController {

	private static String fileUploadRootDir = null;

	//    @Value"${file.upload.root.dir.windows}")
	String fileUploadRootDirWindows = "C:/work/upload/";

	//    @Value"${file.upload.root.dir.mac}")
	String fileUploadRootDirMac = "/Users/Tommy/upload/";

	//    @Value"${file.upload.root.dir.linux}")
	String fileUploadRootDirLinux = "~/upload/";

	private static List<String> fileRepository = new ArrayList<>();

	@PostConstruct
	public void initFileRepository(){
		// 判断文件夹是否存在，不存在就创建
		String osName = System.getProperty("os.name");
		if (osName.startsWith("Mac OS")) {
			// 苹果
			fileUploadRootDir = fileUploadRootDirMac;
		} else if (osName.startsWith("Windows")) {
			// windows
			fileUploadRootDir = fileUploadRootDirWindows;
		} else {
			// unix or linux
			fileUploadRootDir = fileUploadRootDirLinux;
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

	@GetMapping("/files")
	@ResponseBody
	public JSONObject files() {
		JSONObject res = new JSONObject();
		res.put("data", fileRepository);
		return DemoParser.extendSuccessResult(res);	
	}

	@PostMapping(value = "/upload", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
	@ResponseBody
	public JSONObject upload(@RequestParam("file") MultipartFile file) {
		try {
			File convertFile = new File(fileUploadRootDir + file.getOriginalFilename());
			FileOutputStream fileOutputStream;
			fileOutputStream = new FileOutputStream(convertFile);
			fileOutputStream.write(file.getBytes());
			fileOutputStream.close();

			fileRepository.add(file.getOriginalFilename());

			JSONObject res = new JSONObject();
			res.put("path", file.getOriginalFilename());
			res.put("size", file.getBytes().length);
			return DemoParser.extendSuccessResult(res);
		} 
		catch (Exception e) {
			e.printStackTrace();
			return DemoParser.newErrorResult(e);
		}
	}

	@GetMapping("/download/{fileName}")
	@ResponseBody
	public ResponseEntity<Object> download(@PathVariable(name = "fileName") String fileName) throws FileNotFoundException {

		File file = new File(fileUploadRootDir + fileName);
		InputStreamResource resource = new InputStreamResource(new FileInputStream(file));

		HttpHeaders headers = new HttpHeaders();
		headers.add("Content-Disposition", String.format("attachment;filename=\"%s", fileName));
		headers.add("Cache-Control", "no-cache,no-store,must-revalidate");
		headers.add("Pragma", "no-cache");
		headers.add("Expires", "0");

		ResponseEntity<Object> responseEntity = ResponseEntity.ok()
				.headers(headers)
				.contentLength(file.length())
				.contentType(MediaType.parseMediaType("application/txt"))
				.body(resource);

		return responseEntity;
	}



}

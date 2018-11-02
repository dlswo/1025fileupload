package org.injae.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.injae.domain.BoardAttachVO;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import lombok.extern.log4j.Log4j;
import net.coobird.thumbnailator.Thumbnailator;

@Controller
@Log4j
public class UploadController {

	@PostMapping(value = "/upload", produces = "application/json; charset=utf-8")
	@ResponseBody
	public ResponseEntity<List<BoardAttachVO>> upload(MultipartFile[] files) {

		List<BoardAttachVO> result = new ArrayList<>();

		String uploadFolder = "C:\\upload";
		String uploadFolderPath = getFolder();

		File uploadPath = new File(uploadFolder, uploadFolderPath);

		if (uploadPath.exists() == false) {
			uploadPath.mkdirs();
		}

		for (MultipartFile file : files) {

			BoardAttachVO attach = new BoardAttachVO();

			log.info(file.getOriginalFilename());
			log.info(file.getContentType());
			log.info(file.getSize());

			String saveFileName = file.getOriginalFilename();
			saveFileName = saveFileName.substring(saveFileName.lastIndexOf("\\") + 1);
			attach.setFilename(saveFileName);

			UUID uuid = UUID.randomUUID();

			saveFileName = uuid.toString() + "_" + saveFileName;
			String thumbFileName = "s_" + saveFileName;

			File saveFile = new File(uploadPath, saveFileName);
			FileOutputStream thumbFile = null;

			log.info(saveFile);

			try {
				file.transferTo(saveFile);

				attach.setUuid(uuid.toString());
				attach.setPath(uploadFolderPath);
				attach.setFiletype(thumbFileName.substring(thumbFileName.lastIndexOf(".") + 1));

				thumbFile = new FileOutputStream(new File(uploadPath, thumbFileName));

				Thumbnailator.createThumbnail(file.getInputStream(), thumbFile, 100, 100);

				thumbFile.close();

				result.add(attach);

			} catch (Exception e) {
				e.printStackTrace();
			}

		}

		return new ResponseEntity<>(result, HttpStatus.OK);

	}

	private String getFolder() {

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

		Date date = new Date();

		String str = sdf.format(date);

		return str.replace("-", File.separator);
	}

	@GetMapping("/display")
	@ResponseBody
	public ResponseEntity<byte[]> viewFile(String filename) {

		log.info("Filename :" + filename);

		ResponseEntity<byte[]> result = null;

		try {

			File target = new File("C:\\upload\\" + filename);

			HttpHeaders header = new HttpHeaders();
			header.add("Content-type", Files.probeContentType(target.toPath()));

			byte[] arr = FileCopyUtils.copyToByteArray(target);
			result = new ResponseEntity<>(arr, header, HttpStatus.OK);

		} catch (IOException e) {
			e.printStackTrace();
		}

		return result;
	}
	
	@GetMapping(value="/download", produces= MediaType.APPLICATION_OCTET_STREAM_VALUE)
	@ResponseBody
	public ResponseEntity<byte[]> downloadFile(@RequestHeader("User-Agent")String userAgent, String filename){
		
		log.info("downloadFile: "+ filename);
		
		ResponseEntity<byte[]> result = null;
		
		log.info(userAgent);
		
		try {
			
			File target = new File("c:\\upload\\" + filename);
			
			String downName = null;
			
			if(userAgent.contains("Trident")) {
				log.info("IE");
				downName = URLEncoder.encode(filename, "UTF-8").replaceAll("\\+", "");
			}else if(userAgent.contains("edge")) {
				log.info("EDGE");
				downName = URLEncoder.encode(filename, "UTF-8");
			}else {
				log.info("CHROME");
				downName = new String(filename.getBytes("UTF-8"),"ISO-8859-1");
			}
			
			byte[] arr = FileCopyUtils.copyToByteArray(target);
			
			HttpHeaders header = new HttpHeaders();
			header.add("Content-Disposition", "attachment; filename="+ downName);
			
			result = new ResponseEntity<byte[]>(arr, header, HttpStatus.OK);
			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
		
		return result;
	}

	@PostMapping("/deleteFile")
	@ResponseBody
	public ResponseEntity<String> deleteFile(String filename, String type) {
		
		log.info("deleteFile: "+ filename);

		ResponseEntity<String> result = null;

		File file;

		try {
			file = new File("C:\\upload\\" + URLDecoder.decode(filename, "UTF-8"));

			file.delete();

			if (type.equals("image")) {
				String largetFileName = file.getAbsolutePath().replace("s_", "");
				log.info("largeFileName: " + largetFileName);

				file = new File(largetFileName);
				file.delete();
				result = new ResponseEntity<String>("deleted", HttpStatus.OK);
			}
		} catch (IOException e) {
			e.printStackTrace();
			result = new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}

		return result;

	}

}

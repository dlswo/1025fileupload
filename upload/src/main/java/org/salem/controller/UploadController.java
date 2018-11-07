package org.salem.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import org.salem.domain.UploadDTO;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import lombok.extern.log4j.Log4j;
import net.coobird.thumbnailator.Thumbnailator;

@Controller
@Log4j
public class UploadController {

	@GetMapping(value= "/download/{fileName}", produces= {
			MediaType.APPLICATION_OCTET_STREAM_VALUE
	})
	@ResponseBody
	public ResponseEntity<byte[]> download(@PathVariable("fileName") String fileName) {

		log.info("fileName: " + fileName);

		String fName = fileName.substring(0, fileName.lastIndexOf("_"));
		log.info("FName: " + fName);

		String ext = fileName.substring(fileName.lastIndexOf("_") + 1);
		log.info("ext: " + ext);

		String total = fName + "." + ext;
		
		int under = total.indexOf("_");
		
		String totalOrigin = total.substring(under+1);
		
		
		ResponseEntity<byte[]> result = null;

		try {

			File target = new File("C:\\upload\\" + total);
			
			String downName = new String(totalOrigin.getBytes("UTF-8"),"ISO-8859-1");
			
			HttpHeaders header = new HttpHeaders();
			header.add("Content-Disposition",
					"attachment; filename=" + downName);

			byte[] arr = FileCopyUtils.copyToByteArray(target);
			result = new ResponseEntity<>(arr,header, HttpStatus.OK);

		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return result;
	}

	@GetMapping("/viewFile/{fileName}")
	@ResponseBody
	public ResponseEntity<byte[]> viewFile(@PathVariable("fileName") String fileName) {

		log.info("fileName: " + fileName);

		String fName = fileName.substring(0, fileName.lastIndexOf("_"));
		log.info("FName: " + fName);

		String ext = fileName.substring(fileName.lastIndexOf("_") + 1);
		log.info("ext: " + ext);

		String total = fName + "." + ext;

		ResponseEntity<byte[]> result = null;

		try {

			File target = new File("C:\\upload\\" + total);

			HttpHeaders header = new HttpHeaders();
			header.add("Content-type", Files.probeContentType(target.toPath()));

			byte[] arr = FileCopyUtils.copyToByteArray(target);
			result = new ResponseEntity<>(arr, header, HttpStatus.OK);

		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		}

		return result;
	}

	// responsebody는 리턴값이 http response에 쓰여진다?
	// produces는 리턴값을 이러한 형태로 만든다는 것이다.
	@PostMapping(value = "/upload", produces = "application/json; charset=utf-8")
	@ResponseBody
	public List<UploadDTO> upload(MultipartFile[] files) {

		List<UploadDTO> result = new ArrayList<>();

		for (MultipartFile file : files) {

			log.info(file.getOriginalFilename());
			log.info(file.getContentType());
			log.info(file.getSize());

			UUID uuid = UUID.randomUUID();

			String saveFileName = uuid.toString() + "_" + file.getOriginalFilename();
			String thumbFileName = "s_" + saveFileName;

			File saveFile = new File("C:\\upload\\" + saveFileName);

			FileOutputStream thumbFile = null;

			try {

				thumbFile = new FileOutputStream("C:\\upload\\" + thumbFileName);

				// (파일읽어옴,어디에 저장할건지, 높이,넓이)라는 썸네일을 만드는 코드
				Thumbnailator.createThumbnail(file.getInputStream(), thumbFile, 100, 100);

				thumbFile.close();

				// close해주고 저장해야 동작된다.
				// 파일을 해당 저장공간에 저장하는 코드이다.
				file.transferTo(saveFile);

				result.add(new UploadDTO(saveFileName, file.getOriginalFilename(),
						thumbFileName.substring(0, thumbFileName.lastIndexOf(".")),
						thumbFileName.substring(thumbFileName.lastIndexOf(".") + 1)));

			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		} // end for

		return result;
	}
}

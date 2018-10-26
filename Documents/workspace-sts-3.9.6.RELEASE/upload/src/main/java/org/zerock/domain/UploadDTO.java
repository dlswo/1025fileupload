package org.zerock.domain;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class UploadDTO {

	private String uploadName;
	private String originName;
	private String thumbName;
	private String ext;
	
}

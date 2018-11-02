package org.injae.domain;

import org.springframework.web.util.UriComponentsBuilder;

import lombok.Data;

@Data
public class Param {
	
	private static final double PER = 5.0;
	private int bno,rno;
	private int page, size, start, end, total;
	private boolean prev, next;
	private String[] types;
	private String type;
	private String keyword;
	
	public Param() {
		this.page = 1;
		this.size = 10;
	}
	
	public void setType(String type) {
		this.type = type;
		
		if(type == null || type.trim().length() == 0) { 
			this.types = null;
			return;
		}
		
		this.types = type.split("");
	}
	
	public int getSkip() {
		return (this.page - 1) * this.size;
	}
	
	public void setTotal(int total) {
		this.total = total;
		
		this.end = (int)((Math.ceil(this.page/PER)) * 5);
		this.start = this.end - 4;
		
		if( (this.end * this.size) >= total ) {
			this.end = (int)(Math.ceil(total/(double)this.size));
			this.next = false;
		}else {
			this.next = true;
		}
		
		this.prev = this.start != 1;
	}
	
	public String getLink(String path) {
		
		return UriComponentsBuilder.fromPath(path)
				.queryParam("bno", this.bno)
				.queryParam("page", this.page)
				.queryParam("size", this.size)
				.queryParam("type", this.type)
				.queryParam("keyword", this.keyword)
				.toUriString();
		
	}
	

}

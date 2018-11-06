package org.injae.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/sample/*")
public class SampleController {

	@GetMapping("/all")
	public void doAll() {
		log.info("ALL PAGE");
	}
	
	@GetMapping("/member")
	public void doMember() {
		log.info("member PAGE");
	}
	
	@GetMapping("/admin")
	public void doAdmin() {
		log.info("admin PAGE");
	}
	
	
}

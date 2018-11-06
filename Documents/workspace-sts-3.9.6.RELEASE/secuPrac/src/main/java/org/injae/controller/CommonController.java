package org.injae.controller;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.extern.log4j.Log4j;

@Controller
@Log4j
public class CommonController {
	
	@GetMapping({"/customLogin","/customLogout"})
	public void customLogin() {
		log.info("custom Login Logout Page");
	}

	@RequestMapping("/accessError")
	public void accessError(Authentication auth, Model model) {
		log.info(auth);
		
		model.addAttribute("msg","Access Error !!!!!");
	}
}

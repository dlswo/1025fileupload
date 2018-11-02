package org.injae.controller;

import java.util.List;

import org.injae.domain.Param;
import org.injae.domain.ReplyVO;
import org.injae.mapper.BoardMapper;
import org.injae.service.ReplyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;


@RestController
@RequestMapping("/replies/")
@Log4j
public class ReplyController {
	
	@Setter(onMethod_= @Autowired)
	private ReplyService service;
	Param param = new Param();
	
	@PostMapping(value= "/new", consumes="application/json", produces= {MediaType.TEXT_PLAIN_VALUE})
	public ResponseEntity<String> create(@RequestBody ReplyVO vo) {
		return service.register(vo) == 1 
				? new ResponseEntity<>("success",HttpStatus.OK)
				: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	@GetMapping(value = "/pages/{bno}/{page}", produces= {MediaType.APPLICATION_XML_VALUE, MediaType.APPLICATION_JSON_UTF8_VALUE})
	public ResponseEntity<List<ReplyVO>> getList(@PathVariable("page") int page,@PathVariable("bno") int bno) {
		log.info("getList.....");
		
		param.setPage(page);
		param.setBno(bno);
		
		return new ResponseEntity<>(service.getList(param), HttpStatus.OK);
	}
	
	@GetMapping(value = "/{rno}", produces= {MediaType.APPLICATION_XML_VALUE, MediaType.APPLICATION_JSON_UTF8_VALUE})
	public ResponseEntity<ReplyVO> read(@PathVariable("rno") int rno){
		log.info("get: " + rno);
		
		param.setRno(rno);
		
		return new ResponseEntity<>(service.read(param), HttpStatus.OK);
	}
	
	@DeleteMapping(value = "/{rno}", produces= {MediaType.TEXT_PLAIN_VALUE})
	public ResponseEntity<String> remove(@PathVariable("rno") int rno){
		log.info("get: " + rno);
		
		param.setRno(rno);
		
		return service.remove(param) == 1 
				? new ResponseEntity<>(("success"), HttpStatus.OK)
				: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	@RequestMapping(method = { RequestMethod.PUT, RequestMethod.PATCH},
			value = "/{rno}",
			consumes = "application/json",
			produces = {MediaType.TEXT_PLAIN_VALUE})
	public ResponseEntity<String> modify(@RequestBody ReplyVO vo, @PathVariable("rno") int rno) {
		vo.setRno(rno);
		
		return service.modify(vo) == 1 
				? new ResponseEntity<>(("success"), HttpStatus.OK)
				: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
}

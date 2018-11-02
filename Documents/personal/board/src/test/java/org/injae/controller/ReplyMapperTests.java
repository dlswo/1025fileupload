package org.injae.controller;

import org.injae.domain.Param;
import org.injae.domain.ReplyVO;
import org.injae.mapper.ReplyMapper;
import org.injae.service.ReplyService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class ReplyMapperTests {
	
	@Setter(onMethod_ = @Autowired)
	private ReplyMapper mapper;
	
	@Setter(onMethod_ = @Autowired)
	private ReplyService service;
	
	@Test
	public void test() {
		
		ReplyVO vo = new ReplyVO();
		vo.setReply("update TEST");
		vo.setRno(1);
		
		log.info(mapper.update(vo));
		
	}
	
	@Test
	public void readTest() {
		Param param = new Param();
		param.setRno(2);
		
		log.info(mapper.read(param));
	}
	
	@Test
	public void deleteTest() {
		Param param = new Param();
		param.setBno(65569);
		
		log.info(mapper.delete(param));
	}
	
	@Test
	public void listTest() {
		Param param = new Param();
		param.setBno(65569);
		
		log.info(mapper.getListWithPaging(param));
	}

	@Test
	public void serviceTest() {
		ReplyVO vo = new ReplyVO();
		vo.setReply("update TEST");
		vo.setReplyer("replyer");
		vo.setBno(65573);
		service.register(vo);
	}
}

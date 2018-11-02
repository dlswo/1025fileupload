package org.injae.controller;

import org.injae.domain.BoardAttachVO;
import org.injae.domain.Param;
import org.injae.mapper.BoardAttachMapper;
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
public class BoardAttachMapperTests {
	
	@Setter(onMethod_ = @Autowired)
	private BoardAttachMapper mapper;
	
	@Test
	public void test() {
		
		BoardAttachVO vo = new BoardAttachVO();
		vo.setBno(1);
		vo.setFilename("파일이름333");
		vo.setPath("c:\\upload");
		vo.setUuid("아무거나3333");
		vo.setFiletype("img");
		
		mapper.insert(vo);
	}
	
	@Test
	public void findTest() {
		Param param = new Param();
		param.setBno(2);
		log.info(mapper.findByBno(param));
		
		
		
		log.info(mapper.deleteAll(param.getBno()));
	}

}

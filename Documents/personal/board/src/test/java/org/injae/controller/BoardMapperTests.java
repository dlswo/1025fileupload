package org.injae.controller;

import org.injae.domain.Board;
import org.injae.domain.Param;
import org.injae.mapper.BoardMapper;
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
public class BoardMapperTests {
	
	@Setter(onMethod_ = @Autowired)
	private BoardMapper mapper;
	
	@Test
	public void testAll() {
		//log.info(mapper.getList());
	}
	
	@Test
	public void insertTest() {
		Board board = new Board();
		board.setTitle("이거슨 테스트33");
		board.setWriter("미스터 황");
		board.setContent("뭔내용");
		log.info(mapper.insertSelectKey(board));
	}
	
	@Test
	public void readTest() {
		Param param = new Param();
		param.setBno(20);
		log.info(mapper.delete(param));
	}
	
	@Test
	public void countTest() {
		log.info(mapper.count());
	}
	
	@Test
	public void searchTest() {
		Param param = new Param();
		param.setType("tcw");
		param.setKeyword("ㅇㅇ");
		log.info(mapper.getList(param));
		log.info(mapper.count());
	}

}

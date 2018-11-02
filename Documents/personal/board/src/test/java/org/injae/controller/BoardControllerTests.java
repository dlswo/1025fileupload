package org.injae.controller;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;

import org.injae.domain.Board;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import com.google.gson.Gson;

import lombok.Setter;

@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration({
	"file:src/main/webapp/WEB-INF/spring/root-context.xml",
	"file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml",
})
public class BoardControllerTests {
	
	@Setter(onMethod_= @Autowired)
	private WebApplicationContext ctx;
	
	private MockMvc mockMvc;
	
	@Before
	public void setup() {
		mockMvc = MockMvcBuilders.webAppContextSetup(ctx).build();
	}
	
	@Test
	public void controllerTest()throws Exception {
		
		Board board = new Board();
		board.setTitle("이거슨 테스트33");
		board.setWriter("미스터 황");
		board.setContent("뭔내용");
		
		String str = new Gson().toJson(board);
		
		mockMvc.perform(get("/board/register")
				.contentType(MediaType.APPLICATION_JSON_UTF8_VALUE)
				.content(str));
		
	}

}

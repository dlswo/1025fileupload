package org.salem.interceptor;

import java.net.URLEncoder;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.salem.domain.MemberVO;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import lombok.extern.log4j.Log4j;

@Log4j
public class AfterLoginInterceptor extends HandlerInterceptorAdapter{

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {

		//모델- 디스패치하는 데이터(전달해주는 데이터/서버에서 나온데이터) , 뷰는 어떻게 뿌릴건지(화면)
		//responsebody는 view데이터를 쓸 수 없다.
		Object result = modelAndView.getModel().get("member");
		
		if(result==null) {
			return;
		}
		
		MemberVO memberVO = (MemberVO)result;
		
		log.info("Member: " + memberVO);
		
		Cookie loginCookie = new Cookie("lcookie",URLEncoder.encode(memberVO.getName(), "UTF-8"));
		loginCookie.setMaxAge(60*5); //쿠키 300초 유지
		response.addCookie(loginCookie);
		
	}

	
}

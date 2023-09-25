package com.ehr.web.salary;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.mail.EmailAttachment;
import org.apache.commons.mail.EmailException;
import org.apache.commons.mail.HtmlEmail;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

@Component
public class Util {
	public int obToInt(Object object) {
		int result = 0;
		
		try {
			result = Integer.parseInt((String.valueOf(object)));
		} catch (Exception e) {
			
		}
		return result; 
	}
	
	public int getEno(HttpSession session) {
		int eno = obToInt(session.getAttribute("eno"));
		return eno;
	}
	
	//경로 얻어오기
	public HttpServletRequest getCurrentRequest() {
	      return ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
	   }
	public HttpServletResponse getCurrentResponse() {
	      return ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getResponse();
	   }
	
	//세션 얻어오기
	   public HttpSession getSession() {
		   return ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest().getSession();
		   }
	
	//업로드 폴더까지의 경로 얻어오기
	   public String uploadPath() {
		      return getCurrentRequest().getServletContext().getRealPath("/upload");
		   }   
	
	public void htmlMailSender(Map<String, Object> map) throws EmailException {
	      String emailAddr = "hjsong96@outlook.com";// 보내는 사람
	      String passwd = "54540614a~";// 메일의 암호를 넣어주세요.
	      String name = "인사담당자";// 보내는 사람 이름
	      String hostname = "smtp.office365.com";// smtp 주소
	      int port = 587;// 포트가 뭔지 모르면 검색하셔야 합니다.
	      // 메일보내기 작업하기
	      //SimpleEmail mail = new SimpleEmail();
	      HtmlEmail mail = new HtmlEmail(); //html메일 보내기로 변경합니다.
	      mail.setCharset("UTF-8");
	      mail.setDebug(false);
	      mail.setHostName(hostname); // 고정
	      mail.setAuthentication(emailAddr, passwd); // 고정
	      mail.setSmtpPort(port); // 고정
	      mail.setStartTLSEnabled(true); // 고정
	      mail.setFrom(emailAddr, name); // 고정

	      mail.addTo((String) map.get("to")); // 받는 사람 email
	      mail.setSubject((String) map.get("title")); // 메일 제목
		  mail.setMsg((String) map.get("content")); //본문내용
//		  String html = "<html>";
//		  html += "<h3>님 연봉계약서 동의 여부가 선택되지 않았습니다.<br>확인 후 연봉계약서 동의 부탁드립니다.^^</h3>";
//	      html = "</html>";
//	      mail.setHtmlMsg(html);
	      String result = mail.send(); // 메일 보내기
	      System.out.println("메일 보내기 : " + result);
	   }
	
	public String exchange(String str) {
		str = str.replaceAll("a", "♥");
		return str;
	}
	
}

package com.ehr.web.main;

import java.io.File;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.mail.EmailException;
import org.apache.commons.mail.HtmlEmail;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.MultipartFile;

import com.ehr.web.attend.AttendService;
import com.ehr.web.attend.Paging;
import com.ehr.web.board.BoardService;

@Controller
public class MainController {
	@Autowired
	private MainService mainService;

	@Autowired
	private BoardService boardService;

	@Autowired
	private AttendService attendService;

	@GetMapping(value = { "/", "/login" })
	public String home() {
		return "/login";
	}

	/*
	 * @PostMapping("/login") public String login(@RequestParam Map<String, Object>
	 * map, Model model) { Map<String, Object> result = mainService.login(map);
	 * System.out.println("로그인 메소드의 결과값은 : "+result); model.addAttribute("list",
	 * result); return "main"; }
	 */

//이것도 임시로 만듬 dw
	@GetMapping("/main")
	   public String main(Map<String, Object> map, HttpSession session, Model model) {

	      if (session.getAttribute("eid") != null && session.getAttribute("eid") != "") {
	         String eid = String.valueOf(session.getAttribute("eid"));
	         Map<String, Object> result = mainService.login(eid);
	         List<Map<String, Object>> newMember = mainService.newMember();
	         System.out.println(String.valueOf(newMember.get(0).get("ehiredate")).substring(0, 10));
	         newMember.get(0).put("ehiredate", String.valueOf(newMember.get(0).get("ehiredate")).substring(0, 10));
	         newMember.get(1).put("ehiredate", String.valueOf(newMember.get(1).get("ehiredate")).substring(0, 10));
	         newMember.get(2).put("ehiredate", String.valueOf(newMember.get(2).get("ehiredate")).substring(0, 10));
	         newMember.get(3).put("ehiredate", String.valueOf(newMember.get(3).get("ehiredate")).substring(0, 10));
	         newMember.get(4).put("ehiredate", String.valueOf(newMember.get(4).get("ehiredate")).substring(0, 10));
	         System.out.println(newMember);
	         model.addAttribute("newM", newMember);
	         model.addAttribute("ehiredate", String.valueOf(result.get("ehiredate")).substring(0, 10));
	         model.addAttribute("list", result);
	         Integer egrade = (Integer) session.getAttribute("egrade");
	         System.out.println(egrade);

	         // 출결 현황 - 메인 페이지
	         map.put("eid", session.getAttribute("eid"));
	         map.put("eno", session.getAttribute("eno"));

	         List<Map<String, Object>> list2 = attendService.timeSelect(map);
	         //2023-09-23 트라이@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	         System.out.println("출근 값은 : " + list2);
	         //System.out.println("마지막 값이 나오나요 : " + list2.get(list2.size()-1).get("atmgdate"));
	         if(list2.isEmpty()) {
	            list2 = new ArrayList<Map<String,Object>>();//리스트 2를 초기화
	            Map<String, Object> nope = new HashMap<String, Object>();
	            nope.put("atmgdate", "none");
	            list2.add(nope);
	            System.out.println("새로운 출근값 : " + list2);
	         }
	         
	         String atmgdate = String.valueOf(list2.get(list2.size()-1).get("atmgdate"));
	         LocalDate now = LocalDate.now();
	         String now2 = String.valueOf(now);
	         if(atmgdate.equals(now2)) {
	            map.put("atmgdate", "exist");
	         }else {
	            System.out.println("틀린데요??");
	            map.put("atmgdate", "none");
	         }
	         
	         System.out.println(now);
	         
	         //여기까지@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	         map.put("list2", list2);
	         List<Map<String, Object>> nlist = boardService.nlist();
	         model.addAttribute("nlist", nlist);

	         for (int i = 0; i < nlist.size(); i++) {
	            nlist.get(i).put("ndate", String.valueOf(boardService.nlist().get(i).get("ndate")).substring(0, 10));
	         }
	         //System.out.println(String.valueOf(boardService.nlist().get(0).get("ndate")).substring(0, 10));

	         List<String> ndateList = new ArrayList<>();

	         for (Map<String, Object> data : boardService.nlist()) {
	            if (data.containsKey("ndate")) {
	               Object ndateObj = data.get("ndate");
	               if (ndateObj instanceof String) {
	                  String ndate = (String) ndateObj;
	                  if (ndate.length() >= 10) {
	                     String truncatedDate = ndate.substring(0, 10);
	                     ndateList.add(truncatedDate);
	                  }
	               }
	            }
	         }

	         model.addAttribute("ndate", ndateList);

	         return "/main";
	      }

	      return "login";
	   }

//로그인 확인하기 dw
	@ResponseBody
	@PostMapping("/loginCheck")
	public String loginCheck(@RequestParam Map<String, Object> map, HttpSession session) {
		JSONObject json = new JSONObject();
		// 일치하는 아이디가 있는지 ?
		int IDresult = mainService.IDresult(map);
		// System.out.println("★IDresult의 값은 : " + IDresult);
		// System.out.println("★map의 값은: " + map);
		if (IDresult == 0) {
			json.put("IDresult", 0);
			return json.toString();
		} else {
			int ecount = mainService.eCount(map);
			System.out.println("ecount의 값은 : " + ecount);
			// 5회 이상 틀린 사람 아이디 잠궈버리기
			if (ecount > 5) {
				String uuid = UUID.randomUUID().toString().substring(0, 8);
				map.put("uuid", uuid);
				int result = mainService.ecountPW(map);
				// System.out.println("UUID로 바꿔버린 비밀번호 : " + map.get("id"));
				json.put("ecount", ecount);
				json.put("result", 1);
				return json.toString();
			}
			int PWresult = mainService.PWresult(map);
			if (PWresult == 1) {
				Map<String, Object> loginCheck = mainService.loginCheck(map);
				// System.out.println("★로그인 했을때 값은 : " + loginCheck);

				// ecount를 0으로 초기화
				int result = mainService.eCountReset(map);
				// System.out.println("이카운트 결과 값은 : " + result);
				session.setAttribute("ename", loginCheck.get("ename"));
				session.setAttribute("eid", map.get("id"));
				session.setAttribute("edept", loginCheck.get("edept"));
				session.setAttribute("eno", loginCheck.get("eno"));
				session.setAttribute("egrade", loginCheck.get("egrade"));

				json.put("ecount", ecount);
				json.put("result", 1);
				return json.toString();
			} else {
				int result0 = mainService.eCountPlus(map);
				json.put("result", 0);
				json.put("ecount", ecount);
				return json.toString();
			}
		}
	}

	@GetMapping("/join")
	public String join() {
		return "/join";
	}

	@PostMapping("/join")
	public String join(@RequestParam(value="eimg",required = false) MultipartFile eimg,@RequestParam Map<String, Object> map, Model m) {
	   System.out.println(map);
	   System.out.println(map.get("errn"));
	   System.out.println(map.get("errn2"));
	   String eemail = String.valueOf(map.get("eemail"))+"@ehr.net";
	      map.put("eemail", eemail);

	   String errn = String.valueOf(map.get("errn")) + String.valueOf(map.get("errn2"));
	   map.put("errn", errn);
	   if (!eimg.isEmpty()) {
	      // 저장할 경로명 뽑기 request뽑기
	      HttpServletRequest req = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes())
	            .getRequest();
	      String path = req.getServletContext().getRealPath("/upload");
	      //System.out.println("=======================================================");
	      System.out.println("실제경로:" + path);
	      // upfile 정보 보기
	      System.out.println("이미지 오리지널 파일 이름 : " + eimg.getOriginalFilename());
	      
	      
	      //System.out.println(eimg.getSize());
	      //System.out.println(eimg.getContentType());
	      
	      LocalDateTime ldt = LocalDateTime.now();
	      String format = ldt.format(DateTimeFormatter.ofPattern("YYYYMMddHHmmss"));
	      String realFileName = format + eimg.getOriginalFilename();
	      
	      
	      //확장자 자르기
	      String[] parts = eimg.getOriginalFilename().split("\\.");
	      String lastPart = parts[parts.length - 1];
	      System.out.println(lastPart);
	      if(!(lastPart.equals("jpg") || lastPart.equals("png") || lastPart.equals("jpeg") || lastPart.equals("bmp") || lastPart.equals("gif") || lastPart.equals("jpe"))) {
	         realFileName = "noimg2.png";
	      }
	      //요기까지가 확장자 다르면 noimg2.png 박아넣기
	      File newFileName = new File(path, realFileName);
	      
	      try {
	      } catch (Exception e) {
	         e.printStackTrace();
	      }

	      try {
	         FileCopyUtils.copy(eimg.getBytes(), newFileName);
	      } catch (IOException e) {
	         e.printStackTrace();
	      }

	      // #{upFile}, #{realFile}
	      //map.put("upFile", upfile.getOriginalFilename());
	      //map.put("realFile", realFileName);
	      System.out.println(realFileName);
	      map.put("realFile", realFileName);
	      m.addAttribute("realFile",realFileName);
	   }
	   System.out.println("이미지가 비어있나요? : "+eimg.isEmpty());
	   if(eimg.isEmpty()) {
	      map.put("realFile", "noimg2.png");
	   }
	   
	   mainService.join(map);

	   return "redirect:/main";
	}

	@ResponseBody
	@PostMapping("/eidcheck")
	public String eidcheck(@RequestParam("eid") String eid) {
		int result = mainService.eidcheck(eid);

		JSONObject json = new JSONObject();
		json.put("result", result);
		return json.toString();
	}

	@ResponseBody
	@PostMapping("/eemailcheck")
	public String eemailcheck(@RequestParam("eemail") String eemail) {
		int result = mainService.eemailcheck(eemail);

		JSONObject json = new JSONObject();
		json.put("result", result);
		return json.toString();
	}

	@GetMapping("/logout")
	public String logout(HttpSession session) {
		if (session.getAttribute("eid") != null) {
			session.invalidate();
		}
		return "redirect:/";
	}

	@GetMapping("/findID")
	public String findID() {
		return "findID";
	}

	@GetMapping("/findPW")
	public String findPW() {
		return "findPW";
	}

	@GetMapping("/mypage")
	public String mypage(HttpSession session, Model model) {
		if (session.getAttribute("eid") != null && session.getAttribute("eid") != "") {
			String eid = String.valueOf(session.getAttribute("eid"));
			Map<String, Object> result = mainService.login(eid);
			String ebirth = String.valueOf(result.get("ebirth")).substring(0, 10);
			model.addAttribute("ebirth", ebirth);
			model.addAttribute("ehiredate", String.valueOf(result.get("ehiredate")).substring(0, 10));
			model.addAttribute("list", result);

			LocalDate currentDate = LocalDate.now();
			int currentYear = currentDate.getYear();

			int birthYear = Integer.parseInt(ebirth.substring(0, 4));
			System.out.println(currentYear - birthYear);
			int age = currentYear - birthYear;
			model.addAttribute("age", age);

			String[] arr = { "사원", "주임", "대리", "과장", "차장", "부장", "부사장", "사장", "관리자" };
			model.addAttribute("egrade", arr[Integer.parseInt(String.valueOf(result.get("egrade")))]);
			return "/mypage";
		}

		return "login";
	}

	@GetMapping("/mypageupdate")
	public String mypageupdate(HttpSession session, Model model) {
		if (session.getAttribute("eid") != null && session.getAttribute("eid") != "") {
			String eid = String.valueOf(session.getAttribute("eid"));
			Map<String, Object> result = mainService.login(eid);
			// System.out.println(result);
			String ebirth = String.valueOf(result.get("ebirth")).substring(0, 10);
			result.put("ehiredate", String.valueOf(result.get("ehiredate")).substring(0, 10));
			result.put("ebirth", ebirth);

			LocalDate currentDate = LocalDate.now();
			int currentYear = currentDate.getYear();

			int birthYear = Integer.parseInt(ebirth.substring(0, 4));
			// System.out.println(currentYear-birthYear);
			int age = currentYear - birthYear;
			model.addAttribute("age", age);
			model.addAttribute("list", result);
			String[] arr = { "사원", "주임", "대리", "과장", "차장", "부장", "부사장", "사장", "관리자" };
			model.addAttribute("egrade", arr[Integer.parseInt(String.valueOf(result.get("egrade")))]);
			return "mypageupdate";
		} else {
			return "redirect:/";
		}
	}

	@PostMapping("/mypageupdate")
	public String mypageupdate(HttpSession session, Model model,
			@RequestParam(value = "eimg", required = false) MultipartFile eimg, @RequestParam Map<String, Object> map) {

		if (!eimg.isEmpty()) {
			// 저장할 경로명 뽑기 request뽑기
			HttpServletRequest req = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes())
					.getRequest();
			String path = req.getServletContext().getRealPath("/upload");
			// System.out.println("=======================================================");
			System.out.println("실제경로:" + path);
			// upfile 정보 보기
			System.out.println(eimg.getOriginalFilename());
			// System.out.println(eimg.getSize());
			// System.out.println(eimg.getContentType());

			LocalDateTime ldt = LocalDateTime.now();
			String format = ldt.format(DateTimeFormatter.ofPattern("YYYYMMddHHmmss"));
			String realFileName = format + eimg.getOriginalFilename();

			File newFileName = new File(path, realFileName);

			try {
			} catch (Exception e) {
				e.printStackTrace();
			}

			try {
				FileCopyUtils.copy(eimg.getBytes(), newFileName);
			} catch (IOException e) {
				e.printStackTrace();
			}

			System.out.println(realFileName);
			map.put("realFile", realFileName);
			model.addAttribute("realFile", realFileName);
		}

		System.out.println(map);
		map.put("eid", session.getAttribute("eid"));
		mainService.mypageupdate(map);

		return "redirect:/mypage";
	}

//2023-09-12 추가
	@ResponseBody
	@PostMapping("/findID")
	public String findID(@RequestParam Map<String, Object> map) {
		JSONObject json = new JSONObject();
		System.out.println(map);
		Map<String, Object> result = mainService.findID(map);
		System.out.println(result);
		json.put("result", result);
		return json.toString();
	}

	@ResponseBody
	@PostMapping("/findPW")
	public String findPW(@RequestParam Map<String, Object> map) {
		JSONObject json = new JSONObject();
		// System.out.println(map);
		Map<String, Object> result = mainService.findPW(map);
		System.out.println(result);

		if (Integer.parseInt(String.valueOf(result.get("count"))) == 1) {
			String email = String.valueOf(result.get("eemail2"));
			System.out.println(email);
			String email2 = email.substring(1, 4);
			String email3 = "●".repeat(email2.length());
			String email4 = email.replace(email2, email3);
			System.out.println(email4);
			result.put("email2", email4);
			result.put("to", email);

			result.put("title", "[지식소프트] 임시 비밀번호입니다.");
			String uuid = String.valueOf(UUID.randomUUID()).substring(0, 7);
			result.put("uuid", uuid);
			// System.out.println(uuid);
			mainService.changePW(result);
			// System.out.println("두 번째 결과값 : " + result);
			json.put("result", result);
			try {
				htmlMailSender(result, uuid);
			} catch (EmailException e) {
				String error = "현재 사내 메일 시스템 오류로 인해 임시 이메일 발송이 어렵습니다. 임시 비밀번호는 " + uuid + " 입니다. 로그인을 시도해주세요.";
				json.put("error", error);
			}
			return json.toString();
		} else {
			result.put("eid", "0");
			System.out.println("1아님 ㅠㅠ");
			System.out.println("카운트가 0일 때 : " + result);
			json.put("result", result);
			return json.toString();
		}

	}

	public void htmlMailSender(Map<String, Object> map, String pw) throws EmailException {
		String emailAddr = "korea96440@outlook.com";
		String passwd = "1QAZXSW23EDC"; // 메일의 암호를 넣어주세요
		String name = "지식소프트";// 보내는 사람 이름
		String hostname = "smtp.office365.com";// smtp 주소
		int port = 587;// 포트가 뭔지 모르면 검색하셔야 합니다.
		// 메일보내기 작업하기
		// SimpleEmail mail = new SimpleEmail();
		HtmlEmail mail = new HtmlEmail(); // html메일 보내기로 변경합니다.
		mail.setCharset("UTF-8");
		mail.setDebug(false);
		mail.setHostName(hostname); // 고정
		mail.setAuthentication(emailAddr, passwd); // 고정
		mail.setSmtpPort(port); // 고정
		mail.setStartTLSEnabled(true); // 고정
		mail.setFrom(emailAddr, name); // 고정

		mail.addTo((String) map.get("to")); // 받는 사람 email
		mail.setSubject((String) map.get("title")); // 메일 제목
		// mail.setMsg((String) map.get("content")); // 본문내용
		// 이미지 경로 잡아오기
		String img = "http://172.30.1.33/img/logo.png";
		// String file2 = path + "/Thymeleaf.docx";

		String html = "<html>";// 코드가 길어지니 여기서 작업해서 넣어줄게욤.
		// html += "<h1>그림을 첨부합니다</h1>";
		// html += "<img alt=\"이미지\" src='"+img+"'>";
		html += "<h2>임시 비밀번호를 보내드립니다.</h2>";
		html += "<div> 임시 암호 : " + pw + "</div>";
		html += "<h3>인사 홈페이지로 돌아가서 로그인을 진행해주세요.</h3>";
		// html += "<a href='/localhost'>눌러주세요</a>";
		html += "</html>";
		mail.setHtmlMsg(html);
		// 첨부파일도 보내기
		// EmailAttachment file = new EmailAttachment();
		// 위 파일은 문서파일입니다.
		// file.setPath(file2);
		// mail.attach(file);

		String result = mail.send(); // 메일 보내기
		System.out.println("메일 보내기 : " + result);
	}

	@GetMapping("/memberlist")
	public String memberlist(Model model) {

		List<Map<String, Object>> list = mainService.memberlist();
		model.addAttribute("list", list);

		for (int i = 0; i < list.size(); i++) {
			list.get(i).put("ehiredate",
					String.valueOf(mainService.memberlist().get(i).get("ehiredate")).substring(0, 10));
			list.get(i).put("ebirth", String.valueOf(mainService.memberlist().get(i).get("ebirth")).substring(0, 10));

			String ebirth = String.valueOf(list.get(i).get("ebirth")).substring(0, 4);

			int ebirthYear = Integer.parseInt(ebirth);

			LocalDate currentDate = LocalDate.now();
			int currentYear = currentDate.getYear();

			int eage = currentYear - ebirthYear;
			list.get(i).put("eage", eage);
			// System.out.println("eage:" + list.get(i).get("eage"));

			model.addAttribute("eage", list.get(i).get("eage"));
		}
		return "memberlist";
	}

	@RequestMapping(value = "/egradeChange", method = RequestMethod.GET)
	public String gradeChange(@RequestParam Map<String, String> map) {
		int result = mainService.egradeChange(map);
		System.out.println(result);
		return "redirect:/memberlist";
	}

	@RequestMapping(value = "/edeptChange", method = RequestMethod.GET)
	public String edeptChange(@RequestParam Map<String, String> map) {
		// System.out.println(map);
		int result = mainService.edeptChange(map);
		return "redirect:/memberlist";
	}

//2023-09-20 추가
	@GetMapping("/changePW")
	public String changePW(HttpSession session, Model model) {
		model.addAttribute("eno", session.getAttribute("eno"));
		return "changePW";
	}

	@PostMapping("/checkPW")
	@ResponseBody
	public String checkPW(@RequestParam Map<String, Object> map) {
		JSONObject json = new JSONObject();
		// System.out.println(map);
		int result = mainService.checkPW(map);
		// System.out.println("result의 값은 : " + result);
		if (result == 1) {
			json.put("result", "ok");
		} else {
			json.put("result", "nope");
		}
		return json.toString();
	}

	@PostMapping("/changePW")
	@ResponseBody
	public String changePW(@RequestParam Map<String, Object> map) {
		JSONObject json = new JSONObject();
		System.out.println(map);
		int count = mainService.searchPW(map);
		if (count == 1) {
			System.out.println("중복");
			json.put("eno", "exist");
		} else {

			int result = mainService.newPW(map);
			System.out.println("새 비밀번호 값은 : " + result);
		}
		return json.toString();

	}
}
//컨트롤러 끝

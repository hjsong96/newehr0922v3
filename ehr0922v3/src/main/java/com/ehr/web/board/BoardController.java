package com.ehr.web.board;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ehr.web.attend.Paging;

@Controller
public class BoardController {
	@Autowired
	private BoardService boardService;

//날짜 자르는 메소드
	public String cutDate(Object str) {
		String str2 = String.valueOf(str).substring(0, 10);
		return str2;
	}

	@GetMapping("/annonyboard")
	public String annonyBoard(@RequestParam(value = "page", required = false, defaultValue = "1") int page, Model model,
			HttpSession session) {
		if (session.getAttribute("eno") != null) {
			int pageSize = 10;
			int totalCnt = boardService.acount();
			model.addAttribute("totalCnt", totalCnt);

			Paging paging = new Paging(totalCnt, page, pageSize);

			if (page < 0 || page > paging.getTotalPage())
				page = 1;
			if (pageSize < 0 || pageSize > 50)
				pageSize = 10;

			int pageCount = totalCnt / pageSize;
			// System.out.println("첫 페이지 카운트는" + pageCount);
			if (totalCnt % pageSize != 0) {
				pageCount = pageCount + 1;
			}
			// System.out.println("결과 페이지 카운트는 : " + pageCount);

			Map<String, Integer> map = new HashMap<String, Integer>();
			// .put("pageIndex", pagingDTO.getPageIndex());
			map.put("pageSize", pageSize);
			map.put("offset", (page - 1) * pageSize);
			// 게시판 신고 횟수 조회
			String eid = String.valueOf(session.getAttribute("eid"));
			int eboardCount2 = boardService.eboardCount2(eid);
			// System.out.println("보드 카운트의 값은 : " + eboardCount2);
			List<Map<String, Object>> list = boardService.alist(map);
			LocalDate now = LocalDate.now();
			String now2 = String.valueOf(now);
			for (int i = 0; i < list.size(); i++) {
				String date = String.valueOf(list.get(i).get("abdate"));
				String date2 = cutDate(date);
				if (now2.equals(date2)) {
					String date3 = String.valueOf(list.get(i).get("abdate")).substring(11, 16);
					list.get(i).put("abdate", date3);
				} else {

					list.get(i).put("abdate", cutDate(list.get(i).get("abdate")));
				}
			}
			list.get(0).get("abdate");
			System.out.println("오늘 날짜는 : " + now);
			System.out.println("리스트의 값은 : " + list);
			// 댓글 가져오기
			// List<Map<String, Object>> comment = boardService.comment

			// System.out.println(count);
			model.addAttribute("eboardCount", eboardCount2);
			model.addAttribute("pageCount", pageCount);
			model.addAttribute("list", list);
			model.addAttribute("ph", paging);
			return "annonyboard";
		} else {
			return "/";
		}

	}

//익명게시판 글쓴이 만들어주는 메소드
//2023-09-18 수정
	public String annonywriter() {
		String[] arr01 = { "수진", "화진", "대원", "재윤", "지선", "승리" };
		String[] arr02 = { "집가는", "공부하는", "자는", "코딩하는", "사과게임하는", "일기쓰는", "커피마시는", "발표하는", "숨쉬는", "밥먹는", "운동하는", "병원가는",
				"지하철타는", "버스타는", "점프하는", "달리는", "쉬고있는", "과자먹는", "배고픈", "지루한", "부탁하는", "분주한" };
		int random1 = (int) (Math.random() * arr01.length);
		int random2 = (int) (Math.random() * arr02.length);
		String nickName = arr02[random2] + " " + arr01[random1];
		return nickName;
	}

//2023-09-18 수정
	@GetMapping("/annonyWrite")
	public String annonywrite(Model model, HttpSession session) {

		// System.out.println(nickName);
		if (session.getAttribute("eno") != null) {

			// 게시판 신고 횟수 조회
			String eid = String.valueOf(session.getAttribute("eid"));
			int eboardCount2 = boardService.eboardCount2(eid);
			if (eboardCount2 < 6) {

				model.addAttribute("nickName", annonywriter());
				return "/annonywrite";
			} else {
				return "redirect:/annonyboard";
			}

		} else {
			return "/";
		}
	}

	@PostMapping("/annonyWrite")
	public String annonywrite(@RequestParam Map<String, Object> map) {

		System.out.println(map);
		boardService.awrite(map);
		return "redirect:/annonyboard";
	}

//2023-09-22 수정
	@GetMapping("/annonyDetail")
	public String annonyDetail(@RequestParam(value = "num", required = false, defaultValue = "1") int num,
			Model model) {
		Map<String, Object> detail = boardService.adetail(num);
		String abdate = String.valueOf(detail.get("abdate")).substring(0, 16);
		detail.put("abdate", abdate);
		int abno = Integer.parseInt(String.valueOf(detail.get("abno")));
		boardService.areadUp(abno);
		// System.out.println(detail);
		// {abcontent=<p>FSADFSAD</p>, abdate=2023-09-16 11:09:38.0, rowNum=39,
		// abread=14, abwrite=점프하는 재윤, eno=44, abtitle=FDAS, abdel=1, abno=410}
		int count = boardService.commentCount(abno);
		List<Map<String, Object>> commentList = boardService.commentList(abno);
		// [{c_date=2023-09-18 10:37:56.0, c_secret=0, c_write=부탁하는 무지1, cno=1, cdel=0,
		// eno=13, abno=410, c_comment=ㅋㅋㅎㅇ}]
		model.addAttribute("count", count);
		model.addAttribute("commentList", commentList);
		model.addAttribute("detail", detail);

		model.addAttribute("commentWriter", annonywriter());
		return "annonydetail";
	}

	@GetMapping("/adetailDel")
	public String adetailDel(@RequestParam(value = "abno") int abno, HttpSession session) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("abno", abno);
		map.put("eno", session.getAttribute("eno"));
		int count = boardService.acheckEno(map);
		if (count == 1) {

			System.out.println("abno의 값은 : " + abno);
			boardService.adel(abno);
			return "redirect:/annonyboard";
		} else {
			return "redirect:/annonyboard";
		}

	}

	@GetMapping("/adetailUp")
	public String adetailUp(@RequestParam(value = "num") int num, Model model, HttpSession session) {

		Map<String, Object> detail = boardService.adetail(num);
		detail.put("eno", session.getAttribute("eno"));
		System.out.println("수정할 값은 : " + detail);
		int count = boardService.acheckEno(detail);
		if (count == 1) {
			System.out.println("카운트의 값은 : " + count);
			model.addAttribute("detail", detail);
			return "adetailup";

		} else {
			return "redirect:/annonyboard";
		}

	}

	@PostMapping("/adetailUp")
	public String adetailUp(@RequestParam Map<String, Object> map) {
		System.out.println(map);
		boardService.adetailUp(map);
		return "redirect:/annonyboard";
	}

//2023-09-18 추가
	@PostMapping("/comment")
	public String comment(@RequestParam Map<String, Object> map, HttpSession session) {
		if (session.getAttribute("eno") != null) {

			if (map.get("secret") == null) {
				map.put("secret", 1);
			}
			// System.out.println("eno의 값 : " + session.getAttribute("eno"));
			// System.out.println("detailEno의 값 : " + map.get("detailEno"));
			// System.out.println(String.valueOf(session.getAttribute("eno")).equals(String.valueOf(map.get("detailEno"))));
			if (String.valueOf(session.getAttribute("eno")).equals(String.valueOf(map.get("detailEno")))) {
				// System.out.println("작성자와 게시판 글쓴이가 같습니다.");
				map.put("c_self", 0);
			}
			System.out.println("디테일 eno의 값은 : " + map.get("detailEno"));
			// 게시판의 eno와 세션의 eno가 같으면 (작성자) 추가

			/*
			 * if( map.get("eno").equals(map.get("detailEno"))) {
			 * System.out.println("값이 같구나"); map.put("writer", map.get("writer") +
			 * " (작성자) "); }
			 */
			System.out.println("댓글에 들어오는 값은 : " + map);
			boardService.comment(map);

			return "redirect:/annonyDetail?num=" + map.get("rowNum");
		} else {
			return "/";
		}

	}

	@GetMapping("/notice")
	public String notice(Model model, HttpSession session, @RequestParam(defaultValue = "1") Integer page,
			@RequestParam(defaultValue = "10") Integer pageSize) {
		if (session.getAttribute("eid") != null) {

			LocalDate now = LocalDate.now();
			String now2 = String.valueOf(now);

			int totalCnt = boardService.getCount();
			model.addAttribute("totalCnt", totalCnt);

			Paging paging = new Paging(totalCnt, page, pageSize);

			if (page < 0 || page > paging.getTotalPage())
				page = 1;
			if (pageSize < 0 || pageSize > 50)
				pageSize = 10;

			Map<String, Object> map = new HashMap<String, Object>();
			map.put("offset", (page - 1) * pageSize);
			map.put("pageSize", pageSize);

			List<Map<String, Object>> list = boardService.getPage(map);

			for (int i = 0; i < list.size(); i++) {
				String date = String.valueOf(list.get(i).get("ndate"));
				String date2 = cutDate(date);
				if (now2.equals(date2)) {
					String date3 = String.valueOf(list.get(i).get("ndate")).substring(11, 16);
					list.get(i).put("ndate", date3);
				} else {

					list.get(i).put("ndate", cutDate(list.get(i).get("ndate")));
				}
			}

			model.addAttribute("list", list);
			model.addAttribute("ph", paging);
			// System.out.println(list);
			return "notice";
		} else {
			return "redirect:/notice";
		}
	}

	@GetMapping("/noticeWrite")
	public String noticeWrite(Model model, HttpSession session) {

		return "noticewrite";

	}

	@PostMapping("/noticeWrite")
	public String noticeWrite(@RequestParam Map<String, Object> map, HttpSession session) {

		System.out.println(map);
		map.put("eid", session.getAttribute("eid"));
		boardService.nwrite(map);
		System.out.println(map);
		return "redirect:/notice";

	}

	@GetMapping("/noticeDetail")
	public String noticeDetail(@RequestParam("nno") int nno, Model m) {
		Map<String, Object> noticeDetail = boardService.ndetail(nno);
		boardService.nreadUp(Integer.parseInt(String.valueOf(noticeDetail.get("nno"))));
		System.out.println(noticeDetail);
		m.addAttribute("nd", noticeDetail);

		return "noticedetail";
	}

	@GetMapping("/ndetailDel")
	public String ndetailDel(@RequestParam("nno") int nno, HttpSession session) {

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("nno", nno);
		map.put("eno", session.getAttribute("eno"));
		int count = boardService.ncheckEno(map);
		System.out.println("count" + count);
		System.out.println("=====");
		if (count == 1) {
			System.out.println("nno의 값은 : " + nno);
			boardService.ndel(nno);
			return "redirect:/notice";
		} else {
			return "redirect:/notice";
		}

	}

	@GetMapping("/ndetailUp")
	public String ndetailUp(HttpSession session, @RequestParam Map<String, Object> map, Model model) {

		System.out.println(map);
		int nno = Integer.parseInt(String.valueOf(map.get("nno")));

		Map<String, Object> res = boardService.ndetail(nno);
		res.put("eno", session.getAttribute("eno"));

		int count = boardService.ncheckEno(res);
		System.out.println(count);
		if (count == 1) {
			model.addAttribute("res", res);
			return "noticeupdate";
		} else {
			return "redirect:/notice";
		}

	}

	@PostMapping("/ndetailUp")
	public String ndetailUp(@RequestParam Map<String, Object> map, HttpSession session, Model m) {
		System.out.println(map);

		map.put("eno", session.getAttribute("eno"));

		boardService.ndetailUp(map);
		return "redirect:notice"; // 다시 컨트롤러 지나가기 GET방식으로 간다.
	}

//2023-09-19 여기서부터 추가된 부분
	@PostMapping("/cedit")
	public String cedit(@RequestParam Map<String, Object> map) {
		System.out.println(map);
		boardService.cedit(map);
		return "redirect:/annonyDetail?num=" + map.get("rowNum");
	}

	@ResponseBody
	@PostMapping("/cdel")
	public String cdel(@RequestParam Map<String, Object> map) {
		JSONObject json = new JSONObject();
		System.out.println(map);
		int result = boardService.cdel(map);
		System.out.println(result);
		json.put("result", "ok");
		return json.toString();
	}

	@ResponseBody
	@PostMapping("/report")
	public String report(@RequestParam Map<String, Object> map) {
		JSONObject json = new JSONObject();
		System.out.println("신고 값은 : " + map);
		int result = boardService.report(map);
		System.out.println(result);
		if (result == 1) {
			json.put("result", result);
		}
		return json.toString();
	}

	@GetMapping("/report")
	public String report(@RequestParam(name = "num") int num, Model model) {
		System.out.println(num);
		Map<String, Object> detail = boardService.adetail(num);
		model.addAttribute("detail", detail);
		return "report";
	}

	@GetMapping("/checkBoard")
	   public String checkBoard(Model model, HttpSession session) {
	      if (Integer.parseInt(String.valueOf(session.getAttribute("egrade"))) == 8) {
	         List<Map<String, Object>> list = boardService.reportList();
	         System.out.println(list);
	         for (int i = 0; i < list.size(); i++) {
	            
	            String rdate =  String.valueOf(list.get(i).get("rdate")).substring(0, 19);
	            list.get(i).put("rdate", rdate);
	         }
	         model.addAttribute("list", list);
	         return "checkBoard";
	      } else {
	         return "redirect:/main";
	      }
	   }

	@ResponseBody
	@PostMapping("/reportDetail")
	public String reportDetail(@RequestParam(name = "abno") int abno) {
		JSONObject json = new JSONObject();
		System.out.println(abno);
		Map<String, Object> detail = boardService.reportDetail(abno);
		System.out.println(detail);
		json.put("detail", detail);
		return json.toString();
	}

	@ResponseBody
	@PostMapping("/reportAgree")
	public String reportAgree(@RequestParam(value = "abno") int abno,
			@RequestParam(value = "rreported") int rreported) {
		System.out.println("abno 승인 값 : " + abno);
		JSONObject json = new JSONObject();
		int result = boardService.reportAgree(abno);

		if (result == 1) {
			System.out.println("승인 성공");
			boardService.eboardCount(rreported);
			boardService.adel(abno);
		}

		return json.toString();
	}

	@ResponseBody
	@PostMapping("/reportReject")
	public String reportReject(@RequestParam(value = "abno") int abno) {
		JSONObject json = new JSONObject();
		int result = boardService.reportReject(abno);
		json.put("result", result);
		return json.toString();
	}

	@GetMapping("/reportDetail")
	public String reportDetail(@RequestParam(name = "abno") int abno, Model model) {
		Map<String, Object> detail = boardService.reportDetail(abno);
		String abdate = String.valueOf(detail.get("abdate")).substring(0, 16);
		detail.put("abdate", abdate);
		// System.out.println("abno의 값은 : " + abno);

		// 중복 신고된 횟수
		int reportCount = boardService.reportCount(abno);
		model.addAttribute("detail", detail);
		model.addAttribute("reportCount", reportCount);
		return "reportDetail";
	}
}// 컨트롤러 끝

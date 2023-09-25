package com.ehr.web.attend;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

@Controller
public class AttendController {
	@Autowired
	private AttendService attendService;

	@PostMapping("/attend")
	public String attend(HttpServletRequest request) {
		return "";
	}

	@GetMapping("/attendRegister")
	public String attendRegister(Model model, HttpSession session, @RequestParam(defaultValue = "1") Integer page,
			@RequestParam Map<String, Object> map) {
		if (session.getAttribute("eid") != null) {
			int pageSize = 10;
			String eid = String.valueOf(session.getAttribute("eid"));
			map.put("eid", eid);
			int totalCnt = attendService.getCount(map); // 전체 게시글 개수
			model.addAttribute("totalCnt", totalCnt);
			System.out.println("선택한것: " + map.get("searchData") + " / 글수 : " + totalCnt);

			Paging paging = new Paging(totalCnt, page, pageSize);

			if (page < 0 || page > paging.getTotalPage())
				page = 1;
			if (pageSize < 0 || pageSize > 50)
				pageSize = 10;

			Map<String, Object> map2 = new HashMap<String, Object>();
			map2.put("offset", (page - 1) * pageSize);
			map2.put("eid", eid);
			map2.put("pageSize", pageSize);
			map2.put("selected", map.get("searchData"));
			map2.put("atregdate", map.get("atregdate"));
			map2.put("atregsts", map.get("atregsts"));
			map2.put("atregacpt", map.get("atregacpt"));
			map2.put("atregcontent", map.get("atregcontent"));
			map2.put("atregcomment", map.get("atregcomment"));

			System.out.println(map2.get("selected"));

			List<AttendDTO> attendList = attendService.attendList(map2);
			System.out.println("신청리스트 : " + attendList);
			model.addAttribute("attendList", attendList);
			model.addAttribute("ph", paging);
			model.addAttribute("selectedMap", map);
			return "attendRegister";
		} else {
			return "redirect:/login";
		}
	}

	@PostMapping("/atapplication")
	public String atapplication(AttendDTO attendDTO, HttpSession session) {
		if (session.getAttribute("eid") != null) {
			attendDTO.setEid(String.valueOf(session.getAttribute("eid")));
			System.out.println(attendDTO);
			attendService.atapplication(attendDTO);
			return "redirect:/attendRegister";
		} else {
			return "redirect:/login";
		}
	}

	@ResponseBody
	@PostMapping("/atcancel")
	public String atcancel(@RequestParam(value = "chkarr[]") List<Integer> atregnoArr) throws JsonProcessingException {
		for (int i = 0; i < atregnoArr.size(); i++) {
			System.out.println("관리번호 : " + atregnoArr.get(i));
			attendService.atcancel(atregnoArr.get(i));
		}
		int result = 0;
		ObjectMapper mapp = new ObjectMapper();
		String json = mapp.writeValueAsString(result);

		return json;
	}

	@ResponseBody
	@PostMapping("/atview")
	public String atview(@RequestParam(value = "chkarr[]") List<Integer> atregnoArr) throws JsonProcessingException {
		int atregno = atregnoArr.get(0);
		AttendDTO result = attendService.attendView(atregno);
		ObjectMapper mapp = new ObjectMapper();
		String json = mapp.writeValueAsString(result);
		return json;
	}

	@ResponseBody
	@PostMapping("/ateditview")
	public String ateditview(@RequestParam(value = "chkarr[]") List<Integer> atregnoArr, Model model)
			throws JsonProcessingException {
		int atregno = atregnoArr.get(0);
		model.addAttribute("edit-atregno", atregno);
		AttendDTO result = attendService.attendView(atregno);
		ObjectMapper mapp = new ObjectMapper();
		String json = mapp.writeValueAsString(result);
		return json;
	}

	@PostMapping("/atedit")
	public String atedit(AttendDTO attendDTO, HttpSession session) {
		attendDTO.setEid(String.valueOf(session.getAttribute("eid")));
		attendService.attendEdit(attendDTO);
		return "redirect:/attendRegister";
	}

	@GetMapping("/attend")
	public String attend(Map<String, Object> map, Model model, HttpSession session) {

		map.put("eid", session.getAttribute("eid"));
		map.put("eno", session.getAttribute("eno"));

		List<Map<String, Object>> list = attendService.timeSelect(map);
		map.put("list", list);

		Map<String, Object> nowResult = attendService.nowResult(map);
		map.put("nowResult", nowResult);

		System.out.println(list);

		return "attend";
	}

	@ResponseBody
	@PostMapping("/attendIn")
	public String attendIn(@RequestParam Map<String, Object> map, HttpSession session, Model model) {

		System.out.println(map);

		int result = 0;
		System.out.println(session.getAttribute("eid"));
		map.put("eid", session.getAttribute("eid"));
		map.put("ename", session.getAttribute("ename"));

		if (session.getAttribute("eid") != null) { // 로그인 계정
			if (Integer.parseInt((String) map.get("btnIn")) == 0) { // 출근 시간이 안 찍혀있으면
				result = attendService.atmanageInsert(map);
				System.out.println("result : " + result);
			}
		}

		JSONObject json = new JSONObject();
		json.put("result", result);

		return json.toString();
	}

	@ResponseBody
	@PostMapping("/attendOut")
	public String attendOut(@RequestParam Map<String, Object> map, HttpSession session) {

		System.out.println(map);

		int result2 = 0;
		System.out.println(session.getAttribute("eid"));
		map.put("eid", session.getAttribute("eid"));
		map.put("ename", session.getAttribute("ename"));
		// 컨트롤러에서 현재날짜와 로그인한 사번의 atmgno를 map에다 담아 update문을 실행한다.
		int atmgno = attendService.noList(map);
		System.out.println("atmgno: " + atmgno);
		map.put("atmgno", atmgno);

		if (session.getAttribute("eid") != null) { // 로그인 계정
			if (Integer.parseInt((String) map.get("btnOut")) == 0) {
				result2 = attendService.atmanageUpdate(map);
				System.out.println("result2 : " + result2);
			}
		}

		JSONObject json = new JSONObject();
		json.put("result2", result2);

		return json.toString();
	}

	@GetMapping("/attendAdmin")
	public String attendAdmin(Model model, HttpSession session, @RequestParam(defaultValue = "1") Integer page,
			@RequestParam Map<String, Object> map) {
		if (Integer.parseInt(String.valueOf(session.getAttribute("egrade"))) == 8) {
			int pageSize = 10;
			int totalCnt = attendService.getCountAll(map); // 전체 게시글 개수
			model.addAttribute("totalCnt", totalCnt);

			Paging paging = new Paging(totalCnt, page, pageSize);

			if (page < 0 || page > paging.getTotalPage())
				page = 1;
			if (pageSize < 0 || pageSize > 50)
				pageSize = 10;

			Map<String, Object> map2 = new HashMap<String, Object>();
			map2.put("offset", (page - 1) * pageSize);
			map2.put("pageSize", pageSize);
			map2.put("selected", map.get("searchData"));
			map2.put("atregdate", map.get("atregdate"));
			map2.put("egrade", map.get("egrade"));
			map2.put("atregsts", map.get("atregsts"));
			map2.put("atregacpt", map.get("atregacpt"));
			map2.put("atregcontent", map.get("atregcontent"));
			map2.put("atregcomment", map.get("atregcomment"));

			List<AttendDTO> attendList = attendService.attendListAll(map2);
			model.addAttribute("attendList", attendList);
			model.addAttribute("ph", paging);
			model.addAttribute("selectedMap", map);
			return "attendAdmin";
		} else {
			return "redirect:/attend";
		}
	}

	@ResponseBody
	@PostMapping("/atApproval")
	public String atApproval(@RequestParam(value = "atregno") int atregno, HttpSession session) {
		int result = attendService.atApproval(atregno);
		JSONObject json = new JSONObject();
		json.put("result", result);
		return json.toString();
	}

	@ResponseBody
	@PostMapping("/atNotApproval")
	public String atNotApproval(@RequestParam Map<String, Object> map, HttpSession session) {
		int result = attendService.atNotApproval(map);
		JSONObject json = new JSONObject();
		json.put("result", result);
		return json.toString();
	}

	@GetMapping("/attendCalList")
	public String attendCalList(Map<String, Object> map, Model model, HttpSession session,
			@RequestParam(defaultValue = "1") Integer page) {

		if (session.getAttribute("eid") != null && session.getAttribute("eid") != "") {

			map.put("eid", session.getAttribute("eid"));
			map.put("eno", session.getAttribute("eno"));

			List<Map<String, Object>> calList = attendService.calList(map);
			map.put("calList", calList);

			return "attendCalList";
		} else {
			return "redirect:/login";
		}
	}
}

package com.ehr.web.salary;

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
public class SalaryController {
	
	@Autowired
	private SalaryService salaryService;
	
	@Autowired
	private Util util;
	
	@GetMapping("/salary")
	public String salary(@RequestParam Map<String, Object> map, Model model, HttpSession session) {
		
		if (util.obToInt(session.getAttribute("eno")) == util.obToInt(map.get("eno")) && 
				session.getAttribute("eno") != null && session.getAttribute("eno") != "") {
			
//			if (map.get("sdate") == null) {
//				String sdate = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM"));
//				map.put("sdate", sdate);
//				
//				Map<String, Object> elist = salaryService.elist(map);
//				model.addAttribute("elist", elist);
//				//날짜 생성하기
//			LocalDate date = LocalDate.now();
//			System.out.println(date);
//			SimpleDateFormat simple = new SimpleDateFormat("YYYY-MM");
//			String sdate = simple.format(date); 
//			System.out.println(sdate);
//				
//			} 
			
			Map<String, Object> slist = salaryService.slist(map);
			model.addAttribute("slist", slist);
			
			return "/salary";
		}
		
		return "login";
		
	}

	@PostMapping("/salary")
	public String searchSal(@RequestParam Map<String, Object> map, Model model) {

		Map<String, Object> searchSal = salaryService.searchSal(map);
		model.addAttribute("elist", searchSal);

		Map<String, Object> searchSal2 = salaryService.searchSal2(map);
		model.addAttribute("slist", searchSal2);

		return "/salary";
	}

	@ResponseBody
	@PostMapping("/searchSal")
	public String searchSal(@RequestParam Map<String, Object> map) {

		System.out.println(map);
		Map<String, Object> searchSal = salaryService.searchSal(map);
		Map<String, Object> searchSal2 = salaryService.searchSal2(map);

		JSONObject json = new JSONObject();
		json.put("elist", searchSal);
		json.put("slist", searchSal2);

		return json.toString();
	}
	
	@GetMapping("salary2")
	public String salary2(@RequestParam Map<String, Object> map, Model model, HttpSession session, @RequestParam(defaultValue = "1") int page) {
		
		//System.out.println(map);
		
		if (util.obToInt(session.getAttribute("eno")) == util.obToInt(map.get("eno")) && 
				session.getAttribute("eno") != null && session.getAttribute("eno") != "") {
		
        int pageSize = 10;
        int eno = util.obToInt(session.getAttribute("eno"));
        int totalCnt = salaryService.getCount(eno); //전체 게시글 개수
        //System.out.println(totalCnt);
        model.addAttribute("totalCnt", totalCnt);

        Paging paging = new Paging(totalCnt, page, pageSize);

        if (page < 0 || page > paging.getTotalPage())
           page = 1;
        if (pageSize < 0 || pageSize > 50)
           pageSize = 10;
        
        map.put("page", page);
        map.put("offset", (page - 1) * pageSize);
        map.put("eno", eno);
        map.put("pageSize", pageSize);

        List<Map<String, Object>> list = salaryService.list(map);
		model.addAttribute("list", list);      
        model.addAttribute("ph", paging);
        
        List<Map<String, Object>> eidList = salaryService.eidList();
		model.addAttribute("eidList", eidList);   

		return "/salary2";
		}
		
		return "login";
	}
	
	@PostMapping("/salary2")
	public String save(@RequestParam Map<String, Object> map, Model model, HttpSession session) {
		
		//System.out.println(map);
		
		if (util.obToInt(session.getAttribute("eno")) == util.obToInt(map.get("eno")) && 
				session.getAttribute("eno") != null && session.getAttribute("eno") != "") {

		int result = salaryService.save(map);
		
		return "redirect:/salary2?eno="+session.getAttribute("eno");
		
		}
		
		return "login";
	}
	
	@ResponseBody
	@PostMapping("/searchEmp")
	public String searchEmp(@RequestParam(value="eid") int eid) {

		Map<String, Object> elist = salaryService.searchEmp(eid);

		JSONObject json = new JSONObject();
		json.put("elist", elist);
		System.out.println(elist);

		return json.toString();
	}
	
	@ResponseBody
	@PostMapping("/deleteRows")
	public String deleteRows(@RequestParam(value = "row[]") List<Integer> snoArr) {
		
		System.out.println(snoArr);
		int result = salaryService.deleteRows(snoArr);
		
		JSONObject json = new JSONObject();

		return json.toString();
	}
}

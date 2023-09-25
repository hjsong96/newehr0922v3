package com.ehr.web.approval;

import java.io.File;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.ehr.web.attend.Paging;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

@Controller
public class ApprovalController {
	
	@Autowired
	private ApprovalService approvalService;
	
	@Autowired
	private ApprovalUtil util;
	
	@GetMapping("/approval")
	public String approval(Model model, HttpSession session) {
		ApprovalDTO dto = new ApprovalDTO();
		Map<String, Object> sessionInfo = util.getSessionInfo(session);
		String egrade = sessionInfo.get("egrade").toString();
		String eno = sessionInfo.get("eno").toString();
		System.out.println(egrade);
		if (egrade != null && eno != null) {
			dto.setEgrade(egrade); 
			List<ApprovalDTO> approval = approvalService.approval(dto);
			model.addAttribute("approval", approval);
			model.addAttribute("myEno", eno);
			return "/approval";
		} else {
			return "/error";
		}
	}
	
	@PostMapping("/approval")
	public String approvalInsert(@RequestParam Map<String, String> map, HttpSession session) {
		Map<String, Object> sessionInfo = util.getSessionInfo(session);
		String eno = sessionInfo.get("eno").toString(); 
		
		/* jsp 에서 뽑아온 값 dto로 옮기기 */
		ApprovalDTO dto = new ApprovalDTO();
		dto.setEno(eno); 
		dto.setAplist(map.get("ipAplist"));
		dto.setAptitle(map.get("ipAptitle"));
		dto.setApcontent(map.get("ipEditor"));
		dto.setAprealfile(map.get("fileNameStr"));
		/* DB insert */
		int apno = approvalService.approvalInsert(dto);
		//System.out.println(dto.getApno()); //방금삽입된 apno 불러오기
		/* 결재자 insert */
		String[] enoArr = map.get("appersonArr").split(",");
		for (int i = 0; i < enoArr.length; i++) {
			map.put("apperson", enoArr[i]);
			map.put("apno", Integer.toString(dto.getApno()));
			int result = approvalService.apperson(map);
		}
		return "redirect:/approvalBoard";
	}

	@ResponseBody
	@PostMapping("/uploadFile")
	public String uploadFile (MultipartFile[] uploadFile, HttpServletRequest req) throws JsonProcessingException {
		Map<String, Object> res = new HashMap<String, Object>();
		String uploadForder = req.getServletContext().getRealPath("/upload");
		
		List<String> fileNames = new ArrayList<String>();
		for(MultipartFile mpf : uploadFile) {

			System.out.println(mpf.getSize());
			System.out.println(mpf.getOriginalFilename());
			String fileName = mpf.getOriginalFilename();

			LocalDateTime ldt = LocalDateTime.now();
			String format = ldt.format(DateTimeFormatter.ofPattern("YYYYMMddHHmmss"));
			String realFileName = format + "_" + mpf.getOriginalFilename();
			File save = new File(uploadForder, realFileName);
			try {
				FileCopyUtils.copy(mpf.getBytes(), save);
			} catch (IOException e) {
				e.printStackTrace();
			}
			fileNames.add(realFileName);
			try {
				mpf.transferTo(save);
			} catch (Exception e) {
				System.out.println("error");
			}
		}
		res.put("fileNames", fileNames);
		ObjectMapper map = new ObjectMapper();
		String json = map.writeValueAsString(res);
		return json;
	}
	
	@GetMapping(value = {"/approvalBoard", "/approvalboard"})
	public String approvalBoard(Model model, ApprovalDTO dto, HttpSession session, @RequestParam(defaultValue = "1") Integer page) {
		Map<String, Object> sessionInfo = util.getSessionInfo(session);
		String eno = sessionInfo.get("eno").toString(); 
		if (eno != null) {
			/* 페이징 start */
			int pageSize = 10;
			String eid = String.valueOf(session.getAttribute("eid"));
			int totalCnt = approvalService.getCount(eid); //전체 게시글 개수
			
			model.addAttribute("totalCnt", totalCnt);
			Paging paging = new Paging(totalCnt, page, pageSize);
			System.out.println(totalCnt);
			
			if (page < 0 || page > paging.getTotalPage())
				page = 1;
			if (pageSize < 0 || pageSize > 50)
				pageSize = 10;
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("offset", (page - 1) * pageSize);
			map.put("eno", eno);
			map.put("pageSize", pageSize);
			
			List<ApprovalDTO> approvalBoardList = approvalService.approvalBoardList(map);
			System.out.println(map);
			model.addAttribute("approvalBoardList", approvalBoardList);         
			model.addAttribute("ph", paging);
			
			/* 페이징 end */
			dto.setEno(eno); 
			List<ApprovalDTO> approvalPerson = approvalService.approvalperson();
			//System.out.println(approvalPerson);
			model.addAttribute("approvalPerson", approvalPerson);
			model.addAttribute("myEno", eno);
			return "/approvalBoard";
		} else { 
			return "error"; 
		}
	}
	
	
	
	@ResponseBody
	@PostMapping(value = {"/approvaldetail", "/approvalDetail"})
	public String approvalDetail(@RequestParam("apno") int apno) throws JsonProcessingException {
		Map<String, Object> list = new LinkedHashMap<String, Object>();
		list = approvalService.approvalDetail(apno);
		List<LinkedHashMap<String, Object>> list2 = approvalService.appersondetail(apno);//결재자 리스트 불러오기
		//결재자의 순서를 그대로 list2 와 list 합치기
		for (int i = 0; i < list2.size(); i++) {
			LinkedHashMap<String, Object> map = list2.get(i);
			Object valueToRename = map.remove("apperson"); 
			Object valueToRename2 = map.remove("apacptdetail");
			Object valueToRename3 = map.remove("ename"); 
			Object valueToRename4 = map.remove("edept"); 
			Object valueToRename5 = map.remove("egrade"); 
			String newKey = "apperson"+i;
			String newKey2 = "apacptdetail"+i;
			String newKey3 = "ename"+i;
			String newKey4 = "edept"+i;
			String newKey5 = "egrade"+i;
			list2.get(i).put(newKey, valueToRename);
			list2.get(i).put(newKey2, valueToRename2);
			list2.get(i).put(newKey3, valueToRename3);
			list2.get(i).put(newKey4, valueToRename4);
			list2.get(i).put(newKey5, valueToRename5);
		}
		//System.out.println(list2);
		for (int i = 0; i < list2.size(); i++) {
			list.putAll(list2.get(i));
		}
		list.put("appersonsize", list2.size());
		//json String 타입으로 바꾸어 jsp에 주입
		ObjectMapper map = new ObjectMapper();
		String json = map.writeValueAsString(list);
		//System.out.println(json);
		return json;
	}
	@ResponseBody
	@GetMapping("/revise")
	public String revise(@RequestParam("apno") int apno, HttpSession session) throws JsonProcessingException {
		Map<String, Object> revise = new LinkedHashMap<String, Object>();
		revise = approvalService.approvalDetail(apno);
		
		ApprovalDTO dto = new ApprovalDTO();
		Map<String, Object> sessionInfo = util.getSessionInfo(session);
		String egrade = sessionInfo.get("egrade").toString();
		String eno = sessionInfo.get("eno").toString();
		
		//System.out.println("나와라...eno"+eno);
		//System.out.println("나와라...egrade"+egrade);
		dto.setEgrade(egrade);
		List<ApprovalDTO> approval = approvalService.approval(dto);
		//System.out.println("approval : "+approval);
		
		// 두 데이터를 합치는 작업
	    Map<String, Object> combinedData = new LinkedHashMap<>();
	    combinedData.put("revise", revise);
	    combinedData.put("approval", approval);
	    combinedData.put("myEno", eno);
	    //System.out.println("combinedData : "+ combinedData);
		
		ObjectMapper map = new ObjectMapper();
		String json = map.writeValueAsString(combinedData);
		//System.out.println(json);
		return json;
	}
	
	@PostMapping("/revise")
	public String revise(@RequestParam Map<String, String> reviseData, HttpSession session) {
		ApprovalDTO dto = new ApprovalDTO();
		dto.setApno(Integer.parseInt(reviseData.get("revApno")));
		dto.setApcontent(reviseData.get("revContent"));
		dto.setApmemo(reviseData.get("revDate"));
		System.out.println(reviseData); 
		//{revApno=18, revContent=<p>테스트....</p>, revAppersonArr=9, revDate=| 수정일 : 2023-9-12}
		int resultRevise = approvalService.revise(dto);
		if (resultRevise == 1) {
			int resultDelete = approvalService.deleteForInsert(dto);
			if (resultDelete != 0) {
				/* 결재자 새로 insert */
				String[] enoArr = reviseData.get("revAppersonArr").split(",");
				for (int i = 0; i < enoArr.length; i++) {
					reviseData.put("apperson", enoArr[i]);
					reviseData.put("apno", Integer.toString(dto.getApno()));
					int resultInsert = approvalService.InsertForRevise(reviseData);
				}
			}
		}
		return "redirect:/approvalBoard";
	}
	
	@PostMapping("/delete")
	public String delete(@RequestParam("delApno") int apno) {
		//System.out.println(apno);
		int deleteAppersonT = approvalService.deleteAppersonT(apno);
		int deleteApprovalT = approvalService.deleteApprovalT(apno);
		return "redirect:/approvalBoard";
	}
	
	@GetMapping(value = {"/doApproval", "/doapproval"})
	public String doApproval(Model model, HttpSession session, @RequestParam(defaultValue = "1") Integer page) {
		ApprovalDTO dto = new ApprovalDTO();
		Map<String, Object> sessionInfo = util.getSessionInfo(session);
		String egrade = (String) sessionInfo.get("egrade");
		String eno = sessionInfo.get("eno").toString();
		String ename = sessionInfo.get("ename").toString();
		
		if (egrade != null && eno != null && ename != null) {
			dto.setEno(eno);
			List<Map<String, Integer>> apno = approvalService.ApnoForDoAp(dto);
			List<ApprovalDTO> ApListForDoAp = approvalService.ApListForDoAp(apno);
			
			//List<ApprovalDTO> ListForDoAp = approvalService.ListForDoAp(apno);
			
			/* 페이징 start */
			int pageSize = 10;
			String eid = String.valueOf(session.getAttribute("eid"));
			int totalCnt = approvalService.getCountDoApprovalBoard(eid); //전체 게시글 개수
			
			model.addAttribute("totalCnt", totalCnt);
			Paging paging = new Paging(totalCnt, page, pageSize);
			System.out.println(totalCnt);
			
			if (page < 0 || page > paging.getTotalPage())
				page = 1;
			if (pageSize < 0 || pageSize > 50)
				pageSize = 10;
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("offset", (page - 1) * pageSize);
			map.put("eno", eno);
			map.put("pageSize", pageSize);
			
			List<ApprovalDTO> doApprovalList = approvalService.doApprovalList(map);
			model.addAttribute("doApprovalList", doApprovalList);         
			model.addAttribute("ph", paging);
			
			/* 페이징 end */
			
			Map<String, Object> myInfo = new HashMap<String, Object>();
			myInfo.put("myEno", eno);
			myInfo.put("myEname", ename);
			myInfo.put("myEgrade", util.changeGrade(egrade).toString());
			
			//model.addAttribute("ListForDoAp", ListForDoAp); 
			model.addAttribute("ApListForDoAp", ApListForDoAp); 
			model.addAttribute("myInfo",myInfo);
			
			return "/doApproval";
		} else {
			return "/error";
		}
	}
	
	@ResponseBody
	@PostMapping("/doApDetail")
	public String doApDetail(@RequestParam("apno") int apno) throws JsonProcessingException {
		Map<String, Object> list = new LinkedHashMap<String, Object>();
		list = approvalService.approvalDetail(apno);
		List<LinkedHashMap<String, Object>> list2 = approvalService.appersondetail(apno);//결재자 리스트 불러오기
		//결재자의 순서를 그대로 list2 와 list 합치기
		for (int i = 0; i < list2.size(); i++) {
			LinkedHashMap<String, Object> map = list2.get(i);
			Object valueToRename = map.remove("apperson"); 
			Object valueToRename2 = map.remove("apacptdetail");
			Object valueToRename3 = map.remove("ename"); 
			Object valueToRename4 = map.remove("edept"); 
			Object valueToRename5 = map.remove("egrade"); 
			map.remove("count"); 
			String newKey = "apperson"+i;
			String newKey2 = "apacptdetail"+i;
			String newKey3 = "ename"+i;
			String newKey4 = "edept"+i;
			String newKey5 = "egrade"+i;
			String newKey6 = "count"+i;
			list2.get(i).put(newKey, valueToRename);
			list2.get(i).put(newKey2, valueToRename2);
			list2.get(i).put(newKey3, valueToRename3);
			list2.get(i).put(newKey4, valueToRename4);
			list2.get(i).put(newKey5, valueToRename5);
			list2.get(i).put(newKey6, i);
		}
		//System.out.println(list2);
		for (int i = 0; i < list2.size(); i++) {
			list.putAll(list2.get(i));
		}
		list.put("appersonsize", list2.size());
		//json String 타입으로 바꾸어 jsp에 주입
		ObjectMapper map = new ObjectMapper();
		String json = map.writeValueAsString(list);
		System.out.println(json);
		return json;
	}
	
	@PostMapping("/doApproval")
	public String doApproval(@RequestParam("doApno") String apno, HttpSession session) {
		Map<String, Object> sessionInfo = util.getSessionInfo(session);
		String eno = sessionInfo.get("eno").toString();
		
		Map<String, String> infoForAp = new HashMap<String, String>();
		infoForAp.put("eno", eno);
		infoForAp.put("apno", apno);
		int doApResult = approvalService.doApproval(infoForAp);
		return "redirect:/doApproval";
	}
	
	@PostMapping("/notAp")
	public String notAp(@RequestParam("doNotApno") String apno, @RequestParam("addMemo") String apmemo, HttpSession session) {
		//System.out.println(apno);
		Map<String, Object> sessionInfo = util.getSessionInfo(session);
		String eno = sessionInfo.get("eno").toString();
		Map<String, String> infoForAp = new HashMap<String, String>();
		infoForAp.put("eno", eno);
		infoForAp.put("apno", apno);
		infoForAp.put("apmemo", apmemo);
		infoForAp.put("aApno", apno);
		int notApResult = approvalService.notAp(infoForAp);
		return "redirect:/doApproval";
	}
	

}

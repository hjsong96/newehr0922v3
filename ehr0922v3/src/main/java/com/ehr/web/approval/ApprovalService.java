package com.ehr.web.approval;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ApprovalService {

	@Autowired
	private ApprovalDAO approvalDAO;

	public int dayoffcancle(String atregno) {
		return approvalDAO.dayoffcancle(atregno);
	}

	
	
	
	
	public List<ApprovalDTO> approval(ApprovalDTO dto) {
		return approvalDAO.approval(dto);
	}

	public int approvalInsert(ApprovalDTO dto) {
		return approvalDAO.approvalInsert(dto);
	}

	public int apperson(Map<String, String> map) {
		return approvalDAO.apperson(map);
	}

	public List<ApprovalDTO> approvalBoard(ApprovalDTO dto) {
		return approvalDAO.approvalBoard(dto);
	}





	public List<ApprovalDTO> approvalperson() {
		return approvalDAO.approvalperson();
	}

	public Map<String, Object> approvalDetail(int apno) {
		return approvalDAO.approvalDetail(apno);
	}

	public List<LinkedHashMap<String, Object>> appersondetail(int apno) {
		return approvalDAO.appersondetail(apno);
		
	}





	public int revise(ApprovalDTO dto) {
		return approvalDAO.revise(dto);
	}





	public int deleteForInsert(ApprovalDTO dto) {
		return approvalDAO.deleteForInsert(dto);
	}





	public int InsertForRevise(Map<String, String> reviseData) {
		return approvalDAO.InsertForRevise(reviseData);
	}





	public int deleteApprovalT(int apno) {
		return approvalDAO.deleteApprovalT(apno);
	}





	public int deleteAppersonT(int apno) {
		return approvalDAO.deleteAppersonT(apno);
	}





	public List<Map<String, Integer>> ApnoForDoAp(ApprovalDTO dto) {
		return approvalDAO.ApnoForDoAp(dto);
	}





	public List<ApprovalDTO> ListForDoAp(List<Map<String, Integer>> apno) {
		return approvalDAO.ListForDoAp(apno);
	}





	public List<ApprovalDTO> ApListForDoAp(List<Map<String, Integer>> apno) {
		return approvalDAO.ApListForDoAp(apno);
	}





	public int doApproval(Map<String, String> infoForAp) {
		return approvalDAO.doApproval(infoForAp);
	}





	public int notAp(Map<String, String> infoForAp) {
		return approvalDAO.notAp(infoForAp);
	}





	public int getCount(String eid) {
		return approvalDAO.getCount(eid);
	}





	public List<ApprovalDTO> approvalBoardList(Map<String, Object> map) {
		return approvalDAO.approvalBoardList(map);
	}





	public int getCountDoApprovalBoard(String eid) {
		return approvalDAO.getCountDoApprovalBoard(eid);
	}

	public List<ApprovalDTO> doApprovalList(Map<String, Object> map) {
		return approvalDAO.doApprovalList(map);
	}








	

	

	

	
}

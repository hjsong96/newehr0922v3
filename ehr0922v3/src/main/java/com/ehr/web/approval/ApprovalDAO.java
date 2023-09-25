package com.ehr.web.approval;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ApprovalDAO {

	int dayoffcancle(String atregno);

	List<ApprovalDTO> approval(ApprovalDTO dto);

	int approvalInsert(ApprovalDTO dto);

	int apperson(Map<String, String> map);

	List<ApprovalDTO> approvalBoard(ApprovalDTO dto);

	List<ApprovalDTO> approvalperson();

	Map<String, Object> approvalDetail(int apno);

	List<LinkedHashMap<String, Object>> appersondetail(int apno);

	int revise(ApprovalDTO dto);

	int deleteForInsert(ApprovalDTO dto);

	int InsertForRevise(Map<String, String> reviseData);
 
	int deleteApprovalT(int apno);

	int deleteAppersonT(int apno);

	List<Map<String, Integer>> ApnoForDoAp(ApprovalDTO dto);

	List<ApprovalDTO> ListForDoAp(List<Map<String, Integer>> apno);

	List<ApprovalDTO> ApListForDoAp(List<Map<String, Integer>> apno);

	int doApproval(Map<String, String> infoForAp);

	int notAp(Map<String, String> infoForAp);

	int getCount(String eid);

	List<ApprovalDTO> approvalBoardList(Map<String, Object> map);

	List<ApprovalDTO> doApprovalList(Map<String, Object> map);

	int doApprovalList(String eid);

	int getCountDoApprovalBoard(String eid);

	






	

}
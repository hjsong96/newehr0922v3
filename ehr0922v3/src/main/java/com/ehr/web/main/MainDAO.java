package com.ehr.web.main;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface MainDAO {

	Map<String, Object> loginCheck(Map<String, Object> map);

	int eCount(Map<String, Object> map);

	int eCountReset(Map<String, Object> map);

	int IDresult(Map<String, Object> map);

	int PWresult(Map<String, Object> map);

	int eCountPlus(Map<String, Object> map);

	Map<String, Object> login(String eid);

	int ecountPW(Map<String, Object> map);
	
	void join(Map<String, Object> map);

	int eidcheck(String eid);

	int eemailcheck(String eemail);

	List<Map<String, Object>> newMember();

	void mypageupdate(Map<String, Object> map);

	Map<String, Object> findID(Map<String, Object> map);

	Map<String, Object> findPW(Map<String, Object> map);

	void changePW(Map<String, Object> result);

	List<Map<String, Object>> memberlist();

	int egradeChange(Map<String, String> map);

	int checkPW(Map<String, Object> map);

	int newPW(Map<String, Object> map);

	int searchPW(Map<String, Object> map);

	int edeptChange(Map<String, String> map);
	

}

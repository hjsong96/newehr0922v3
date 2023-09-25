package com.ehr.web.attend;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface AttendDAO {

	List<AttendDTO> attendList(Map<String, Object> map);

	void atapplication(AttendDTO attendDTO);

	void atcancel(int atregno);

	AttendDTO attendView(int atregno);

	void attendEdit(AttendDTO attendDTO);

	int getCount(Map<String, Object> map);

	List<Map<String, Object>> getPage(Map<String, Object> map);
	
	List<Map<String, Object>> seTime(int eno);

	List<Map<String, Object>> list();

	int atmanageInsert(Map<String, Object> map);

	int atmanageUpdate(Map<String, Object> map);

	int noList(Map<String, Object> map);

	List<Map<String, Object>> timeSelect(Map<String, Object> map);

	int getCountAll(Map<String, Object> map);

	List<AttendDTO> attendListAll(Map<String, Object> map2);

	int atApproval(int atregno);

	int atNotApproval(Map<String, Object> map);

	Map<String, Object> nowResult(Map<String, Object> map);

	List<Map<String, Object>> calList(Map<String, Object> map);
	
}

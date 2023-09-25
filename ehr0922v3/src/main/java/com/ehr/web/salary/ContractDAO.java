package com.ehr.web.salary;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ContractDAO {
	List<Map<String, Object>> clist(Map<String, Object> map);

	Map<String, Object> elist(Map<String, Object> map);

	Map<String, Object> clist2(Map<String, Object> map);

	int aggrCheck(Map<String, Object> map);

	Map<String, Object> slist(Map<String, Object> map);

	List<Map<String, Object>> adclist(Map<String, Object> map);

	int deleteRows2(List<Integer> snoArr);

	Map<String, Object> searchEmp2(int eid);

	List<Map<String, Object>> eidList();

	int save(Map<String, Object> map);
}

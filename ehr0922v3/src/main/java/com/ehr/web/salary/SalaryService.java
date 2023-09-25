package com.ehr.web.salary;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class SalaryService {

	@Autowired
	private SalaryDAO salaryDAO;

	public Map<String, Object> elist(Map<String, Object> map) {
		return salaryDAO.elist(map);
	}

	public Map<String, Object> slist(Map<String, Object> map) {
		return salaryDAO.slist(map);
	}

	public Map<String, Object> searchSal(Map<String, Object> map) {
		return salaryDAO.searchSal(map);
	}

	public Map<String, Object> searchSal2(Map<String, Object> map) {
		return salaryDAO.searchSal2(map);
	}

	public List<Map<String, Object>> list(Map<String, Object> map) {
		return salaryDAO.list(map);
	}

	public List<Map<String, Object>> sallist(Map<String, Object> map) {
		return salaryDAO.sallist(map);
	}

	public int save(Map<String, Object> map) {
		return salaryDAO.save(map);
	}

	public int getCount(int eno) {
		return salaryDAO.getCount(eno);
	}

	public Map<String, Object> searchEmp(int eid) {
		return salaryDAO.searchEmp(eid);
	}

	public List<Map<String, Object>> eidList() {
		return salaryDAO.eidList();
	}

	public int deleteRows(List<Integer> snoArr) {
		return salaryDAO.deleteRows(snoArr);
	}

}

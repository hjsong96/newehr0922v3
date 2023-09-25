package com.ehr.web.attend;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class AttendService {
	@Autowired
	private AttendDAO attendDAO;

	public List<AttendDTO> attendList(Map<String, Object> map) {
		return attendDAO.attendList(map);
	}

	public void atapplication(AttendDTO attendDTO) {
		attendDAO.atapplication(attendDTO);
	}

	public void atcancel(int atregno) {
		attendDAO.atcancel(atregno);
	}

	public AttendDTO attendView(int atregno) {
		return attendDAO.attendView(atregno);
	}

	public void attendEdit(AttendDTO attendDTO) {
		attendDAO.attendEdit(attendDTO);
	}

	public int getCount(Map<String, Object> map) {
		return attendDAO.getCount(map);
	}	

	public List<Map<String, Object>> seTime(int eno) {
		return attendDAO.seTime(eno);
	}

	public int atmanageInsert(Map<String, Object> map) {
		return attendDAO.atmanageInsert(map);
	}

	public int atmanageUpdate(Map<String, Object> map) {
		return attendDAO.atmanageUpdate(map);
	}

	public int noList(Map<String, Object> map) {
		return attendDAO.noList(map);
	}

	public List<Map<String, Object>> timeSelect(Map<String, Object> map) {
		return attendDAO.timeSelect(map);
	}

	public int getCountAll(Map<String, Object> map) {
		return attendDAO.getCountAll(map);
	}

	public List<AttendDTO> attendListAll(Map<String, Object> map2) {
		return attendDAO.attendListAll(map2);
	}

	public int atApproval(int atregno) {
		return attendDAO.atApproval(atregno);
	}

	public int atNotApproval(Map<String, Object> map) {
		return attendDAO.atNotApproval(map);
	}

	public Map<String, Object> nowResult(Map<String, Object> map) {
		return attendDAO.nowResult(map);
	}

	public List<Map<String, Object>> calList(Map<String, Object> map) {
		return attendDAO.calList(map);
	}
}

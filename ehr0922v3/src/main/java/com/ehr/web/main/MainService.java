package com.ehr.web.main;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class MainService {
@Autowired
private MainDAO mainDAO;

public Map<String, Object> loginCheck(Map<String, Object> map) {
	return mainDAO.loginCheck(map);
}

public int eCount(Map<String, Object> map) {
	return mainDAO.eCount(map);
}

public int eCountReset(Map<String, Object> map) {
	return mainDAO.eCountReset(map);
}

public int IDresult(Map<String, Object> map) {
	return mainDAO.IDresult(map);
}

public int PWresult(Map<String, Object> map) {
	return mainDAO.PWresult(map);
}

public int eCountPlus(Map<String, Object> map) {
	return mainDAO.eCountPlus(map);
}

public Map<String, Object> login(String eid) {
	return mainDAO.login(eid);
}

public int ecountPW(Map<String, Object> map) {
	return mainDAO.ecountPW(map);
}
public void join(Map<String, Object> map) {
	mainDAO.join(map);
}


public int eidcheck(String eid) {
	return mainDAO.eidcheck(eid);
}


public int eemailcheck(String eemail) {
	return mainDAO.eemailcheck(eemail);
}

public List<Map<String, Object>> newMember() {
	return mainDAO.newMember();
}

public void mypageupdate(Map<String, Object> map) {
	 mainDAO.mypageupdate(map);	
}

public Map<String, Object> findID(Map<String, Object> map) {
	return mainDAO.findID(map);
}

public Map<String, Object> findPW(Map<String, Object> map) {
	return mainDAO.findPW(map);
}

public void changePW(Map<String, Object> result) {
	mainDAO.changePW(result);
	
}

public List<Map<String, Object>> memberlist() {
	return mainDAO.memberlist();
}

public int egradeChange(Map<String, String> map) {
	return mainDAO.egradeChange(map);
}

public int checkPW(Map<String, Object> map) {
	return mainDAO.checkPW(map);
}

public int newPW(Map<String, Object> map) {
	return mainDAO.newPW(map);
	}

public int searchPW(Map<String, Object> map) {
	
	return mainDAO.searchPW(map);
}

public int edeptChange(Map<String, String> map) {
	return mainDAO.edeptChange(map);
}




}

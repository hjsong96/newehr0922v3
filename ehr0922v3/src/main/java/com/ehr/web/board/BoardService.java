package com.ehr.web.board;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class BoardService {
@Autowired
private BoardDAO boardDAO;

public int acount() {
	return boardDAO.acount();
}

public List<Map<String, Object>> alist(Map<String, Integer> map) {
	return boardDAO.alist(map);
}

public void awrite(Map<String, Object> map) {
	boardDAO.awrite(map);
	
}

public Map<String, Object> adetail(int num) {
	return boardDAO.adetail(num);
}

public void areadUp(int abno) {
	boardDAO.areadUp(abno);
	
}

public void adel(int abno) {
	boardDAO.adel(abno);
	
}

public void adetailUp(Map<String, Object> map) {
	boardDAO.adetailUp(map);
}

public int acheckEno(Map<String, Object> map) {
	return boardDAO.acheckEno(map);
}

public List<Map<String, Object>> nlist() {
	List<Map<String, Object>> list = boardDAO.nlist();
	return list;
}

public Map<String, Object> ndetail(int nno) {
	return boardDAO.ndetail(nno);
}

public void nwrite(Map<String, Object> map) {
	boardDAO.nwrite(map);
	
}

public void ndetailDel(Map<String, Object> map) {
	boardDAO.ndetailDel(map);
	
}

public void ndetailUp(Map<String, Object> map) {
	boardDAO.ndetailUp(map);
	
}

public int getCount() {
	return boardDAO.getCount();
}


public List<Map<String, Object>> getPage(Map<String, Object> map) {
	return boardDAO.getPage(map);
}

public int ncheckEno(Map<String, Object> map) {
	return boardDAO.ncheckEno(map);
}

public void ndel(int nno) {
	boardDAO.ndel(nno);	
}

public void nreadUp(int nno) {
	boardDAO.nreadUp(nno);
	
}

public int commentCount(int abno) {
	return boardDAO.commentCount(abno);
}

public List<Map<String, Object>> commentList(int abno) {
	return boardDAO.commentList(abno);
}

public void comment(Map<String, Object> map) {
	boardDAO.comment(map);
}

public void cedit(Map<String, Object> map) {
	boardDAO.cedit(map);
	
}

public int cdel(Map<String, Object> map) {
	return boardDAO.cdel(map);
}

public int report(Map<String, Object> map) {
	return boardDAO.report(map);
}

public List<Map<String, Object>> reportList() {
	return boardDAO.reportList();
}

public Map<String, Object> reportDetail(int abno) {
	return boardDAO.reportDetail(abno);
}

public int reportAgree(int abno) {
	return boardDAO.reportAgree(abno);
}

public void eboardCount(int rreported) {
	boardDAO.eboardCount(rreported);
	
}

public int reportReject(int abno) {
	// TODO Auto-generated method stub
	return boardDAO.reportReject(abno);
}

public int eboardCount2(String eid) {
	// TODO Auto-generated method stub
	return boardDAO.eboardCount2(eid);
}

public int reportCount(int abno) {
	return boardDAO.reportCount(abno);
}

}

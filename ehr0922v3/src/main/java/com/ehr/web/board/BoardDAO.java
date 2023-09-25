package com.ehr.web.board;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface BoardDAO {

	int acount();

	List<Map<String, Object>> alist(Map<String, Integer> map);

	void awrite(Map<String, Object> map);

	Map<String, Object> adetail(int num);

	void areadUp(int abno);

	void adel(int abno);

	void adetailUp(Map<String, Object> map);

	int acheckEno(Map<String, Object> map);
	
	List<Map<String, Object>> nlist();

	Map<String, Object> ndetail(int nno);

	void nwrite(Map<String, Object> map);

	void ndetailDel(Map<String, Object> map);

	void ndetailUp(Map<String, Object> map);
	
	int getCount();

	List<Map<String, Object>> getPage(Map<String, Object> map);

	int ncheckEno(Map<String, Object> map);

	void ndel(int nno);

	void nreadUp(int nno);

	int commentCount(int abno);

	List<Map<String, Object>> commentList(int abno);

	void comment(Map<String, Object> map);
	
	void cedit(Map<String, Object> map);

	int cdel(Map<String, Object> map);

	int report(Map<String, Object> map);

	List<Map<String, Object>> reportList();

	Map<String, Object> reportDetail(int abno);

	int reportAgree(int abno);

	void eboardCount(int rreported);

	int reportReject(int abno);

	int eboardCount2(String eid);

	int reportCount(int abno);


}

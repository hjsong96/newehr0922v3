package com.ehr.web.approval;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Component;

@Component
public class ApprovalUtil {
   
   public Map<String, Object> getSessionInfo(HttpSession session){
      Map<String, Object> res = new HashMap<String, Object>();
      
      String eno = session.getAttribute("eno").toString();
      String egrade = session.getAttribute("egrade").toString();
      String ename = session.getAttribute("ename").toString();
      
      res.put("eno", eno);
      res.put("egrade", egrade);
      res.put("ename", ename);
      
      return res;
   }
   
   public String changeGrade (String egrade) {
      String grade = "0";
      if (egrade.equals("0")) {
          grade = "사원";
      } else if (egrade.equals("1")) {
          grade = "주임";
      } else if (egrade.equals("2")) {
          grade = "대리";
      } else if (egrade.equals("3")) {
          grade = "과장";
      } else if (egrade.equals("4")) {
          grade = "차장";
      } else if (egrade.equals("5")) {
          grade = "부장";
      } else if (egrade.equals("6")) {
          grade = "부사장";
      } else if (egrade.equals("7")) {
          grade = "사장";
      } else if (egrade.equals("8")) {
          grade = "관리자";
      } 
      return grade;
   }
   
}
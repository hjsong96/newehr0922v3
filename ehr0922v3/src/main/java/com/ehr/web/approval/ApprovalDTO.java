package com.ehr.web.approval;

import java.util.Map;

import lombok.Data;

@Data
public class ApprovalDTO {
	public int apno;
	public String myeno, myegrade;
	public String atregdate, atregrestdate, atregcontent, eno, edept, egrade, atregno, ename;
	public String aplist, aptitle, apcontent, apdate, aporifile, aprealfile, apmemo;
	public String apperson, apacptdetail, count;

}


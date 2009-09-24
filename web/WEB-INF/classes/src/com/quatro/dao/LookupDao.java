/*******************************************************************************
 * Copyright (c) 2005, 2009 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the GNU General Public License
 * which accompanies this distribution, and is available at
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *
 * Contributors:
 *     <Quatro Group Software Systems inc.>  <OSCAR Team>
 *******************************************************************************/
package com.quatro.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.GregorianCalendar;
import java.util.Hashtable;
import java.util.List;
import java.util.Calendar;

import org.caisi.dao.ProviderDAO;
import org.hibernate.Criteria;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

import oscar.MyDateFormat;
import oscar.OscarProperties;
import oscar.oscarDB.DBPreparedHandler;
import oscar.oscarDB.DBPreparedHandlerParam;

import com.quatro.common.KeyConstants;
import com.quatro.model.Attachment;
import com.quatro.model.FieldDefValue;
import com.quatro.model.LookupCodeValue;
import com.quatro.model.LookupTableDefValue;
import com.quatro.model.LstOrgcd;
import com.quatro.model.security.SecProvider;
import com.quatro.util.Utility;

import org.oscarehr.PMmodule.dao.ProviderDao;
import org.oscarehr.PMmodule.model.Program;
import org.oscarehr.PMmodule.model.Facility;
import java.util.Calendar;

public class LookupDao extends HibernateDaoSupport {

	/* Column property mappings defined by the generic idx 
	 *  1 - Code 2 - Description 3 Active 
	 *  4 - Display Order, 5 - ParentCode 6 - Buf1 7 - CodeTree
	 *  8 - Last Update User   9 - Last Update Date
	 *  10 - 16 Buf3 - Buf9   17 - CodeCSV
	 */
	private ProviderDao providerDao;
	private static Hashtable lookupTableDefs = null;
	private static Hashtable orgCodeCsvs = null;
	private static Calendar lastCacheTime = Calendar.getInstance();
	private static int lastId  = -1;
	public List LoadCodeList(String tableId, boolean activeOnly, String code, String codeDesc)
	throws SQLException
	{
	   return LoadCodeList(tableId,activeOnly,"",code,codeDesc,true);
	}
	public String getOrgCdCsv(String code) throws SQLException
	{
		if (code == null || code.equals("")) return "";
		Calendar now = Calendar.getInstance();
		int timeOut = OscarProperties.getInstance().getOrgCacheTimeoutMinutes();
		timeOut = timeOut * 60000; //milliseconds
		if (orgCodeCsvs == null || now.getTimeInMillis()-lastCacheTime.getTimeInMillis() > timeOut) doCache();
		return (String)orgCodeCsvs.get(code);
	}
	private boolean isOrgChanged() throws SQLException
	{
		boolean isChanged = true;
		String sSQL = "select max(logid) from lst_orgcd_log";
		DBPreparedHandler db = new DBPreparedHandler();
		try {
			ResultSet rs = db.queryResults(sSQL);
			rs.next();
			int id = rs.getInt(1);
			rs.close();
			db.closeConn();
			db = null;
			isChanged = (id > lastId);
			if (isChanged) lastId = id;
		}
		catch(SQLException ex)
		{
			throw ex;
		}
		return isChanged;
	}
	private void doCache() throws SQLException
	{
		synchronized ("runonceOrg") 
		{
			if (isOrgChanged())
			{
				orgCodeCsvs = new Hashtable();
				List list = LoadCodeList("ORG", false, "","", "");
				for (int i=0; i< list.size(); i++)
				{
					LookupCodeValue lkv = (LookupCodeValue) list.get(i);
					orgCodeCsvs.put(lkv.getCode(), lkv.getCodecsv());
				}
			}
			lastCacheTime = Calendar.getInstance();
		}
	}
	public LookupCodeValue GetCode(String tableId,String code) throws SQLException
	{
		if (code == null || "".equals(code)) return null;
		List lst = LoadCodeList(tableId, false,"", code, "",false);
		LookupCodeValue lkv = null;
		if (lst.size()>0) 
		{
			lkv = (LookupCodeValue) lst.get(0);
		}
		return lkv;
	}
	public List LoadCodeList(String tableId,boolean activeOnly,  String parentCode,String code, String codeDesc)
	throws SQLException {
		return LoadCodeList(tableId,activeOnly,parentCode,code,codeDesc,true);
	}

	private List LoadCodeList(String tableId,boolean activeOnly,  String parentCode,String code, String codeDesc, boolean includeTree)
	throws SQLException
	{
		String pCd=parentCode;
		if("USR".equals(tableId)) parentCode=null;
		LookupTableDefValue tableDef = GetLookupTableDef(tableId);
		List fields = LoadFieldDefList(tableId);
		DBPreparedHandlerParam [] params = new DBPreparedHandlerParam[100];
		String fieldNames [] = new String[17];
		String sSQL1 = "";
		String sSQL="select distinct ";
		boolean activeFieldExists = true;
		for (int i = 1; i <= 17; i++)
		{
			boolean ok = false;
			for (int j = 0; j<fields.size(); j++)
			{
				FieldDefValue fdef = (FieldDefValue)fields.get(j);
				if (fdef.getGenericIdx()== i)
				{
					if (fdef.getFieldSQL().indexOf('(') >= 0) {
						sSQL += fdef.getFieldSQL() + " " + fdef.getFieldName()+ ",";
						fieldNames[i-1]=fdef.getFieldName();
					}
					else
					{
						sSQL += "s." + fdef.getFieldSQL() + ",";
						fieldNames[i-1]=fdef.getFieldSQL();
					}
					ok = true;
					break;
				}
			}
			if (!ok) {
				if (i==3) {
					activeFieldExists = false;
					sSQL += " 1 field" + i + ",";
				}
				else
				{				
					sSQL += " null field" + i + ",";
				}
				fieldNames[i-1] = "field" + i;
			}
		}
		sSQL = sSQL.substring(0,sSQL.length()-1);
	    sSQL +=" from " + tableDef.getTableName() ;
		sSQL1 = oscar.Misc.replace(sSQL,"s\\.", "a.") + " a,";	    
		sSQL += " s where 1=1";
	    int i= 0;
        if (activeFieldExists && activeOnly) {
	    	sSQL += " and " + fieldNames[2] + "=?"; 
	    	params[i++] = new DBPreparedHandlerParam(1);
        }
	   if (!Utility.IsEmpty(parentCode)) {
	    	sSQL += " and " + fieldNames[4] + "=?"; 
	    	params[i++]= new DBPreparedHandlerParam(parentCode);
	   }
	   if (!Utility.IsEmpty(code)) {
	    	sSQL += " and " + fieldNames[0] + " in (";
	    	String [] codes = code.split(",");
    		sSQL += "?";
	    	params[i++] = new DBPreparedHandlerParam(codes[0]);
	    	for(int k = 1; k<codes.length; k++)
	    	{
	    		if(codes[k].equals("")) continue;
	    		sSQL += ",?";
		    	params[i++] = new DBPreparedHandlerParam(codes[k]);
	    	}
	    	sSQL += ")";
	   }
	   if (!Utility.IsEmpty(codeDesc)) {
	    	sSQL += " and upper(" + fieldNames[1] + ") like ?"; 
	    	params[i++]= new DBPreparedHandlerParam("%" + codeDesc.toUpperCase() + "%");
	   }	
	   
	   if (tableDef.isTree() && includeTree) {
		 sSQL = sSQL1 + "(" + sSQL + ") b";
		 sSQL += " where b." + fieldNames[6] + " like a." + fieldNames[6] + "||'%'";
	   }
	   if (tableDef.isTree() && includeTree)
	   {
		   sSQL += " order by 4,7";
	   } else {
		   sSQL += " order by 4,2";
	   }
	   DBPreparedHandlerParam [] pars = new DBPreparedHandlerParam[i];
	   for(int j=0; j<i;j++)
	   {
		   pars[j] = params[j];
	   }
	   
	   DBPreparedHandler db = new DBPreparedHandler();
	   ArrayList list = new ArrayList();
	   
	   try {
		   ResultSet rs = db.queryResults(sSQL,pars);
		   while (rs.next()) {
			   LookupCodeValue lv = new LookupCodeValue();
			   lv.setPrefix(tableId);
			   lv.setCode(rs.getString(1));
			   lv.setDescription(db.getString(rs, 2));
			   lv.setActive(Integer.valueOf("0" + db.getString(rs, 3)).intValue()==1);
			   lv.setOrderByIndex(Integer.valueOf("0" + db.getString(rs,4)).intValue());
			   lv.setParentCode(db.getString(rs, 5));
			   lv.setBuf1(db.getString(rs,6));
			   lv.setCodeTree(db.getString(rs, 7));
			   lv.setLastUpdateUser(db.getString(rs,8));
			   lv.setLastUpdateDate(MyDateFormat.getCalendar(db.getString(rs, 9)));
			   lv.setBuf3(db.getString(rs,10));
			   lv.setBuf4(db.getString(rs,11));
			   lv.setBuf5(db.getString(rs,12));
			   lv.setBuf6(db.getString(rs,13));
			   lv.setBuf7(db.getString(rs,14));
			   lv.setBuf8(db.getString(rs,15));
			   lv.setBuf9(db.getString(rs,16));
			   lv.setCodecsv(db.getString(rs, 17));
			   list.add(lv);
			}
			rs.close();
			//filter by programId for user
			if("USR".equals(tableId) && !Utility.IsEmpty(pCd)){
				List userLst = providerDao.getActiveProviders(new Integer(pCd));	
				ArrayList newLst=new ArrayList();
				for(int n=0;n<userLst.size();n++){
					SecProvider sp =(SecProvider)userLst.get(n);
					for(int m=0;m<list.size();m++){
						LookupCodeValue lv=(LookupCodeValue)list.get(m);					
						if(lv.getCode().equals(sp.getProviderNo()))	newLst.add(lv);
					}
				}
				list =newLst;
			}
	   }
	   catch(SQLException e)
	   {
		   throw e;
		  //e.printStackTrace();
	   }
	   finally
	   {
		   db.closeConn();
	   }	 
	   return list;
	}

	public LookupTableDefValue GetLookupTableDef(String tableId) throws SQLException
	{
		if (lookupTableDefs == null) {
		    synchronized ("runonece")
		    {
				String sSQL="from LookupTableDefValue s";
				lookupTableDefs = new Hashtable();
				List tableDefs = getHibernateTemplate().find(sSQL);
				for(int i=0; i<tableDefs.size(); i++)
				{
					LookupTableDefValue tdv = (LookupTableDefValue) tableDefs.get(i);
					lookupTableDefs.put(tdv.getTableId(), tdv);
				}
		    }
		}
	    return (LookupTableDefValue) lookupTableDefs.get(tableId);
	}
	public List LoadFieldDefList(String tableId) 
	{
		String sSql = "from FieldDefValue s where s.tableId=? order by s.fieldIndex ";
		ArrayList paramList = new ArrayList();
	    paramList.add(tableId);
	    Object params[] = paramList.toArray(new Object[paramList.size()]);
		
	    return getHibernateTemplate().find(sSql,params);
	}
	public List GetCodeFieldValues(LookupTableDefValue tableDef, String code) throws SQLException
	{
		String tableName = tableDef.getTableName();
		List fs = LoadFieldDefList(tableDef.getTableId());
		String idFieldName = "";
		
		String sql = "select ";
		for(int i=0; i<fs.size(); i++) {
			FieldDefValue fdv = (FieldDefValue) fs.get(i);
			if(fdv.getGenericIdx()==1) idFieldName = fdv.getFieldSQL();
			if (i==0) {
				sql += fdv.getFieldSQL();
			}
			else
			{
				sql += "," + fdv.getFieldSQL();
			}
		}
		sql += " from " + tableName + " s";
		sql += " where " + idFieldName + "=?"; 
		DBPreparedHandler db = new DBPreparedHandler();
		try { 
			ResultSet rs = db.queryResults(sql,code);
			if (rs.next()) {
				for(int i=0; i< fs.size(); i++) 
				{
					FieldDefValue fdv = (FieldDefValue) fs.get(i);
					String val = db.getString(rs, i+1);
					if("D".equals(fdv.getFieldType()))
						if(fdv.isEditable()) {
							val = MyDateFormat.getStandardDate(MyDateFormat.getCalendarwithTime(val));
						}
						else
						{
							val = MyDateFormat.getStandardDateTime(MyDateFormat.getCalendarwithTime(val));
						}
					fdv.setVal(val);
				}
			}
			rs.close();
			for (int i=0; i< fs.size(); i++)
			{
				FieldDefValue fdv = (FieldDefValue) fs.get(i);
				if (!Utility.IsEmpty(fdv.getLookupTable()))
				{
					LookupCodeValue lkv = GetCode(fdv.getLookupTable(),fdv.getVal());
					if (lkv != null) fdv.setValDesc(lkv.getDescription());
				}
			}
		}
		catch(SQLException e)
		{
			//e.printStackTrace();
			throw e;
		}
		finally
		{
			db.closeConn();
		}
		return fs;
	}
	public List GetCodeFieldValues(LookupTableDefValue tableDef) throws SQLException
	{
		String tableName = tableDef.getTableName();
		List fs = LoadFieldDefList(tableDef.getTableId());
		ArrayList codes = new ArrayList();
		String sql = "select ";
		for(int i=0; i<fs.size(); i++) {
			FieldDefValue fdv = (FieldDefValue) fs.get(i);
			if (i==0) {
				sql += fdv.getFieldSQL();
			}
			else
			{
				sql += "," + fdv.getFieldSQL();
			}
		}
		sql += " from " + tableName;
		DBPreparedHandler db = new DBPreparedHandler();
		try {
			ResultSet rs = db.queryResults(sql);
			while (rs.next()) {
				for(int i=0; i< fs.size(); i++) 
				{
					FieldDefValue fdv = (FieldDefValue) fs.get(i);
					String val = db.getString(rs, i+1);
					if("D".equals(fdv.getFieldType()))
						val = MyDateFormat.getStandardDateTime(MyDateFormat.getCalendarwithTime(val));
					fdv.setVal(val);
					if (!Utility.IsEmpty(fdv.getLookupTable()))
					{
						LookupCodeValue lkv = GetCode(fdv.getLookupTable(),val);
						if (lkv != null) fdv.setValDesc(lkv.getDescription());
					}
				}
				codes.add(fs);
			}
			rs.close();
		}
		catch(SQLException e)
		{
			throw e;
			//System.out.println(e.getStackTrace());
		}
		finally
		{
			db.closeConn();
		}
		return codes;
	}
	private int GetNextId(String idFieldName, String tableName) throws SQLException

	{
		String sql = "select max(" + idFieldName + ")";
		sql += " from " + tableName;
		DBPreparedHandler db = new DBPreparedHandler();
		try {
			ResultSet rs = db.queryResults(sql);
			int id = 0;
			if (rs.next()) 
				 id = rs.getInt(1);
			return id + 1;
		}
		finally
		{
			db.closeConn();
		}
	}
	
	public String SaveCodeValue(boolean isNew, LookupTableDefValue tableDef, List fieldDefList) throws SQLException
	{
		String id = "";
		if (isNew)
		{
			id = InsertCodeValue(tableDef, fieldDefList);
		}
		else
		{
			id = UpdateCodeValue(tableDef,fieldDefList);
		}
		String tableId = tableDef.getTableId();
		if ("OGN,SHL".indexOf(tableId)>=0)
		{
			SaveAsOrgCode(GetCode(tableId, id), tableId); 
		}
		if ("PRP".equals(tableId)) {
			OscarProperties prp = OscarProperties.getInstance();
			LookupCodeValue prpCd = GetCode(tableId,id);
			if(prp.getProperty(prpCd.getDescription()) != null) prp.remove(prpCd.getDescription());
	    	prp.setProperty(prpCd.getDescription(), prpCd.getBuf1().toLowerCase());
		}
		return id;
	}
	public String SaveCodeValue(boolean isNew, LookupCodeValue codeValue) throws SQLException
	{
		String tableId = codeValue.getPrefix();
		LookupTableDefValue  tableDef = GetLookupTableDef(tableId);
		List fieldDefList = this.LoadFieldDefList(tableId);
		for(int i=0; i<fieldDefList.size(); i++)
		{
			FieldDefValue fdv = (FieldDefValue) fieldDefList.get(i);
			
			switch(fdv.getGenericIdx())
			{
			case 1:
				fdv.setVal(codeValue.getCode());
				break;
			case 2:
				fdv.setVal(codeValue.getDescription());
				break;
			case 3:
				fdv.setVal(codeValue.isActive()?"1":"0");
				break;
			case 4:
				fdv.setVal(String.valueOf(codeValue.getOrderByIndex()));
				break;
			case 5:
				fdv.setVal(codeValue.getParentCode());
				break;
			case 6:
				fdv.setVal(codeValue.getBuf1());
				break;
			case 7:
				fdv.setVal(codeValue.getCodeTree());
				break;
			case 8:
				fdv.setVal(codeValue.getLastUpdateUser());
				break;
			case 9:
				fdv.setVal(MyDateFormat.getStandardDateTime(codeValue.getLastUpdateDate()));
				break;
			case 10:
				fdv.setVal(codeValue.getBuf3());
			case 11:
				fdv.setVal(codeValue.getBuf4());
			case 12:
				fdv.setVal(codeValue.getBuf5());
			case 13:
				fdv.setVal(codeValue.getBuf6());
			case 14:
				fdv.setVal(codeValue.getBuf7());
			case 15:
				fdv.setVal(codeValue.getBuf8());
			case 16:
				fdv.setVal(codeValue.getBuf9());
			case 17:
				fdv.setVal(codeValue.getCodecsv());
			}
		}
		if (isNew) 
		{
			return InsertCodeValue(tableDef, fieldDefList);
		}
		else
		{
			return UpdateCodeValue(tableDef,fieldDefList);
		}
	}
	private String InsertCodeValue(LookupTableDefValue tableDef, List fieldDefList) throws SQLException
	{
		String tableName = tableDef.getTableName();
		String idFieldVal = "";

		int fields = 0;
		for(int i=0; i< fieldDefList.size(); i++) {
			FieldDefValue fdv = (FieldDefValue) fieldDefList.get(i);
			if (fdv.getFieldLength()!= null && fdv.getFieldLength().intValue() == -1) continue;
			fields ++;
		}
		DBPreparedHandlerParam[] params = new DBPreparedHandlerParam[fields];
		String phs = "";
		String sql = "insert into  " + tableName + "("; 
		for(int i=0; i< fieldDefList.size(); i++) {
			FieldDefValue fdv = (FieldDefValue) fieldDefList.get(i);
			if (fdv.getFieldLength() != null && fdv.getFieldLength().intValue() == -1) continue;
			sql += fdv.getFieldSQL() + ",";
			phs +="?,"; 
			if (fdv.getGenericIdx() == 1) {
				if (fdv.isAuto())
				{
					idFieldVal = String.valueOf(GetNextId(fdv.getFieldSQL(), tableName));
					fdv.setVal(idFieldVal);
				}
				else
				{
					idFieldVal = fdv.getVal();
				}
			}
			if ("S".equals(fdv.getFieldType()))
			{
				params[i] = new DBPreparedHandlerParam(fdv.getVal());
			}
			else if ("D".equals(fdv.getFieldType()))
			{
				//for last update date Using calendar Instance
				params[i] = new DBPreparedHandlerParam(MyDateFormat.getCalendarwithTime(fdv.getVal()));
			}
			else
			{
				params[i] = new DBPreparedHandlerParam(Integer.valueOf(fdv.getVal()).intValue());
			}
		}
		sql = sql.substring(0,sql.length()-1);
		phs = phs.substring(0,phs.length()-1);
		sql += ") values (" + phs + ")";

		//check the existence of the code 
		LookupCodeValue lkv= GetCode(tableDef.getTableId(), idFieldVal);
		if(lkv != null) 
		{
			throw new SQLException("The Code Already Exists.");
		}
		DBPreparedHandler db = new DBPreparedHandler();
		try{
			db.queryExecuteUpdate(sql, params);
		}
		finally
		{
			db.closeConn();
		}
		return idFieldVal;
	}
	private String UpdateCodeValue(LookupTableDefValue tableDef, List fieldDefList) throws SQLException
	{
		String tableName = tableDef.getTableName();
		String idFieldName = "";
		String idFieldVal = "";
		int fields = 0;
		for(int i=0; i< fieldDefList.size(); i++) {
			FieldDefValue fdv = (FieldDefValue) fieldDefList.get(i);
			if (fdv.getFieldLength()!= null && fdv.getFieldLength().intValue() == -1) continue;
			fields ++;
		}
		DBPreparedHandlerParam[] params = new DBPreparedHandlerParam[fields+1];
		String sql = "update " + tableName + " set ";
		for(int i=0; i< fieldDefList.size(); i++) {
			FieldDefValue fdv = (FieldDefValue) fieldDefList.get(i);
			if (fdv.getFieldLength() != null && fdv.getFieldLength().intValue() == -1) continue;
			if (fdv.getGenericIdx()==1) {
				idFieldName = fdv.getFieldSQL();
				idFieldVal = fdv.getVal();
			}
			
			sql += fdv.getFieldSQL() + "=?,";
			if ("S".equals(fdv.getFieldType()))
			{
				params[i] = new DBPreparedHandlerParam(fdv.getVal());
			}
			else if ("D".equals(fdv.getFieldType()))
			{
				if (fdv.isEditable()) {
					params[i] = new DBPreparedHandlerParam(MyDateFormat.getCalendar(fdv.getVal()));
				}
				else
				{
					params[i] = new DBPreparedHandlerParam(MyDateFormat.getCalendarwithTime(fdv.getVal()));
				}
			}
			else
			{
				params[i] = new DBPreparedHandlerParam(Integer.valueOf(fdv.getVal()).intValue());
			}
		}
		sql = sql.substring(0,sql.length()-1);
		sql += " where " + idFieldName + "=?";
		params[fields] = params[0];
		DBPreparedHandler db = new DBPreparedHandler();
		try {
			db.queryExecuteUpdate(sql, params);
		}
		finally
		{
			db.closeConn();
		}
		return idFieldVal;
	}
	public void SaveAsOrgCode(Program program) throws SQLException
	{
		LookupTableDefValue tableDef = this.GetLookupTableDef("ORG");
		List codeValues = new ArrayList();
		String  programId = "0000000" + program.getId().toString();
		programId = "P" + programId.substring(programId.length()-7);
		String fullCode = "P" + program.getId();
		
		String facilityId = "0000000" + String.valueOf(program.getFacilityId());
		facilityId = "F" + facilityId.substring(facilityId.length()-7); 
		
		LookupCodeValue fcd = GetCode("ORG", "F" + program.getFacilityId());
		fullCode = fcd.getBuf1() + fullCode;
		
		boolean isNew = false;
		LookupCodeValue pcd = GetCode("ORG", "P" + program.getId());
		if (pcd == null) {
			isNew = true;
			pcd = new LookupCodeValue();
		}
		pcd.setPrefix("ORG");
		pcd.setCode("P" + program.getId());
		pcd.setCodeTree(fcd.getCodeTree() + programId);
		pcd.setCodecsv(fcd.getCodecsv()+ "P" + program.getId()+",");
		pcd.setDescription(program.getName());
		pcd.setBuf1(fullCode);
		pcd.setActive(Program.PROGRAM_STATUS_ACTIVE.equals(program.getProgramStatus()));
		pcd.setOrderByIndex(0);
		pcd.setLastUpdateDate(Calendar.getInstance());
		pcd.setLastUpdateUser(program.getLastUpdateUser());
		if(!isNew){
			this.updateOrgTree(pcd.getCode(), pcd);
			this.updateOrgStatus(pcd.getCode(), pcd);
		}
		this.SaveCodeValue(isNew,pcd);
		doCache();
	}
	private void updateOrgTree(String orgCd, LookupCodeValue newCd) throws SQLException
	{
		LookupCodeValue oldCd = GetCode("ORG", orgCd);
		if(!oldCd.getCodecsv().equals(newCd.getCodecsv())) {
			String oldFullCode = oldCd.getBuf1();
			String oldTreeCode = oldCd.getCodeTree();
			String oldCsv = oldCd.getCodecsv();
			
			String newFullCode = newCd.getBuf1();
			String newTreeCode = newCd.getCodeTree();
			String newCsv = newCd.getCodecsv();
			String sql = "update lst_orgcd set fullcode =replace(fullcode,'" + oldFullCode + "','" + newFullCode + "')" + 
											  ",codetree =replace(codetree,'" + oldTreeCode + "','" + newTreeCode + "')" + 
						                       ",codecsv =replace(codecsv,'" + oldCsv + "','" + newCsv + "')" + 
						 " where codecsv like '" + oldCsv + "_%'";

			DBPreparedHandler db = new DBPreparedHandler();
			try{
				db.queryExecuteUpdate(sql);
			}
			finally
			{
				db.closeConn();
			}
		}
	
		
	}

	private void updateOrgStatus(String orgCd, LookupCodeValue newCd) throws SQLException
	{
		LookupCodeValue oldCd = GetCode("ORG", orgCd);
		if(!newCd.isActive()) {
			String oldCsv = oldCd.getCodecsv();
			
			String sql = "update lst_orgcd set activeyn ='0' where codecsv like '" + oldCsv + "_%'";

			DBPreparedHandler db = new DBPreparedHandler();
			try{
				db.queryExecuteUpdate(sql);
			}
			finally
			{
				db.closeConn();
			}
		}
	
		
	}
	public boolean inOrg(String org1,String org2){
		boolean isInString=false;
		String sql="From LstOrgcd a where  a.fullcode like '%"+"?'  ";
		
		LstOrgcd orgObj1 =(LstOrgcd)getHibernateTemplate().find(sql,new Object[] {org1});
		LstOrgcd orgObj2 =(LstOrgcd)getHibernateTemplate().find(sql,new Object[] {org2});
		if(orgObj2.getFullcode().indexOf(orgObj1.getFullcode())>0) isInString = true;
		return isInString;
		
	}
	public void SaveAsOrgCode(Facility facility) throws SQLException
	{
		LookupTableDefValue tableDef = this.GetLookupTableDef("ORG");
		List codeValues = new ArrayList();
		String  facilityId = "0000000" + facility.getId().toString();
		facilityId = "F" + facilityId.substring(facilityId.length()-7);
		String fullCode = "F" + facility.getId();
		
		String orgId = "0000000" + String.valueOf(facility.getOrgId());
		orgId = "S" + orgId.substring(orgId.length()-7); 
		
		LookupCodeValue ocd = GetCode("ORG", "S" + facility.getOrgId());
		fullCode = ocd.getBuf1() + fullCode;
		
		boolean isNew = false;
		LookupCodeValue fcd = GetCode("ORG", "F" + facility.getId());
		if (fcd == null) {
			isNew = true;
			fcd = new LookupCodeValue();
		}
		fcd.setPrefix("ORG");
		fcd.setCode("F" + facility.getId());
		fcd.setCodeTree(ocd.getCodeTree() + facilityId);
		fcd.setCodecsv(ocd.getCodecsv()+"F" + facility.getId()+",");
		fcd.setDescription(facility.getName());
		fcd.setBuf1(fullCode);
		fcd.setActive(facility.getActive());
		fcd.setOrderByIndex(0);
		fcd.setLastUpdateDate(Calendar.getInstance());
		fcd.setLastUpdateUser(facility.getLastUpdateUser());
		if(!isNew){
			this.updateOrgTree(fcd.getCode(), fcd);
			this.updateOrgStatus(fcd.getCode(), fcd);
		}
		this.SaveCodeValue(isNew,fcd);
		doCache();
	}
	public void SaveAsOrgCode(LookupCodeValue orgVal, String tableId) throws SQLException
	{
		LookupTableDefValue tableDef = this.GetLookupTableDef("ORG");
		List codeValues = new ArrayList();
		String orgPrefix = tableId.substring(0,1);
		String orgPrefixP = "R1";
		if ("S".equals(orgPrefix)) orgPrefixP = "O";   //parent of Organization is R, parent of Shelter is O.

		String  orgId = "0000000" + orgVal.getCode();
		orgId = orgPrefix + orgId.substring(orgId.length()-7);

		String orgCd = orgPrefix + orgVal.getCode();
		String parentCd = orgPrefixP + orgVal.getParentCode();
		
		LookupCodeValue pCd = GetCode("ORG",parentCd);
		if(pCd == null) return;
		
		LookupCodeValue ocd = GetCode("ORG", orgCd);
		boolean isNew = false;
		if (ocd == null) {
			isNew = true;
			ocd = new LookupCodeValue();
		}
		ocd.setPrefix("ORG");
		ocd.setCode(orgCd);
		ocd.setCodeTree(pCd.getCodeTree() + orgId);
		ocd.setCodecsv(pCd.getCodecsv()+orgCd+",");
		ocd.setDescription(orgVal.getDescription());
		ocd.setBuf1(pCd.getBuf1()+ orgCd);
		ocd.setActive(orgVal.isActive());
		ocd.setOrderByIndex(0);
		ocd.setLastUpdateDate(Calendar.getInstance());
		ocd.setLastUpdateUser(orgVal.getLastUpdateUser());
		if(!isNew){
			this.updateOrgTree(ocd.getCode(), ocd);
			this.updateOrgStatus(ocd.getCode(), ocd);
		}
		this.SaveCodeValue(isNew,ocd);
		doCache();
	}
	public void runProcedure(String procName, String [] params) throws SQLException
	{
		DBPreparedHandler db = new DBPreparedHandler();
		try {
			db.procExecute(procName, params);
		}
		finally{
			db.closeConn();
		}
	}
	
	public int getCountOfActiveClient(String orgCd) throws SQLException{
		String sql = "select count(*) from admission where admission_status='" +  KeyConstants.INTAKE_STATUS_ADMITTED + "' and  'P' || program_id in (" +
				" select code from lst_orgcd  where codecsv like '%' || '" +  orgCd  + ",' || '%')";
		String sql1 = "select count(*) from program_queue where  'P' || program_id in (" +
		" select code from lst_orgcd  where codecsv like '%' || '" +  orgCd  + ",' || '%')";

		DBPreparedHandler db = new DBPreparedHandler();
		try {
			ResultSet rs = db.queryResults(sql);
			int id = 0;
			if (rs.next()) 
				 id = rs.getInt(1);
			if (id > 0) return id;
			
			rs.close();
			rs = db.queryResults(sql1);
			if (rs.next()) 
				 id = rs.getInt(1);
			rs.close();
			return id;
		}
		finally
		{
			db.closeConn();
		}
	}

	
	public void setProviderDao(ProviderDao providerDao) {
		this.providerDao = providerDao;
	}
}

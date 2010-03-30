// -----------------------------------------------------------------------------------------------------------------------
// *
// *
// * Copyright (c) 2001-2002. Department of Family Medicine, McMaster University. All Rights Reserved. *
// * This software is published under the GPL GNU General Public License. 
// * This program is free software; you can redistribute it and/or 
// * modify it under the terms of the GNU General Public License 
// * as published by the Free Software Foundation; either version 2 
// * of the License, or (at your option) any later version. * 
// * This program is distributed in the hope that it will be useful, 
// * but WITHOUT ANY WARRANTY; without even the implied warranty of 
// * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
// * GNU General Public License for more details. * * You should have received a copy of the GNU General Public License 
// * along with this program; if not, write to the Free Software 
// * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. * 
// * 
// * <OSCAR TEAM>
// * This software was written for the 
// * Department of Family Medicine 
// * McMaster Unviersity 
// * Hamilton 
// * Ontario, Canada 
// *
// -----------------------------------------------------------------------------------------------------------------------
package oscar.oscarMessenger.pageUtil;

import java.util.Hashtable;

import oscar.oscarDB.DBHandler;

public class MsgDisplayMessagesBean {
  private String sample = "Start value";
  //Access sample property

  private String providerNo;
  private java.util.Vector messageid;
  private java.util.Vector messagePosition;
  private java.util.Vector status;
  private java.util.Vector date;
  private java.util.Vector ime;
  private java.util.Vector sentby;
  private java.util.Vector subject;
  private java.util.Vector attach;
  private int counter;
  private String currentLocationId;

 /*
 * edit 2006-0811-01 by wreby
 */
  private String filter;
  
  //Just sets the filter keyword after ensuring that the user is not trying to
  // insert any stray single quotes, since that is the escape character in SQL
  public void setFilter(String filter){
      if (filter == null || filter.equals("")) {
          this.filter = null;
      }
      else {
          //get rid of the stray single quotes, since that is the SQL escape character
          filter.replaceAll("'", "''");
          this.filter = filter;
      }
  }
  public void clearFilter(){
      filter = null;
  }
  public String getFilter() {
      if (filter == null ) {
          filter = "";
      }
      
      return filter;
  }
  public String getSQLSearchFilter(String[] colsToSearch) {
      if ( filter==null || colsToSearch.length == 0) {
          return "";
      }
      else {
          String search = " and (";
          int numOfCols = colsToSearch.length;
          for (int i = 0; i < numOfCols-1; i++) {
              search = search + colsToSearch[i] + " like '%" + filter + "%' or ";
          }
          search = search + colsToSearch[numOfCols-1] + " like '%" + filter + "%') ";
          return search;
      }
  }
  // end edit 2006-08011-01 by wreby


  public java.util.Vector getAttach (){
    return attach;
  }



  public String getCurrentLocationId(){
        if (currentLocationId == null){
            try{
              DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
              java.sql.ResultSet rs;
              rs = db.GetSQL("select locationId from oscarcommlocations where current1 = '1'");

              if (rs.next()) {
                currentLocationId = db.getString(rs,"locationId");
              }
              rs.close();
            }catch (java.sql.SQLException e){ e.printStackTrace(System.out); }
        }
        return currentLocationId;
  }



  /**
   * Used to set message ids to be viewed on the DisplayMessages.jsp
   * @param messageid Vector, Contains all the messageids to be displayed
   */
  public void setMessageid(java.util.Vector messageid){
    this.messageid = messageid;
  }

  /**
   * calls getMessageIDS and getInfo which are used to fill the Vectors
   * with the Message headers for the current provider No
   * @return Vector, Contains the messageids for use on the DisplayMessage.jsp
   * @see getMessageIDs , getInfo
   */
  public java.util.Vector getMessageid(){
    getMessageIDs();
    getInfo();
    estInbox();

    return this.messageid;
  }
  
  public java.util.Vector getDelMessageid(){
    getDeletedMessageIDs();
    getInfo();
    estDeletedInbox();
    return this.messageid;
  }

  public java.util.Vector getSentMessageid(){
    getSentMessageIDs();
    estSentItemsInbox();
    return this.messageid;
  }

  /**
   * Used to set the Status vector. either read, new, del
   * @param status Vector, Strings either read , new or del
   */
  public void setStatus(java.util.Vector status){
    this.status = status;
  }

  /**
   * Will check to see if the status has already been set, if not it will intialize the
   * Vectors of this Bean with getMessageIDs and get Info
   * @return Vector Strings either read, new or del
   * @see getMessageIDs, getInfo
   */
  public java.util.Vector getStatus(){
    if (status == null){
       getMessageIDs();
       getInfo();
    }
  return this.status;
  }


  public void setDate(java.util.Vector date){
    this.date = date;
  }

  /**
   * Will check to see if the date has already been set, if not it will intialize the
   * Vectors of this Bean with getMessageIDs and get Info
   * @return Vector Strings either read, new or del
   * @see getMessageIDs, getInfo
   */
  public java.util.Vector getDate(){
    if (date == null){
       getMessageIDs();
       getInfo();
    }
  return this.date;
  }

  /**
   * used to set the sentby Vector
   * @param sentby Vector contains Strings of who sent the message
   */
  public void setSentby(java.util.Vector sentby){
    this.sentby = sentby;
  }

  /**
   * Will check to see if the sentby has already been set, if not it will intialize the
   * Vectors of this Bean with getMessageIDs and get Info
   * @return Vector Strings either read, new or del
   * @see getMessageIDs, getInfo
   */
  public java.util.Vector getSentby (){
    if (sentby == null){
       getMessageIDs();
       getInfo();
    }
  return this.sentby;
  }

  /**
   * used to set the subject Vector of the messages
   * @param subject Vector, contains Strings of subjects
   */
  public void setSubject(java.util.Vector subject){
    this.subject = subject;
  }

  /**
   * Will check to see if the subject has already been set, if not it will intialize the
   * Vectors of this Bean with getMessageIDs and get Info
   * @return Vector Strings either read, new or del
   * @see getMessageIDs, getInfo
   */
   public java.util.Vector getSubject(){
     if (subject == null){
        getMessageIDs();
        getInfo();
     }
   return this.subject;
   }



  /**
   * Used to set the providerNo that will determine what this bean will fill itself with
   * @param providerNo String, provider No
   */
   public void setProviderNo(String providerNo){

     this.providerNo = providerNo;
   }

  /**
   * gets the current provider No
   * @return
   */
   public String getProviderNo(){
     return this.providerNo;
   }

  /**
   * This method uses the ProviderNo and searches for messages for this providerNo
   * in the messagelisttbl
   */
  void getMessageIDs(){

     String providerNo= this.getProviderNo();

     messageid = new java.util.Vector();
     status  = new java.util.Vector();
     messagePosition = new java.util.Vector();
     
     int index = 0;
     
     try{
        DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
        java.sql.ResultSet rs;

        String sql = new String("select message, status from messagelisttbl where provider_no = '"+ providerNo+"' and status not like \'del\' and remoteLocation = '"+getCurrentLocationId()+"' order by message");
        rs = db.GetSQL(sql);

        while (rs.next()) {
           messagePosition.add(Integer.toString(index));
           messageid.add( db.getString(rs,"message")  );
           status.add( db.getString(rs,"status")  );
           index++;
        }

       rs.close();

    }catch (java.sql.SQLException e){ e.printStackTrace(System.out); }

  }//getMessageIDs
////////////////////////////////////////////////////////////////////////////////
  public String getOrderBy(String order){          
     String orderBy = null;
     if(order == null){        
        orderBy=" m.messageid desc";
     }else{
        String desc = "";
        if (order.charAt(0) == '!'){
           desc = " desc ";
           order = order.substring(1);
        }
        Hashtable orderTable = new Hashtable();
        orderTable.put("status", "status");    
        orderTable.put("from","sentby");
        orderTable.put("subject","thesubject");
        orderTable.put("date","thedate");        
        orderTable.put("sentto", "sentto");
                                
        orderBy = (String) orderTable.get(order);
        if (orderBy == null){
           orderBy = "message";
        }
        orderBy += desc + ", m.messageid desc";
     }   
     System.out.println("order "+order+" orderby "+orderBy);
     return orderBy; 
  }
  
  
  public java.util.Vector estInbox(){
     return estInbox(null);
  }
//INBOX
  public java.util.Vector estInbox(String orderby,String moreMessages,int initialDisplay){

     String providerNo= this.getProviderNo();
     java.util.Vector msg = new java.util.Vector();
    
     String[] searchCols = {"m.thesubject", "m.themessage", "m.sentby", "m.sentto"};

     try{
        DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
        java.sql.ResultSet rs;
        String messageLimit="";
        
/*        if (moreMessages.equals("false"))
        {messageLimit=" Limit "+initialDisplay;}
*/        
        String sql = new String("select map.messageID is null as isnull, ml.message, ml.status, m.thesubject, m.thedate, m.theime, m.attachment, m.pdfattachment, m.sentby  from messagelisttbl ml, messagetbl m "
        + " left outer join msgDemoMap map on map.messageID = m.messageid "
        +" where ml.provider_no = '"+ providerNo+"' and status not like \'del\' and remoteLocation = '"+getCurrentLocationId()+"' "
        +" and ml.message = m.messageid " + getSQLSearchFilter(searchCols) + " order by isnull asc, "+getOrderBy(orderby));
        System.out.println(sql);
        rs = db.GetSQL(sql);
        int idx = 0;
        while (rs.next()) {
        	idx ++;
            if (moreMessages.equals("false") && idx > initialDisplay) break;
            oscar.oscarMessenger.data.MsgDisplayMessage dm = new oscar.oscarMessenger.data.MsgDisplayMessage();
            dm.status     = db.getString(rs,"status");
            dm.messageId  = db.getString(rs,"message");
            dm.thesubject = db.getString(rs,"thesubject");
            dm.thedate    = db.getString(rs,"thedate");
            dm.theime    = db.getString(rs,"theime");
            dm.sentby     = db.getString(rs,"sentby");
            String att    = db.getString(rs,"attachment");
            String pdfAtt    = db.getString(rs,"pdfattachment");           
            if (att == null || att.equals("null") ){
              dm.attach = "0";
            }else{
              dm.attach = "1";
            }
            if ( pdfAtt == null || pdfAtt.equals("null") ){
              dm.pdfAttach = "0";
            }else{
              dm.pdfAttach = "1";
            }
            msg.add(dm);
        }

       rs.close();

    }catch (java.sql.SQLException e){ e.printStackTrace(System.out); }

    return msg;
  }
//
//////////////////////////////////////////////=---------------------------------

public java.util.Vector estDemographicInbox(){
     return estDemographicInbox(null, null);
  }
//INBOX
  public java.util.Vector estDemographicInbox(String orderby, String demographic_no){

     String providerNo= this.getProviderNo();
     java.util.Vector msg = new java.util.Vector();
     int index = 0;
     
     String[] searchCols = {"m.thesubject", "m.themessage", "m.sentby", "m.sentto"};

     try{
        DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
        java.sql.ResultSet rs;

        //String sql = new String("select ml.message, ml.status, m.thesubject, m.thedate, m.theime, m.attachment, m.pdfattachment, m.sentby  from messagelisttbl ml, messagetbl m, msgDemoMap map"
        //+" where map.demographic_no = '"+ demographic_no+"' and remoteLocation = '"+getCurrentLocationId()+"' "
        //+" and m.messageid = map.messageID and ml.message=m.messageid order by "+getOrderBy(orderby));
        
        String sql = "select m.messageid, m.thesubject, m.thedate, m.theime, m.attachment, m.pdfattachment, m.sentby  " +
              "from  messagetbl m, msgDemoMap map where map.demographic_no = '"+ demographic_no+"'  " +
              "and m.messageid = map.messageID " + getSQLSearchFilter(searchCols) + " order by "+getOrderBy(orderby);
        
        
        System.out.println("this "+sql);
        rs = db.GetSQL(sql);

        while (rs.next()) {

           oscar.oscarMessenger.data.MsgDisplayMessage dm = new oscar.oscarMessenger.data.MsgDisplayMessage();
           dm.status     = "    ";//db.getString(rs,"status");
           dm.messageId  = db.getString(rs,"messageid");
           dm.messagePosition  = Integer.toString(index);
           dm.thesubject = db.getString(rs,"thesubject");
           dm.thedate    = db.getString(rs,"thedate");
           dm.theime    = db.getString(rs,"theime");
           dm.sentby     = db.getString(rs,"sentby");
           
           String att    = db.getString(rs,"attachment");
           String pdfAtt    = db.getString(rs,"pdfattachment");
              if (att == null || att.equals("null") ){
                dm.attach = "0";
              }else{
                dm.attach = "1";
              }
              if (pdfAtt == null || pdfAtt.equals("null") ){
                dm.pdfAttach = "0";
              }else{
                dm.pdfAttach = "1";
              }

           
           if(rs.isLast()){
               dm.isLastMsg = true;
           }
           
           msg.add(dm);

           index++;

        }

       rs.close();

    }catch (java.sql.SQLException e){ e.printStackTrace(System.out); }

    return msg;
  }
//
//////////////////////////////////////////////=---------------------------------  
  
////////////////////////////////////////////////////////////////////////////////
//
  
  public java.util.Vector estInbox(String orderby){
     return estInbox(null);
  }
  //////////////////////////////////////////////////////////////////////////////////
  public java.util.Vector estDeletedInbox(){
     return estDeletedInbox(null); 
  }
  
  public java.util.Vector estDeletedInbox(String orderby){

     String providerNo= this.getProviderNo();
     java.util.Vector msg = new java.util.Vector();
     String[] searchCols = {"m.thesubject", "m.themessage", "m.sentby", "m.sentto"};

     try{
        DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
        java.sql.ResultSet rs;

        String sql = new String("select ml.message, ml.status, m.thesubject, m.thedate, m.theime, m.attachment, m.pdfattachment, m.sentby  from messagelisttbl ml, messagetbl m "
        +" where provider_no = '"+ providerNo+"' and status like \'del\' and remoteLocation = '"+getCurrentLocationId()+"' "
        +" and ml.message = m.messageid " + getSQLSearchFilter(searchCols) + " order by "+getOrderBy(orderby));
                
        rs = db.GetSQL(sql);

        while (rs.next()) {

           oscar.oscarMessenger.data.MsgDisplayMessage dm = new oscar.oscarMessenger.data.MsgDisplayMessage();
           dm.status     = "deleted";
           dm.messageId  = db.getString(rs,"message");
           dm.thesubject = db.getString(rs,"thesubject");
           dm.thedate    = db.getString(rs,"thedate");
           dm.theime    = db.getString(rs,"theime");
           dm.sentby     = db.getString(rs,"sentby");
           String att    = db.getString(rs,"attachment");
           String pdfAtt    = db.getString(rs,"pdfattachment");
              if (att == null || att.equals("null") ){
                dm.attach = "0";
              }else{
                dm.attach = "1";
              }
              if (pdfAtt == null || pdfAtt.equals("null") ){
                dm.pdfAttach = "0";
              }else{
                dm.pdfAttach = "1";
              }
           
           msg.add(dm);

           // System.out.println("message "+db.getString(rs,"message")+" status "+db.getString(rs,"status"));

        }

       rs.close();

    }catch (java.sql.SQLException e){ e.printStackTrace(System.out); }

    return msg;
  }
//
/////////////////////////////////////////////=----------------------------------



  /**
   * This method uses the ProviderNo and searches for messages for this providerNo
   * in the messagelisttbl
   */
  void getDeletedMessageIDs(){
    // System.out.println("In deleted MEssages");
     String providerNo= this.getProviderNo();

     messageid = new java.util.Vector();
     status  = new java.util.Vector();
     try{
        DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
        java.sql.ResultSet rs;

        String sql = new String("select message from messagelisttbl where provider_no = '"+ providerNo+"' and status like \'del\' and remoteLocation = '"+getCurrentLocationId()+"'");
        rs = db.GetSQL(sql);
        int cou = 0;
        while (rs.next()) {
           messageid.add( db.getString(rs,"message")  );
           status.add("deleted");
           cou++;
        }
        // System.out.println("cou "+cou+" messageid size "+messageid.size()+" for "+providerNo);

       rs.close();

    }catch (java.sql.SQLException e){ e.printStackTrace(System.out); }
    // System.out.println("LEaving deleted messages ID this is the size ive got "+messageid.size());
  }//getDeletedMessageIDs

  /**
   * This method uses the ProviderNo and searches for messages for this providerNo
   * in the messagelisttbl
   */
  void getSentMessageIDs(){
    // System.out.println("In sent MEssages");
     String providerNo= this.getProviderNo();

     messageid = new java.util.Vector();
     status  = new java.util.Vector();
     sentby = new java.util.Vector();
     date  = new java.util.Vector();
     ime  = new java.util.Vector();
     subject  = new java.util.Vector();
     try{
        DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
        java.sql.ResultSet rs;

        String sql = new String("select messageid, thedate,  theime, thesubject, sentby from messagetbl where sentbyNo = '"+ providerNo+"' and sentByLocation = '"+getCurrentLocationId()+"'");
        rs = db.GetSQL(sql);
        int cou = 0;
        while (rs.next()) {
           messageid.add( db.getString(rs,"messageid")  );
           status.add("sent");
           sentby.add(db.getString(rs,"sentby"));
           date.add(db.getString(rs,"thedate"));
           ime.add(db.getString(rs,"theime"));
           subject.add(db.getString(rs,"thesubject"));
           cou++;
        }
        // System.out.println("cou "+cou+" messageid size "+messageid.size()+" for "+providerNo);

       rs.close();

    }catch (java.sql.SQLException e){ e.printStackTrace(System.out); }
    // System.out.println("LEaving deleted messages ID this is the size ive got "+messageid.size());
  }//getSentMessageIDs

////////////////////////////////////////////////////////////////////////////////
//INBOX
  public java.util.Vector estSentItemsInbox(){
     return estSentItemsInbox(null);
  }
  public java.util.Vector estSentItemsInbox(String orderby){

     String providerNo= this.getProviderNo();
     java.util.Vector msg = new java.util.Vector();
     String[] searchCols = {"m.thesubject", "m.themessage", "m.sentby", "m.sentto"};


     try{
        DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
        java.sql.ResultSet rs;

        String sql = new String("select messageid as status, messageid as message , thedate, theime, thesubject, sentby, sentto, attachment, pdfattachment from messagetbl m where sentbyNo = '"+ providerNo+"' and sentByLocation = '"+getCurrentLocationId()+"'  " + getSQLSearchFilter(searchCols) + " order by "+getOrderBy(orderby));

        rs = db.GetSQL(sql);

        while (rs.next()) {

           oscar.oscarMessenger.data.MsgDisplayMessage dm = new oscar.oscarMessenger.data.MsgDisplayMessage();
           dm.status     = "sent";
           dm.messageId  = db.getString(rs,"status");
           dm.thesubject = db.getString(rs,"thesubject");
           dm.thedate    = db.getString(rs,"thedate");
           dm.theime    = db.getString(rs,"theime");
           dm.sentby     = db.getString(rs,"sentby");
           dm.sentto     = db.getString(rs,"sentto");
           String att    = db.getString(rs,"attachment");
           String pdfAtt    = db.getString(rs,"pdfattachment");           
              if (att == null || att.equals("null") ){
                dm.attach = "0";
              }else{
                dm.attach = "1";
              }
              if (pdfAtt == null || pdfAtt.equals("null") ){
                dm.pdfAttach = "0";
              }else{
                dm.pdfAttach = "1";
              }
           
           msg.add(dm);

           //System.out.println("message "+db.getString(rs,"message")+" status "+db.getString(rs,"status"));

        }

       rs.close();

    }catch (java.sql.SQLException e){ e.printStackTrace(System.out); }

    return msg;
  }
//
//////////////////////////////////////////////=---------------------------------








  /**
   * This method uses the Vector initialized by getMessageIDs and fills the Vectors with
   * the Message header Info
   */
  void getInfo(){
    // System.out.println("Get Info called ms = "+messageid.size());
     sentby  = new java.util.Vector();
     date    = new java.util.Vector();
     subject = new java.util.Vector();
     attach  = new java.util.Vector();
     String att;
     try{
        DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
        java.sql.ResultSet rs;

        // System.out.println("Messages in getInfo = "+messageid.size());
        //make search string
        StringBuffer stringBuffer = new StringBuffer();
        for ( int i = 0; i < messageid.size() ; i++){
            if (messageid.size()-1 == i){
                stringBuffer.append(" messageid = '"+messageid.get(i)+"' ");
            }else{
                stringBuffer.append(" messageid = '"+messageid.get(i)+"' or ");
            }
        }

//        for ( int i = 0; i < messageid.size() ; i++){
//           String sql = new String("select thesubject, thedate ,sentby from messagetbl where messageid = "+ messageid.get(i) );
           String sql = new String("select thesubject, thedate, theime ,sentby, attachment from messagetbl where "+stringBuffer.toString()+" order by thedate");
           rs = db.GetSQL(sql);
           while (rs.next()) {
              sentby.add( db.getString(rs,"sentby")  );
              date.add( db.getString(rs,"thedate")  );
              ime.add( db.getString(rs,"theime")  );
              subject.add ( db.getString(rs,"thesubject") );
              att = db.getString(rs,"attachment");
              if (att == null || att.equals("null") ){
                attach.add("0");
              }else{
                attach.add("1");
              }
           }//while
        rs.close();

    }catch (java.sql.SQLException e){ e.printStackTrace(System.out); }
  } //getInfo

}//DisplayMessageBean

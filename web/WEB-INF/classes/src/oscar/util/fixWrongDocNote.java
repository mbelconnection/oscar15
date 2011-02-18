/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package oscar.util;
import java.sql.ResultSet;
import java.util.Vector;
import oscar.dms.EDocUtil;
/**
 *
 * @author jackson
 */
public class fixWrongDocNote {
    public static void main(String[] args) {
          Vector vec=  checkWrongDocNote();
          System.out.println("wrong data="+vec);
    }

    public static Vector<String> checkWrongDocNote(){
         //get all documents from ctl_document with status=A
             //for each doc id, get note id from casemgmt_note_link, table_name=5
             //for each note id from this doc id, get demo from casemgmt note table
        System.out.println("in checkWrongDocNote");
        Vector retVal=new Vector();
              try{
                    int countCorruptedNo = 0;
                    ResultSet rs1=EDocUtil.getAllActiveDocs();

                    rs1.beforeFirst();
                    while (rs1.next()) {
                        //System.out.println("as");
                        String module=rs1.getString("module");
                        int moduleId=rs1.getInt("module_id");//document Demo no
                        int docNo=rs1.getInt("document_no");                        
                        ResultSet rs2;
                        rs2=EDocUtil.getAllNotesFromDocId(docNo);
                        while(rs2.next()){
                            int noteId=rs2.getInt("note_id");
                            ResultSet rs3;
                            rs3=EDocUtil.getDemoNoFromNoteId(noteId);
                            while(rs3.next()){
                                int noteDemoNo=rs3.getInt("demographic_no");
                                if(noteDemoNo!=moduleId){
                                    String errorStr="ERROR: doc id="+docNo+",module="+module+", moduleId(demo no)="+moduleId+",noteId="+noteId+",wrong demo no="+noteDemoNo;
                                    System.out.println(errorStr);
                                    retVal.add(errorStr);
                                    countCorruptedNo++;
                                }
                            }
                        }
                    }
                    System.out.println("countCorruptedNo="+countCorruptedNo);

              }catch(Exception e){
                  e.printStackTrace();
              }
        return retVal;
    }
}

package oscar.util;

import java.io.IOException;

import java.util.Properties;
import java.util.Vector;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import oscar.oscarDB.DBHandler;

public class BackupDownload extends GenericDownload {

    private static final String ROLE_BACKUP_ADMIN = "_admin.backup";

    private static final String ROLE_ADMIN = "_admin";

    public BackupDownload() {}

    public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession session = req.getSession(true);

        // check the rights        
        String filename = req.getParameter("filename") == null ? "null" : req.getParameter("filename");
        String dir = (String) session.getAttribute("backupfilepath") == null ? "/home/mysql/" : (String) session
                .getAttribute("backupfilepath");
        
        boolean adminPrivs = false;

        String roleName = (String)req.getSession().getAttribute("userrole") + "," + (String) req.getSession().getAttribute("user");
        Vector v = getPrivilegeProp("_admin.backup,_admin");
        if (checkPrivilege(roleName, (Properties) v.get(0), (Vector) v.get(1))){
            adminPrivs = true;
        }

        boolean bDownload = false;
        if (filename != null && adminPrivs) {
            bDownload = true;
        }
        download(bDownload, res, dir, filename, null);
    }

    //TODO: Refactor this out of the security tag.
    private String rights = "r";
    private Vector getPrivilegeProp(String objName) {
        Vector ret = new Vector();
        Properties prop = new Properties();
        try {
            DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
            java.sql.ResultSet rs;
            String [] objectNames  = getVecObjectName(objName);
            StringBuffer objectWhere = new StringBuffer();
            for (int i = 0; i < objectNames.length; i++){
                if (i < (objectNames.length - 1)){
                   objectWhere.append(" objectName = '"+objectNames[i]+"' or ");
                }else{
                   objectWhere.append(" objectName = '"+objectNames[i]+"'  ");
                }
            }

            String sql = new String("select roleUserGroup,privilege from secObjPrivilege where "+ objectWhere.toString() +" order by priority desc");
            ////System.out.println("sql for roles: "+sql );
            rs = db.GetSQL(sql);
            Vector roleInObj = new Vector();
            while (rs.next()) {
                prop.setProperty(db.getString(rs,"roleUserGroup"), db.getString(rs,"privilege"));
                roleInObj.add(db.getString(rs,"roleUserGroup"));
            }
            ret.add(prop);
            ret.add(roleInObj);
            //System.out.println(roleInObj);
            rs.close();
            db.CloseConn();
        } catch (java.sql.SQLException e) {
            e.printStackTrace(System.out);
        }
        return ret;
    }
    
    
    
    private Properties getVecRole(String roleName) {
        Properties prop = new Properties();
        String[] temp = roleName.split("\\,");
        for (int i = 0; i < temp.length; i++) {
            prop.setProperty(temp[i], "1");
        }
        return prop;
    }
    
    private String[] getVecObjectName(String objectName) {
        String[] temp = objectName.split("\\,");
        return temp;
    }
    

    private Vector getVecPrivilege(String privilege) {
        Vector vec = new Vector();
        String[] temp = privilege.split("\\|");
        for (int i = 0; i < temp.length; i++) {
            if ("".equals(temp[i]))
                continue;
            vec.add(temp[i]);
        }
        return vec;
    }

    private boolean checkPrivilege(String roleName, Properties propPrivilege, Vector roleInObj) {
        boolean ret = false;
        Properties propRoleName = getVecRole(roleName);
        for (int i = 0; i < roleInObj.size(); i++) {
            if (!propRoleName.containsKey(roleInObj.get(i)))
                continue;

            String singleRoleName = (String) roleInObj.get(i);
            String strPrivilege = propPrivilege.getProperty(singleRoleName, "");
            Vector vecPrivilName = getVecPrivilege(strPrivilege);

            boolean[] check = { false, false };
            for (int j = 0; j < vecPrivilName.size(); j++) {
                //System.out.println("role: " + singleRoleName + " privilege:" +
                // vecPrivilName.get(j));
                check = checkRights((String) vecPrivilName.get(j), rights);
                //System.out.println("check: " + check);
                if (check[0]) { // get the rights, stop comparing
                    return true;
                }
                if (check[1]) { // get the only rights, stop and return the result
                    return check[0];
                }
            }
        }
        return ret;
    }

    private boolean[] checkRights(String privilege, String rights1) {
        boolean[] ret = { false, false }; // (gotRights, break/continue)

        if ("x".equals(privilege)) {
            ret[0] = true;
        } else if (privilege.compareTo(rights1.toLowerCase()) >=0) {
            ret[0] = true;
        }
        return ret;
    }
}
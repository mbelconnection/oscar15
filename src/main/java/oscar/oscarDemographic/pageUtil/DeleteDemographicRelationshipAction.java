/*
 *  Copyright (c) 2001-2002. Department of Family Medicine, McMaster University. All Rights Reserved. *
 *  This software is published under the GPL GNU General Public License.
 *  This program is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU General Public License
 *  as published by the Free Software Foundation; either version 2
 *  of the License, or (at your option) any later version. *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *  GNU General Public License for more details. * * You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. *
 *
 *  Jason Gallagher
 *
 *  This software was written for the
 *  Department of Family Medicine
 *  McMaster University
 *  Hamilton
 *  Ontario, Canada   
 *
 * DeleteDemographicRelationshipAction.java
 *
 * Created on January 11, 2006, 6:34 PM
 *
 */

package oscar.oscarDemographic.pageUtil;

import java.util.ArrayList;
import java.util.Hashtable;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import oscar.log.LogAction;
import oscar.log.LogConst;
import oscar.oscarDemographic.data.DemographicRelationship;

/**
 *
 * @author jay
 */
public class DeleteDemographicRelationshipAction extends Action {
    
    /** Creates a new instance of DeleteDemographicRelationshipAction */
    public DeleteDemographicRelationshipAction() {
    }
    
    public ActionForward execute(ActionMapping mapping,ActionForm form,HttpServletRequest request,HttpServletResponse response) {
      String origDemo = request.getParameter("origDemo");
      String id = request.getParameter("id");
      String idRel = getRelationID(id);
      
      DemographicRelationship demo = new DemographicRelationship();
      demo.deleteDemographicRelationship(id);
      demo.deleteDemographicRelationship(idRel);
      
      String ip = request.getRemoteAddr();
      LogAction.addLog( (String) request.getSession().getAttribute("user"), LogConst.DELETE, LogConst.CON_DEMOGRAPHIC_RELATION, id, ip);
      request.setAttribute("demo", origDemo);                   
      return mapping.findForward("success");
   }
    
    String getRelationID(String id) {
	String relationID = "";
	DemographicRelationship demo = new DemographicRelationship();
	ArrayList dr = demo.getDemographicRelationshipsByID(id);
	for (int i=0; i<dr.size(); i++) {
	    Hashtable h = (Hashtable) dr.get(i);
	    String demo_no = (String) h.get("demographic_no");
	    String demo_r  = (String) h.get("relation_demographic_no");
	    String rel     = (String) h.get("relation");
	    String[] relOf = getRelationOf(rel);
	    
	    relationID = getRelationshipID(demo_r, demo_no, relOf);
	}
	return relationID;
    }
    
    String getRelationshipID(String demo_no, String demo_r, String[] rel_of) {
	String relationshipID = "";
	DemographicRelationship demo = new DemographicRelationship();
	ArrayList dr = demo.getDemographicRelationships(demo_no);
	for (int i=0; i<dr.size(); i++) {
	    Hashtable h = (Hashtable) dr.get(i);
	    String demoRel = (String) h.get("demographic_no");
	    if (demo_r.trim().equalsIgnoreCase(demoRel.trim())) {
		String rel = (String) h.get("relation");
		boolean matched = false;
		if(rel_of!=null){
		  for (int j=0; j<rel_of.length; j++) {
		    if (rel.trim().equalsIgnoreCase(rel_of[j])) matched = true;
		  }
		}  
		if (matched) {
		    relationshipID = (String) h.get("id");
		    i = dr.size();
		}
	    }
	}
	return relationshipID;
    }
    
    String[] getRelationOf(String relation) {
	relation = relation.trim().toLowerCase();
	String[] relationOf = new String[3];
	
	if (relation.equals("child") || relation.equals("son") || relation.equals("daughter")) {
	    relationOf[0] = "father";
	    relationOf[1] = "mother";
	    relationOf[2] = "parent";
	} else if (relation.equals("spouse") || relation.equals("husband") || relation.equals("wife")) {
	    relationOf[0] = "husband";
	    relationOf[1] = "wife";
	    relationOf[2] = "spouse";
	} else if (relation.equals("sibling") || relation.equals("brother") || relation.equals("sister")) {
	    relationOf[0] = "brother";
	    relationOf[1] = "sister";
	    relationOf[2] = "sibling";
	} else if (relation.equals("parent") || relation.equals("father") || relation.equals("mother")) {
	    relationOf[0] = "son";
	    relationOf[1] = "daughter";
	    relationOf[2] = "child";
	} else if (relation.equals("partner")) {
	    relationOf[0] = "partner";
	    relationOf[1] = "partner";
	    relationOf[2] = "partner";
	} else {
	    relationOf = null;
	}
	return relationOf;
    }
}

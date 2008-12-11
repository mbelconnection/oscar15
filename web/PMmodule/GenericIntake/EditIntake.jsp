<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="java.util.*,org.oscarehr.PMmodule.dao.*,org.oscarehr.PMmodule.service.*,org.oscarehr.PMmodule.model.*,org.springframework.web.context.support.*,org.springframework.web.context.*" %>
<%@ taglib uri="/WEB-INF/caisi-tag.tld" prefix="caisi" %>
<%@ include file="/taglibs.jsp" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Edit Intake</title>
        <script type="text/javascript">
            function add(id,nodeTemplateId,parentId,pos,psize){
               var eURL = "AddToIntake.jsp?id="+id+"&node="+nodeTemplateId+"&parentId="+parentId+"&pos="+pos+"&pSize="+psize;
               popup('230','330',eURL,'intakeAdd');
            }
            
            function del(id, pid){
	       var ans = confirm("Delete this node (and all its children) ?");
	       if (ans) {
		   var eURL = "DeleteIntake.jsp?id="+id+"&parentId="+pid;
		   popup('200','300',eURL,'intakeDel');
	       }
            }
            
            function editlabel(id){
               var eURL = "EditLabel.jsp?id="+id;
               popup('200','300',eURL,'lbledit');
            }
            
            function reorder(id){
               var eURL = "ReorderNode.jsp?id="+id;
               popup('300','400',eURL,'rodrnode');
            }
            
            function saveform(published){
               var eURL = "SaveForm.jsp";
               if (published) {
                  eURL += "?published=1";
               }
               popup('200','300',eURL,'sveform');
            }
	    
	    function resetform(){
               var eURL = "ResetForm.jsp";
               popup('200','300',eURL,'rstform');
            }

        </script>
        <style type="text/css">
            @import "<html:rewrite page="/css/genericIntake.css"/>";
        </style>
        <script language="javascript" type="text/javascript" src="<html:rewrite page="/share/javascript/Oscar.js"/>" ></script>
        <script type="text/javascript">
        <!--
        var djConfig = {
            isDebug: false,
            parseWidgets: false,
            searchIds: ["layoutContainer", "topPane", "clientPane", "bottomPane", "clientTable", "admissionsTable"]
        };

        var programMaleOnly =[];
        var programFemaleOnly =[];
        var programTransgenderOnly =[];

	

        // -->

        function openSurvey(ctl) {
            var formId = ctl.options[ctl.selectedIndex].value;
            if (formId == 0) {
                return;
            }
            var id = document.getElementById('formInstanceId').value;
            var url = '<html:rewrite action="/PMmodule/Forms/SurveyExecute.do"/>?method=survey&type=provider&formId=' + formId + '&formInstanceId=' + id + '&clientId=' + 10;
            ctl.selectedIndex = 0;
            popupPage(url);
        }

        function popupPage(varpage) {
            var page = "" + varpage;
            windowprops = "height=600,width=700,location=no,"
                    + "scrollbars=yes,menubars=no,toolbars=no,resizable=yes,top=0,left=0";
            window.open(page, "", windowprops);
        }
        </script>
        
        <script type="text/javascript" src="<html:rewrite page="/dojoAjax/dojo.js"/>"></script>
        <script type="text/javascript" src="<html:rewrite page="/js/AlphaTextBox.js"/>"></script>
        <script type="text/javascript">
        <!--
        dojo.require("dojo.widget.*");
        dojo.require("dojo.validate.*");
        // -->
        </script>
        <script type="text/javascript" src="<html:rewrite page="/js/genericIntake.js.jsp" />"></script>
        <script type="text/javascript" src="<html:rewrite page="/js/checkDate.js"/>"></script>
        
        
    </head>
    <body>
        <form>
        <%
        
        WebApplicationContext  ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(getServletContext());
        GenericIntakeManager  genericIntakeManager =  (GenericIntakeManager) ctx.getBean("genericIntakeManager");
        
        String id = request.getParameter("id");
        if (id == null){ id = "41333";};
        int iNum = Integer.parseInt(id);
	
        List<IntakeNode> lis = genericIntakeManager.getIntakeNodes();
        if (lis != null){ %>
        <script>
			function change_form(value) {
				location.href='EditIntake.jsp?id=' + value;
			}
        </script>
	<select onchange="change_form(this.options[this.selectedIndex].value)">
                    <% for (IntakeNode i : lis) {
			   String frmLabel = i.getForm_version()!=null ? i.getLabelStr()+" ("+i.getForm_version()+")" : i.getLabelStr();
			   if (i.getPublish_date()!=null) frmLabel += " PUBLISHED " +i.getPublishDateStr()+ " BY " +i.getPublish_by();
			   %>
	    <option <%=i.getId()==iNum?"selected":""%> value="<%=i.getId()%>"><%=frmLabel%></option>
                    <% } %>
	</select>
	<%}
	if (session.getAttribute("publisher")==null) session.setAttribute("publisher", request.getParameter("pub"));
	
	IntakeNode iNode = (IntakeNode) session.getAttribute("intakeNode");
        if (iNode==null || !iNode.getId().equals(iNum)) iNode = genericIntakeManager.getIntakeNode(iNum);
        
	session.setAttribute("form_version", getFrmVersion(iNode.getLabelStr(), lis));
	
        goRunner(iNode,out);
        session.setAttribute("intakeNode", iNode);
	
	out.write("<p>&nbsp;</p>");
	out.write(" <input type=\"button\" value=\"Save Form\" onclick=\"saveform(publish.checked);\" />");
        out.write(" <input type=\"checkbox\" name=\"publish\">Publish this as the Registration Intake</input>");
        out.write("<br>");
	out.write(" <input type=\"button\" value=\"Reset\" onclick=\"resetform();\" />");
        out.write("<p>&nbsp;</p>");
        out.write(" <input type=\"button\" value=\"Close\" onclick=\"window.close();\" />");
        %>
        </form>
    </body>
</html>

<%!

void  goRunner(IntakeNode in,JspWriter out) throws Exception{
//String ret = in.getLabelStr()+ " : "+ in.getId()+" <br/>";
	if(in == null) {
		System.out.println("in is null");		
	}
    IntakeNode pIntake = in.getParent();
    IntakeNode node = in;
    String pId = "";
    if (pIntake != null){
        pId = ""+pIntake.getId();
    }
    
    
    String si = ""+in.getChildren().size();
    System.out.println(node.getId()+" : "+si);
    
    boolean hasChildren = false;
    
    if (in.getChildren() != null && in.getChildren().size() > 1){
        hasChildren = true;
    }
    
    if (in.getId().equals(1) || in.getId().equals(2)) {
	in.setLabel(in.getNodeTemplate().getLabel());
    }
    String labelId = "";
    if (in.getLabel() != null){
        labelId = ""+in.getLabel().getId();
    }
    String exitElement = "</blockquote>";
    
    if (node.isIntake()) {
        out.write("<h1>");
        out.write(in.getLabelStr());
//out.write("id:"+in.getId() + ":"+in.getLabelStr()+ " : "+in.getNodeTemplate().getId()+" x:"+in.getIndex()+" "+in.getType()+" "+pId+" ");
        out.write(" <a href=\"javascript: void(0);\" onclick=\"add('"+in.getId()+"','1','"+pId+"','"+in.getIndex()+"','"+si+"');\">+</a>");
        out.write(" <a href=\"javascript: void(0);\" onclick=\"editlabel('"+labelId+"');\">[edit]</a>");
        if(hasChildren){
            out.write(" <a href=\"javascript: void(0);\" onclick=\"reorder('"+in.getId()+"');\">[reorder children]</a>");
        }
        out.write("</h1>");
        exitElement = "";
        
    } else if (node.isPage()) {
        out.write("<blockquote>");
        out.write(in.getLabelStr());
//out.write("id:"+in.getId() + ":"+in.getLabelStr()+ " : "+in.getNodeTemplate().getId()+" x:"+in.getIndex()+" "+in.getType()+" "+pId+" ");
        out.write(" <a href=\"javascript: void(0);\" onclick=\"add('"+in.getId()+"','"+in.getNodeTemplate().getId()+"','"+pId+"','"+in.getIndex()+"','"+si+"');\">+</a>");
        out.write(" <a href=\"javascript: void(0);\" onclick=\"editlabel('"+labelId+"');\">[edit]</a>");
    } else if (node.isSection()) {
        out.write("<div  style=\"border:1px solid #84A3D1;\">");
        out.write("<h3 style=\"background:#85AEEC ; border:1px solid #84A3D1; color:#000000;  font-size:12px; font-weight:bold; margin-top: 0;\">");
        out.write(in.getLabelStr());
//out.write("id:"+in.getId() + ":"+in.getLabelStr()+ " : "+in.getNodeTemplate().getId()+" x:"+in.getIndex()+" "+in.getType()+" "+pId+" ");
        out.write(" <a href=\"javascript: void(0);\" onclick=\"add('"+in.getId()+"','4','"+pId+"','"+in.getIndex()+"','"+si+"');\">+</a>");
	out.write(" <a href=\"javascript: void(0);\" onclick=\"del('"+in.getId()+"','"+pId+"');\">-</a>");
        out.write(" <a href=\"javascript: void(0);\" onclick=\"editlabel('"+labelId+"');\">[edit]</a>");
        if(hasChildren){
            out.write(" <a href=\"javascript: void(0);\" onclick=\"reorder('"+in.getId()+"');\">[reorder children]</a>");
        }
        
        out.write("</h3>");
        exitElement = "</div>";
    } else if (node.isQuestion()) {
        out.write("<blockquote>");
        out.write("<h3 style=\"background:grey ; border:1px solid grey; color:#000000;  font-size:12px; font-weight:bold; margin-top: 0;\">");
        out.write(in.getLabelStr());
	if (in.getMandatory()) {
	    out.write("<font color=red>*</font>");
	}
//out.write("id:"+in.getId() + ":"+in.getLabelStr()+ " : "+in.getNodeTemplate().getId()+" x:"+in.getIndex()+" "+in.getType()+" "+pId+" ");
        out.write(" <a href=\"javascript: void(0);\" onclick=\"add('"+in.getId()+"','5','"+pId+"','"+in.getIndex()+"','"+si+"');\">+</a>");
	out.write(" <a href=\"javascript: void(0);\" onclick=\"del('"+in.getId()+"','"+pId+"');\">-</a>");
        out.write(" <a href=\"javascript: void(0);\" onclick=\"editlabel('"+labelId+"');\">[edit]</a>");
        if(hasChildren){
            out.write(" <a href=\"javascript: void(0);\" onclick=\"reorder('"+in.getId()+"');\">[reorder children]</a>");
        }
	if (in.getEq_to_id()==null || in.getEq_to_id()<0) {
	    out.write(" <font color=red>(new)</font>");
	}
        out.write("</h3>");
    } else if (node.isAnswerCompound()) {
        out.write("<div  style=\"border:1px solid blue;\">");
        out.write("<h3 style=\" border:1px solid #84A3D1; color:#000000;  font-size:12px; font-weight:bold; margin-top: 0;\">");
        out.write("Inline group of questions :"+in.getLabelStr());
	if (in.getMandatory()) {
	    out.write("<font color=red>*</font>");
	}
//out.write("+ answer scalar choice + answer scalar text + answer scalar note")
//out.write("id:"+in.getId() + ":"+in.getLabelStr()+ " : "+in.getNodeTemplate().getId()+" x:"+in.getIndex()+" "+in.getType()+" "+pId+" ");
        out.write(" <a href=\"javascript: void(0);\" onclick=\"add('"+in.getId()+"','6','"+pId+"','"+in.getIndex()+"','"+si+"');\">+</a>");
	out.write(" <a href=\"javascript: void(0);\" onclick=\"del('"+in.getId()+"','"+pId+"');\">-</a>");
        out.write(" <a href=\"javascript: void(0);\" onclick=\"editlabel('"+labelId+"');\">[edit]</a>");
        if(hasChildren){
            out.write(" <a href=\"javascript: void(0);\" onclick=\"reorder('"+in.getId()+"');\">[reorder children]</a>");
        }
        out.write("</h3>");
        exitElement = "</div>";
    } else if (node.isAnswerChoice()) {
	if (node.isAnswerBoolean()) {
	    out.write("<blockquote>");
	    out.write("<label><input type=\"checkbox\"/>"+in.getLabelStr()+ "</label>");
	    out.write(" <a href=\"javascript: void(0);\" onclick=\"del('"+in.getId()+"','"+pId+"');\">-</a>");
	    out.write(" <a href=\"javascript: void(0);\" onclick=\"editlabel('"+labelId+"');\">[edit]</a>");
        } else {
	    Set intakeAnswerElements = in.getNodeTemplate().getAnswerElements();
	    Object[] elements = intakeAnswerElements.toArray();
	    
	    out.write("<blockquote>");
	    out.write("<label>"+in.getLabelStr()+" <select>");
	    for (int i=0; i<elements.length; i++) {
		IntakeAnswerElement answerElement = (IntakeAnswerElement) elements[i];
		out.write("<option>"+answerElement.getElement()+"</option>");
	    }
	    out.write("</select></label>");
	    out.write(" <a href=\"javascript: void(0);\" onclick=\"del('"+in.getId()+"','"+pId+"');\">-</a>");
	    out.write(" <a href=\"javascript: void(0);\" onclick=\"editlabel('"+labelId+"');\">[edit]</a>");
	}
	if (in.getEq_to_id()==null || in.getEq_to_id()<0) {
	    out.write(" <font color=red>(new)</font>");
	}
//out.write("id:"+in.getId() + ":"+in.getLabelStr()+ " : "+in.getNodeTemplate().getId()+" x:"+in.getIndex()+" "+in.getType()+" "+pId+" ");
//out.write(" <a href=\"javascript: void(0);\" onclick=\"add('"+in.getId()+"','"+in.getNodeTemplate().getId()+"','"+pId+"','"+in.getIndex()+"','"+si+"');\">+</a>");
        
    } else if (node.isAnswerText()) {
        out.write("<blockquote>");
        out.write("<label>"+in.getLabelStr()+ "<input type=\"text\"  /> </label>");
	out.write(" <a href=\"javascript: void(0);\" onclick=\"del('"+in.getId()+"','"+pId+"');\">-</a>");
        out.write(" <a href=\"javascript: void(0);\" onclick=\"editlabel('"+labelId+"');\">[edit]</a>");
	if (in.getEq_to_id()==null || in.getEq_to_id()<0) {
	    out.write(" <font color=red>(new)</font>");
	}
        
//out.write("id:"+in.getId() + ":"+in.getLabelStr()+ " : "+in.getNodeTemplate().getId()+" x:"+in.getIndex()+" "+in.getType()+" "+pId+" ");
//out.write(" <a href=\"javascript: void(0);\" onclick=\"add('"+in.getId()+"','"+in.getNodeTemplate().getId()+"','"+pId+"','"+in.getIndex()+"','"+si+"');\">+</a>");
        
    } else if (node.isAnswerNote()) {
        out.write("<blockquote>");
        out.write(in.getLabelStr()+"<textarea rows=\"5\" cols=\"50\"></textarea>");
//out.write("id:"+in.getId() + ":"+in.getLabelStr()+ " : "+in.getNodeTemplate().getId()+" x:"+in.getIndex()+" "+in.getType()+" "+pId+" ");
//out.write(" <a href=\"javascript: void(0);\" onclick=\"add('"+in.getId()+"','"+in.getNodeTemplate().getId()+"','"+pId+"','"+in.getIndex()+"','"+si+"');\">+</a>");
	out.write(" <a href=\"javascript: void(0);\" onclick=\"del('"+in.getId()+"','"+pId+"');\">-</a>");
        out.write(" <a href=\"javascript: void(0);\" onclick=\"editlabel('"+labelId+"');\">[edit]</a>");
	if (in.getEq_to_id()==null || in.getEq_to_id()<0) {
	    out.write(" <font color=red>(new)</font>");
	}
    } else {
        throw new IllegalStateException("No html adapter for type: " + node.getType());
    }
    
    for (IntakeNode iN : in.getChildren()){

    	if(iN == null) {
    		System.out.println("iN is null");
    		//continue;
    	}

        goRunner(iN,out);
    }
    
    out.write(exitElement);
}

int getFrmVersion(String frmLabel, List<IntakeNode> iList) {
    int n=1;
    for (int i=0; i<iList.size(); i++) {
	String iLabel = iList.get(i).getLabelStr().trim();
	if (iLabel.equals(frmLabel.trim())) n++;
    }
    return n;
}

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ include file="/taglibs.jsp" %>
<html>
<head>
<link rel="shortcut icon" href="images/favicon.ico" type="image/x-icon" />
<link rel="stylesheet" href="../theme/Master.css" type="text/css">
<title>PrintPreview</title>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="GENERATOR" content="Rational Application Developer">
<link rel="stylesheet" type="text/css" media="all" href="theme.css" />


</head>
<html-el:form action="/PMmodule/PrintView.do">
	<input type="hidden" name="rId">
<input type="hidden" name="token" value="<c:out value="${sessionScope.token}"/>" /></html-el:form>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.*"%>

<%@ taglib prefix="s" uri="/struts-tags"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>

  <head>
    
    <title>复旦天翼缴费平台</title>
	
	<!--jquery的js类库  -->
	<script type="text/javascript" src="../dwr/engine.js"></script>
	<script type="text/javascript" src="../dwr/util.js"></script>
	<script type="text/javascript" src="../dwr/interface/ScanHandle.js"></script>
	
		<style type="text/css">
		
		body {
			margin-left: 0px;
			margin-top: 0px;
			margin-right: 0px;
			margin-bottom: 0px;
		}
		
		.style2 {
			font-size: 16px;
			font-weight: bold;
			font-family: "微软雅黑";
			margin:10px;
		}
		</style>
		
  </head>
  
  <jsp:include page="top.jsp"/>
  
  <script type="text/javascript" src="../js/mobilePay/jquery.min.js"></script>
	<script type="text/javascript" src="../js/mobilePay/jquery.qrcode.min.js"></script>
  <script type="text/javascript">
			$(function(){
				$("#code_url").qrcode({ 
				    render: "table",
				    text: "<%=request.getAttribute("weixin_code_url") %>"
				});
				dwr.engine.setActiveReverseAjax(true);
				ScanHandle.addBillSession('<%=request.getAttribute("billno") %>');
			});
			
			function toSuccess(url){
				window.location.href = url;
			}
			
			var bankSettle = function(){
			var billno='<%=request.getAttribute("billno") %>';
			var over = false;
			var hour = document.getElementById("hour");
			var second = document.getElementById("second");
			if(second=="00"){
				hour.innerHTML = hour-1;
				second.innerHTML = 60;
			}
			second.innerHTML = second-1;
			if(second-1<10){
				second.innerHTML = '0'+second-1;
			}
			if(second=="00"&&hour=="00"){
				document.getElementById("hour").style.color="red";
				document.getElementById("second").style.color="red";
				document.getElementById("maohao").style.color="red";
			}
			$.ajax({
				type: "POST",
				async: false,
				data:{billno:billno},
				url: "weixinBankSettle.action",
				success:function(data){
					if(data=="true"){
						over = true;
					}
				}
			});
        
			if(!over){
				setTimeout("bankSettle()",1000);
			}
    };
  </script>
<body bgcolor="#FFFFFF" onLoad="bankSettle();">
  				<table width="100%" border="0" cellpadding="0" cellspacing="0">
				 <tr height="100%">
			    <td align="center" valign="middle"><table width="80%" border="0" cellpadding="0" cellspacing="0" style="margin:10px; "> 
			      <tr align="center">
			        <td bgcolor="#FFFFFF"></td>
					<%
						SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");//格式化输出日期
						Date now = new Date();
						Long second = 900L;
						System.out.println("提示时间是:" + second);
						long time = second*1000;//60秒
						Date afterDate = new Date(now.getTime() + time);//60秒后的时间
						String locktime = sdf.format(afterDate);
					%>
			        <td rowspan="4" bgcolor="#FFFFFF"><img src="3.jpg" width="321" height="410"></td>
			      </tr>
			      <tr align="center">
			        <td align="left" bgcolor="#FFFFFF">
					<span class="style2">微信支付</span>
					<br/>
					<span style="font-size:20px;color:red;padding-left:70px;">请在<%=locktime %>之前缴费。</span>
					<span id="hour" style="font-size:20px;color:blue;">15</span>
					<span id="maohao" style="font-size:20px;color:blue;">:</span>
					<span id="second" style="font-size:20px;color:blue;">00</span>
					</td>
			      </tr>
			      <tr align="center">
			        <td bgcolor="#FFFFFF"><div style="padding-top:20px" id="code_url"></div></td>
			      </tr>
			      <tr align="center">
			        <td bgcolor="#FFFFFF"><img src="2.jpg" width="306" height="68"></td>
			        </tr>
			    </table></td></tr>
				</table>
  	
  </body>
</html>

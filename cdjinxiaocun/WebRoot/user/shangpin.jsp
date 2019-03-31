<%@ page language="java" contentType="text/html; charset=utf-8"  import="com.model.User"  pageEncoding="utf-8"%>
   
<%
	// 权限验证
	User user = (User)session.getAttribute("user");
	if(user==null){
		System.out.println("没有得到zhaopinId");
		response.sendRedirect("index.jsp");
		return;
	}
	String userXingming = user.getUserXingming();
	int userId = user.getUserId();
	String userPassword = user.getUserPassword();
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>商品信息管理</title>
<link rel="stylesheet" type="text/css" href="../jquery-easyui-1.3.3/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="../jquery-easyui-1.3.3/themes/icon.css">
<script type="text/javascript" src="../jquery-easyui-1.3.3/jquery.min.js"></script>
<script type="text/javascript" src="../jquery-easyui-1.3.3/jquery.easyui.min.js"></script>
<script type="text/javascript" src="../jquery-easyui-1.3.3/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript">
var url;
var userId = <%=userId%>;
	function searchShangpin(){
		$('#dg').datagrid('load',{
			shangpinName:$('#s_shangpinName').val(),
			sptypeId:$('#s_sptypeId').combobox("getValue"),
			sdate:$('#s_sdate').datebox("getValue"),
			edate:$('#s_edate').datebox("getValue")
		});
	}
	
	function saveShangpin(){
		$("#fm").form("submit",{
			url:url,
			onSubmit:function(){
				return $(this).form("validate");
			},
			success:function(result){
			
				var s=result;
				var result = eval('(' + result + ')');
			
				if(result.errorMsg){
					$.messager.alert("系统提示",result.errorMsg);
					return;
				}else{
					$.messager.alert("系统提示","保存成功");
					resetValue();
					$("#dlg").dialog("close");
					$("#dg").datagrid("reload");
				}
			}
		});
	}
	
	function openShangpinAddDialog(){
		$("#dlg").dialog("open").dialog("setTitle","添加商品信息");
		url="../addShangpin?userId="+userId;
	}
	
	function resetValue(){
	}
	
	function deleteShangpin(){
		var selectedRows=$("#dg").datagrid('getSelections');
		if(selectedRows.length==0){
			$.messager.alert("系统提示","请选择要删除的数据！");
			return;
		}
		var strIds=[];
		for(var i=0;i<selectedRows.length;i++){
			strIds.push(selectedRows[i].shangpinId);
		}
		var ids=strIds.join(",");
		$.messager.confirm("系统提示","您确认要删掉这<font color=red>"+selectedRows.length+"</font>条数据吗？",function(r){
			if(r){
				$.post("../deleteShangpin",{delIds:ids},function(result){
					if(result.success){
						$.messager.alert("系统提示","您已成功删除<font color=red>"+result.delNums+"</font>条数据！");
						$("#dg").datagrid("reload");
					}else{
						$.messager.alert('系统提示','<font color=red>'+selectedRows[result.errorIndex].shangpinName+'</font>'+result.errorMsg);
					}
				},"json");
			}
		});
	}
	
	function closeShangpinDialog(){
		$("#dlg").dialog("close");
		resetValue();
	}
	
	function openShangpinModifyDialog(){
		var selectedRows=$("#dg").datagrid('getSelections');
		if(selectedRows.length!=1){
			$.messager.alert("系统提示","请选择一条要编辑的数据！");
			return;
		}
		var row=selectedRows[0];
		$("#dlg").dialog("open").dialog("setTitle","编辑商品信息");
		$("#fm").form("load",row);
		url="../addShangpin?shangpinId="+row.shangpinId;
	}
	
	function formatSex(shujuSex, row) {  
		if(shujuSex==0){
			return "男";
		}
		if(shujuSex==1){
			return "女";
		}
	}
	
	function formatType1(shujuType1, row) {  
		if(shujuType1==0){
			return "零";
		}
		if(shujuType1==1){
			return "一";
		}
	}
	
	function formatType(shujuType, row) {  
		if(shujuType==0){
			return "提交";
		}
		if(shujuType==1){
			return "通过";
		}
		if(shujuType==2){
			return "拒绝";
		}
	}
	
	function formatChakan(shujuImg, row) {
		if(shujuImg){
			return '<a target="_blank" style="color:red;" href="../' + shujuImg + '">查看' + '</a>'; 
		}else {
			return "未上传";
		}
	}
	
	function formatXiazai(shujuImgName, row) {
		if(shujuImgName){
			return '<a target="_blank" style="color:red;" href="../downFile?filename=' + shujuImgName + '">下载' + '</a>'; 
		}else {
			return "未上传";
		}
	}
	
	function daochuShangpin(){
		var selectedRows=$("#dg").datagrid('getSelections');
		if(selectedRows.length==0){
			$.messager.alert("系统提示","请选择要导出的数据！");
			return;
		}
		var shangpinIds=[];
		for(var i=0;i<selectedRows.length;i++){
			shangpinIds.push(selectedRows[i].shangpinId);
		}
		var ids=shangpinIds.join(",");
		$.messager.confirm("系统提示","您确认要导出数据吗？",function(r){
			if(r){
				$.post("../daochuShangpin",{delIds:ids},function(result){
					if(result.success){
						$.messager.alert("系统提示","您已成功导出数据：D:！");
						$("#dg").datagrid("reload");
					}else{
						$.messager.alert('系统提示','<font color=red>'+selectedRows[result.errorIndex].shangpinName+'</font>'+result.errorMsg);
					}
				},"json");
			}
		});
	}
	
	function datetostr(dateTime, row) {
		if(dateTime){
			var JsonDateValue = new Date(dateTime.time);
			var text = JsonDateValue.toLocaleString();
			return text;
		}else{
			return "未填写";
		}
	}
	
	function doPrint() {      
        bdhtml=window.document.body.innerHTML;      
        sprnstr="<!--startprint-->";      
        eprnstr="<!--endprint-->";      
        prnhtml=bdhtml.substr(bdhtml.indexOf(sprnstr)+17);      
        prnhtml=prnhtml.substring(0,prnhtml.indexOf(eprnstr));      
        window.document.body.innerHTML=prnhtml;   
        window.print();      
	}
	
	function daoruShangpins(){
		$("#daoru").dialog("open").dialog("setTitle","导入商品信息");
		daoruurl="../daoruShangpin";
	}
	
	function closeDaoruShangpin(){
		$("#daoru").dialog("close");
		resetValue();
	}
	
	function saveDaoruShangpin(){
		$("#drfm").form("submit",{
			url:daoruurl,
			onSubmit:function(){
				return $(this).form("validate");
			},
			success:function(result){
			
				if(result.errorMsg){
					$.messager.alert("系统提示",result.errorMsg);
					return;
				}else{
					$.messager.alert("系统提示","保存成功");
					resetValue();
					$("#daoru").dialog("close");
					$("#dg").datagrid("reload");
				}
			}
		});
	}
	
	function shangchuanShangpin(){
		var selectedRows=$("#dg").datagrid('getSelections');
		if(selectedRows.length!=1){
			$.messager.alert("系统提示","请选择一条要编辑的数据！");
			return;
		}
		var row=selectedRows[0];
		$("#shangchuan").dialog("open").dialog("setTitle","上传商品信息");
		$("#shchfm").form("load",row);
		shchurl="../shangchuanShangpin?shangpinId="+row.shangpinId;
	}
	
	function closeShangchuanShangpin(){
		$("#shangchuan").dialog("close");
		resetValue();
	}
	
	function saveShangchuanShangpin(){
		$("#shchfm").form("submit",{
			url:shchurl,
			onSubmit:function(){
				return $(this).form("validate");
			},
			success:function(result){
			
				var s=result;
				var result = eval('(' + result + ')');
			
				if(result.errorMsg){
					$.messager.alert("系统提示",result.errorMsg);
					return;
				}else{
					$.messager.alert("系统提示","保存成功");
					resetValue();
					$("#shangchuan").dialog("close");
					$("#dg").datagrid("reload");
				}
			}
		});
	}
</script>
</head>
<body style="margin: 5px;">
<!--startprint-->
	<table id="dg" title="商品信息" class="easyui-datagrid" fitColumns="true"
	 pagination="true" url="../getShangpins" fit="true" toolbar="#tb">
		<thead>
			<tr>
				<th field="cb" checkbox="true"></th>
				<th field="shangpinId" width="20">编号</th>
				<th field="shangpinName" width="40">名称</th>
				<th field="shangpinMark" width="40">厂家</th>
				<th field="shangpinType1" width="20">预警</th>
				<th field="shangpinZong" width="20">总数</th>
				<th field="shangpinJin" width="20">总进</th>
				<th field="shangpinXiao" width="20">总销</th>
				<th field="sptypeId" width="20" hidden="true">类型ID</th>
				<th field="sptypeName" width="40">类型</th>
				<th field="shangpinImg" width="20" formatter="formatChakan">图片</th>
				<th field="shangpinDate" width="40" formatter="datetostr">时间</th>
			</tr>
		</thead>
	</table>
	
	<div id="tb">
		<div>
		&nbsp;名称：&nbsp;<input type="text" name="s_shangpinName" id="s_shangpinName" size="10"/>
		&nbsp;时间：&nbsp;<input class="easyui-datebox" name="s_sdate" id="s_sdate" editable="false" size="10"/>->
		<input class="easyui-datebox" name="s_edate" id="s_edate" editable="false" size="10"/>
		&nbsp;类型：&nbsp;<input class="easyui-combobox" id="s_sptypeId" name="s_sptypeId"  data-options="panelHeight:'auto',editable:false,valueField:'sptypeId',textField:'sptypeName',url:'../sptypeComboList'"/>
		<a href="javascript:searchShangpin()" class="easyui-linkbutton" iconCls="icon-search" plain="true">搜索</a>
		</div>
	</div>
<!--endprint-->
	<div id="dlg" class="easyui-dialog" style="width: 540px;height: 300px;padding: 10px 20px"
		closed="true" buttons="#dlg-buttons">
		<form id="fm" method="post">
			<table cellspacing="5px;">
				<tr>
					<td>名称：</td>
					<td><input type="text" name="shangpinName" id="shangpinName" class="easyui-validatebox" required="true"/></td>
					<td>备注：</td>
					<td><input type="text" name="shangpinMark" id="shangpinMark" class="easyui-validatebox" required="true"/></td>
				</tr>
				<tr>
					<td>备注1：</td>
					<td><input type="text" name="shangpinMark1" id="shangpinMark1" class="easyui-validatebox" required="true"/></td>
					<td>备注2：</td>
					<td><input type="text" name="shangpinMark2" id="shangpinMark2" class="easyui-validatebox" required="true"/></td>
				</tr>
				<tr>
					<td>预警：</td>
					<td><input type="text" name="shangpinType1" id="shangpinType1" class="easyui-validatebox" required="true"/></td>
					<td>类型：</td>
					<td><input class="easyui-combobox" id="sptypeId" name="sptypeId"  data-options="panelHeight:'auto',editable:false,valueField:'sptypeId',textField:'sptypeName',url:'../sptypeComboList'"/></td>
				</tr>
				<tr>
					<td>时间1：</td>
					<td><input class="easyui-datetimebox" name="shangpinDate" id="shangpinDate" required="true" editable="false" /></td>
					<td>时间2：</td>
					<td><input class="easyui-datetimebox" name="shangpinDate1" id="shangpinDate1" required="true" editable="false" /></td>
				</tr>
			</table>
		</form>
	</div>
	
	<div id="dlg-buttons">
		<a href="javascript:saveShangpin()" class="easyui-linkbutton" iconCls="icon-ok">保存</a>
		<a href="javascript:closeShangpinDialog()" class="easyui-linkbutton" iconCls="icon-cancel">关闭</a>
	</div>
<!--上传-->	
	<div id="shangchuan" class="easyui-dialog" style="width: 320px;height: 140px;padding: 10px 20px"
		closed="true" buttons="#shangchuan-buttons">
		<form id="shchfm" method="post" enctype="multipart/form-data">
			<table cellspacing="5px;">
				<tr>
					<td><input type="file" name="uploadFile" id="uploadFile" class="easyui-validatebox" required="true"/></td>
				</tr>
			</table>
		</form>
	</div>
	
	<div id="shangchuan-buttons">
		<a href="javascript:saveShangchuanShangpin()" class="easyui-linkbutton" iconCls="icon-ok">保存</a>
		<a href="javascript:closeShangchuanShangpin()" class="easyui-linkbutton" iconCls="icon-cancel">关闭</a>
	</div>
<!--导入-->	
	<div id="daoru" class="easyui-dialog" style="width: 320px;height: 140px;padding: 10px 20px"
		closed="true" buttons="#daoru-buttons">
		<form id="drfm" method="post" enctype="multipart/form-data">
			<table cellspacing="5px;">
				<tr>
					<td><input type="file" name="uploadFile" id="uploadFile" class="easyui-validatebox" required="true"/></td>
				</tr>
			</table>
		</form>
	</div>
	
	<div id="daoru-buttons">
		<a href="javascript:saveDaoruShangpin()" class="easyui-linkbutton" iconCls="icon-ok">保存</a>
		<a href="javascript:closeDaoruShangpin()" class="easyui-linkbutton" iconCls="icon-cancel">关闭</a>
	</div>
	
</body>
</html>
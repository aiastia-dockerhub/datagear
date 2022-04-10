<#--
 *
 * Copyright 2018 datagear.tech
 *
 * Licensed under the LGPLv3 license:
 * http://www.gnu.org/licenses/lgpl-3.0.html
 *
-->
<#include "../include/page_import.ftl">
<#include "../include/html_doctype.ftl">
<#assign Role=statics['org.datagear.management.domain.Role']>
<#--
titleMessageKey 标题标签I18N关键字，不允许null
selectOperation 是否选择操作，允许为null
-->
<#assign selectOperation=(selectOperation!false)>
<#assign selectPageCss=(selectOperation?string('page-grid-select',''))>
<#assign AnalysisProject=statics['org.datagear.management.domain.AnalysisProject']>
<html>
<head>
<#include "../include/html_head.ftl">
<title><#include "../include/html_title_app_name.ftl"><@spring.message code='${titleMessageKey}' /></title>
</head>
<body class="fill-parent">
<#if !isAjaxRequest>
<div class="fill-parent">
</#if>
<#include "../include/page_obj.ftl">
<#include "../include/page_obj_opt_permission.ftl" >
<div id="${pageId}" class="page-grid ${selectPageCss} page-grid-analysisProject">
	<div class="head">
		<div class="search search-analysisProject">
			<#include "../include/page_obj_searchform_data_filter.ftl">
		</div>
		<div class="operation" show-any-role="${Role.ROLE_DATA_ADMIN},${Role.ROLE_DATA_ANALYST}">
			<#if selectOperation>
				<button type="button" class="selectButton recommended"><@spring.message code='confirm' /></button>
				<button type="button" class="viewButton view-button"><@spring.message code='view' /></button>
			<#else>
				<button type="button" class="addButton" show-any-role="${Role.ROLE_DATA_ADMIN}"><@spring.message code='add' /></button>
				<button type="button" class="editButton" show-any-role="${Role.ROLE_DATA_ADMIN}"><@spring.message code='edit' /></button>
				<button type="button" class="viewButton"><@spring.message code='view' /></button>
				<#if !(currentUser.anonymous)>
				<button type="button" class="shareButton" show-any-role="${Role.ROLE_DATA_ADMIN}"><@spring.message code='share' /></button>
				</#if>
				<button type="button" class="deleteButton" show-any-role="${Role.ROLE_DATA_ADMIN}"><@spring.message code='delete' /></button>
			</#if>
		</div>
	</div>
	<div class="content">
		<table id="${pageId}-table" width="100%" class="hover stripe">
		</table>
	</div>
	<div class="foot">
		<div class="pagination-wrapper">
			<div id="${pageId}-pagination" class="pagination"></div>
		</div>
	</div>
</div>
<#if !isAjaxRequest>
</div>
</#if>
<#include "../include/page_obj_pagination.ftl">
<#include "../include/page_obj_grid.ftl">
<#include "../include/page_obj_data_permission.ftl" >
<script type="text/javascript">
(function(po)
{
	po.initGridBtns();
	po.initDataFilter();
	
	po.currentUser = <@writeJson var=currentUser />;
	
	po.url = function(action)
	{
		return "${contextPath}/analysisProject/" + action;
	};
	
	po.element(".addButton").click(function()
	{
		po.open(po.url("add"),
		{
			<#if selectOperation>
			pageParam:
			{
				submitSuccess: function(data)
				{
					po.pageParamCallSelect(true, data);
				}
			}
			</#if>
		});
	});
	
	po.element(".editButton").click(function()
	{
		po.executeOnSelect(function(row)
		{
			var data = {"id" : row.id};
			
			po.open(po.url("edit"), { data : data });
		});
	});
	
	po.element(".viewButton").click(function()
	{
		po.executeOnSelect(function(row)
		{
			var data = {"id" : row.id};
			
			po.open(po.url("view"),
			{
				data : data
			});
		});
	});
	
	po.element(".shareButton").click(function()
	{
		po.executeOnSelect(function(row)
		{
			if(!po.canAuthorize(row, po.currentUser))
			{
				$.tipInfo("<@spring.message code='error.PermissionDeniedException' />");
				return;
			}
			
			var options = {};
			$.setGridPageHeightOption(options);
			po.open(contextPath+"/authorization/${AnalysisProject.AUTHORIZATION_RESOURCE_TYPE}/" + row.id +"/query", options);
		});
	});
	
	po.element(".deleteButton").click(
	function()
	{
		po.executeOnSelects(function(rows)
		{
			po.confirmDeleteEntities(po.url("delete"), rows);
		});
	});
	
	po.element(".selectButton").click(function()
	{
		po.executeOnSelect(function(row)
		{
			po.pageParamCallSelect(true, row);
		});
	});
	
	var tableColumns = [
		$.buildDataTablesColumnSimpleOption("<@spring.message code='id' />", "id", true),
		$.buildDataTablesColumnSimpleOption($.buildDataTablesColumnTitleSearchable("<@spring.message code='analysisProject.name' />"), "name"),
		$.buildDataTablesColumnSimpleOption($.buildDataTablesColumnTitleSearchable("<@spring.message code='analysisProject.desc' />"), "desc"),
		$.buildDataTablesColumnSimpleOption("<@spring.message code='analysisProject.createUser' />", "createUser.realName"),
		$.buildDataTablesColumnSimpleOption("<@spring.message code='analysisProject.createTime' />", "createTime")
	];
	
	po.initPagination();
	
	var tableSettings = po.buildDataTableSettingsAjax(tableColumns, po.url("pagingQueryData"));
	tableSettings.order = [[$.getDataTableColumn(tableSettings, "createTime"), "desc"]];
	po.initDataTable(tableSettings);
	po.bindResizeDataTable();
	po.handlePermissionElement();
})
(${pageId});
</script>
</body>
</html>

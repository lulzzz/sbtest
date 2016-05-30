<%@ Control Language="C#" CodeBehind="Header.ascx.cs" Inherits="HrMaxx.Web.Header" %>
<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>

<link rel="stylesheet" type="text/css" href="<%= Url.Content("~/Header/CSS/Header.css") %>" />
<link rel="shortcut icon" href="<%= Url.Content("~/Header/Images/favicon.ico") %>" />
<link rel="icon" type="image/gif" href="<%= Url.Content("~/Header/Images/animated_favicon.gif") %>" />
<form id="form1" runat="server">
	<telerik:RadScriptManager ID="radScriptManager" EnablePartialRendering="true" runat="server" />
	<div id="Div1" class="qsf-demo-canvas qsf-demo-canvas-vertical" runat="server">

		<telerik:RadAjaxLoadingPanel ID="pnlLoading" runat="server" Transparency="15" MinDisplayTime="500"
		                             BackColor="#e0e0e0">
			<img src='<%= RadAjaxLoadingPanel.GetWebResourceUrl(Page, "Telerik.Web.UI.Skins.Default.Ajax.loading.gif") %>'
			     alt="Loading..." style="border: 1; margin-top: -30px; position: relative; top: 40%;" />
		</telerik:RadAjaxLoadingPanel>
		<asp:Panel ID="panel1" runat="server">
			<div id="header">
				<table border="0" cellpadding="0" cellspacing="0" width="100%" height="25px">
					<tr>
						<td style="width: 25%;">
							<img id="img7" src="<%= Url.Content("~/Header/Images/UINew2/512pt_@2x.png") %>" alt="VisZ" class="plusImage3" />
							
						</td>
						<td class="taC">
							<asp:Label ID="lblTitle" runat="server" Style="font-size: 22px" />
						</td>
						<td style="width: 15%;" class="taR">
							<img src="<%= Url.Content("~/Header/Images/NewUI/VisionStream.png") %>" alt="Vision Stream" />
						</td>

					</tr>
					<%--					<tr>
						<td colspan="6">
							<asp:Panel ID="pnlUserState" Visible="true" runat="server">
								<table border="0" cellpadding="0" cellspacing="0" width="100%" style="color: #4F81BD; background-color: White">
									<tr style="height: 3px">
										<td style="width: 50%; padding-right: 5px;" class="taR">
											<span style="font-size: small;">State: </span>
										</td>
										<td style="width: 9%;">
											<asp:DropDownList ID="ddlCurrentState" runat="server" CssClass="dropdownlist" Width="150px"
												AutoPostBack="true" DataTextField="StateCode" DataValueField="StateID" OnSelectedIndexChanged="ddlCurrentState_SelectedIndexChanged"
												Visible="true" />
										</td>
										<td style="width: 14%; font-size: small;">
											<asp:Label ID="lblUserName" runat="server" Font-Bold="true" />&nbsp;&nbsp;<span>|</span>&nbsp;&nbsp;<asp:Label
												ID="lblCurrentDate" runat="server" />
										</td>
										<td style="width: 6%; height: 25px; font-size: small;">
											<asp:LinkButton ID="lnkLogout" runat="server" Text="LOGOUT" OnClick="lnkLogout_Click"
												CssClass="logout" />
										</td>
									</tr>
								</table>
							</asp:Panel>
						</td>
					</tr>
					<tr>
						<td colspan="6" class="subHeader" style="background-color: white">
							<telerik:RadMenu runat="server" ID="RadMenu1" Width="100%" CssClass="TemplateMenu" Style="z-index: 100" CollapseDelay="0" ExpandDelay="0"
								OnItemClick="RadMenu1_ItemClick" Flow="Horizontal">
								<Items>

									<telerik:RadMenuItem Width="11%" Value="CIDetails" CssClass="Cursor" Visible="false">

										<ItemTemplate>
											<table border="0">
												<tr>
													<td rowspan="2" style="vertical-align: middle;">
														<img id="img1" src="<%= Url.Content("~/Header/Images/NewUI/Cidetails.png")%>" style="width: 50px; height: 50px" />
														<a href="#"></a>
													</td>
												</tr>
												<tr>
													<td>
														<span class="HeaderLevel1">CI Details</span>
														<span class="HeaderLevel2">Contract Instruction</span>
													</td>
												</tr>
											</table>
										</ItemTemplate>
										<Items>

											<telerik:RadMenuItem Value="CEO" CssClass="Cursor" Visible="false" ImageUrl="~/Header/Images/NewCIDetailsIcons/CED_Hover.png" HoveredImageUrl="../Header/Images/NewCIDetailsIcons/CED_Selected.png">
											</telerik:RadMenuItem>

											<telerik:RadMenuItem Value="BOQ" CssClass="Cursor" Visible="false" ImageUrl="../Header/Images/NewCIDetailsIcons/Boq_Hover.png" HoveredImageUrl="../Header/Images/NewCIDetailsIcons/Boq_Selected.png">
											</telerik:RadMenuItem>

											<telerik:RadMenuItem Value="Task" CssClass="Cursor" Visible="false" ImageUrl="../Header/Images/NewCIDetailsIcons/Task_Hover.png" HoveredImageUrl="../Header/Images/NewCIDetailsIcons/Task_Selected.png">
											</telerik:RadMenuItem>

											<telerik:RadMenuItem Value="SubbyLocations" CssClass="Cursor" Visible="false" ImageUrl="../Header/Images/NewCIDetailsIcons/SubbyLocation_Hover.png" HoveredImageUrl="../Header/Images/NewCIDetailsIcons/SubbyLocation_Selected.png">
											</telerik:RadMenuItem>

											<telerik:RadMenuItem Value="Variation" CssClass="Cursor" Visible="false" ImageUrl="../Header/Images/NewCIDetailsIcons/SubMenuIcons/Variations_Hover.png" HoveredImageUrl="../Header/Images/NewCIDetailsIcons/SubMenuIcons/Variations_Selected.png">
											</telerik:RadMenuItem>

											<telerik:RadMenuItem Value="As-Built" CssClass="Cursor" Visible="false" ImageUrl="../Header/Images/NewCIDetailsIcons/SubMenuIcons/AsBuilt_Hover.png" HoveredImageUrl="../Header/Images/NewCIDetailsIcons/SubMenuIcons/AsBuilt_Selected.png">
												<Items>
													<telerik:RadMenuItem Value="As-Built" CssClass="Cursor" Visible="false" ImageUrl="../Header/Images/NewCIDetailsIcons/Asbuilt_Hover.png" HoveredImageUrl="../Header/Images/NewCIDetailsIcons/Asbuilt_Selected.png">
													</telerik:RadMenuItem>

													<telerik:RadMenuItem Value="PCP" CssClass="Cursor" Visible="false" ImageUrl="../Header/Images/NewCIDetailsIcons/PCP_Hover.png" HoveredImageUrl="../Header/Images/NewCIDetailsIcons/PCP_Selected.png">
													</telerik:RadMenuItem>

													<telerik:RadMenuItem Value="PC" CssClass="Cursor" Visible="false" ImageUrl="../Header/Images/NewCIDetailsIcons/PC_Hover.png" HoveredImageUrl="../Header/Images/NewCIDetailsIcons/PC_Selected.png">
													</telerik:RadMenuItem>
												</Items>

											</telerik:RadMenuItem>

											<telerik:RadMenuItem Value="MStones" CssClass="Cursor" Visible="false" ImageUrl="../Header/Images/NewCIDetailsIcons/SubMenuIcons/Milestones_Hover.png" HoveredImageUrl="../Header/Images/NewCIDetailsIcons/SubMenuIcons/Milestones_Selected.png">
												<Items>
													<telerik:RadMenuItem Value="MStones" CssClass="Cursor" Visible="false" ImageUrl="../Header/Images/NewCIDetailsIcons/SubMenuIcons/p6Summary_Hover.png" HoveredImageUrl="../Header/Images/NewCIDetailsIcons/SubMenuIcons/p6Summary_Selected.png">
													</telerik:RadMenuItem>
													<telerik:RadMenuItem Value="Status" CssClass="Cursor" Visible="false" ImageUrl="../Header/Images/NewCIDetailsIcons/SubMenuIcons/Status_Hover.png" HoveredImageUrl="../Header/Images/NewCIDetailsIcons/SubMenuIcons/Status_Selected.png">
													</telerik:RadMenuItem>
												</Items>
											</telerik:RadMenuItem>

											<telerik:RadMenuItem Value="Status" CssClass="Cursor" Visible="false" ImageUrl="../Header/Images/NewCIDetailsIcons/Status_Hover.png" HoveredImageUrl="../Header/Images/NewCIDetailsIcons/Status_Selected.png">
											</telerik:RadMenuItem>

											<telerik:RadMenuItem Value="PCP" CssClass="Cursor" Visible="false" ImageUrl="../Header/Images/NewCIDetailsIcons/PCP_Hover.png" HoveredImageUrl="../Header/Images/NewCIDetailsIcons/PCP_Selected.png">
											</telerik:RadMenuItem>

											<telerik:RadMenuItem Value="PC" CssClass="Cursor" Visible="false" ImageUrl="../Header/Images/NewCIDetailsIcons/PC_Hover.png" HoveredImageUrl="../Header/Images/NewCIDetailsIcons/PC_Selected.png">
											</telerik:RadMenuItem>

											<telerik:RadMenuItem Value="DEP" CssClass="Cursor" Visible="false" ImageUrl="../Header/Images/NewCIDetailsIcons/dependency_Hover.png" HoveredImageUrl="../Header/Images/NewCIDetailsIcons/dependency_Selected.png">
											</telerik:RadMenuItem>

										</Items>
									</telerik:RadMenuItem>

									<telerik:RadMenuItem Width="11%" Value="AddNEWWorkOrder" CssClass="Cursor" Visible="true">

										<ItemTemplate>
											<table border="0">
												<tr>
													<td rowspan="2" style="vertical-align: middle;">
														<img id="img10" src="<%= Url.Content("~/Header/Images/UINew2/AddNewCI.png")%>" style="width: 50px; height: 50px" />
													</td>
												</tr>
												<tr>
													<td>
														<span class="HeaderLevel1">ADD NEW</span>
														<span class="HeaderLevel2">Work Order/CI</span>
													</td>
												</tr>
											</table>
										</ItemTemplate>


										<Items>
											<telerik:RadMenuItem Value="NBN" CssClass="Cursor" Visible="false" ImageUrl="../Header/Images/PureImageMenuIcons/NBN_Hover.png" HoveredImageUrl="../Header/Images/PureImageMenuIcons/NBN_Selected.png">
												<Items>
													<telerik:RadMenuItem Value="LNDN" CssClass="Cursor" Visible="false" ImageUrl="../Header/Images/PureImageMenuIcons/LNDN_Hover.png" HoveredImageUrl="../Header/Images/PureImageMenuIcons/LNDN_Selected.png">
													</telerik:RadMenuItem>

													<telerik:RadMenuItem Value="BuildDrop" CssClass="Cursor" Visible="false" ImageUrl="../Header/Images/PureImageMenuIcons/BD_Hover.png" HoveredImageUrl="../Header/Images/PureImageMenuIcons/BD_Selected.png">
													</telerik:RadMenuItem>

													<telerik:RadMenuItem Value="NewDev" CssClass="Cursor" Visible="false" ImageUrl="../Header/Images/PureImageMenuIcons/NewDev_Hover.png" HoveredImageUrl="../Header/Images/PureImageMenuIcons/NewDev_Selected.png">
													</telerik:RadMenuItem>

													<telerik:RadMenuItem Value="FSD" CssClass="Cursor" Visible="false" ImageUrl="../Header/Images/PureImageMenuIcons/FSD_Hover.png" HoveredImageUrl="../Header/Images/PureImageMenuIcons/FSD_Selected.png">
													</telerik:RadMenuItem>

													<telerik:RadMenuItem Value="Transit" CssClass="Cursor" Visible="false" ImageUrl="../Header/Images/PureImageMenuIcons/Transit_Hover.png" HoveredImageUrl="../Header/Images/PureImageMenuIcons/Transit_Selected.png">
													</telerik:RadMenuItem>

												</Items>
											</telerik:RadMenuItem>

											<telerik:RadMenuItem Value="CarrierNetwork" CssClass="Cursor" Visible="false" ImageUrl="../Header/Images/PureImageMenuIcons/CarrierNetwork_Hover.png" HoveredImageUrl="../Header/Images/PureImageMenuIcons/CarrierNetwork_Selected.png">
												<Items>
													<telerik:RadMenuItem Value="Dias" CssClass="Cursor" Visible="false" ImageUrl="../Header/Images/PureImageMenuIcons/Dias_Hover.png" HoveredImageUrl="../Header/Images/PureImageMenuIcons/Dias_Selected.png">
													</telerik:RadMenuItem>
													<telerik:RadMenuItem Value="IEN" CssClass="Cursor" Visible="false" ImageUrl="../Header/Images/PureImageMenuIcons/IEN_Hover.png" HoveredImageUrl="../Header/Images/PureImageMenuIcons/IEN_Selected.png">
													</telerik:RadMenuItem>
													<telerik:RadMenuItem Value="Optus" CssClass="Cursor" Visible="false" ImageUrl="../Header/Images/PureImageMenuIcons/Optus_Hover.png" HoveredImageUrl="../Header/Images/PureImageMenuIcons/Optus_Selected.png">
													</telerik:RadMenuItem>
												</Items>

											</telerik:RadMenuItem>

											<telerik:RadMenuItem Value="Ericsson" CssClass="Cursor" Visible="false" ImageUrl="../Header/Images/PureImageMenuIcons/Ericssion_Hover.png" HoveredImageUrl="../Header/Images/PureImageMenuIcons/Ericssion_Selected.png">
											</telerik:RadMenuItem>


										</Items>





									</telerik:RadMenuItem>


									<telerik:RadMenuItem Width="11%" Value="Search" CssClass="Cursor">
										<ItemTemplate>
											<table border="0">
												<tr>
													<td rowspan="2" style="vertical-align: middle;">
														<img id="img8" src="<%= Url.Content("~/Header/Images/UINew3/Search.gif")%>" style="width: 50px; height: 50px" />
														<a href="../Work/SearchWorkOrder.aspx"></a></td>
												</tr>
												<tr>
													<td>
														<span class="HeaderLevel1">Search</span>
														<span class="HeaderLevel2">Your Project</span>
													</td>
												</tr>

											</table>
										</ItemTemplate>
										<Items>
											<telerik:RadMenuItem Value="SearchWorkID" CssClass="SearchWorkID">
												<ItemTemplate>
													<asp:TextBox ID="txtNewSearch" Text="Search Work ID" MaxLength="10" onfocus="if(this.value == 'Search Work ID') {this.value=''}" AutoPostBack="true"
														onblur="if(this.value == ''){this.value ='Search Work ID'}" runat="server" OnTextChanged="txtNewSearch_TextChanged" CssClass="SearchWorkID"></asp:TextBox>
												</ItemTemplate>

											</telerik:RadMenuItem>

											<telerik:RadMenuItem Value="AdvanceSearch" CssClass="Cursor" ImageUrl="../Header/Images/PureImageMenuIcons/AdvancSearch.png" HoveredImageUrl="../Header/Images/PureImageMenuIcons/AdvanceSearch_Selected.png">
											</telerik:RadMenuItem>


										</Items>
									</telerik:RadMenuItem>

									<telerik:RadMenuItem Width="11%" Value="Task" CssClass="Cursor" Visible="false">
										<ItemTemplate>
											<table border="0">
												<tr>
													<td rowspan="2" style="vertical-align: middle;">
														<img id="img9" src="<%= Url.Content("~/Header/Images/VisZNewIcons/Task.gif")%>" style="width: 50px; height: 50px" />
														<a href="../Work/TaskFSD.aspx"></a>
													</td>
												</tr>
												<tr>
													<td>
														<span class="HeaderLevel1">Task</span>
														<span class="HeaderLevel2">Work Order Mgt</span>
													</td>
												</tr>
											</table>
										</ItemTemplate>

									</telerik:RadMenuItem>

									<telerik:RadMenuItem Width="11%" Value="QualityControl" CssClass="Cursor">

										<ItemTemplate>
											<table border="0">
												<tr>
													<td rowspan="2" style="vertical-align: middle;">
														<img id="img2" src="<%= Url.Content("~/Header/Images/UINew3/QualityControl.png")%>" style="width: 50px; height: 50px" />
														<a href="../NCQFIC/QFICSummary.aspx"></a>
													</td>
												</tr>
												<tr>
													<td>
														<span class="HeaderLevel1">Quality Control</span>
													</td>
												</tr>
											</table>
										</ItemTemplate>
										<Items>
											<telerik:RadMenuItem Value="NonConformance" CssClass="Cursor" ImageUrl="../Header/Images/PureImageMenuIcons/NonConformance.png" HoveredImageUrl="../Header/Images/PureImageMenuIcons/NonConformance_Selected.png">
											</telerik:RadMenuItem>

											<telerik:RadMenuItem Value="QualityField" CssClass="Cursor" ImageUrl="../Header/Images/PureImageMenuIcons/QualityField.png" HoveredImageUrl="../Header/Images/PureImageMenuIcons/QualityField_Selected.png">
											</telerik:RadMenuItem>

											<telerik:RadMenuItem Value="AddRaiseDefect" CssClass="Cursor" ImageUrl="../Header/Images/PureImageMenuIcons/AddRaiseDefect.png" HoveredImageUrl="../Header/Images/PureImageMenuIcons/AddRaiseDefect_Selected.png">
											</telerik:RadMenuItem>



										</Items>
									</telerik:RadMenuItem>

									<telerik:RadMenuItem Width="11%" Value="Payments" CssClass="Cursor">

										<ItemTemplate>
											<table border="0">
												<tr>
													<td rowspan="2" style="vertical-align: middle;">
														<img id="img3" src="<%= Url.Content("~/Header/Images/UINew3/Payments.gif")%>" style="width: 50px; height: 50px" />
														<a href="../Work/POInvoiceSummary.aspx"></a>
													</td>
												</tr>
												<tr>
													<td>
														<span class="HeaderLevel1">Payments</span>
													</td>
												</tr>
											</table>
										</ItemTemplate>
										<Items>

											<telerik:RadMenuItem Value="POInvoice" CssClass="Cursor" ImageUrl="../Header/Images/PureImageMenuIcons/PurchaseOrder_Hover.png" HoveredImageUrl="../Header/Images/PureImageMenuIcons/PurchaseOrder_Selected.png">
											</telerik:RadMenuItem>

											<telerik:RadMenuItem Value="Invoice" CssClass="Cursor" ImageUrl="../Header/Images/PureImageMenuIcons/Invoices_Hover.png" HoveredImageUrl="../Header/Images/PureImageMenuIcons/Invoices_Selected.png">
												<Items>
													<telerik:RadMenuItem Value="NewInvoice" CssClass="Cursor" ImageUrl="../Header/Images/PureImageMenuIcons/NewInvoice.png" HoveredImageUrl="../Header/Images/PureImageMenuIcons/NewInvoice_Selected.png">
													</telerik:RadMenuItem>

													<telerik:RadMenuItem Value="ApprovedInvoice" CssClass="Cursor" ImageUrl="../Header/Images/PureImageMenuIcons/ApprovedInvoice.png" HoveredImageUrl="../Header/Images/PureImageMenuIcons/ApprovedInvoice_Selected.png">
													</telerik:RadMenuItem>

													<telerik:RadMenuItem Value="DisputedInvoice" CssClass="Cursor" ImageUrl="../Header/Images/PureImageMenuIcons/DisputedInvoices.png" HoveredImageUrl="../Header/Images/PureImageMenuIcons/DisputedInvoices_Selected.png">
													</telerik:RadMenuItem>


													<telerik:RadMenuItem Value="ResolvedInvoice" CssClass="Cursor" ImageUrl="../Header/Images/PureImageMenuIcons/ResolvedInvoices.png" HoveredImageUrl="../Header/Images/PureImageMenuIcons/ResolvedInvoices_Selected.png">
													</telerik:RadMenuItem>

												</Items>
											</telerik:RadMenuItem>


											<telerik:RadMenuItem Value="Retention" CssClass="Cursor" ImageUrl="../Header/Images/PureImageMenuIcons/Retention.png" HoveredImageUrl="../Header/Images/PureImageMenuIcons/Retention_Selected.png">
											</telerik:RadMenuItem>

											<telerik:RadMenuItem Value="OracleInvoices" CssClass="Cursor" ImageUrl="../Header/Images/PureImageMenuIcons/OracleInvoice.png" HoveredImageUrl="../Header/Images/PureImageMenuIcons/OracleInvoice_Selected.png">
											</telerik:RadMenuItem>


										</Items>
									</telerik:RadMenuItem>

									<telerik:RadMenuItem Width="10%" Value="Claims" CssClass="Cursor">

										<ItemTemplate>
											<table border="0">
												<tr>
													<td rowspan="2" style="vertical-align: middle;">

														<img id="img4" src="<%= Url.Content("~/Header/Images/UINew3/Claims.gif")%>" style="width: 50px; height: 50px" />
														<a href="../Work/Claims.aspx"></a>
													</td>
												</tr>
												<tr>
													<td>

														<span class="HeaderLevel1">Claims</span>
													</td>
												</tr>
											</table>
										</ItemTemplate>
										<Items>




											<telerik:RadMenuItem Value="SearchClaim" CssClass="Cursor" ImageUrl="../Header/Images/PureImageMenuIcons/SearchClaim.png" HoveredImageUrl="../Header/Images/PureImageMenuIcons/SearchClaim_Selected.png">
											</telerik:RadMenuItem>




											<telerik:RadMenuItem Value="CreateClaim" CssClass="Cursor" ImageUrl="../Header/Images/PureImageMenuIcons/CreateClaim.png" HoveredImageUrl="../Header/Images/PureImageMenuIcons/CreateClaim_Selected.png">
											</telerik:RadMenuItem>


											<telerik:RadMenuItem Value="Variations" CssClass="Cursor" ImageUrl="../Header/Images/PureImageMenuIcons/Variations.png" HoveredImageUrl="../Header/Images/PureImageMenuIcons/Variations_Selected.png">
											</telerik:RadMenuItem>





										</Items>
									</telerik:RadMenuItem>

									<telerik:RadMenuItem Width="11%" Value="Reports" CssClass="Cursor">

										<ItemTemplate>
											<table border="0">
												<tr>
													<td rowspan="2" style="vertical-align: middle;">

														<img id="img5" src="<%= Url.Content("~/Header/Images/UINew3/Reports.gif")%>" style="width: 50px; height: 50px" />
														<a href="../Work/Reports.aspx"></a>
													</td>
												</tr>
												<tr>
													<td>

														<span class="HeaderLevel1">Reports</span>
													</td>
												</tr>

											</table>
										</ItemTemplate>
										<Items>
											<telerik:RadMenuItem Value="ProjectReports" CssClass="Cursor" ImageUrl="../Header/Images/PureImageMenuIcons/ProjectReports.png" HoveredImageUrl="../Header/Images/PureImageMenuIcons/ProjectReports_Selected.png">
											</telerik:RadMenuItem>

											<telerik:RadMenuItem Value="BusinessIntelligence" CssClass="Cursor" ImageUrl="../Header/Images/PureImageMenuIcons/BusinessIntelligence.png" HoveredImageUrl="../Header/Images/PureImageMenuIcons/BusinessIntelligence_Selected.png">
											</telerik:RadMenuItem>


											<telerik:RadMenuItem Value="NonTaskForms" CssClass="Cursor" ImageUrl="../Header/Images/PureImageMenuIcons/NonTaskForms.png" HoveredImageUrl="../Header/Images/PureImageMenuIcons/NonTaskForms_Selected.png">
											</telerik:RadMenuItem>
										</Items>

									</telerik:RadMenuItem>

									<telerik:RadMenuItem Width="11%" Value="Maintenance" CssClass="Cursor">

										<ItemTemplate>
											<table border="0">
												<tr>
													<td rowspan="2" style="vertical-align: middle;">

														<img id="img7" src="<%= Url.Content("~/Header/Images/UINew2/Maintenance.png")%>" style="width: 50px; height: 50px" />
														<a href="../Maintenance/ProjectCode.aspx"></a>
													</td>
												</tr>
												<tr>
													<td>

														<span class="HeaderLevel1">Maintenance</span>
													</td>
												</tr>
											</table>
										</ItemTemplate>


									</telerik:RadMenuItem>


									<telerik:RadMenuItem Width="11%" Value="Security" CssClass="Cursor">

										<ItemTemplate>
											<table border="0">
												<tr>
													<td rowspan="2" style="vertical-align: middle;">

														<img id="img6" src="<%= Url.Content("~/Header/Images/UINew3/Security.gif")%>" style="width: 50px; height: 50px" />
														<a href="../MyAccount/ChangePassword.aspx"></a></td>
												</tr>
												<tr>
													<td>

														<span class="HeaderLevel1">Security</span>
													</td>
												</tr>
											</table>

										</ItemTemplate>
										<Items>


											<telerik:RadMenuItem Value="AddUser" CssClass="Cursor" ImageUrl="../Header/Images/PureImageMenuIcons/AddUser.png" HoveredImageUrl="../Header/Images/PureImageMenuIcons/AddUser_Selected.png">
											</telerik:RadMenuItem>

											<telerik:RadMenuItem Value="ChangePassword" CssClass="Cursor" ImageUrl="../Header/Images/PureImageMenuIcons/ChangePassword.png" HoveredImageUrl="../Header/Images/PureImageMenuIcons/ChangePassword_Selected.png">
											</telerik:RadMenuItem>


											<telerik:RadMenuItem Value="VersionHistory" CssClass="Cursor" ImageUrl="../Header/Images/PureImageMenuIcons/VersionHistory.png" HoveredImageUrl="../Header/Images/PureImageMenuIcons/VersionHistory_Selected.png">
											</telerik:RadMenuItem>


											<telerik:RadMenuItem Value="AuthorityMatrix" CssClass="Cursor" ImageUrl="../Header/Images/PureImageMenuIcons/AuthorityMatrix.png" HoveredImageUrl="../Header/Images/PureImageMenuIcons/AuthorityMatrix_Selected.png">
											</telerik:RadMenuItem>


											<telerik:RadMenuItem Value="ModuleEventLog" CssClass="Cursor" ImageUrl="../Header/Images/PureImageMenuIcons/ModuleEventLog.png" HoveredImageUrl="../Header/Images/PureImageMenuIcons/ModuleEventLog_Selected.png">
											</telerik:RadMenuItem>


											<telerik:RadMenuItem Value="UserEventLog" CssClass="Cursor" ImageUrl="../Header/Images/PureImageMenuIcons/UserEventLog.png" HoveredImageUrl="../Header/Images/PureImageMenuIcons/UserEventLog_Selected.png">
											</telerik:RadMenuItem>



										</Items>
									</telerik:RadMenuItem>



									<telerik:RadMenuItem Width="10%" Value="Help" CssClass="Cursor">

										<ItemTemplate>
											<table border="0">
												<tr>
													<td rowspan="2" style="vertical-align: middle;">

														<img id="img11" src="<%= Url.Content("~/Header/Images/UINew2/Help.png")%>" style="width: 50px; height: 50px" />
														<a href="../Work/Help.aspx"></a></td>
												</tr>
												<tr>
													<td>

														<span class="HeaderLevel1">Help</span>
													</td>
												</tr>
											</table>
										</ItemTemplate>
										<Items>


											<telerik:RadMenuItem Value="Help_LNDN" CssClass="Cursor" ImageUrl="../Header/Images/PureImageMenuIcons/LNDN_Hover.png" HoveredImageUrl="../Header/Images/PureImageMenuIcons/LNDN_Selected.png">
											</telerik:RadMenuItem>

											<telerik:RadMenuItem Value="Help_BD" CssClass="Cursor" ImageUrl="../Header/Images/PureImageMenuIcons/BD_Hover.png" HoveredImageUrl="../Header/Images/PureImageMenuIcons/BD_Selected.png">
											</telerik:RadMenuItem>

											<telerik:RadMenuItem Value="Help_NewDev" CssClass="Cursor" ImageUrl="../Header/Images/PureImageMenuIcons/NewDev_Hover.png" HoveredImageUrl="../Header/Images/PureImageMenuIcons/NewDev_Selected.png">
											</telerik:RadMenuItem>

											<telerik:RadMenuItem Value="Help_FSD" CssClass="Cursor" ImageUrl="../Header/Images/PureImageMenuIcons/FSD_Hover.png" HoveredImageUrl="../Header/Images/PureImageMenuIcons/FSD_Selected.png">
											</telerik:RadMenuItem>

											<telerik:RadMenuItem Value="Help_QFIC" CssClass="Cursor" ImageUrl="../Header/Images/PureImageMenuIcons/QFIC_Hover.png" HoveredImageUrl="../Header/Images/PureImageMenuIcons/QFIC_Selected.png">
											</telerik:RadMenuItem>



										</Items>
									</telerik:RadMenuItem>




								</Items>
							</telerik:RadMenu>
						</td>
					</tr>--%>
				</table>
			</div>


		</asp:Panel>



	</div>

</form>
<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="DashBoard._Default"
    EnableEventValidation="false" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Dash Board</title>
    <meta http-equiv="X-UA-Compatible" content="IE=8;FF=3;OtherUA=4" />
    <script src="scripts/jquery-1.7.1.js" type="text/javascript"></script>
    <style type="text/css">
        .row
        {
            color: #FFF5EE;
        }
        /* #grd_GridData  
        {  
           overflow-x:hidden !important;  
        }     */.grd_ItemCss
        {
            width: 0.5%;
        }
        .grd_ItemCss1
        {
            width: 5%;
        }
    </style>

    <script type="text/javascript" language="javascript">
        var oldgridSelectedColor1;
        function setMouseOverColor2(element) {
            oldgridSelectedColor = element.style.backgroundColor;
            oldgridSelectedColor1 = element.style.color;
            element.style.backgroundColor = '#FFF5EE';
            element.style.color = '#000000';
            //element.style.cursor = 'pointer';
            // $(element).addClass("grdCls");
        }
        function setMouseOutColor2(element) {
            element.style.backgroundColor = oldgridSelectedColor;
            element.style.color = oldgridSelectedColor1;
            //$(element).removeClass("grdCls");
        }

        function clientShow(sender, eventArgs) {
            var txtInput = document.getElementById("txtInput");
            sender.argument = txtInput.value;
        }
        function clientClose(sender, args) {
            if (args.get_argument() !== null) {
                alert("'" + sender.get_name() + "'" + " was closed and returned the following argument: '" + args.get_argument() + "'");
            }
        }
        var grdClientID = null;
        var refreshTime = 6000 * 1;//ONE MINUTE
        function GridCreated(sender, args) {
            grdClientID = sender;
            var scrollArea = sender.GridDataDiv;
            scrollArea.style.height = document.documentElement.clientHeight - 240 + "px";
        }
        $(document).ready(function() {
            //setTimeout("RefreshGrid()", refreshTime);
        });  
        
    </script>

</head>
<body>
    <form id="form1" runat="server">   
    <script type="text/javascript" language="javascript"> 
    function RefreshGrid() {
        var masterTable = grdClientID.get_masterTableView();
        masterTable.rebind();
        setTimeout("RefreshGrid()", refreshTime);
        }
    </script>
    <telerik:RadScriptManager ID="RadScriptManager1" runat="server">
    </telerik:RadScriptManager>
    <telerik:RadSkinManager ID="QsfSkinManager" runat="server" ShowChooser="true" />
    <telerik:RadFormDecorator ID="QsfFromDecorator" runat="server" DecoratedControls="All"
        EnableRoundedCorners="true" />
    <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server" UpdateInitiatorPanelsOnly="true">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="grd">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="grd" LoadingPanelID="RadAjaxLoadingPanel1" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManager>
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server" />
    <div style="width: 100%;">
        <telerik:RadGrid ID="grd" runat="server" CellSpacing="0" AllowFilteringByColumn="true"
            AutoGenerateColumns="False" GridLines="None" AllowSorting="True" OnItemDataBound="grd_ItemDataBound"
            OnNeedDataSource="grd_NeedDataSource" OnPreRender="grd_PreRender" OnItemCommand="grd_ItemCommand"
            OnSortCommand="grd_SortCommand" ShowGroupPanel="True">
            <HeaderContextMenu CssClass="GridContextMenu GridContextMenu_Default">
            </HeaderContextMenu>
            <MasterTableView DataKeyNames="Uid" Width="100%" AllowNaturalSort="false">
                <ExpandCollapseColumn FilterControlAltText="Filter ExpandColumn column">
                </ExpandCollapseColumn>
                <Columns>
                    <telerik:GridBoundColumn DataField="GroupName" DataType="System.String" HeaderText="Group Name"
                        UniqueName="GroupName" SortExpression="GroupName">
                        <HeaderStyle Width="13.2%" HorizontalAlign="Left" VerticalAlign="Middle" />                        
                        <FilterTemplate>
                            <telerik:RadComboBox ID="cmbGroupName" Height="200px" Width="100%" AppendDataBoundItems="true"
                                OnSelectedIndexChanged="cmbFilterTemplate_SelectedIndexChanged" runat="server"
                                OnClientSelectedIndexChanged="TitleIndexChanged" OnPreRender="cmbFilterTemplate_PreRender">
                                <Items>
                                    <telerik:RadComboBoxItem Text="All" />
                                </Items>
                            </telerik:RadComboBox>
                            <telerik:RadScriptBlock ID="RadScriptBlock1" runat="server">
                                <script type="text/javascript">
                                    function TitleIndexChanged(sender, args) {
                                        var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                        tableView.filter("GroupName", args.get_item().get_value(), "EqualTo");
                                    }
                                </script>
                            </telerik:RadScriptBlock>
                        </FilterTemplate>
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="DoctorName" DataType="System.String" HeaderText="Doctor Name"
                        UniqueName="DoctorName" SortExpression="DoctorName">
                        <HeaderStyle Width="11%" HorizontalAlign="Left" VerticalAlign="Middle" />                        
                        <FilterTemplate>
                            <telerik:RadComboBox ID="cmbDoctorName" Height="200px" Width="100%" AppendDataBoundItems="true"
                                OnSelectedIndexChanged="cmbFilterTemplate_SelectedIndexChanged" runat="server"
                                OnClientSelectedIndexChanged="TitleIndexChanged2" OnPreRender="cmbFilterTemplate_PreRender">
                                <Items>
                                    <telerik:RadComboBoxItem Text="All" />
                                </Items>
                            </telerik:RadComboBox>
                            <telerik:RadScriptBlock ID="RadScriptBlock2" runat="server">
                                <script type="text/javascript">
                                    function TitleIndexChanged2(sender, args) {
                                        var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                        tableView.filter("DoctorName", args.get_item().get_value(), "EqualTo");
                                    }
                                </script>
                            </telerik:RadScriptBlock>
                        </FilterTemplate>
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="DoctorCode" DataType="System.String" HeaderText="Doctor Code"
                        UniqueName="DoctorCode" SortExpression="DoctorCode">
                        <HeaderStyle Width="9%" HorizontalAlign="Left" VerticalAlign="Middle" />
                        <ItemStyle HorizontalAlign="Left" Width="9%" />
                        <FilterTemplate>
                            <telerik:RadComboBox ID="cmbDoctorCode" Height="200px" Width="100%" AppendDataBoundItems="true"
                                OnSelectedIndexChanged="cmbFilterTemplate_SelectedIndexChanged" runat="server"
                                OnClientSelectedIndexChanged="TitleIndexChanged3" OnPreRender="cmbFilterTemplate_PreRender">
                                <Items>
                                    <telerik:RadComboBoxItem Text="All" />
                                </Items>
                            </telerik:RadComboBox>
                            <telerik:RadScriptBlock ID="RadScriptBlock3" runat="server">
                                <script type="text/javascript">
                                    function TitleIndexChanged3(sender, args) {
                                        var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                        tableView.filter("DoctorCode", args.get_item().get_value(), "EqualTo");
                                    }
                                </script>
                            </telerik:RadScriptBlock>
                        </FilterTemplate>
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="medantexID" DataType="System.String" HeaderText="Medantex ID"
                        UniqueName="medantexID" SortExpression="medantexID">
                        <HeaderStyle Width="9%" HorizontalAlign="Left" VerticalAlign="Middle" />                        
                        <FilterTemplate>
                            <telerik:RadComboBox ID="cmbmedantexID" Height="200px" Width="100%" AppendDataBoundItems="true"
                                OnSelectedIndexChanged="cmbFilterTemplate_SelectedIndexChanged" runat="server"
                                OnClientSelectedIndexChanged="TitleIndexChanged4" OnPreRender="cmbFilterTemplate_PreRender" r>
                                <Items>
                                    <telerik:RadComboBoxItem Text="All" />
                                </Items>                                
                            </telerik:RadComboBox>
                            <telerik:RadScriptBlock ID="RadScriptBlock4" runat="server">
                                <script type="text/javascript">
                                    function TitleIndexChanged4(sender, args) {
                                        var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                        tableView.filter("medantexID", args.get_item().get_value(), "EqualTo");
                                    }
                                </script>
                            </telerik:RadScriptBlock>
                        </FilterTemplate>
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="AudioFileName" DataType="System.String" HeaderText="Audio File Name"
                        UniqueName="AudioFileName" SortExpression="AudioFileName">
                        <HeaderStyle Width="9%" HorizontalAlign="Left" VerticalAlign="Middle" />
                    </telerik:GridBoundColumn>                    
                    <telerik:GridTemplateColumn HeaderText="FileReceiveDT" DataType="System.DateTime"
                        SortExpression="FileReceiveDT" UniqueName="FileReceiveDT" DataField="FileReceiveDT" AllowFiltering="false" >
                        <ItemTemplate>
                            <asp:Label ID="lblFileReceiveDT" runat="server"></asp:Label>
                        </ItemTemplate>
                        <FilterTemplate>                            
                            <table>
                                <tr>
                                    <td>From</td>
                                    <td><telerik:RadDatePicker ID="FromFRdt" runat="server" Width="140px" ClientEvents-OnDateSelected="FromDateSelected" DbSelectedDate='<%# FromDate %>' /></td>
                                </tr>
                                <tr><td>To
                                    </td>
                                    <td><telerik:RadDatePicker ID="ToFRdt" runat="server" Width="140px" ClientEvents-OnDateSelected="ToDateSelected" DbSelectedDate='<%# ToDate %>' />
                                    </td>
                                </tr>
                            </table>
                            <telerik:RadScriptBlock ID="RadScriptBlock5" runat="server">

                            <script type="text/javascript">
                                function FromDateSelected(sender, args) {
                                    var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                    var ToPicker = $find('<%# ((GridItem)Container).FindControl("ToFRdt").ClientID %>');

                                    var fromDate = FormatSelectedDate(sender);
                                    var toDate = FormatSelectedDate(ToPicker);

                                    tableView.filter("FileReceiveDT", fromDate + " " + toDate, "Between");

                                }
                                function ToDateSelected(sender, args) {
                                    var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                    var FromPicker = $find('<%# ((GridItem)Container).FindControl("FromFRdt").ClientID %>');

                                    var fromDate = FormatSelectedDate(FromPicker);
                                    var toDate = FormatSelectedDate(sender);

                                    tableView.filter("FileReceiveDT", fromDate + " " + toDate, "Between");
                                }
                                function FormatSelectedDate(picker) {
                                    var date = picker.get_selectedDate();
                                    var dateInput = picker.get_dateInput();
                                    var formattedDate = dateInput.get_dateFormatInfo().FormatDate(date, dateInput.get_displayDateFormat());                                    
                                    return formattedDate;
                                }
                            </script>

                        </telerik:RadScriptBlock>
                        </FilterTemplate>                        
                        <HeaderStyle Width="9.5%" HorizontalAlign="Center" VerticalAlign="Middle" />
                    </telerik:GridTemplateColumn>
                    <telerik:GridBoundColumn DataField="FileType" DataType="System.String" HeaderText="FileType"
                        AllowFiltering="false" UniqueName="FileType" SortExpression="FileType">
                        <HeaderStyle Width="5%" HorizontalAlign="Center" VerticalAlign="Middle" />                        
                    </telerik:GridBoundColumn>
                    <telerik:GridTemplateColumn HeaderText="File Size" AllowFiltering="false">
                        <ItemTemplate>
                            <asp:Label ID="lblFilesize" runat="server"></asp:Label>
                        </ItemTemplate>
                        <HeaderStyle Width="6%" HorizontalAlign="Center" VerticalAlign="Middle" />                        
                    </telerik:GridTemplateColumn>
                    <telerik:GridTemplateColumn HeaderText="Status" DataType="System.String" UniqueName="Status"
                        AllowFiltering="false">
                        <ItemTemplate>
                            <asp:Label ID="lblStatus" runat="server"></asp:Label>
                        </ItemTemplate>
                        <HeaderStyle Width="7%" HorizontalAlign="Center" VerticalAlign="Middle" />                        
                    </telerik:GridTemplateColumn>
                    <telerik:GridTemplateColumn HeaderText="Redownload" AllowFiltering="false">
                        <ItemTemplate>
                            <asp:CheckBox ID="chkRedownload" runat="server" />
                        </ItemTemplate>
                        <HeaderStyle Width="7%" HorizontalAlign="Center" VerticalAlign="Middle" />                        
                    </telerik:GridTemplateColumn>
                </Columns>
                <EditFormSettings>
                    <EditColumn FilterControlAltText="Filter EditCommandColumn column">
                    </EditColumn>
                </EditFormSettings>
                <CommandItemTemplate>
                    <div>
                        <telerik:RadButton ID="btnUpdate" runat="server">
                        </telerik:RadButton>
                    </div>
                </CommandItemTemplate>                
            </MasterTableView>
            <ClientSettings AllowAutoScrollOnDragDrop="False" AllowExpandCollapse="False" AllowGroupExpandCollapse="False"
                AllowDragToGroup="True">
                <DataBinding ShowEmptyRowsOnLoad="False">
                </DataBinding>
                <Selecting EnableDragToSelectRows="False" />
                <ClientEvents OnGridCreated="GridCreated" />
                <KeyboardNavigationSettings EnableKeyboardShortcuts="False" />
                <Scrolling AllowScroll="True" UseStaticHeaders="True" SaveScrollPosition="true" />
                <Resizing ClipCellContentOnResize="False" ShowRowIndicatorColumn="False" />
            </ClientSettings>
            <FilterMenu EnableImageSprites="False" CausesValidation="False">
            </FilterMenu>
            <SortingSettings EnableSkinSortStyles="False" />
        </telerik:RadGrid>
    </div>           
    </form>
</body>
</html>

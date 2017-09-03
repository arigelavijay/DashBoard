using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

using DataLayer;
using Telerik.Web.UI;
using System.Text;

namespace DashBoard
{
    public partial class _Default : System.Web.UI.Page
    {
        public string dbString = ConfigurationManager.ConnectionStrings["DBConn"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if(!IsPostBack)
                BindGrid();            
        }

        public void BindGrid()
        {
            using (var dt = access.GetAudioFiles(dbString))
            {
                grd.DataSource = dt;
                grd.DataBind();
            }
        }

        protected void grd_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridDataItem && e.Item.IsDataBound)
            {
                
                DataRowView drow = e.Item.DataItem as DataRowView;

                e.Item.Attributes["onmouseover"] = "javascript:setMouseOverColor2(this);";
                e.Item.Attributes["onmouseout"] = "javascript:setMouseOutColor2(this);";                

                Label lblFileReDt = e.Item.FindControl("lblFileReceiveDT") as Label;
                DateTime dt = Convert.ToDateTime(drow["FileReceiveDT"]);
                lblFileReDt.Text = dt.ToString();

                string strStatus = drow["Status"].ToString();
                Label lblStatus = e.Item.FindControl("lblStatus") as Label;
                lblStatus.Text = strStatus;
                lblStatus.ForeColor = strStatus == "Success" ? System.Drawing.Color.Green : System.Drawing.Color.Red;
                
                Label lblFileSize = e.Item.FindControl("lblFilesize") as Label;
                lblFileSize.Text = SetBytes(Convert.ToDecimal(drow["FileSize"]));

                CheckBox chkRedownload = e.Item.FindControl("chkRedownload") as CheckBox;
                chkRedownload.Checked = Convert.ToBoolean(drow["redownloadRequest"]);
            }
            else if (e.Item is GridFilteringItem)
            {
                GridFilteringItem Item = (GridFilteringItem)e.Item;
                RadComboBox comboGroupName = (RadComboBox)Item.FindControl("cmbGroupName");                

                string Query = "Select C.GroupName as GroupName,C.GroupCode as GroupCode from ToolAudioFiles A inner join DoctorDetails B ";
                Query += "on A.medantexID = B.medantexID inner join GroupDetails as C on B.GroupCode = C.GroupCode Group By C.GroupName,C.GroupCode ";

                comboGroupName.DataSource = access.GetQueryData(Query, dbString);
                comboGroupName.DataTextField = "GroupName";
                comboGroupName.DataValueField = "GroupName"; 
                comboGroupName.DataBind();                

                string Query2 = "Select B.DoctorCode1 as DoctorCode,B.DoctorShortName as DoctorName,B.MedantexId as medantexID from ToolAudioFiles A inner join DoctorDetails B ";
                Query2 += "on A.medantexID = B.medantexID inner join GroupDetails as C on B.GroupCode = C.GroupCode Group By B.DoctorCode1,B.DoctorShortName,B.MedantexId ";

                var dt = access.GetQueryData(Query2,dbString);

                RadComboBox comboDoctorName = (RadComboBox)Item.FindControl("cmbDoctorName");

                comboDoctorName.DataSource = dt;
                comboDoctorName.DataTextField = "DoctorName";
                comboDoctorName.DataValueField = "DoctorName";
                comboDoctorName.DataBind();                

                RadComboBox comboDoctorCode = (RadComboBox)Item.FindControl("cmbDoctorCode");

                comboDoctorCode.DataSource = dt;
                comboDoctorCode.DataTextField = "DoctorCode";
                comboDoctorCode.DataValueField = "DoctorCode";
                comboDoctorCode.DataBind();                

                RadComboBox comboMedantexID = (RadComboBox)Item.FindControl("cmbmedantexID");

                comboMedantexID.DataSource = dt;
                comboMedantexID.DataTextField = "MedantexID";
                comboMedantexID.DataValueField = "MedantexID";
                comboMedantexID.DataBind();                
            }
        }

        protected void grd_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
        {
            grd.DataSource = access.GetAudioFiles(dbString);
        }

        protected void grd_PreRender(object sender, EventArgs e)
        {
            if (grd.MasterTableView.FilterExpression != string.Empty)
            {
                RefreshCombos();
            }
        }

        protected void RefreshCombos()
        {
            grd.MasterTableView.Rebind();
        }

        protected void grd_ItemCommand(object sender, GridCommandEventArgs e)
        {
            if (e.CommandName == RadGrid.FilterCommandName)
            {
                Pair filterPair = (Pair)e.CommandArgument;               

                switch (filterPair.Second.ToString())
                {
                    case "FileReceiveDT":
                        this.FromDate = ((e.Item as GridFilteringItem)[filterPair.Second.ToString()].FindControl("FromFRdt") as RadDatePicker).SelectedDate;
                        this.ToDate = ((e.Item as GridFilteringItem)[filterPair.Second.ToString()].FindControl("ToFRdt") as RadDatePicker).SelectedDate;
                        break;                    
                    default:
                        break;
                }
            }
        }
       

        protected void grd_SortCommand(object sender, GridSortCommandEventArgs e)
        {
            string orderByFormat = "";
            switch (e.NewSortOrder)
            {
                case GridSortOrder.Ascending:
                    orderByFormat = "ORDER BY {0} ASC";
                    break;
                case GridSortOrder.Descending:
                    orderByFormat = "ORDER BY {0} DESC";
                    break;
            }
            switch (e.CommandArgument.ToString())
            {
                case "GroupName":
                    orderByFormat = string.Format(orderByFormat, "GroupName");
                    break;
                case "DoctorName":
                    orderByFormat = string.Format(orderByFormat, "DoctorName");
                    break;
                case "DoctorCode":
                    orderByFormat = string.Format(orderByFormat, "DoctorCode");
                    break;
                case "medantexID":
                    orderByFormat = string.Format(orderByFormat, "medantexID");
                    break;
                case "AudioFileName":
                    orderByFormat = string.Format(orderByFormat, "AudioFileName");
                    break;
                case "FileSize":
                    orderByFormat = string.Format(orderByFormat, "FileSize");
                    break;
                case "FileReceiveDT":
                    orderByFormat = string.Format(orderByFormat, "FileReceiveDT");
                    break;
                case "FileType":
                    orderByFormat = string.Format(orderByFormat, "FileType");
                    break;
                case "Status":
                    orderByFormat = string.Format(orderByFormat, "Status");
                    break;
                case "redownloadRequest":
                    orderByFormat = string.Format(orderByFormat, "redownloadRequest");
                    break;
                case "Uid":
                    orderByFormat = string.Format(orderByFormat, "Uid");
                    break;
            }

            StringBuilder sb = new StringBuilder();
            sb.Append("Select C.GroupName,B.DoctorShortName as DoctorName,B.DoctorCode1 as DoctorCode,B.medantexID as medantexID,A.OriginalFileName as AudioFileName,");
            sb.Append("A.FileSize as FileSize,A.file_Uploaded as FileReceiveDT,A.FileType as FileType,A.fileStatus as Status,A.redownloadRequest as redownloadRequest,A.Uid as Uid from ToolAudioFiles A");
            sb.Append(" inner join DoctorDetails B on A.medantexID = B.medantexID");
            sb.AppendFormat(" inner join GroupDetails as C on B.GroupCode = C.GroupCode {0}", orderByFormat);

            e.Item.OwnerTableView.DataSource = access.GetQueryData(sb.ToString(), dbString);
            e.Item.OwnerTableView.Rebind();
        }
        
        protected void cmbFilterTemplate_PreRender(object sender, EventArgs e)
        {
            RadComboBox combo = (RadComboBox)sender;
            if (ViewState[combo.ClientID] != null)
                combo.SelectedValue = Convert.ToString(ViewState[combo.ClientID]);
        }

        protected void cmbFilterTemplate_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            RadComboBox combo = sender as RadComboBox;
            ViewState[combo.ClientID] = e.Value;            
        }
        
        protected DateTime? FromDate
        {
            set
            {
                ViewState["strD"] = value;
            }
            get
            {
                if (ViewState["strD"] != null)
                    return (DateTime)ViewState["strD"];
                else
                    return new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day);
            }
        }
        protected DateTime? ToDate
        {
            set
            {
                ViewState["endD"] = value;
            }
            get
            {
                if (ViewState["endD"] != null)
                    return (DateTime)ViewState["endD"];
                else
                    return new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day);
            }
        }

        public string SetBytes(decimal Bytes)
        {
            var SetBytes = "";
            if (Bytes >= 1073741824)
                SetBytes = string.Format("{0} GB", Math.Round(Bytes / 1024 / 1024 / 1024,2));
            else if(Bytes >= 1048576)
                SetBytes = string.Format("{0} MB", Math.Round(Bytes / 1024 / 1024,2));
            else if(Bytes >= 1024)
                SetBytes = string.Format("{0} KB", Math.Round(Bytes / 1024));
            else if(Bytes < 1024)
                SetBytes = Math.Truncate(Bytes) + " Bytes";
            return SetBytes;
        }
    }
}

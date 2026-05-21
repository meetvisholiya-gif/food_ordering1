<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="OrderStatus.aspx.cs" Inherits="Foodie.Admin.OrderStatus" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        /*For disappearing alert message*/
        window.onload = function () {
            var seconds = 5;
            setTimeout(function () {
                document.getElementById("<%=lblMsg.ClientID %>").style.display = "none";
            }, seconds * 1000);
        };
    </script>
 <style>
    .sub-title {
        font-size: 22px;
        font-weight: 600;
        margin-bottom: 20px;
        color: #343a40;
        border-left: 5px solid #007bff;
        padding-left: 12px;
    }

    .card {
        border-radius: 12px;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        background: #ffffff;
    }

    .card-header {
        background-color: #007bff;
        color: white;
        padding: 18px 24px;
        font-size: 20px;
        font-weight: bold;
        border-top-left-radius: 12px;
        border-top-right-radius: 12px;
    }

    .card-block {
        padding: 28px;
    }

    .table-responsive {
        border: 1px solid #dee2e6;
        border-radius: 8px;
        background-color: #fdfdfd;
        max-height: 500px;
        overflow-y: auto;
    }

    .table th, .table td {
        font-size: 16px;
        padding: 14px 20px;
        vertical-align: middle;
    }

    .table th {
        background-color: #f8f9fa;
        color: #495057;
        font-weight: 600;
    }

    .table tbody tr:hover {
        background-color: #f1f3f5;
        transition: 0.2s ease-in-out;
    }

    .badge {
        font-size: 15px;
        padding: 8px 14px;
        border-radius: 20px;
        font-weight: 500;
    }

    .badge-success {
        background-color: #28a745;
        color: #fff;
    }

    .badge-warning {
        background-color: #ffc107;
        color: #212529;
    }

    .badge-primary {
        background-color: #007bff;
        color: white;
        cursor: pointer;
    }

    .form-control {
        border-radius: 8px;
        border: 1px solid #ced4da;
        padding: 12px 14px;
        font-size: 16px;
    }

    .form-group label {
        font-weight: 500;
        color: #495057;
        font-size: 16px;
    }

    .btn-primary {
        background-color: #007bff;
        border: none;
        padding: 12px 22px;
        border-radius: 8px;
        font-size: 16px;
        font-weight: 500;
    }

    .btn-primary:hover {
        background-color: #0056b3;
    }

    .mobile-inputs {
        background-color: #f8f9fc;
        border-radius: 12px;
        padding: 24px;
        box-shadow: 0 0 10px rgba(0, 123, 255, 0.1);
    }

    .pb-5 {
        padding-bottom: 1.25rem !important;
    }

    .text-danger {
        color: #dc3545;
    }

    .align-align-self-end {
        text-align: right;
        margin-bottom: 12px;
        padding-right: 16px;
        font-size: 15px;
    }
    .col-lg-8 {
    -webkit-box-flex: 0;
    -webkit-flex: 0 0 66.666667%;
    -ms-flex: 0 0 66.666667%;
    flex: 0 0 66.666667%;
    max-width: 100%;
}
</style>


</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="pcoded-inner-content pt-0">
        <div class="align-align-self-end">
            <asp:Label ID="lblMsg" runat="server" Visible="false"></asp:Label>
        </div>

        <div class="main-body">
            <div class="page-wrapper">
                <div class="page-body">
                    <div class="row">
                        <div class="col-sm-12">
                            <div class="card">
                                <div class="card-header">
                                </div>
                                <div class="card-block">
                                    <div class="row">

                                        <div class="col-sm-6 col-md-8 col-lg-8">
                                            <h4 class="sub-title">Order List</h4>

                                            <div class="card-block table-border-style">
                                                <div class="table-responsive" style="max-height: 400px; overflow-y: auto;">
                                                    <asp:Repeater ID="rOrderStatus" runat="server" OnItemCommand="rOrderStatus_ItemCommand">
                                                        <HeaderTemplate>
                                                            <table class="table table-striped table-hover nowrap">
                                                                <thead>
                                                                    <tr>
                                                                        <th class="table-plus">Order No.</th>
                                                                        <th>Order Date</th>
                                                                        <th>Status</th>
                                                                        <th>Product Name</th>
                                                                        <th>Product Price</th>
                                                                        <th>Payment Mode</th>
                                                                        <th class="datatable-nosort">Edit</th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody>
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <tr>
                                                                <td class="table-plus"><%# Eval("OrderNo") %> </td>
                                                                <td><%# Eval("OrderDate") %> </td>
                                                                <td>
                                                                    <asp:Label ID="lblStatus" runat="server" Text='<%# Eval("Status") %>'
                                                                        CssClass='<%# Eval("Status").ToString() == "Delivered" ? "badge badge-success" : "badge badge-warning" %>'>
                                                                    </asp:Label>
                                                                </td>
                                                                <td><%# Eval("Name") %> </td>
                                                                <td><%# Eval("TotalPrice") %> </td>
                                                                <td><%# Eval("PaymentMode") %> </td>
                                                                <td>
                                                                    <asp:LinkButton ID="lnkEdit" Text="Edit" runat="server" CssClass="badge badge-primary"
                                                                        CommandArgument='<%# Eval("OrderDetailsId") %>' CommandName="edit">
                                                                            <i class="ti-pencil"></i>
                                                                    </asp:LinkButton>
                                                                </td>
                                                            </tr>
                                                        </ItemTemplate>
                                                        <FooterTemplate>
                                                            </tbody>
                                                            </table>
                                                        </FooterTemplate>
                                                    </asp:Repeater>

                                                </div>
                                            </div>

                                        </div>


                                        <div class="col-sm-6 col-md-4 col-lg-4 mobile-inputs">
                                            <asp:Panel ID="pUpdateOrderStatus" runat="server">
                                                <h4 class="sub-title">Update Status</h4>
                                                <div>
                                                    <div class="form-group">
                                                        <label>Order Status</label>
                                                    </div>
                                                    <asp:DropDownList ID="ddlOrderStatus" runat="server" CssClass="form-control">
                                                        <asp:ListItem Value="0">Select Status</asp:ListItem>
                                                        <asp:ListItem>Pending</asp:ListItem>
                                                        <asp:ListItem>Dispatched</asp:ListItem>
                                                        <asp:ListItem>Delivered</asp:ListItem>
                                                    </asp:DropDownList>
                                                    <asp:RequiredFieldValidator ID="rfvDdlOrderStatus" runat="server" ForeColor="Red" ControlToValidate="ddlOrderStatus"
                                                        ErrorMessage="Order status is required" SetFocusOnError="true" Display="Dynamic" InitialValue="0"></asp:RequiredFieldValidator>
                                                    <asp:HiddenField ID="hdnId" runat="server" Value="0" />
                                                </div>                                              
                                                <div class="pb-5">
                                                    <asp:Button ID="btnUpdate" runat="server" Text="Update" CssClass="btn btn-primary"
                                                        OnClick="btnUpdate_Click" />
                                                    &nbsp;
                                                <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-primary"
                                                    OnClick="btnCancel_Click" />
                                                </div>                                             
                                            </asp:Panel>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
</asp:Content>

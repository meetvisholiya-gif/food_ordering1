<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Category.aspx.cs" Inherits="Foodie.Admin.Category" %>

<%@ Import Namespace="Foodie" %>
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
    <script>
        function ImagePreview(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function (e) {
                    $('#<%=imgCategory.ClientID%>').prop('src', e.target.result)
                        .width(200)
                        .height(200);
                };
                reader.readAsDataURL(input.files[0]);
            }
        }
    </script>
    <style>
        /* General Styles */
body {
    font-family: Arial, sans-serif;
    background-color: #f4f7fa;
    margin: 0;
    padding: 0;
}

.pcoded-inner-content {
    padding-top: 0;
    background-color: #fff;
}

.card {
    border-radius: 10px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    background-color: #fff;
}

.card-header {
    background-color: #f1f3f8;
    padding: 10px 15px;
    font-size: 18px;
    font-weight: bold;
}

.card-block {
    padding: 20px;
}

.sub-title {
    font-size: 18px;
    font-weight: bold;
    margin-bottom: 20px;
}

/* Form Group Styles */
.form-group {
    margin-bottom: 15px;
}

label {
    font-size: 14px;
    color: #333;
}

input[type="text"], .form-control, .file-upload, .form-check-input {
    width: 100%;
    padding: 8px;
    font-size: 14px;
    border: 1px solid #ddd;
    border-radius: 5px;
    margin-top: 5px;
}

input[type="text"]:focus {
    border-color: #0069d9;
    box-shadow: 0 0 5px rgba(0, 105, 217, 0.5);
}

/* Buttons */
.btn {
    padding: 8px 15px;
    font-size: 14px;
    font-weight: bold;
    border-radius: 5px;
    cursor: pointer;
    transition: all 0.3s ease;
}

.btn-primary {
    background-color: #0069d9;
    color: #fff;
    border: none;
}

.btn-primary:hover {
    background-color: #0056b3;
}

/* Checkbox */
.form-check {
    margin-top: 10px;
}

.form-check-input {
    margin-right: 10px;
}

/* Category Table */
.table {
    width: 100%;
    margin-top: 20px;
    border-collapse: collapse;
}

.table th, .table td {
    padding: 10px;
    text-align: left;
    border-bottom: 1px solid #ddd;
}

.table-plus {
    padding-left: 15px;
}

.table th {
    background-color: #f1f3f8;
    color: #333;
}

.table td img {
    max-width: 100px;
    border-radius: 5px;
}

.table-hover tbody tr:hover {
    background-color: #f8f9fa;
}

.datatable-nosort {
    text-align: center;
}

/* Image Thumbnail */
.img-thumbnail {
    width: 100px;
    height: 100px;
    object-fit: cover;
    border-radius: 5px;
    margin-top: 15px;
}

/* Responsive Design */
@media (max-width: 768px) {
    .mobile-inputs {
        margin-top: 20px;
    }
    .col-sm-6, .col-md-4, .col-md-8, .col-lg-4, .col-lg-8 {
        width: 100%;
        margin-bottom: 20px;
    }
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

                                        <div class="col-sm-6 col-md-4 col-lg-4">
                                            <h4 class="sub-title">Category</h4>
                                            <div>
                                                <div class="form-group">
                                                    <label>Category Name</label>
                                                </div>
                                                <asp:TextBox ID="txtName" runat="server" CssClass="form-control"
                                                    placeholder="Enter Category Name" required></asp:TextBox>
                                                <asp:HiddenField ID="hdnId" runat="server" Value="0" />
                                            </div>
                                        </div>
                                        <div class="from-group">
                                            <label>Category Image</label>
                                            <div>
                                                <asp:FileUpload ID="fuCategoryImage" runat="server" CssClass="from-control"
                                                    onchange="ImagePreview(this);" />
                                            </div>
                                        </div>
                                        <div class="form-check pl-4">
                                            <asp:CheckBox ID="cbIsActive" runat="server" Text="&nbsp; IsActive"
                                                CssClass="form-check-input" />
                                        </div>
                                        <div class="pb-5">
                                            <asp:Button ID="btnAddOrUpdate" runat="server" Text="Add" CssClass="btn btn-primary"
                                                OnClick="btnAddOrUpdate_Click" />
                                            &nbsp;
                                        <asp:Button ID="btnClear" runat="server" Text="Clear" CssClass="btn btn-primary"
                                            CausesValidation="false" OnClick="btnClear_Click" />
                                        </div>
                                        <div>
                                            <asp:Image ID="imgCategory" runat="server" CssClass="img-thumbnail" />
                                        </div>
                                    </div>
                                </div>


                                <div class="col-sm-6 col-md-8 col-lg-8 mobile-inputs">
                                    <h4 class="sub-title">Category Lists</h4>
                                    <div class="card-block table-border-style">
                                        <div class="table-responsive" style="max-height: 400px; overflow-y: auto;">
                                            <asp:Repeater ID="rCategory" runat="server" OnItemCommand="rCategory_ItemCommand"
                                                OnItemDataBound="rCategory_ItemDataBound">
                                                <HeaderTemplate>
                                                    <table class="table table-striped table-hover nowrap">
                                                        <thead>
                                                            <tr>
                                                                <th class="table-plus">Name</th>
                                                                <th>Image</th>
                                                                <th>IsActive</th>
                                                                <th>CreatedDate</th>
                                                                <th class="datatable-nosort">Action</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <tr>
                                                        <td class="table-plus"><%# Eval("Name") %> </td>
                                                        <td>
                                                            <img alt="" width="80" src="<%# Utils.GetImageUrl( Eval("ImageUrl")) %>" />
                                                        </td>
                                                        <td>
                                                            <asp:Label ID="lblIsActive" runat="server" Text='<%# Eval("IsActive") %>'></asp:Label>
                                                        </td>
                                                        <td><%# Eval("CreatedDate") %> </td>
                                                        <td>
                                                            <asp:LinkButton ID="lnkEdit" Text="Edit" runat="server" CssClass="badge badge-primary"
                                                                CommandArgument='<%# Eval("CategoryId") %>' CommandName="edit">
                                                            <i class="ti-pencil"></i>
                                                            </asp:LinkButton>
                                                            <asp:LinkButton ID="lnkDelete" runat="server" CssClass="badge bg-danger"
                                                                CommandName="delete" CommandArgument='<%# Eval("CategoryId") %>'
                                                                OnClientClick="return confirm('Do you want to delete this category?');">
                                                             <i class="ti-trash"></i>
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
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

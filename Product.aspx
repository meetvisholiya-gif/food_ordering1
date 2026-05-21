<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Product.aspx.cs" Inherits="Foodie.Admin.Product" %>

<%@ Import Namespace="Foodie" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        window.onload = function () {
            var seconds = 5;
            setTimeout(function () {
                document.getElementById("<%=lblMsg.ClientID %>").style.display = "none";
            }, seconds * 1000);
        };

        function ImagePreview(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function (e) {
                    $('#<%=imgProduct.ClientID%>').prop('src', e.target.result)
                        .width(200)
                        .height(200);
                };
                reader.readAsDataURL(input.files[0]);
            }
        }

        function toggleFormVisibility() {
            var form = document.getElementById('productForm');
            if (form.style.display === 'none' || form.style.display === '') {
                form.style.display = 'block';
            } else {
                form.style.display = 'none';
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

        .container-fluid {
            margin-top: 20px;
        }

        .card {
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            background-color: #fff;
        }

        .card-header {
            background-color: #007bff;
            color: #fff;
            padding: 15px;
            font-size: 18px;
            font-weight: bold;
            text-align: center;
        }

        .card-body {
            padding: 20px;
        }

        .form-group {
            margin-bottom: 15px;
        }

        label {
            font-size: 14px;
            color: #333;
            margin-bottom: 5px;
        }

        input[type="text"], .form-control, .file-upload, select {
            width: 100%;
            padding: 10px;
            font-size: 14px;
            border: 1px solid #ddd;
            border-radius: 5px;
            margin-top: 5px;
        }

        /* Product Form Visibility */
        #productForm {
            display: none;
        }

        .btn-toggle-form {
            margin-top: 10px;
            background-color: #007bff;
            color: white;
            padding: 10px 20px;
            cursor: pointer;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid">
        <div class="row">
            <!-- Left Side: Product Form Toggle Button -->
            <div class="col-md-12">
             <button type="button" class="btn-toggle-form" onclick="toggleFormVisibility()">Add New Product</button>

            </div>

            <!-- Left Side: Product Form (Initially Hidden) -->
            <div class="col-md-12 mt-3" id="productForm">
                <div class="card">
                    <div class="card-header">
                        <h4>Product Details</h4>
                    </div>
                    <div class="card-body">
                        <asp:Label ID="lblMsg" runat="server" Visible="false" CssClass="text-danger"></asp:Label>
                        <asp:HiddenField ID="hdnId" runat="server" Value="0" />

                        <div class="form-group">
                            <label>Product Name</label>
                            <asp:TextBox ID="txtName" runat="server" CssClass="form-control" placeholder="Enter Product Name"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Name is required" ForeColor="Red" ControlToValidate="txtName" Display="Dynamic"></asp:RequiredFieldValidator>
                        </div>

                        <div class="form-group">
                            <label>Product Description</label>
                            <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" placeholder="Enter Product Description" TextMode="MultiLine"></asp:TextBox>
                        </div>

                        <div class="form-group">
                            <label>Product Price (₹)</label>
                            <asp:TextBox ID="txtPrice" runat="server" CssClass="form-control" placeholder="Enter Product Price"></asp:TextBox>
                        </div>

                        <div class="form-group">
                            <label>Product Quantity</label>
                            <asp:TextBox ID="txtQuantity" runat="server" CssClass="form-control" placeholder="Enter Product Quantity"></asp:TextBox>
                        </div>

                        <div class="form-group">
                            <label>Product Image</label>
                            <asp:FileUpload ID="fuProductImage" runat="server" CssClass="form-control" onchange="ImagePreview(this);" />
                            <asp:Image ID="imgProduct" runat="server" CssClass="img-thumbnail mt-2" Width="150" Height="150" />
                        </div>

                        <div class="form-group">
                            <label>Product Category</label>
                            <asp:DropDownList ID="ddlCategories" runat="server" CssClass="form-control" DataSourceID="SqlDataSource1" DataTextField="Name" DataValueField="CategoryId" AppendDataBoundItem="true">
                                <asp:ListItem Value="0">Select Category</asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <div class="form-check">
                            <asp:CheckBox ID="cbIsActive" runat="server" Text="&nbsp; IsActive" CssClass="form-check-input" />
                        </div>

                        <div class="form-group mt-3">
                            <asp:Button ID="btnAddOrUpdate" runat="server" Text="Add" CssClass="btn btn-primary" OnClick="btnAddOrUpdate_Click" />
                            <asp:Button ID="btnClear" runat="server" Text="Clear" CssClass="btn btn-secondary" CausesValidation="false" OnClick="btnClear_Click" />
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Side: Category List -->
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header">
                        <h4>Category List</h4>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive" style="max-height: 400px; overflow-y: auto;">
                            <asp:Repeater ID="rProduct" runat="server" OnItemCommand="rProduct_ItemCommand" OnItemDataBound="rProduct_ItemDataBound">
                                <HeaderTemplate>
                                    <table class="table table-striped table-hover">
                                        <thead>
                                            <tr>
                                                <th class="table-plus">Name</th>
                                                <th>Image</th>
                                                <th>Price(₹)</th>
                                                <th>Qty</th>
                                                <th>Category</th>
                                                <th>IsActive</th>
                                                <th>Description</th>
                                                <th class="datatable-nosort">Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr>
                                        <td><%# Eval("Name") %></td>
                                        <td><img src="<%# Utils.GetImageUrl(Eval("ImageUrl")) %>" width="80" /></td>
                                        <td><%# Eval("Price") %></td>
                                        <td><asp:Label ID="lblQuantity" runat="server" Text='<%# Eval("Quantity") %>'></asp:Label></td>
                                        <td><%# Eval("CategoryName") %></td>
                                        <td><asp:Label ID="lblIsActive" runat="server" Text='<%# Eval("IsActive") %>'></asp:Label></td>
                                        <td><%# Eval("Description") %></td>
                                        <td>
                                            <asp:LinkButton ID="lnkEdit" runat="server" Text="Edit" CssClass="btn btn-sm btn-primary" CausesValidation="false" CommandArgument='<%# Eval("ProductId") %>' CommandName="edit">
                                                <i class="ti-pencil"></i>
                                            </asp:LinkButton>
                                            <asp:LinkButton ID="lnkDelete" runat="server" Text="Delete" CssClass="btn btn-sm btn-danger" CommandName="delete" CommandArgument='<%# Eval("ProductId") %>' OnClientClick="return confirm('Do you want to delete this product?');" CausesValidation="false">
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

    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:cs %>" SelectCommand="SELECT [CategoryId], [Name] FROM [Categories]"></asp:SqlDataSource>
</asp:Content>

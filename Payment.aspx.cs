using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace Foodie.User
{
    public partial class Payment : System.Web.UI.Page
    {
        SqlConnection con;
        SqlCommand cmd;
        DataTable dt;
        SqlTransaction transaction = null;
        string _name = "", _cardNo = "", _expiryDate = "", _cvv = "";
        string _address = "", _paymentMode = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && Session["userId"] == null)
            {
                Response.Redirect("Login.aspx");
            }
        }

        protected void lbCardSubmit_Click(object sender, EventArgs e)
        {
            _name = txtName.Text.Trim();
            _cardNo = string.Format("************{0}", txtCardNo.Text.Trim().Substring(12, 4));
            _expiryDate = txtExpMonth.Text.Trim() + "/" + txtExpYear.Text.Trim();
            _cvv = txtCvv.Text.Trim();
            _address = txtAddress.Text.Trim();
            _paymentMode = "card";

            if (Session["userId"] != null)
                OrderPayment(_name, _cardNo, _expiryDate, _cvv, _address, _paymentMode);
            else
                Response.Redirect("Login.aspx");
        }

        protected void lbCodSubmit_Click(object sender, EventArgs e)
        {
            _address = txtCODAddress.Text.Trim();
            _paymentMode = "cod";

            if (Session["userId"] != null)
                OrderPayment(_name, _cardNo, _expiryDate, _cvv, _address, _paymentMode);
            else
                Response.Redirect("Login.aspx");
        }

        void OrderPayment(string name, string cardNo, string expiryDate, string cvv, string address, string paymentMode)
        {
            int paymentId;
            dt = new DataTable();
            dt.Columns.AddRange(new DataColumn[]
            {
                new DataColumn("OrderNo", typeof(string)),
                new DataColumn("ProuctId", typeof(int)),
                new DataColumn("Quantity", typeof(int)),
                new DataColumn("UserId", typeof(int)),
                new DataColumn("Status", typeof(string)),
                new DataColumn("PaymentId", typeof(int)),
                new DataColumn("OrderDate", typeof(DateTime)),
            });

            con = new SqlConnection(Connection.GetConnectionString());
            con.Open();
            transaction = con.BeginTransaction();

            try
            {
                // Save payment
                cmd = new SqlCommand("Save_Payment", con, transaction);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Name", name);
                cmd.Parameters.AddWithValue("@CardNo", cardNo);
                cmd.Parameters.AddWithValue("@ExpiryDate", expiryDate);
                cmd.Parameters.AddWithValue("@Cvv", cvv);
                cmd.Parameters.AddWithValue("@Address", address);
                cmd.Parameters.AddWithValue("@PaymentMode", paymentMode);
                SqlParameter outParam = new SqlParameter("@InsertedId", SqlDbType.Int)
                {
                    Direction = ParameterDirection.Output
                };
                cmd.Parameters.Add(outParam);

                cmd.ExecuteNonQuery();
                paymentId = Convert.ToInt32(outParam.Value);

                // Step 1: Get all cart items into memory
                List<Tuple<int, int>> cartItems = new List<Tuple<int, int>>();
                cmd = new SqlCommand("Cart_Crud", con, transaction)
                {
                    CommandType = CommandType.StoredProcedure
                };
                cmd.Parameters.AddWithValue("@Action", "SELECT");
                cmd.Parameters.AddWithValue("@UserId", Session["userId"]);
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        int pid = (int)dr["ProductId"];
                        int qty = (int)dr["Quantity"];
                        cartItems.Add(Tuple.Create(pid, qty));
                    }
                }

                // Step 2: Loop cart items and process each
                foreach (var item in cartItems)
                {
                    int productId = item.Item1;
                    int quantity = item.Item2;

                    UpdateQuantity(productId, quantity, transaction, con);
                    DeleteCartItem(productId, transaction, con);

                    dt.Rows.Add(Utils.GetUniqueId(), productId, quantity, (int)Session["userId"],
                        "Pending", paymentId, DateTime.Now);
                }

                // Save order details
                if (dt.Rows.Count > 0)
                {
                    cmd = new SqlCommand("Save_Orders", con, transaction);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@tblOrders", dt);
                    cmd.ExecuteNonQuery();
                }

                transaction.Commit();
                lblMsg.Visible = true;
                lblMsg.Text = "Your item ordered successfully!";
                lblMsg.CssClass = "alert alert-success";
                Response.AddHeader("REFRESH", "1;URL=Invoice.aspx?id=" + paymentId);
            }
            catch (Exception e)
            {
                try { transaction.Rollback(); } catch { }
                lblMsg.Visible = true;
                lblMsg.Text = "Order failed: " + e.Message;
                lblMsg.CssClass = "alert alert-danger";
            }
            finally
            {
                con.Close();
            }
        }

        void UpdateQuantity(int productId, int quantity, SqlTransaction transaction, SqlConnection connection)
        {
            int dbQuantity = 0;
            cmd = new SqlCommand("Product_Crud", connection, transaction)
            {
                CommandType = CommandType.StoredProcedure
            };
            cmd.Parameters.AddWithValue("@Action", "GETBYID");
            cmd.Parameters.AddWithValue("@ProductId", productId);

            using (SqlDataReader dr1 = cmd.ExecuteReader())
            {
                if (dr1.Read())
                {
                    dbQuantity = (int)dr1["Quantity"];
                }
            }

            if (dbQuantity >= quantity)
            {
                cmd = new SqlCommand("Product_Crud", connection, transaction)
                {
                    CommandType = CommandType.StoredProcedure
                };
                cmd.Parameters.AddWithValue("@Action", "QTYUPDATE");
                cmd.Parameters.AddWithValue("@Quantity", dbQuantity - quantity);
                cmd.Parameters.AddWithValue("@ProductId", productId);
                cmd.ExecuteNonQuery();
            }
        }

        void DeleteCartItem(int productId, SqlTransaction transaction, SqlConnection connection)
        {
            cmd = new SqlCommand("Cart_Crud", connection, transaction)
            {
                CommandType = CommandType.StoredProcedure
            };
            cmd.Parameters.AddWithValue("@Action", "DELETE");
            cmd.Parameters.AddWithValue("@ProductId", productId);
            cmd.Parameters.AddWithValue("@UserId", Session["userId"]);
            cmd.ExecuteNonQuery();
        }
    }
}

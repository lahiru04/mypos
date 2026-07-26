using System.Windows;
using FreePOS.Views.finance;
using FreePOS.Views.others;

using FreePOS.Views.product;
using FreePOS.bll;
using FreePOS.data;
using System.Runtime.InteropServices;
using System.Linq;
using System.Collections.Generic;
using System;
// Removed Telerik charting/document list dependencies
using System.Collections.ObjectModel;
using FreePOS.data.dapper;
using System.Windows.Controls;
using MySql.Data.MySqlClient;
using Dapper;

namespace FreePOS.Views
{

    [ComVisible(true)]
    public partial class Dashboard : Window
    {
       
        data.dapper.user loggininuserd;
        // Charting removed: collection placeholder

        public Dashboard()
        {
            InitializeComponent();
           
            loaccounts();
            TimeUtils.setIntervalInUIThread(() =>
            {
                loaccounts();
                return 0;
            }, 30000);
        }
        void loaccounts()
        {
            var userrepo = new userrepo();
            var financetransactionrepo = new financetransactionrepo();
            var sales = 0;
            var customers = 0;
            var vendors = 0;
            var product_count = 0;
            var users = 0;
            decimal monthly_target = 0;
            decimal monthly_revenue = 0;
            decimal today_revenue = 0;
            if (userutils.loggedinuserd.role == "superadmin" || userutils.loggedinuserd.role == "admin")
            {
                sales = -financetransactionrepo.gettransactionsumbyaccountnamesandfromtodate(new string[] { "pos sale","sale","service sale"},DateTime.Now,DateTime.Now);
                customers = userrepo.getbywherein("role", new object[] { "customer" }).Count();
                vendors = userrepo.getbywherein("role", new object[] { "vendor" }).Count();
                users = userrepo.getbywherein("role", new object[] { "admin", "user" }).Count();
            }
            
            // Update WebView content asynchronously (fire-and-forget)
            // get product count where status = 1
            try
            {
                var conn = databaseutils.connectionstring;
                using (var connection = new MySqlConnection(conn))
                {
                    product_count = connection.QuerySingle<int>("select count(*) from product where status=1");
                }
            }
            catch
            {
                product_count = 0;
            }

            try
            {
                var mrepo = new data.dapper.monthly_targetrepo();
                var mlist = mrepo.get();
                var current = mlist.Where(m => m.month != null && ((DateTime)m.month).Month == DateTime.Now.Month && ((DateTime)m.month).Year == DateTime.Now.Year).FirstOrDefault();
                if (current != null && current.target != null) monthly_target = current.target.Value;

                var fromMonth = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
                var nextMonth = fromMonth.AddMonths(1);
                using (var connection = new MySqlConnection(databaseutils.connectionstring))
                {
                    // sum invoice_payment.payment_amount for current month
                    var mres = connection.ExecuteScalar<decimal?>("select sum(payment_amount) from invoice_payment where created_at >= @from and created_at < @to and deleted_at is null;", new { from = fromMonth, to = nextMonth });
                    monthly_revenue = mres ?? 0;

                    // today revenue: sum for today
                    var fromToday = DateTime.Today;
                    var toTomorrow = fromToday.AddDays(1);
                    var tres = connection.ExecuteScalar<decimal?>("select sum(payment_amount) from invoice_payment where created_at >= @from and created_at < @to and deleted_at is null;", new { from = fromToday, to = toTomorrow });
                    today_revenue = tres ?? 0;
                }
            }
            catch
            {
                monthly_target = 0;
                monthly_revenue = 0;
                today_revenue = 0;
            }

            _ = SetDashboardHtmlAsync(sales, customers, vendors, users, product_count, monthly_target, monthly_revenue, today_revenue);
        }

        private async System.Threading.Tasks.Task SetDashboardHtmlAsync(int sales, int customers, int vendors, int users, int product_count, decimal monthly_target, decimal monthly_revenue, decimal today_revenue)
        {
            try
            {
                string assetsPath = System.IO.Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "assets", "dashboard.html");
                if (!System.IO.File.Exists(assetsPath))
                {
                    var projectRoot = System.IO.Path.GetFullPath(System.IO.Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "..", ".."));
                    var alt = System.IO.Path.Combine(projectRoot, "assets", "dashboard.html");
                    if (System.IO.File.Exists(alt)) assetsPath = alt;
                }

                string html;
                if (System.IO.File.Exists(assetsPath))
                {
                    html = System.IO.File.ReadAllText(assetsPath);
                    html = html.Replace("sales_value", sales.ToString());
                    html = html.Replace("customer_count", customers.ToString());
                    html = html.Replace("vendor_count", vendors.ToString());
                    html = html.Replace("product_count", product_count.ToString());
                    html = html.Replace("user_count", users.ToString());

                    // replace monthly target and revenues
                    html = html.Replace("monthly_target", monthly_target.ToString());
                    html = html.Replace("monthly_revenue", monthly_revenue.ToString());
                    html = html.Replace("today_revenue", today_revenue.ToString());

                    // percentage of target achieved
                    var percent = 0m;
                    if (monthly_target > 0) percent = Math.Round(((decimal)monthly_revenue / monthly_target) * 100, 2);
                    html = html.Replace("monthly_target_percent", percent.ToString() + "%");
                    // simple change indicator placeholder
                    var change = "";
                    if (monthly_target > 0) change = ((percent - 0) >= 0 ? "+" : "") + "0%"; else change = "";
                    html = html.Replace("monthly_target_change", change);
                }
                else
                {
                    html = $"<html><body><h3>Sales: {sales}</h3><h3>Customers: {customers}</h3><h3>Vendors: {vendors}</h3><h3>Users: {users}</h3><p>assets/dashboard.html not found.</p></body></html>";
                }

                // Ensure WebView2 core is initialized before navigating
                try
                {
                    await webview.EnsureCoreWebView2Async(null).ConfigureAwait(true);
                }
                catch
                {
                    // Ignore initialization errors; NavigateToString may still work
                }

                // Navigate on UI thread
                await System.Windows.Application.Current.Dispatcher.InvokeAsync(() =>
                {
                    webview.NavigateToString(html);
                });
            }
            catch (Exception ex)
            {
                var fallback = $"<html><body><h3>Sales: {sales}</h3><h3>Customers: {customers}</h3><h3>Vendors: {vendors}</h3><h3>Users: {users}</h3><p>Error: {ex.Message}</p></body></html>";
                await System.Windows.Application.Current.Dispatcher.InvokeAsync(() => webview.NavigateToString(fallback));
            }
        }

        #region customer
        private void mi_AddNewCustomer(object sender, RoutedEventArgs e)
        {
            new user.Add("customer").Show();
        }
        private void mi_ViewAllCustomers(object sender, RoutedEventArgs e)
        {
            var w = new user.List("customer");
            userutils.authorizerole(w, new string[] { "superadmin", "admin" });
        }
        #endregion customer

        private void ReloadDashboard_Click(object sender, RoutedEventArgs e)
        {
            loaccounts();
        }

        #region vendor
        private void mi_ViewAllVendors(object sender, RoutedEventArgs e)
        {
            userutils.authorizerole(new user.List("vendor"), new string[] {"superadmin","admin"});
        }
        private void mi_AddNewVendor(object sender, RoutedEventArgs e)
        {
            userutils.authorizerole(new user.Add("vendor"), new string[] { "superadmin", "admin" });
        }
        #endregion vendor


        #region staff
        private void mi_AddAdmin(object sender, RoutedEventArgs e)
        {
            userutils.authorizerole(new user.Add("admin"), new string[] { "superadmin", "admin" });
        }

        private void mi_AllAdmin(object sender, RoutedEventArgs e)
        {
            userutils.authorizerole(new user.List("admin"), new string[] { "superadmin", "admin" });
        }
        private void mi_AddUser(object sender, RoutedEventArgs e)
        {
            userutils.authorizerole(new user.Add("user"), new string[] { "superadmin", "admin" });
        }

        private void mi_AllUser(object sender, RoutedEventArgs e)
        {
            userutils.authorizerole(new user.List("user"), new string[] { "superadmin", "admin" });
        }
        #endregion staff


        #region menuitem_products
        private void productadd(object sender, RoutedEventArgs e)
        {
           new ProductAdd().Show();
        }
        private void products(object sender, RoutedEventArgs e)
        {
            var w = new ProductList();
            userutils.authorizerole(w, new string[] { "superadmin", "admin" });
        }
        private void product_inventoryValueReport(object sender, RoutedEventArgs e)
        {
            var w = new  InventoryValueReport();
            userutils.authorizerole(w, new string[] { "superadmin", "admin" });
        }
        #endregion menuitem_products

        #region menuitem_finance
        private void accountsshow(object sender, RoutedEventArgs e)
        {
            var w = new accounts();
            userutils.authorizerole(w, new string[] { "superadmin", "admin" });
        }
        private void accountsbalanceshow(object sender, RoutedEventArgs e)
        {
            var w = new accountsbalance();
            userutils.authorizerole(w, new string[] { "superadmin", "admin" });
        }
        private void pos(object sender, RoutedEventArgs e)
        {
            new pos().Show();
        }
        private void salenewshow(object sender, RoutedEventArgs e)
        {
            new salenew().Show();
        }
        private void transactionsshow(object sender, RoutedEventArgs e)
        {
            var w = new transactions();
            userutils.authorizerole(w, new string[] { "superadmin", "admin" });
        }
        private void salesshow(object sender, RoutedEventArgs e)
        {
            var w = new Views.finance.salespurchases("sale");
            userutils.authorizerole(w, new string[] { "superadmin", "admin" });
        }
        private void purchasenewshow(object sender, RoutedEventArgs e)
        {
            var w  = new Views.finance.purchasenew();
            userutils.authorizerole(w,new string[] { "superadmin", "admin" });
        }
        private void purchasesshow(object sender, RoutedEventArgs e)
        {
            var w = new Views.finance.salespurchases("purchase");
            userutils.authorizerole(w, new string[] { "superadmin", "admin" });
        }
        private void expencesshow(object sender, RoutedEventArgs e)
        {
            var w = new Views.finance.expences();
            userutils.authorizerole(w, new string[] { "superadmin", "admin" });
        }
        private void cashclosingadd(object sender, RoutedEventArgs e)
        {
            new Views.finance.cashclosingadd().Show();
        }
        private void cashclosing(object sender, RoutedEventArgs e)
        {
            var w = new Views.finance.cashclosing();
            userutils.authorizerole(w, new string[] { "superadmin", "admin" });
        }
        private void monthlytargetadd(object sender, RoutedEventArgs e)
        {
            new Views.finance.monthlytargetadd().Show();
        }
        private void monthlytargetview(object sender, RoutedEventArgs e)
        {
            var w = new Views.finance.monthlytarget();
            userutils.authorizerole(w, new string[] { "superadmin", "admin" });
        }
        #endregion menuitem_finance

        #region others
        private void mi_Setting(object sender, RoutedEventArgs e)
        {
            var w = new Window_Setting();
            userutils.authorizerole(w, new string[] { "superadmin", "admin" });
        }
        private void mi_ravicosoftaccount(object sender, RoutedEventArgs e)
        {
            var w = new ravicosoftaccount();
            userutils.authorizerole(w, new string[] { "superadmin", "admin" });
        }
        private void mi_sms(object sender, RoutedEventArgs e)
        {
            var w = new sms();
            w.Show();
        }
        private void mi_databasesetting(object sender, RoutedEventArgs e)
        {
            var w = new DatabaseSettingWindow();
            userutils.authorizerole(w, new string[] { "superadmin", "admin" });
        }
        #endregion others

        private void mi_LogOut(object sender, RoutedEventArgs e)
        {
            Close();
            new Login().Show();
        }
        private void mi_sqlquerybuilder(object sender, RoutedEventArgs e)
        {
            var w = new SQLQueryBuilder();
            userutils.authorizerole(w, new string[] { "superadmin", "admin" });
        }


    }

}

using Dapper;
using Dapper.Contrib.Extensions;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FreePOS.data.dapper
{
    [System.ComponentModel.DataAnnotations.Schema.Table("invoice")]
    public class invoice
    {
        public int id { get; set; }
        public string invoice_no { get; set; }
        public Nullable<int> customer { get; set; }
        public DateTime created_at { get; set; }
        public Nullable<decimal> amount { get; set; }
        public int added_by { get; set; }
    }

    [System.ComponentModel.DataAnnotations.Schema.Table("invoice_item")]
    public class invoice_item
    {
        public int id { get; set; }
        public int invoice_id { get; set; }
        public int product_id { get; set; }
        public Nullable<double> qty { get; set; }
    }

    [System.ComponentModel.DataAnnotations.Schema.Table("invoice_payment")]
    public class invoice_payment
    {
        public int id { get; set; }
        public int invoice_id { get; set; }
        public int payment_type { get; set; }
        public Nullable<decimal> payment_amount { get; set; }
        public DateTime created_at { get; set; }
        public Nullable<DateTime> modyfied_at { get; set; }
        public Nullable<DateTime> deleted_at { get; set; }
    }

    public class invoicerepo
    {
        string conn = databaseutils.connectionstring;
        public dapper.invoice save(dapper.invoice inv)
        {
            using (var connection = new MySqlConnection(conn))
            {
                var res = connection.Insert<dapper.invoice>(inv);
                inv.id = (int)res;
                return inv;
            }
        }
    }

    public class invoiceitemrepo
    {
        string conn = databaseutils.connectionstring;
        public dapper.invoice_item save(dapper.invoice_item item)
        {
            using (var connection = new MySqlConnection(conn))
            {
                var res = connection.Insert<dapper.invoice_item>(item);
                item.id = (int)res;
                return item;
            }
        }
    }

    public class invoicepaymentrepo
    {
        string conn = databaseutils.connectionstring;
        public dapper.invoice_payment save(dapper.invoice_payment pay)
        {
            using (var connection = new MySqlConnection(conn))
            {
                var res = connection.Insert<dapper.invoice_payment>(pay);
                pay.id = (int)res;
                return pay;
            }
        }
    }
}

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
    [System.ComponentModel.DataAnnotations.Schema.Table("monthly_target")]
    public class monthly_target
    {
        public int id { get; set; }
        public Nullable<System.DateTime> month { get; set; }
        public Nullable<decimal> target { get; set; }
        public Nullable<System.DateTime> created_at { get; set; }
        public Nullable<int> created_by { get; set; }
    }
    public class monthly_targetextended : monthly_target
    {
        public string username { get; set; }
    }

    public class monthly_targetrepo
    {
        string joinselect = "t1.id,t1.month,t1.target,t1.created_at,t1.created_by,t2.name as username from monthly_target t1 left join user t2 on t1.created_by = t2.id";

        string conn = databaseutils.connectionstring;

        public List<dapper.monthly_targetextended> get()
        {
            var sql = "select " + joinselect + ";";
            using (var connection = new MySqlConnection(conn))
            {
                var res = connection.Query<dapper.monthly_targetextended>(sql).ToList();
                return res;
            }
        }

        public dapper.monthly_target save(dapper.monthly_target mt)
        {
            using (var connection = new MySqlConnection(conn))
            {
                var res = connection.Insert<dapper.monthly_target>(mt);
                mt.id = (int)res;
                return mt;
            }
        }
    }
}

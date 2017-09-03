using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;

namespace DataLayer
{
    public class access
    {
        public static DataTable GetAudioFiles(string dbConn)
        {
            using (var con = new SqlConnection(dbConn))
            {
                con.Open();
                var cmd = new SqlCommand
                {
                    Connection = con,
                    CommandType = CommandType.StoredProcedure,
                    CommandText = "Proc_GetAudioFiles"
                };

                var dt = new DataTable();
                var da = new SqlDataAdapter(cmd);
                da.Fill(dt);

                con.Close();

                return dt;
            }
        }

        public static DataTable GetQueryData(string Query,string dbConn)
        {
            using (var con = new SqlConnection(dbConn))
            {
                con.Open();
                using (var dt = new DataTable())
                {
                    var da = new SqlDataAdapter(Query, con);
                    da.Fill(dt);

                    con.Close();

                    return dt;
                }               
                
            }
        }
    }
}

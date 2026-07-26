using FreePOS.bll;
using FreePOS.data;
using FreePOS.data.dapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;

namespace FreePOS.Views.finance
{
    /// <summary>
    /// Interaction logic for monthlytarget.xaml
    /// </summary>
    public partial class monthlytarget : Window
    {
        public monthlytarget()
        {
            InitializeComponent();
            var repo = new data.dapper.monthly_targetrepo();
            var items = repo.get();
            foreach (var item in items)
            {
                dg.Items.Add(item);
            }
        }
    }
}

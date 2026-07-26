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
    /// Interaction logic for monthlytargetadd.xaml
    /// </summary>
    public partial class monthlytargetadd : Window
    {
        data.dapper.monthly_targetrepo repo = null;
        public monthlytargetadd()
        {
            InitializeComponent();
            repo = new data.dapper.monthly_targetrepo();
            month_dp.SelectedDate = DateTime.Now;
        }

        private void save(object sender, RoutedEventArgs e)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(target_tb.Text))
                {
                    MessageBox.Show("Please fill target");
                    return;
                }

                var mt = new data.dapper.monthly_target();
                mt.month = month_dp.SelectedDate ?? DateTime.Now;
                mt.target = Convert.ToDecimal(target_tb.Text);
                mt.created_at = DateTime.Now;
                mt.created_by = userutils.loggedinuserd.id;
                repo.save(mt);
                MessageBox.Show("Monthly target saved");
                Close();
            }
            catch
            {
                MessageBox.Show("Monthly target not saved");
            }
        }

        private void close(object sender, RoutedEventArgs e)
        {
            Close();
        }
    }
}

using Microsoft.Win32;
using System.Collections.Generic;
using System.Windows;
using System.Linq;

namespace WeatherApp
{
    public partial class MainWindow : Window
    {
        private List<WeatherData> weatherDataList = new List<WeatherData>();

        public MainWindow()
        {
            InitializeComponent();
        }

        private void LoadData_Click(object sender, RoutedEventArgs e)
        {
            OpenFileDialog openFileDialog = new OpenFileDialog
            {
                Filter = "CSV Files (*.csv)|*.csv",
                Title = "Wybierz plik z danymi pogodowymi"
            };

            if (openFileDialog.ShowDialog() == true)
            {
                weatherDataList = WeatherService.LoadWeatherData(openFileDialog.FileName);
                WeatherDataGrid.ItemsSource = weatherDataList;

                if (weatherDataList.Any())
                {
                    double avgTemp = WeatherAnalyzer.CalculateAverageTemperature(weatherDataList);
                    AverageTempText.Text = avgTemp.ToString("F2") + " °C";
                }
            }
        }
    }
}

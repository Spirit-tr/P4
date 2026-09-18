using System.Windows;
using DziennikLekcyjny.Wpf.ViewModels;

namespace DziennikLekcyjny.Wpf;

public partial class MainWindow : Window
{
    public MainWindow()
    {
        InitializeComponent();
        DataContext = new MainViewModel();
    }
}

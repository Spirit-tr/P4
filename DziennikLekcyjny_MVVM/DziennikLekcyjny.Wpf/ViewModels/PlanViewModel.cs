using System.Collections.ObjectModel;
using System.Windows;
using DziennikLekcyjny.Wpf.Data;
using DziennikLekcyjny.Wpf.Infrastructure;
using DziennikLekcyjny.Wpf.Models;

namespace DziennikLekcyjny.Wpf.ViewModels;

public sealed class PlanViewModel : ViewModelBase
{
    private readonly Database _database;
    private string _status = string.Empty;

    public ObservableCollection<PlanLekcjiRow> Schedule { get; } = new();
    public string Status { get => _status; set => SetProperty(ref _status, value); }
    public RelayCommand RefreshCommand { get; }

    public PlanViewModel(Database database)
    {
        _database = database;
        RefreshCommand = new RelayCommand(Load);
        Load();
    }

    private void Load()
    {
        try
        {
            Schedule.Clear();
            foreach (var item in _database.GetSchedule()) Schedule.Add(item);
            Status = $"Pozycje planu: {Schedule.Count}";
        }
        catch (Exception ex)
        {
            Status = "Błąd połączenia z bazą.";
            MessageBox.Show(ex.Message, "Błąd SQL", MessageBoxButton.OK, MessageBoxImage.Error);
        }
    }
}

using System.Collections.ObjectModel;
using System.Globalization;
using System.Windows;
using DziennikLekcyjny.Wpf.Data;
using DziennikLekcyjny.Wpf.Infrastructure;
using DziennikLekcyjny.Wpf.Models;

namespace DziennikLekcyjny.Wpf.ViewModels;

public sealed class GradesViewModel : ViewModelBase
{
    private readonly Database _database;
    private Student? _selectedStudent;
    private Przedmiot? _selectedSubject;
    private string _gradeText = "5,0";
    private DateTime _date = DateTime.Today;
    private string _status = string.Empty;

    public ObservableCollection<OcenaRow> Grades { get; } = new();
    public ObservableCollection<Student> Students { get; } = new();
    public ObservableCollection<Przedmiot> Subjects { get; } = new();

    public Student? SelectedStudent { get => _selectedStudent; set => SetProperty(ref _selectedStudent, value); }
    public Przedmiot? SelectedSubject { get => _selectedSubject; set => SetProperty(ref _selectedSubject, value); }
    public string GradeText { get => _gradeText; set => SetProperty(ref _gradeText, value); }
    public DateTime Date { get => _date; set => SetProperty(ref _date, value); }
    public string Status { get => _status; set => SetProperty(ref _status, value); }

    public RelayCommand RefreshCommand { get; }
    public RelayCommand AddGradeCommand { get; }

    public GradesViewModel(Database database)
    {
        _database = database;
        RefreshCommand = new RelayCommand(Load);
        AddGradeCommand = new RelayCommand(AddGrade);
        Load();
    }

    private void Load()
    {
        try
        {
            Students.Clear();
            foreach (var item in _database.GetStudents()) Students.Add(item);

            Subjects.Clear();
            foreach (var item in _database.GetSubjects()) Subjects.Add(item);

            Grades.Clear();
            foreach (var item in _database.GetGrades()) Grades.Add(item);

            SelectedStudent ??= Students.FirstOrDefault();
            SelectedSubject ??= Subjects.FirstOrDefault();
            Status = $"Wczytano ocen: {Grades.Count}";
        }
        catch (Exception ex)
        {
            Status = "Błąd połączenia z bazą.";
            MessageBox.Show(ex.Message, "Błąd SQL", MessageBoxButton.OK, MessageBoxImage.Error);
        }
    }

    private void AddGrade()
    {
        if (SelectedStudent is null || SelectedSubject is null)
        {
            MessageBox.Show("Wybierz ucznia i przedmiot.");
            return;
        }

        var normalized = GradeText.Replace(',', '.');
        if (!decimal.TryParse(normalized, NumberStyles.Number, CultureInfo.InvariantCulture, out var grade))
        {
            MessageBox.Show("Podaj ocenę w formacie np. 4,5.");
            return;
        }

        try
        {
            _database.AddGrade(SelectedStudent.IdStudenta, SelectedSubject.IdPrzedmiotu, grade, Date);
            Load();
            Status = "Dodano ocenę.";
        }
        catch (Exception ex)
        {
            MessageBox.Show(ex.Message, "Nie udało się dodać oceny", MessageBoxButton.OK, MessageBoxImage.Error);
        }
    }
}

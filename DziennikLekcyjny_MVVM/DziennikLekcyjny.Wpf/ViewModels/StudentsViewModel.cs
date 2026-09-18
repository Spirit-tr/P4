using System.Collections.ObjectModel;
using System.Windows;
using DziennikLekcyjny.Wpf.Data;
using DziennikLekcyjny.Wpf.Infrastructure;
using DziennikLekcyjny.Wpf.Models;

namespace DziennikLekcyjny.Wpf.ViewModels;

public sealed class StudentsViewModel : ViewModelBase
{
    private readonly Database _database;
    private Student? _selectedStudent;
    private string _imie = string.Empty;
    private string _nazwisko = string.Empty;
    private string _pesel = string.Empty;
    private DateTime _dataUrodzenia = DateTime.Today.AddYears(-18);
    private Klasa? _selectedClass;
    private string _status = string.Empty;

    public ObservableCollection<Student> Students { get; } = new();
    public ObservableCollection<Klasa> Classes { get; } = new();

    public Student? SelectedStudent
    {
        get => _selectedStudent;
        set
        {
            if (!SetProperty(ref _selectedStudent, value)) return;
            if (value is not null)
            {
                Imie = value.Imie;
                Nazwisko = value.Nazwisko;
                Pesel = value.Pesel;
                DataUrodzenia = value.DataUrodzenia;
                SelectedClass = Classes.FirstOrDefault(c => c.IdKlasy == value.IdKlasy);
            }
        }
    }

    public string Imie { get => _imie; set => SetProperty(ref _imie, value); }
    public string Nazwisko { get => _nazwisko; set => SetProperty(ref _nazwisko, value); }
    public string Pesel { get => _pesel; set => SetProperty(ref _pesel, value); }
    public DateTime DataUrodzenia { get => _dataUrodzenia; set => SetProperty(ref _dataUrodzenia, value); }
    public Klasa? SelectedClass { get => _selectedClass; set => SetProperty(ref _selectedClass, value); }
    public string Status { get => _status; set => SetProperty(ref _status, value); }

    public RelayCommand RefreshCommand { get; }
    public RelayCommand NewCommand { get; }
    public RelayCommand AddCommand { get; }
    public RelayCommand UpdateCommand { get; }
    public RelayCommand DeleteCommand { get; }

    public StudentsViewModel(Database database)
    {
        _database = database;
        RefreshCommand = new RelayCommand(Load);
        NewCommand = new RelayCommand(ClearForm);
        AddCommand = new RelayCommand(AddStudent);
        UpdateCommand = new RelayCommand(UpdateStudent);
        DeleteCommand = new RelayCommand(DeleteStudent);
        Load();
    }

    private void Load()
    {
        try
        {
            Classes.Clear();
            foreach (var item in _database.GetClasses()) Classes.Add(item);

            Students.Clear();
            foreach (var item in _database.GetStudents()) Students.Add(item);

            Status = $"Wczytano uczniów: {Students.Count}";
        }
        catch (Exception ex)
        {
            Status = "Błąd połączenia z bazą.";
            MessageBox.Show(ex.Message, "Błąd SQL", MessageBoxButton.OK, MessageBoxImage.Error);
        }
    }

    private bool ValidateForm()
    {
        if (string.IsNullOrWhiteSpace(Imie) || string.IsNullOrWhiteSpace(Nazwisko) || SelectedClass is null)
        {
            MessageBox.Show("Uzupełnij imię, nazwisko i klasę.", "Brak danych");
            return false;
        }
        if (Pesel.Length != 11 || !Pesel.All(char.IsDigit))
        {
            MessageBox.Show("PESEL powinien składać się z 11 cyfr.", "Niepoprawny PESEL");
            return false;
        }
        return true;
    }

    private void AddStudent()
    {
        if (!ValidateForm() || SelectedClass is null) return;
        try
        {
            _database.AddStudent(Imie.Trim(), Nazwisko.Trim(), Pesel.Trim(), DataUrodzenia, SelectedClass.IdKlasy);
            Load();
            ClearForm();
            Status = "Dodano ucznia.";
        }
        catch (Exception ex)
        {
            MessageBox.Show(ex.Message, "Nie udało się dodać ucznia", MessageBoxButton.OK, MessageBoxImage.Error);
        }
    }

    private void UpdateStudent()
    {
        if (SelectedStudent is null)
        {
            MessageBox.Show("Najpierw wybierz ucznia z tabeli.");
            return;
        }
        if (!ValidateForm() || SelectedClass is null) return;

        try
        {
            SelectedStudent.Imie = Imie.Trim();
            SelectedStudent.Nazwisko = Nazwisko.Trim();
            SelectedStudent.Pesel = Pesel.Trim();
            SelectedStudent.DataUrodzenia = DataUrodzenia;
            SelectedStudent.IdKlasy = SelectedClass.IdKlasy;
            _database.UpdateStudent(SelectedStudent);
            Load();
            Status = "Zapisano zmiany.";
        }
        catch (Exception ex)
        {
            MessageBox.Show(ex.Message, "Nie udało się zapisać zmian", MessageBoxButton.OK, MessageBoxImage.Error);
        }
    }

    private void DeleteStudent()
    {
        if (SelectedStudent is null)
        {
            MessageBox.Show("Najpierw wybierz ucznia z tabeli.");
            return;
        }

        if (MessageBox.Show($"Usunąć ucznia {SelectedStudent.PelneImie}?", "Potwierdzenie",
                MessageBoxButton.YesNo, MessageBoxImage.Question) != MessageBoxResult.Yes)
            return;

        try
        {
            _database.DeleteStudent(SelectedStudent.IdStudenta);
            Load();
            ClearForm();
            Status = "Usunięto ucznia.";
        }
        catch (Exception ex)
        {
            MessageBox.Show(
                "Nie można usunąć ucznia, jeżeli ma powiązane oceny lub obecności.\n\n" + ex.Message,
                "Nie udało się usunąć", MessageBoxButton.OK, MessageBoxImage.Warning);
        }
    }

    private void ClearForm()
    {
        SelectedStudent = null;
        Imie = string.Empty;
        Nazwisko = string.Empty;
        Pesel = string.Empty;
        DataUrodzenia = DateTime.Today.AddYears(-18);
        SelectedClass = Classes.FirstOrDefault();
    }
}

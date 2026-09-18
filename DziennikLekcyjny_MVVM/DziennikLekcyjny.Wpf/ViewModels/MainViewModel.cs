using DziennikLekcyjny.Wpf.Data;

namespace DziennikLekcyjny.Wpf.ViewModels;

public sealed class MainViewModel
{
    private readonly Database _database = new();

    public StudentsViewModel Students { get; }
    public GradesViewModel Grades { get; }
    public PlanViewModel Plan { get; }

    public MainViewModel()
    {
        Students = new StudentsViewModel(_database);
        Grades = new GradesViewModel(_database);
        Plan = new PlanViewModel(_database);
    }
}

namespace DziennikLekcyjny.Wpf.Models;

public sealed class Student
{
    public int IdStudenta { get; set; }
    public string Imie { get; set; } = string.Empty;
    public string Nazwisko { get; set; } = string.Empty;
    public string Pesel { get; set; } = string.Empty;
    public DateTime DataUrodzenia { get; set; }
    public int IdKlasy { get; set; }
    public string NazwaKlasy { get; set; } = string.Empty;
    public string PelneImie => $"{Imie} {Nazwisko}";
}

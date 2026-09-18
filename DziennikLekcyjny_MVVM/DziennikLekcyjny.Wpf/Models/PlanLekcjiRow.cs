namespace DziennikLekcyjny.Wpf.Models;

public sealed class PlanLekcjiRow
{
    public string NazwaKlasy { get; set; } = string.Empty;
    public string NazwaPrzedmiotu { get; set; } = string.Empty;
    public string Nauczyciel { get; set; } = string.Empty;
    public string DzienTygodnia { get; set; } = string.Empty;
    public TimeSpan Godzina { get; set; }
}

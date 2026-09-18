namespace DziennikLekcyjny.Wpf.Models;

public sealed class Przedmiot
{
    public int IdPrzedmiotu { get; set; }
    public string NazwaPrzedmiotu { get; set; } = string.Empty;
    public override string ToString() => NazwaPrzedmiotu;
}

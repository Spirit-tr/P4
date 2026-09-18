namespace DziennikLekcyjny.Wpf.Models;

public sealed class Klasa
{
    public int IdKlasy { get; set; }
    public string NazwaKlasy { get; set; } = string.Empty;
    public override string ToString() => NazwaKlasy;
}

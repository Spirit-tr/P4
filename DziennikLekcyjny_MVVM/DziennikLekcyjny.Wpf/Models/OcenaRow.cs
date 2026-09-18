namespace DziennikLekcyjny.Wpf.Models;

public sealed class OcenaRow
{
    public int Id { get; set; }
    public int IdStudenta { get; set; }
    public string Student { get; set; } = string.Empty;
    public int IdPrzedmiotu { get; set; }
    public string Przedmiot { get; set; } = string.Empty;
    public DateTime Data { get; set; }
    public decimal Ocena { get; set; }
}

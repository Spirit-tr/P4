using Microsoft.Data.SqlClient;
using DziennikLekcyjny.Wpf.Models;

namespace DziennikLekcyjny.Wpf.Data;

public sealed class Database
{
    private SqlConnection CreateConnection() => new(DbSettings.ConnectionString);

    public List<Klasa> GetClasses()
    {
        const string sql = "SELECT ID_klasy, Nazwa_klasy FROM dbo.Klasa ORDER BY Nazwa_klasy";
        var result = new List<Klasa>();
        using var connection = CreateConnection();
        connection.Open();
        using var command = new SqlCommand(sql, connection);
        using var reader = command.ExecuteReader();
        while (reader.Read())
        {
            result.Add(new Klasa
            {
                IdKlasy = reader.GetInt32(0),
                NazwaKlasy = reader.GetString(1)
            });
        }
        return result;
    }

    public List<Student> GetStudents()
    {
        const string sql = @"
SELECT s.ID_studenta, s.Imie, s.Nazwisko, s.Pesel, s.Data_urodzenia,
       s.ID_klasy, k.Nazwa_klasy
FROM dbo.Student s
INNER JOIN dbo.Klasa k ON k.ID_klasy = s.ID_klasy
ORDER BY s.Nazwisko, s.Imie;";

        var result = new List<Student>();
        using var connection = CreateConnection();
        connection.Open();
        using var command = new SqlCommand(sql, connection);
        using var reader = command.ExecuteReader();
        while (reader.Read())
        {
            result.Add(new Student
            {
                IdStudenta = reader.GetInt32(0),
                Imie = reader.GetString(1),
                Nazwisko = reader.GetString(2),
                Pesel = reader.GetString(3),
                DataUrodzenia = reader.GetDateTime(4),
                IdKlasy = reader.GetInt32(5),
                NazwaKlasy = reader.GetString(6)
            });
        }
        return result;
    }

    public void AddStudent(string imie, string nazwisko, string pesel, DateTime dataUrodzenia, int idKlasy)
    {
        using var connection = CreateConnection();
        connection.Open();
        using var command = new SqlCommand("dbo.DodajStudenta", connection)
        {
            CommandType = System.Data.CommandType.StoredProcedure
        };
        command.Parameters.AddWithValue("@Imie", imie);
        command.Parameters.AddWithValue("@Nazwisko", nazwisko);
        command.Parameters.AddWithValue("@Pesel", pesel);
        command.Parameters.AddWithValue("@DataUrodzenia", dataUrodzenia.Date);
        command.Parameters.AddWithValue("@IDKlasy", idKlasy);
        command.ExecuteNonQuery();
    }

    public void UpdateStudent(Student student)
    {
        const string sql = @"
UPDATE dbo.Student
SET Imie = @Imie,
    Nazwisko = @Nazwisko,
    Pesel = @Pesel,
    Data_urodzenia = @DataUrodzenia,
    ID_klasy = @IDKlasy
WHERE ID_studenta = @ID;";

        using var connection = CreateConnection();
        connection.Open();
        using var command = new SqlCommand(sql, connection);
        command.Parameters.AddWithValue("@Imie", student.Imie);
        command.Parameters.AddWithValue("@Nazwisko", student.Nazwisko);
        command.Parameters.AddWithValue("@Pesel", student.Pesel);
        command.Parameters.AddWithValue("@DataUrodzenia", student.DataUrodzenia.Date);
        command.Parameters.AddWithValue("@IDKlasy", student.IdKlasy);
        command.Parameters.AddWithValue("@ID", student.IdStudenta);
        command.ExecuteNonQuery();
    }

    public void DeleteStudent(int idStudenta)
    {
        const string sql = "DELETE FROM dbo.Student WHERE ID_studenta = @ID";
        using var connection = CreateConnection();
        connection.Open();
        using var command = new SqlCommand(sql, connection);
        command.Parameters.AddWithValue("@ID", idStudenta);
        command.ExecuteNonQuery();
    }

    public List<Przedmiot> GetSubjects()
    {
        const string sql = "SELECT ID_przedmiotu, Nazwa_przedmiotu FROM dbo.Przedmiot ORDER BY Nazwa_przedmiotu";
        var result = new List<Przedmiot>();
        using var connection = CreateConnection();
        connection.Open();
        using var command = new SqlCommand(sql, connection);
        using var reader = command.ExecuteReader();
        while (reader.Read())
        {
            result.Add(new Przedmiot
            {
                IdPrzedmiotu = reader.GetInt32(0),
                NazwaPrzedmiotu = reader.GetString(1)
            });
        }
        return result;
    }

    public List<OcenaRow> GetGrades()
    {
        const string sql = @"
SELECT o.ID, o.ID_studenta,
       s.Imie + ' ' + s.Nazwisko AS Student,
       o.ID_przedmiotu, p.Nazwa_przedmiotu,
       o.Data, o.Ocena
FROM dbo.Ocena o
INNER JOIN dbo.Student s ON s.ID_studenta = o.ID_studenta
INNER JOIN dbo.Przedmiot p ON p.ID_przedmiotu = o.ID_przedmiotu
ORDER BY o.Data DESC, s.Nazwisko, s.Imie;";

        var result = new List<OcenaRow>();
        using var connection = CreateConnection();
        connection.Open();
        using var command = new SqlCommand(sql, connection);
        using var reader = command.ExecuteReader();
        while (reader.Read())
        {
            result.Add(new OcenaRow
            {
                Id = reader.GetInt32(0),
                IdStudenta = reader.GetInt32(1),
                Student = reader.GetString(2),
                IdPrzedmiotu = reader.GetInt32(3),
                Przedmiot = reader.GetString(4),
                Data = reader.GetDateTime(5),
                Ocena = reader.GetDecimal(6)
            });
        }
        return result;
    }

    public void AddGrade(int idStudenta, int idPrzedmiotu, decimal ocena, DateTime data)
    {
        using var connection = CreateConnection();
        connection.Open();
        using var command = new SqlCommand("dbo.DodajOcene", connection)
        {
            CommandType = System.Data.CommandType.StoredProcedure
        };
        command.Parameters.AddWithValue("@IDStudenta", idStudenta);
        command.Parameters.AddWithValue("@IDPrzedmiotu", idPrzedmiotu);
        command.Parameters.AddWithValue("@Ocena", ocena);
        command.Parameters.AddWithValue("@Data", data.Date);
        command.ExecuteNonQuery();
    }

    public List<PlanLekcjiRow> GetSchedule()
    {
        const string sql = @"
SELECT Nazwa_klasy, Nazwa_przedmiotu, Nauczyciel, Dzien_tygodnia, Godzina
FROM dbo.PlanLekcjiKlasy
ORDER BY CASE Dzien_tygodnia
    WHEN 'Poniedziałek' THEN 1 WHEN 'Poniedzialek' THEN 1
    WHEN 'Wtorek' THEN 2
    WHEN 'Środa' THEN 3 WHEN 'Sroda' THEN 3
    WHEN 'Czwartek' THEN 4
    WHEN 'Piątek' THEN 5 WHEN 'Piatek' THEN 5
    ELSE 6 END,
    Godzina, Nazwa_klasy;";

        var result = new List<PlanLekcjiRow>();
        using var connection = CreateConnection();
        connection.Open();
        using var command = new SqlCommand(sql, connection);
        using var reader = command.ExecuteReader();
        while (reader.Read())
        {
            result.Add(new PlanLekcjiRow
            {
                NazwaKlasy = reader.GetString(0),
                NazwaPrzedmiotu = reader.GetString(1),
                Nauczyciel = reader.GetString(2),
                DzienTygodnia = reader.GetString(3),
                Godzina = reader.GetTimeSpan(4)
            });
        }
        return result;
    }
}

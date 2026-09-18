# Dziennik Lekcyjny – WPF + MVVM + SQL Server

Prosty projekt studencki pokazujący połączenie aplikacji WPF z istniejącą bazą SQL Server z użyciem wzorca MVVM.

## Zakres pierwszej wersji

- lista uczniów,
- dodawanie, edycja i usuwanie ucznia,
- wybór klasy,
- lista ocen i dodawanie oceny,
- podgląd planu lekcji,
- połączenie z SQL Server Express,
- podział na Model / View / ViewModel,
- skrypt bazy danych dołączony w `DziennikLekcyjny.Wpf/Database/script.sql`.

## Wymagania

- Visual Studio Community (lub Professional) z workloadem **.NET desktop development**,
- .NET 8 SDK,
- SQL Server Express,
- działająca instancja `SQLEXPRESS`,
- baza o nazwie `Projekt bazy danych dziennika lekcyjnego`.

## Uruchomienie

1. Otwórz `DziennikLekcyjny.sln` w Visual Studio.
2. Poczekaj, aż NuGet przywróci pakiet `Microsoft.Data.SqlClient`.
3. Sprawdź, czy SQL Server `(SQLEXPRESS)` działa.
4. Sprawdź połączenie w `DziennikLekcyjny.Wpf/Data/DbSettings.cs`.
5. Ustaw `DziennikLekcyjny.Wpf` jako projekt startowy, jeżeli Visual Studio tego nie zrobi automatycznie.
6. Uruchom projekt klawiszem **F5**.

Domyślne połączenie:

`Server=.\\SQLEXPRESS;Database=Projekt bazy danych dziennika lekcyjnego;Trusted_Connection=True;TrustServerCertificate=True;`

Nie zawiera ono hasła – używane jest uwierzytelnianie Windows.

## Struktura MVVM

- `Models` – klasy reprezentujące dane wyświetlane w aplikacji.
- `Data` – połączenie z SQL Server i zapytania SQL.
- `ViewModels` – logika aplikacji i komendy.
- `Views` – widoki XAML bez logiki biznesowej.
- `Infrastructure` – `ViewModelBase` i `RelayCommand`.

## GitHub

Repozytorium może zawierać cały folder projektu oraz skrypt SQL. Pliki `bin`, `obj` i `.vs` są ignorowane przez `.gitignore`.

## Uwaga o usuwaniu ucznia

Jeżeli uczeń ma już oceny lub wpisy obecności, SQL Server może odmówić jego usunięcia z powodu kluczy obcych. Aplikacja pokazuje wtedy komunikat zamiast usuwać dane powiązane automatycznie.

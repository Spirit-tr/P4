# 📘 Dziennik lekcyjny — WPF + SQL Server + MVVM

Aplikacja desktopowa przygotowana w **C# / WPF**, połączona z bazą **Microsoft SQL Server Express** i zorganizowana zgodnie ze wzorcem **MVVM (Model–View–ViewModel)**.

Projekt przedstawia prosty elektroniczny dziennik lekcyjny. Umożliwia zarządzanie uczniami, dodawanie ocen oraz przeglądanie planu lekcji. Aplikacja korzysta z istniejącej relacyjnej bazy danych SQL Server.

---

## 📷 Wygląd aplikacji

### Uczniowie

![Widok uczniów](docs/uczniowie.png)

### Oceny

![Widok ocen](docs/oceny.png)

### Plan lekcji

![Widok planu lekcji](docs/plan-lekcji.png)

---

## 🎯 Cel projektu

Celem projektu jest pokazanie w praktyce połączenia kilku elementów:

- aplikacji desktopowej **WPF**,
- języka **C#** i platformy **.NET 8**,
- bazy danych **SQL Server**,
- biblioteki **Microsoft.Data.SqlClient**,
- wzorca architektonicznego **MVVM**,
- operacji CRUD na danych,
- procedur składowanych, widoków i relacji w SQL,
- wersjonowania projektu za pomocą **Git / GitHub**.

Projekt został celowo utrzymany w niewielkim zakresie. Najważniejsza jest czytelna struktura, działające połączenie z bazą oraz poprawne rozdzielenie interfejsu od logiki aplikacji.

---

# 🧩 Funkcjonalności aplikacji

Aplikacja posiada trzy główne zakładki:

1. **Uczniowie**
2. **Oceny**
3. **Plan lekcji**

## 👨‍🎓 Uczniowie

Zakładka wyświetla uczniów zapisanych w tabeli `Student`.

Dostępne operacje:

- wyświetlanie listy uczniów,
- dodawanie nowego ucznia,
- edycja istniejącego ucznia,
- usuwanie ucznia,
- wybór klasy z listy,
- odświeżenie danych z bazy,
- podstawowa walidacja formularza.

Po zaznaczeniu ucznia w tabeli jego dane są automatycznie przenoszone do formularza po prawej stronie.

### Przyciski

**Nowy**  
Czyści formularz i przygotowuje go do wprowadzenia nowej osoby.

**Dodaj**  
Dodaje nowego ucznia do bazy danych. Aplikacja korzysta przy tym z procedury składowanej `dbo.DodajStudenta`.

**Zapisz**  
Aktualizuje dane zaznaczonego ucznia.

**Usuń**  
Usuwa zaznaczonego ucznia po potwierdzeniu operacji.

Jeżeli uczeń posiada powiązane rekordy, np. oceny albo obecności, SQL Server może zablokować usunięcie ze względu na klucze obce.

**Odśwież**  
Ponownie pobiera listę klas oraz uczniów bezpośrednio z SQL Server.

### Walidacja

Przed dodaniem lub zapisaniem ucznia aplikacja sprawdza m.in.:

- czy podano imię,
- czy podano nazwisko,
- czy wybrano klasę,
- czy PESEL zawiera dokładnie 11 cyfr.

Dodatkowo baza posiada funkcję `dbo.SprawdzPesel`, która również kontroluje format numeru PESEL.

---

## 📝 Oceny

Zakładka **Oceny** umożliwia:

- przeglądanie wszystkich zapisanych ocen,
- wybór ucznia,
- wybór przedmiotu,
- podanie oceny,
- wybór daty,
- dodanie oceny,
- ponowne wczytanie danych.

Lista ocen łączy dane z trzech tabel:

- `Ocena`,
- `Student`,
- `Przedmiot`.

Dzięki temu użytkownik widzi imię i nazwisko ucznia oraz nazwę przedmiotu zamiast samych identyfikatorów.

Dodanie oceny odbywa się przez procedurę:

`dbo.DodajOcene`

Baza dodatkowo korzysta z funkcji:

`dbo.SprawdzOcene`

> **Uwaga:** w obecnym skrypcie funkcja `SprawdzOcene` dopuszcza wartości od `0.0` do `5.0`, natomiast komunikat błędu w procedurze `DodajOcene` wspomina zakres `0.0–6.0`. Jeżeli projekt będzie dalej rozwijany, warto ujednolicić tę regułę.

---

## 📅 Plan lekcji

Zakładka **Plan lekcji** służy do odczytu planu zapisnego w bazie.

Wyświetlane są:

- klasa,
- dzień tygodnia,
- godzina,
- przedmiot,
- nauczyciel.

Aplikacja nie wykonuje tutaj kilku osobnych zapytań. Korzysta z przygotowanego w bazie widoku:

`dbo.PlanLekcjiKlasy`

Widok łączy tabele:

- `Plan_lekcji`,
- `Klasa`,
- `Przedmiot`,
- `Nauczyciel`.

Przycisk **Odśwież plan** ponownie pobiera dane z SQL Server.

---

# 🗄️ Baza danych

Domyślna nazwa bazy:

`Projekt bazy danych dziennika lekcyjnego`

Domyślny serwer:

`.\SQLEXPRESS`

Projekt zakłada logowanie przez konto Windows:

`Trusted_Connection=True`

Połączenie znajduje się w pliku:

`DziennikLekcyjny.Wpf/Data/DbSettings.cs`

Aktualny connection string:

```text
Server=.\SQLEXPRESS;
Database=Projekt bazy danych dziennika lekcyjnego;
Trusted_Connection=True;
TrustServerCertificate=True;
```

---

## 📚 Tabele

### `Klasa`

Przechowuje dostępne klasy.

Najważniejsze pola:

| Pole | Znaczenie |
|---|---|
| `ID_klasy` | klucz główny |
| `Nazwa_klasy` | nazwa klasy, np. 1A |

Relacja:

`Klasa 1 ─── N Student`

oraz:

`Klasa 1 ─── N Plan_lekcji`

---

### `Student`

Przechowuje dane uczniów.

| Pole | Znaczenie |
|---|---|
| `ID_studenta` | klucz główny |
| `Imie` | imię ucznia |
| `Nazwisko` | nazwisko ucznia |
| `Pesel` | numer PESEL |
| `Data_urodzenia` | data urodzenia |
| `ID_klasy` | klucz obcy do tabeli `Klasa` |

Pole `Pesel` posiada ograniczenie unikalności.

Relacje:

`Student N ─── 1 Klasa`

`Student 1 ─── N Ocena`

`Student 1 ─── N Obecnosc`

---

### `Nauczyciel`

Przechowuje dane nauczycieli.

| Pole | Znaczenie |
|---|---|
| `ID_nauczyciela` | klucz główny |
| `Imie` | imię |
| `Nazwisko` | nazwisko |
| `Pesel` | numer PESEL |

Pole `Pesel` jest unikalne.

Relacja:

`Nauczyciel 1 ─── N Plan_lekcji`

---

### `Przedmiot`

Przechowuje listę przedmiotów.

| Pole | Znaczenie |
|---|---|
| `ID_przedmiotu` | klucz główny |
| `Nazwa_przedmiotu` | nazwa przedmiotu |

Relacje:

`Przedmiot 1 ─── N Ocena`

`Przedmiot 1 ─── N Plan_lekcji`

---

### `Ocena`

Przechowuje oceny uczniów.

| Pole | Znaczenie |
|---|---|
| `ID` | klucz główny |
| `ID_studenta` | klucz obcy do `Student` |
| `ID_przedmiotu` | klucz obcy do `Przedmiot` |
| `Data` | data wystawienia oceny |
| `Ocena` | wartość oceny |

---

### `Obecnosc`

Przechowuje informacje o obecności uczniów.

| Pole | Znaczenie |
|---|---|
| `ID` | klucz główny |
| `ID_studenta` | klucz obcy do `Student` |
| `Data` | data |
| `Status` | np. `Obecny`, `Nieobecny` |

Tabela jest obecna w bazie, ale obecna wersja interfejsu WPF nie posiada jeszcze osobnej zakładki do jej obsługi.

---

### `Plan_lekcji`

Przechowuje pozycje planu lekcji.

| Pole | Znaczenie |
|---|---|
| `ID` | klucz główny |
| `ID_klasy` | klasa |
| `ID_przedmiotu` | przedmiot |
| `ID_nauczyciela` | nauczyciel |
| `Dzien_tygodnia` | dzień tygodnia |
| `Godzina` | godzina lekcji |

---

# 🔗 Relacje w bazie

Uproszczony schemat:

```text
Klasa
  │
  ├────< Student
  │        │
  │        ├────< Ocena >──── Przedmiot
  │        │
  │        └────< Obecnosc
  │
  └────< Plan_lekcji >──── Przedmiot
             │
             └──────────── Nauczyciel
```

Klucze obce zapewniają spójność danych. Przykładowo nie można przypisać ucznia do klasy, która nie istnieje.

---

# 👁️ Widoki SQL

Baza posiada również widoki przygotowane do wygodnego odczytu danych.

## `dbo.SredniaOcenaUcznia`

Oblicza średnią ocen dla każdego ucznia.

Zwraca m.in.:

- identyfikator ucznia,
- imię,
- nazwisko,
- średnią ocen.

Aktualna wersja aplikacji WPF nie wyświetla jeszcze tego widoku, ale może on zostać wykorzystany w przyszłości np. w zakładce **Statystyki**.

## `dbo.StatystykaObecnosci`

Zlicza nieobecności ucznia.

Może zostać wykorzystany przy dalszej rozbudowie modułu obecności.

## `dbo.PlanLekcjiKlasy`

Łączy plan lekcji z nazwą klasy, przedmiotu i nauczyciela.

Ten widok jest już używany przez aplikację w zakładce **Plan lekcji**.

---

# ⚙️ Procedury składowane

Baza zawiera procedury:

### `dbo.DodajStudenta`

Odpowiada za dodawanie ucznia i wykorzystuje funkcję sprawdzającą PESEL.

### `dbo.DodajNauczyciela`

Dodaje nauczyciela po sprawdzeniu PESEL-u.

Obecna wersja aplikacji WPF nie posiada jeszcze interfejsu do zarządzania nauczycielami.

### `dbo.DodajOcene`

Dodaje ocenę ucznia z określonego przedmiotu.

Procedura jest używana bezpośrednio w aplikacji.

---

# 🧪 Funkcje SQL

W bazie znajdują się funkcje pomocnicze:

| Funkcja | Przeznaczenie |
|---|---|
| `SprawdzPesel` | kontrola długości i formatu PESEL |
| `SprawdzOcene` | kontrola zakresu oceny |
| `SprawdzDateObecnosci` | sprawdzenie, czy data nie jest z przyszłości |
| `SprawdzDzienTygodnia` | sprawdzenie poprawnego dnia szkolnego |
| `SprawdzGodzine` | sprawdzenie godzin lekcyjnych |

Nie wszystkie funkcje są obecnie wywoływane bezpośrednio przez interfejs aplikacji, ale stanowią część logiki bazy.

---

# 🏗️ Architektura aplikacji — MVVM

Projekt korzysta z wzorca:

**Model – View – ViewModel**

Dzięki temu wygląd aplikacji jest oddzielony od logiki działania.

```text
┌─────────────┐
│    View     │
│    XAML     │
└──────┬──────┘
       │ Binding / Command
       ▼
┌─────────────┐
│  ViewModel  │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ Data layer  │
│ Database.cs │
└──────┬──────┘
       │ Microsoft.Data.SqlClient
       ▼
┌─────────────┐
│ SQL Server  │
└─────────────┘
```

---

## Model

Folder:

`Models`

Zawiera klasy reprezentujące dane używane przez aplikację, np.:

- `Student`,
- `Klasa`,
- `Przedmiot`,
- `OcenaRow`,
- `PlanLekcjiRow`.

Model nie odpowiada za wygląd interfejsu.

---

## View

Folder:

`Views`

Zawiera interfejs użytkownika napisany w XAML:

- `StudentsView.xaml`,
- `GradesView.xaml`,
- `PlanView.xaml`.

Pliki code-behind tych widoków zawierają jedynie `InitializeComponent()` — logika biznesowa nie jest umieszczana w widokach.

Główne okno aplikacji znajduje się w:

`MainWindow.xaml`

---

## ViewModel

Folder:

`ViewModels`

Zawiera logikę obsługującą poszczególne widoki:

- `StudentsViewModel`,
- `GradesViewModel`,
- `PlanViewModel`,
- `MainViewModel`.

ViewModel udostępnia dane do XAML i obsługuje komendy.

Przykład:

```text
Button "Dodaj"
      │
      ▼
AddCommand
      │
      ▼
StudentsViewModel
      │
      ▼
Database.AddStudent(...)
      │
      ▼
SQL Server
```

---

## Data layer

Folder:

`Data`

### `DbSettings.cs`

Przechowuje connection string.

### `Database.cs`

Odpowiada za komunikację z SQL Server.

Zawiera metody do:

- pobierania klas,
- pobierania uczniów,
- dodawania ucznia,
- edycji ucznia,
- usuwania ucznia,
- pobierania przedmiotów,
- pobierania ocen,
- dodawania ocen,
- pobierania planu lekcji.

Do komunikacji używana jest biblioteka:

`Microsoft.Data.SqlClient`

---

## Infrastructure

Folder:

`Infrastructure`

### `ViewModelBase.cs`

Implementuje `INotifyPropertyChanged`.

Dzięki temu WPF wie, że zmieniła się wartość właściwości ViewModelu i może automatycznie odświeżyć interfejs.

### `RelayCommand.cs`

Implementuje `ICommand`.

Pozwala przypisać metody ViewModelu do przycisków w XAML bez umieszczania logiki w code-behind.

---

# 📁 Struktura projektu

```text
DziennikLekcyjny
│
├── DziennikLekcyjny.sln
├── README.md
├── .gitignore
├── docs
│   ├── uczniowie.png
│   ├── oceny.png
│   └── plan-lekcji.png
│
└── DziennikLekcyjny.Wpf
    │
    ├── App.xaml
    ├── App.xaml.cs
    ├── MainWindow.xaml
    ├── MainWindow.xaml.cs
    ├── DziennikLekcyjny.Wpf.csproj
    │
    ├── Data
    │   ├── Database.cs
    │   └── DbSettings.cs
    │
    ├── Database
    │   └── script.sql
    │
    ├── Infrastructure
    │   ├── RelayCommand.cs
    │   └── ViewModelBase.cs
    │
    ├── Models
    │   ├── Student.cs
    │   ├── Klasa.cs
    │   ├── Przedmiot.cs
    │   ├── OcenaRow.cs
    │   └── PlanLekcjiRow.cs
    │
    ├── ViewModels
    │   ├── MainViewModel.cs
    │   ├── StudentsViewModel.cs
    │   ├── GradesViewModel.cs
    │   └── PlanViewModel.cs
    │
    └── Views
        ├── StudentsView.xaml
        ├── GradesView.xaml
        └── PlanView.xaml
```

---

# 💻 Wymagania

Do uruchomienia projektu potrzebne są:

- system Windows,
- Visual Studio 2022/2026 albo nowsze środowisko obsługujące .NET 8,
- workload **.NET desktop development**,
- **.NET 8 SDK**,
- Microsoft SQL Server Express,
- SQL Server Management Studio — zalecane do zarządzania bazą.

Projekt docelowo używa:

```text
TargetFramework: net8.0-windows
```

Pakiet NuGet:

```text
Microsoft.Data.SqlClient 5.2.2
```

---

# 🚀 Uruchomienie projektu

## 1. SQL Server

Upewnij się, że działa usługa:

```text
SQL Server (SQLEXPRESS)
```

Domyślnie aplikacja oczekuje serwera:

```text
.\SQLEXPRESS
```

---

## 2. Baza danych

Jeżeli baza już istnieje, jej nazwa musi być zgodna z connection stringiem:

```text
Projekt bazy danych dziennika lekcyjnego
```

Jeżeli chcesz odtworzyć bazę z repozytorium, skrypt znajduje się w:

```text
DziennikLekcyjny.Wpf/Database/script.sql
```

Można go otworzyć w SQL Server Management Studio.

> **Ważne:** skrypt został wygenerowany z lokalnej instalacji SQL Server i sekcja `CREATE DATABASE` zawiera ścieżki do plików `.mdf` i `.ldf` z konkretnego komputera. Na innym komputerze może być konieczne dostosowanie tych ścieżek lub utworzenie bazy ręcznie, a następnie wykonanie pozostałej części skryptu.

---

## 3. Connection string

Jeżeli SQL Server znajduje się pod inną nazwą, zmień:

```text
DziennikLekcyjny.Wpf/Data/DbSettings.cs
```

Przykład dla obecnej konfiguracji:

```text
Server=.\SQLEXPRESS;
Database=Projekt bazy danych dziennika lekcyjnego;
Trusted_Connection=True;
TrustServerCertificate=True;
```

---

## 4. Visual Studio

Otwórz:

```text
DziennikLekcyjny.sln
```

Visual Studio powinno automatycznie przywrócić pakiet NuGet.

Jeżeli tego nie zrobi:

**Tools → NuGet Package Manager → Manage NuGet Packages for Solution**

i zainstaluj:

```text
Microsoft.Data.SqlClient
```

---

## 5. Start

Uruchom aplikację:

- `F5` — z debuggerem,
- `Ctrl + F5` — bez debuggera.

Po starcie ViewModele automatycznie próbują pobrać dane z SQL Server.

Jeżeli połączenie się nie powiedzie, aplikacja wyświetli okno z błędem SQL.

---

# 🧭 Jak korzystać z programu

## Dodanie ucznia

1. Otwórz zakładkę **Uczniowie**.
2. Kliknij **Nowy**.
3. Wpisz imię.
4. Wpisz nazwisko.
5. Wprowadź 11-cyfrowy PESEL.
6. Wybierz datę urodzenia.
7. Wybierz klasę.
8. Kliknij **Dodaj**.

Lista uczniów zostanie ponownie pobrana z bazy.

## Edycja ucznia

1. Zaznacz ucznia w tabeli.
2. Jego dane pojawią się w formularzu.
3. Zmień wybrane wartości.
4. Kliknij **Zapisz**.

## Usunięcie ucznia

1. Zaznacz ucznia.
2. Kliknij **Usuń**.
3. Potwierdź operację.

Jeżeli rekord posiada zależne oceny lub obecności, usunięcie może zostać zablokowane przez SQL Server.

## Dodanie oceny

1. Otwórz zakładkę **Oceny**.
2. Wybierz ucznia.
3. Wybierz przedmiot.
4. Podaj ocenę.
5. Wybierz datę.
6. Kliknij **Dodaj ocenę**.

## Wyświetlenie planu

1. Otwórz **Plan lekcji**.
2. Dane zostaną wczytane automatycznie.
3. Kliknij **Odśwież plan**, aby pobrać je ponownie.

---

# 🎨 Interfejs

Interfejs korzysta ze wspólnych stylów zapisanych w `App.xaml`.

Zdefiniowane są tam m.in.:

- kolory aplikacji,
- wygląd przycisków,
- formularzy,
- tabel,
- zakładek,
- zaznaczonych rekordów.

Dzięki temu kolory i wygląd mogą być zmienione w jednym miejscu bez edycji każdego widoku osobno.

Obecna kolorystyka wykorzystuje:

- granatowy nagłówek,
- niebieskie akcje podstawowe,
- zielone przyciski dodawania,
- czerwony przycisk usuwania,
- jasne tła i delikatne obramowania.

---

# 🔐 Bezpieczeństwo i GitHub

W repozytorium **nie należy umieszczać** plików:

```text
*.mdf
*.ldf
*.bak
```

Są to lokalne pliki bazy danych i kopie zapasowe.

W repozytorium wystarczy skrypt:

```text
Database/script.sql
```

Connection string w tym projekcie używa Windows Authentication, dlatego nie zawiera loginu ani hasła.

Jeżeli w przyszłości połączenie będzie używało loginu i hasła SQL Server, dane dostępowe nie powinny być zapisywane bezpośrednio w publicznym repozytorium.

---

# ⚠️ Ograniczenia obecnej wersji

Projekt jest wersją demonstracyjną/edukacyjną i celowo nie został nadmiernie rozbudowany.

Aktualnie:

- nie ma systemu logowania,
- nie ma ról użytkowników,
- nie ma interfejsu do zarządzania nauczycielami,
- nie ma interfejsu do zarządzania klasami,
- nie ma interfejsu do zarządzania przedmiotami,
- nie ma osobnej zakładki obecności,
- plan lekcji jest tylko do odczytu,
- oceny można dodawać i przeglądać, ale obecny interfejs nie posiada edycji ani usuwania ocen,
- connection string jest ustawiony pod lokalny `SQLEXPRESS`,
- aplikacja zakłada istnienie bazy o określonej nazwie.

---

# 🔮 Możliwe kierunki rozwoju

Projekt można dalej rozszerzyć o:

- logowanie nauczyciela lub administratora,
- role i uprawnienia,
- moduł obecności,
- edycję i usuwanie ocen,
- zarządzanie nauczycielami,
- zarządzanie klasami i przedmiotami,
- edycję planu lekcji,
- wyświetlanie średniej ocen,
- statystyki frekwencji,
- wyszukiwanie i filtrowanie uczniów,
- eksport danych do PDF/Excel,
- konfigurację connection stringa poza kodem źródłowym,
- testy jednostkowe.

---

# 🛠️ Technologie

| Technologia | Zastosowanie |
|---|---|
| C# | logika aplikacji |
| .NET 8 | platforma uruchomieniowa |
| WPF | interfejs desktopowy |
| XAML | definicja widoków i stylów |
| MVVM | organizacja kodu |
| SQL Server Express | baza danych |
| T-SQL | struktura i logika bazy |
| Microsoft.Data.SqlClient | komunikacja C# ↔ SQL Server |
| Git / GitHub | wersjonowanie projektu |

---

# 📌 Podsumowanie działania

W największym uproszczeniu przepływ wygląda tak:

```text
Użytkownik
    │
    ▼
WPF / XAML
    │
    ▼
ViewModel
    │
    ▼
Database.cs
    │
    ▼
Microsoft.Data.SqlClient
    │
    ▼
SQL Server
    │
    ▼
Tabele / Widoki / Procedury
```

Po otrzymaniu danych proces działa w przeciwnym kierunku, a ViewModel aktualizuje interfejs dzięki mechanizmowi `INotifyPropertyChanged` i kolekcjom `ObservableCollection`.

---

## Autor

Projekt wykonany jako aplikacja edukacyjna prezentująca współpracę **WPF, MVVM i SQL Server**.

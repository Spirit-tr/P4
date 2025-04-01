using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;

public static class WeatherService
{
    public static List<WeatherData> LoadWeatherData(string filePath)
    {
        var weatherDataList = new List<WeatherData>();

        try
        {
            var lines = File.ReadAllLines(filePath).Skip(1); // Pomijamy nagłówek

            foreach (var line in lines)
            {
                var values = line.Split(',');

                var data = new WeatherData
                {
                    Date = DateTime.ParseExact(values[0], "yyyy-MM-dd", CultureInfo.InvariantCulture),
                    Temperature = double.Parse(values[1], CultureInfo.InvariantCulture),
                    Humidity = double.Parse(values[2], CultureInfo.InvariantCulture),
                    Pressure = double.Parse(values[3], CultureInfo.InvariantCulture)
                };

                weatherDataList.Add(data);
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine("Błąd podczas wczytywania pliku: " + ex.Message);
        }

        return weatherDataList;
    }
}

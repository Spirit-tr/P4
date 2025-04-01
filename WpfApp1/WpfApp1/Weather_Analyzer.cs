using System.Collections.Generic;
using System.Linq;

public static class WeatherAnalyzer
{
    public static double CalculateAverageTemperature(List<WeatherData> data) =>
        data.Average(d => d.Temperature);

    public static double CalculateMaxTemperature(List<WeatherData> data) =>
        data.Max(d => d.Temperature);

    public static double CalculateMinTemperature(List<WeatherData> data) =>
        data.Min(d => d.Temperature);
}

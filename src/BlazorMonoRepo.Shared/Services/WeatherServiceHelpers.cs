using BlazorMonoRepo.Shared.Models;

namespace BlazorMonoRepo.Shared.Services;

public static class WeatherServiceHelpers
{
    private static readonly string[] Summaries = new[]
    {
        "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
    };

    /// <summary>
    /// Generates mock weather forecast data for testing or offline scenarios
    /// </summary>
    /// <param name="days">Number of days to generate forecasts for (default: 5)</param>
    /// <returns>Array of weather forecasts</returns>
    public static WeatherForecast[] GenerateMockWeatherData(int days = 5)
    {
        var startDate = DateOnly.FromDateTime(DateTime.Now);
        
        return Enumerable.Range(1, days).Select(index => new WeatherForecast
        {
            Date = startDate.AddDays(index),
            TemperatureC = Random.Shared.Next(-20, 55),
            Summary = Summaries[Random.Shared.Next(Summaries.Length)]
        }).ToArray();
    }

    /// <summary>
    /// Logs weather service errors in a consistent format
    /// </summary>
    /// <param name="serviceName">Name of the service logging the error</param>
    /// <param name="ex">The exception that occurred</param>
    public static void LogWeatherServiceError(string serviceName, Exception ex)
    {
        Console.WriteLine($"[{serviceName}] Exception Type: {ex.GetType().FullName}");
        Console.WriteLine($"[{serviceName}] Exception Message: {ex.Message}");
        Console.WriteLine($"[{serviceName}] Stack Trace: {ex.StackTrace}");
    }

    /// <summary>
    /// Logs weather service API requests for debugging
    /// </summary>
    /// <param name="serviceName">Name of the service making the request</param>
    /// <param name="baseAddress">Base address of the HTTP client</param>
    /// <param name="endpoint">The endpoint being called</param>
    public static void LogApiRequest(string serviceName, string? baseAddress, string endpoint)
    {
        Console.WriteLine($"[{serviceName}] BaseAddress: {baseAddress}");
        Console.WriteLine($"[{serviceName}] Requesting: {baseAddress}{endpoint}");
    }
}

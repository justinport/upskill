using BlazorMonoRepo.Shared.Models;

namespace BlazorMonoRepo.UI.Services;

public interface IWeatherService
{
    Task<WeatherForecast[]> GetWeatherForecastAsync();
}

public class WeatherService : IWeatherService
{
    private readonly HttpClient _httpClient;

    public WeatherService(HttpClient httpClient)
    {
        _httpClient = httpClient;
    }

    public async Task<WeatherForecast[]> GetWeatherForecastAsync()
    {
        try
        {
            var response = await _httpClient.GetFromJsonAsync<WeatherForecast[]>("weatherforecast");
            return response ?? Array.Empty<WeatherForecast>();
        }
        catch (Exception ex)
        {
            // Log the exception in a real application
            Console.WriteLine($"Error fetching weather data: {ex.Message}");
            return Array.Empty<WeatherForecast>();
        }
    }
}

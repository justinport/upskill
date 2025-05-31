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
            Console.WriteLine($"[WeatherService] BaseAddress: {_httpClient.BaseAddress}");
            Console.WriteLine($"[WeatherService] Requesting: {_httpClient.BaseAddress}weatherforecast");
            var response = await _httpClient.GetFromJsonAsync<WeatherForecast[]>("weatherforecast");
            return response ?? Array.Empty<WeatherForecast>();
        }
        catch (Exception ex)
        {
            Console.WriteLine($"[WeatherService] Exception Type: {ex.GetType().FullName}");
            Console.WriteLine($"[WeatherService] Exception Message: {ex.Message}");
            Console.WriteLine($"[WeatherService] Stack Trace: {ex.StackTrace}");
            return Array.Empty<WeatherForecast>();
        }
    }
}

using BlazorMonoRepo.Shared.Models;
using BlazorMonoRepo.Shared.Services;

namespace BlazorMonoRepo.UI.Services;

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
            WeatherServiceHelpers.LogApiRequest("WeatherService", _httpClient.BaseAddress?.ToString(), "weatherforecast");
            var response = await _httpClient.GetFromJsonAsync<WeatherForecast[]>("weatherforecast");
            return response ?? Array.Empty<WeatherForecast>();
        }
        catch (Exception ex)
        {
            WeatherServiceHelpers.LogWeatherServiceError("WeatherService", ex);
            return Array.Empty<WeatherForecast>();
        }
    }
}

using BlazorMonoRepo.Shared.Models;
using BlazorMonoRepo.Shared.Services;
using System.Net.Http.Json;
using System.Text.Json;

namespace BlazorMonoRepo.MAUI.Services;

public class MauiWeatherService : IWeatherService
{
    private readonly HttpClient _httpClient;
    private readonly bool _useLocalData;

    public MauiWeatherService(HttpClient httpClient)
    {
        _httpClient = httpClient;
        // For now, we'll use local data. You can configure this to call your API when available
        _useLocalData = true;
    }

    public async Task<WeatherForecast[]> GetWeatherForecastAsync()
    {
        if (_useLocalData)
        {
            // Return mock data for offline/local use
            await Task.Delay(500); // Simulate network delay
            return WeatherServiceHelpers.GenerateMockWeatherData();
        }
        else
        {
            try
            {
                // When you want to call your API, configure the base address here
                var response = await _httpClient.GetFromJsonAsync<WeatherForecast[]>("weatherforecast");
                return response ?? Array.Empty<WeatherForecast>();
            }
            catch (Exception ex)
            {
                // Fallback to local data if API fails
                WeatherServiceHelpers.LogWeatherServiceError("MauiWeatherService", ex);
                Console.WriteLine("[MauiWeatherService] Falling back to local data");
                return WeatherServiceHelpers.GenerateMockWeatherData();
            }
        }
    }
}

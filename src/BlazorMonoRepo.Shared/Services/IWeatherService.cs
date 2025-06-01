using BlazorMonoRepo.Shared.Models;

namespace BlazorMonoRepo.Shared.Services;

public interface IWeatherService
{
    Task<WeatherForecast[]> GetWeatherForecastAsync();
}

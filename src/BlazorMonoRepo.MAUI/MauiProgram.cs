using Microsoft.Extensions.Logging;
using BlazorMonoRepo.MAUI.Services;
using BlazorMonoRepo.Shared.Services;

namespace BlazorMonoRepo.MAUI;

public static class MauiProgram
{
	public static MauiApp CreateMauiApp()
	{
		var builder = MauiApp.CreateBuilder();
		builder
			.UseMauiApp<App>()
			.ConfigureFonts(fonts =>
			{
				fonts.AddFont("OpenSans-Regular.ttf", "OpenSansRegular");
			});

		builder.Services.AddMauiBlazorWebView();

		// Register HTTP client and weather service
		builder.Services.AddHttpClient();
		builder.Services.AddScoped<IWeatherService, MauiWeatherService>();

#if DEBUG
		builder.Services.AddBlazorWebViewDeveloperTools();
		builder.Logging.AddDebug();
#endif

		return builder.Build();
	}
}

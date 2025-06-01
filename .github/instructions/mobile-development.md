# Mobile Development Instructions

## Prerequisites Setup

### macOS Development Environment
1. **Xcode**: Install from Mac App Store (required for iOS)
2. **Command Line Tools**: `xcode-select --install`
3. **iOS Simulators**: Install via Xcode → Preferences → Components
4. **MAUI Workload**: `dotnet workload install maui`

### Android Development (Optional)
1. **Android SDK**: Install via Visual Studio installer or standalone
2. **Android Emulator**: Configure in Android Studio
3. **Accept Licenses**: `dotnet build -t:InstallAndroidDependencies`

### Verification
```bash
# Check MAUI workload
dotnet workload list

# Check available simulators
xcrun simctl list devices available

# Verify project builds
dotnet build src/BlazorMonoRepo.MAUI/BlazorMonoRepo.MAUI.csproj -f net9.0-ios
```

## Development Workflow

### iOS Development

#### Building for iOS
```bash
# Clean build
dotnet clean src/BlazorMonoRepo.MAUI/BlazorMonoRepo.MAUI.csproj
dotnet build src/BlazorMonoRepo.MAUI/BlazorMonoRepo.MAUI.csproj -f net9.0-ios
```

#### Running on iOS Simulator
```bash
# Method 1: Using VS Code task (recommended)
# Use Command Palette → "Tasks: Run Task" → "start-maui-ios"

# Method 2: Using VS Code Launch Configuration
# Press F5 → Select "MAUI iOS - Build, Deploy & Run"

# Method 3: Direct script execution
/Users/justinport/Documents/upskill/.vscode/scripts/start-maui-ios.sh

# Method 4: Manual commands (for troubleshooting)
xcrun simctl boot "iPhone 16 Pro"
open -a Simulator
dotnet build src/BlazorMonoRepo.MAUI/BlazorMonoRepo.MAUI.csproj -f net9.0-ios
xcrun simctl install "iPhone 16 Pro" "src/BlazorMonoRepo.MAUI/bin/Debug/net9.0-ios/iossimulator-arm64/BlazorMonoRepo.MAUI.app"
xcrun simctl launch "iPhone 16 Pro" com.companyname.blazormonorepo.maui
```

#### VS Code Integration
The project includes automated iOS development workflows:

**Available Tasks:**
- `start-maui-ios`: Production iOS app launch
- `start-maui-ios-debug`: Debug-enabled iOS app launch with enhanced logging
- `build-maui-ios`: Build iOS project only

**Available Launch Configurations:**
- `MAUI iOS - Build, Deploy & Run`: Complete one-click iOS development workflow

**Automated Scripts:**
- `.vscode/scripts/start-maui-ios.sh`: Handles entire iOS workflow
- `.vscode/scripts/start-maui-ios-debug.sh`: Debug version with enhanced logging

#### iOS Simulator Management
```bash
# List available simulators
xcrun simctl list devices available

# Create new simulator (if needed)
xcrun simctl create "iPhone 15 Pro Test" "iPhone 15 Pro" "iOS-17-0"

# Boot simulator
xcrun simctl boot "iPhone 16 Pro"

# Install app
xcrun simctl install "iPhone 16 Pro" "path/to/app"

# Launch app
xcrun simctl launch "iPhone 16 Pro" "bundle.identifier"

# Uninstall app
xcrun simctl uninstall "iPhone 16 Pro" "bundle.identifier"

# Reset simulator
xcrun simctl erase "iPhone 16 Pro"
```

### Android Development

#### Building for Android
```bash
# Build for Android
dotnet build src/BlazorMonoRepo.MAUI/BlazorMonoRepo.MAUI.csproj -f net9.0-android

# Install Android dependencies if needed
dotnet build -t:InstallAndroidDependencies -f net9.0-android "-p:AndroidSdkDirectory=/path/to/android-sdk"
```

#### Running on Android Emulator
```bash
# List available emulators
emulator -list-avds

# Start emulator
emulator -avd "Pixel_8_API_34"

# Install and run
adb install "src/BlazorMonoRepo.MAUI/bin/Debug/net9.0-android/com.companyname.blazormonorepo.maui-Signed.apk"
adb shell am start -n "com.companyname.blazormonorepo.maui/crc64e1fb321c08285b90.MainActivity"
```

## 🚨 **Current Known Issues & Workarounds**

### **Android SDK Issues**
The Android build currently fails due to missing API level 35:
```
error XA5207: Could not find android.jar for API level 35
```

**Workaround Options:**
1. **Install Android SDK API Level 35:**
   ```bash
   dotnet build -t:InstallAndroidDependencies -f net9.0-android "-p:AndroidSdkDirectory=/Users/justinport/Library/Developer/Xamarin/android-sdk-macosx"
   ```

2. **Target a lower API level** by modifying `BlazorMonoRepo.MAUI.csproj`:
   ```xml
   <TargetSdkVersion>34</TargetSdkVersion>
   ```

### **macOS Codesigning Issues**
The macOS build fails with codesigning errors:
```
error: resource fork, Finder information, or similar detritus not allowed
```

**Workaround:** Focus on iOS simulator development for now, which works correctly.

### **Current Working Configurations**
- ✅ **iOS Simulator**: Builds and runs successfully
- ❌ **Android**: Requires SDK setup
- ❌ **macOS**: Requires codesigning configuration

## Mobile-Specific Development Patterns

### Service Implementation Pattern
```csharp
// MAUI services should prioritize offline-first design
public class MauiWeatherService : IWeatherService
{
    private readonly HttpClient _httpClient;
    private readonly ISecureStorage _secureStorage;
    private readonly IConnectivity _connectivity;

    public async Task<WeatherForecast[]> GetWeatherForecastAsync()
    {
        // 1. Check for cached data first
        var cachedData = await GetCachedDataAsync();
        
        // 2. If online and cache is stale, fetch new data
        if (_connectivity.NetworkAccess == NetworkAccess.Internet)
        {
            try
            {
                var freshData = await FetchFromApiAsync();
                await CacheDataAsync(freshData);
                return freshData;
            }
            catch (Exception ex)
            {
                // 3. Fallback to cached data on API failure
                return cachedData ?? GenerateMockData();
            }
        }
        
        // 4. Return cached data when offline
        return cachedData ?? GenerateMockData();
    }
}
```

### Platform-Specific Features

#### Device Features Integration
```csharp
// Example: Camera integration
public class MauiCameraService : ICameraService
{
    public async Task<byte[]> TakePhotoAsync()
    {
        var photo = await MediaPicker.CapturePhotoAsync();
        if (photo != null)
        {
            using var stream = await photo.OpenReadAsync();
            using var memoryStream = new MemoryStream();
            await stream.CopyToAsync(memoryStream);
            return memoryStream.ToArray();
        }
        return null;
    }
}
```

#### File System Access
```csharp
public class MauiFileService : IFileService
{
    public async Task SaveFileAsync(string filename, byte[] data)
    {
        var path = Path.Combine(FileSystem.AppDataDirectory, filename);
        await File.WriteAllBytesAsync(path, data);
    }
    
    public async Task<byte[]> LoadFileAsync(string filename)
    {
        var path = Path.Combine(FileSystem.AppDataDirectory, filename);
        if (File.Exists(path))
        {
            return await File.ReadAllBytesAsync(path);
        }
        return null;
    }
}
```

### UI Adaptations for Mobile

#### Responsive Component Design
```razor
@* Components should adapt to mobile form factors *@
<div class="weather-component @(IsMobile ? "mobile-layout" : "desktop-layout")">
    @if (IsMobile)
    {
        @* Stacked layout for mobile *@
        <div class="mobile-stack">
            @foreach (var forecast in Forecasts)
            {
                <div class="forecast-card-mobile">
                    <div class="date">@forecast.Date.ToString("MM/dd")</div>
                    <div class="temp">@forecast.TemperatureC°C</div>
                    <div class="summary">@forecast.Summary</div>
                </div>
            }
        </div>
    }
    else
    {
        @* Table layout for desktop *@
        <table class="forecast-table">
            @foreach (var forecast in Forecasts)
            {
                <tr>
                    <td>@forecast.Date.ToShortDateString()</td>
                    <td>@forecast.TemperatureC°C</td>
                    <td>@forecast.Summary</td>
                </tr>
            }
        </table>
    }
</div>

@code {
    [Parameter] public WeatherForecast[] Forecasts { get; set; }
    [Inject] public IBrowserSizeService BrowserSize { get; set; }
    
    private bool IsMobile => BrowserSize.Width < 768;
}
```

#### Platform-Specific CSS
```css
/* BlazorMonoRepo.Components/MyComponent.razor.css */

.weather-component {
    padding: 1rem;
}

/* Mobile-specific styles */
.mobile-layout {
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
}

.forecast-card-mobile {
    background: #f5f5f5;
    border-radius: 8px;
    padding: 1rem;
    display: grid;
    grid-template-columns: 1fr 1fr 2fr;
    align-items: center;
}

/* Desktop-specific styles */
.desktop-layout .forecast-table {
    width: 100%;
    border-collapse: collapse;
}

.desktop-layout .forecast-table td {
    padding: 0.5rem;
    border-bottom: 1px solid #ddd;
}
```

### Testing on Mobile

#### iOS Testing
1. **Simulator Testing**: Primary development testing
2. **Device Testing**: Deploy to physical iOS devices for real-world testing
3. **Memory Profiling**: Use Xcode Instruments for performance analysis

#### Android Testing
1. **Emulator Testing**: Use Android emulators for development
2. **Device Testing**: Test on various Android devices and versions
3. **Performance**: Use Android profiling tools

### Deployment Considerations

#### iOS Deployment
1. **Development**: iOS Simulator (covered in setup)
2. **TestFlight**: Beta distribution to testers
3. **App Store**: Production distribution

#### Android Deployment
1. **Development**: Local APK installation
2. **Google Play Console**: Internal testing and production

### Common Mobile Issues and Solutions

#### Performance Issues
- **Solution**: Implement virtualization for large lists
- **Solution**: Use lazy loading for images and data
- **Solution**: Optimize component rendering cycles

#### Memory Issues
- **Solution**: Dispose of services and subscriptions properly
- **Solution**: Use weak references for event handlers
- **Solution**: Clear caches periodically

#### Network Issues
- **Solution**: Implement retry logic with exponential backoff
- **Solution**: Cache critical data locally
- **Solution**: Provide offline functionality

#### Platform-Specific Bugs
- **Solution**: Use conditional compilation for platform-specific code
- **Solution**: Test on actual devices, not just simulators
- **Solution**: Keep platform-specific logic in services, not components

### Debugging Mobile Applications

#### Web Inspector for iOS
```bash
# Enable Web Inspector in iOS Simulator
# Safari → Develop → iPhone Simulator → [Your App]
```

#### Chrome DevTools for Android
```bash
# Enable USB debugging on Android device
# Chrome → chrome://inspect → Inspect webview
```

#### Native Debugging
- **iOS**: Use Xcode for native debugging and profiling
- **Android**: Use Android Studio for native debugging and profiling

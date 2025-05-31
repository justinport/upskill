# Blazor MonoRepo

This is a Blazor monorepo containing:
- **UI Project**: Blazor Server App (BlazorMonoRepo.UI)
- **API Project**: ASP.NET Core Web API (BlazorMonoRepo.API)
- **Shared Project**: Common models and services (BlazorMonoRepo.Shared)

## Project Structure

```
/
├── src/
│   ├── BlazorMonoRepo.UI/          # Blazor Server App
│   ├── BlazorMonoRepo.API/         # ASP.NET Core Web API
│   └── BlazorMonoRepo.Shared/      # Shared models and services
├── BlazorMonoRepo.sln              # Solution file
└── README.md
```

## Getting Started

### Prerequisites
- .NET 9.0 SDK or later
- Visual Studio 2022, VS Code, or JetBrains Rider

### Running the Applications

#### Option 1: Run both projects simultaneously
```bash
# Build the entire solution
dotnet build

# Run the API (Terminal 1)
cd src/BlazorMonoRepo.API
dotnet run

# Run the UI (Terminal 2) 
cd src/BlazorMonoRepo.UI
dotnet run
```

#### Option 2: Use the solution file
```bash
# Build and run from solution level
dotnet build
dotnet run --project src/BlazorMonoRepo.API &
dotnet run --project src/BlazorMonoRepo.UI
```

### URLs
- **Blazor UI**: https://localhost:7084 or http://localhost:5121
- **API**: https://localhost:7045 or http://localhost:5115
- **API Documentation**: https://localhost:7045/swagger

## Development

### Adding New Features
1. Add shared models to `BlazorMonoRepo.Shared/Models/`
2. Add API endpoints to `BlazorMonoRepo.API/Program.cs`
3. Add services to `BlazorMonoRepo.UI/Services/`
4. Create Blazor components in `BlazorMonoRepo.UI/Components/`

### Testing
```bash
# Run tests (when added)
dotnet test
```

### Project References
- UI → Shared
- API → Shared

This setup allows for shared models and business logic while keeping the UI and API concerns separated.

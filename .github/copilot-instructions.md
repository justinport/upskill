# GitHub Copilot Instructions

## Project Overview
This is a **Blazor Cross-Platform MonoRepo** with maximum code sharing between web and mobile platforms using .NET MAUI Blazor Hybrid architecture.

## Strategic Project Principles

### 🎯 **Primary Goals**
1. **Maximum Code Reuse**: Blazor components should work identically on web and mobile
2. **Clean Architecture**: Separation of concerns with clear project boundaries
3. **Platform Optimization**: Each platform has optimized services while sharing UI/logic
4. **Independent Deployment**: Each project can be built and deployed separately
5. **Developer Experience**: Consistent patterns, clear naming, comprehensive documentation

### 🏗️ **Architecture Rules**

#### **Project Dependencies (Must Follow)**
```
BlazorMonoRepo.UI → BlazorMonoRepo.Components → BlazorMonoRepo.Shared
BlazorMonoRepo.MAUI → BlazorMonoRepo.Components → BlazorMonoRepo.Shared  
BlazorMonoRepo.API → BlazorMonoRepo.Shared
```

#### **Code Placement Guidelines**
- **Shared UI Components** → `BlazorMonoRepo.Components/` (used by both web and mobile)
- **Data Models & Interfaces** → `BlazorMonoRepo.Shared/` (shared across all projects)
- **Web-Specific Services** → `BlazorMonoRepo.UI/Services/` (HTTP API calls)
- **Mobile-Specific Services** → `BlazorMonoRepo.MAUI/Services/` (offline support, native features)
- **API Endpoints** → `BlazorMonoRepo.API/Program.cs` (minimal API pattern)
- **Common Utilities** → `BlazorMonoRepo.Shared/Services/` (helpers, shared logic)

### 🔧 **Development Standards**

#### **When Adding New Features**
1. **Ask**: Can this be shared between web and mobile?
2. **UI Components**: Default to shared components unless platform-specific behavior needed
3. **Services**: Interface in Shared, platform-specific implementations
4. **Models**: Always in Shared unless platform-specific data structures needed
5. **Utilities**: Prefer shared helpers over duplicated code

#### **Naming Conventions**
- **Shared Components**: `[Feature]Component.razor` (e.g., `WeatherComponent.razor`)
- **Services**: `I[Feature]Service` interface, `[Platform][Feature]Service` implementation
- **Models**: Clear, descriptive names following C# conventions
- **Parameters**: Use `[Parameter]` properties for component customization

#### **Code Quality Rules**
- **No Duplicate Code**: Use shared utilities and helpers
- **Consistent Error Handling**: Use shared logging patterns
- **Platform Detection**: When needed, use dependency injection not hard-coded checks
- **Async Patterns**: Always use async/await for I/O operations
- **Dependency Injection**: Register all services properly in Program.cs

### 📱 **Platform-Specific Considerations**

#### **Web (BlazorMonoRepo.UI)**
- Optimized for HTTP API calls to BlazorMonoRepo.API
- Server-side rendering capabilities
- Real-time updates with SignalR (if added)

#### **Mobile (BlazorMonoRepo.MAUI)**
- Offline-first data strategy with API fallback
- Native device feature integration (camera, location, etc.)
- Platform-specific UI adaptations when needed

#### **API (BlazorMonoRepo.API)**
- RESTful endpoints following minimal API pattern
- Proper HTTP status codes and error responses
- Swagger documentation for all endpoints

### 🚀 **Build and Deployment**

#### **VS Code Setup (Primary Development Environment)**
This project includes comprehensive VS Code configuration:
- **Tasks**: Automated build, run, and deployment workflows
- **Launch Configurations**: One-click debugging for all projects  
- **Scripts**: Automated iOS simulator management
- **Extensions**: Recommended extensions for optimal development experience

Use `Ctrl+Shift+P` → "Tasks: Run Task" for build/run operations, `F5` for debugging with launch configurations.

#### **VS Code Tasks Available**
Use `Ctrl+Shift+P` → "Tasks: Run Task":
- **build-solution**: Build entire solution
- **build-working-projects**: Build using custom build script (excludes problematic projects)
- **start-api**: Start API server in background
- **start-ui**: Start web UI in background  
- **start-both**: Start both API and UI simultaneously
- **build-maui-ios**: Build MAUI iOS project only
- **start-maui-ios**: Complete iOS workflow (build → install → launch in simulator)
- **start-maui-ios-debug**: iOS workflow with debug symbols and enhanced logging

#### **VS Code Launch Configurations (F5)**
- **Launch API**: Debug the API server
- **Launch UI**: Debug the web UI server
- **Launch Both (API + UI)**: Debug both web projects simultaneously
- **MAUI iOS - Build, Deploy & Run**: Complete iOS development workflow

#### **Development Automation**
**Build Scripts:**
- `build-working.sh`: Intelligent build script that handles project dependencies
- `.vscode/scripts/start-maui-ios.sh`: Complete iOS simulator workflow
- `.vscode/scripts/start-maui-ios-debug.sh`: Enhanced iOS debugging workflow

**Manual Commands (Alternative):**
```bash
# Build everything
dotnet build BlazorMonoRepo.sln

# Build working projects only (safer alternative)
./build-working.sh

# Run API (Terminal 1)
dotnet run --project src/BlazorMonoRepo.API

# Run Web UI (Terminal 2) 
dotnet run --project src/BlazorMonoRepo.UI

# Run Mobile iOS (requires macOS + Xcode)
./.vscode/scripts/start-maui-ios.sh
```

#### **Always Test These Combinations**
1. Build entire solution: `dotnet build BlazorMonoRepo.sln` or `build-solution` task
2. Web stack: API + UI running together using `start-both` task or `Launch Both (API + UI)`
3. Mobile: iOS simulator using `start-maui-ios` task or `MAUI iOS - Build, Deploy & Run` launch config
4. Component isolation: Shared components work in both platforms

### 📚 **Documentation Standards**
- Update README.md for user-facing changes
- Update specific instruction files in `.github/instructions/` for development guidance
- Comment complex shared utilities and services
- Document breaking changes and migration steps

### 🔍 **When Something Goes Wrong**
1. **Build Errors**: Check project references and namespace imports
2. **Missing Types**: Verify correct `using` statements and project references
3. **Platform Issues**: Check platform-specific setup (iOS SDK, Android SDK)
4. **Service Resolution**: Verify DI registration in Program.cs files

### 💡 **AI Assistant Guidelines**
- Always consider cross-platform implications when suggesting changes
- Prefer shared solutions over platform-specific duplication
- Check project structure before making changes
- Test builds after significant modifications
- Follow existing patterns and naming conventions

## Quick Reference

### **Project Structure Overview**
```
/
├── .github/
│   ├── copilot-instructions.md       # Strategic AI guidance
│   └── instructions/                 # Detailed development guides
├── .vscode/
│   ├── launch.json                   # Debug configurations
│   ├── tasks.json                    # Build and run tasks
│   └── scripts/                      # Automation scripts
│       ├── start-maui-ios.sh         # iOS simulator workflow
│       └── start-maui-ios-debug.sh   # iOS debugging workflow
├── src/
│   ├── BlazorMonoRepo.UI/            # Blazor Server Web App
│   ├── BlazorMonoRepo.MAUI/          # .NET MAUI Blazor Hybrid Mobile App
│   ├── BlazorMonoRepo.API/           # ASP.NET Core Web API
│   ├── BlazorMonoRepo.Components/    # Shared Blazor Components Library
│   └── BlazorMonoRepo.Shared/        # Shared models and services
├── build-working.sh                  # Intelligent build script
├── BlazorMonoRepo.sln                # Solution file
└── README.md
```

### **Access URLs**
- **Web UI**: https://localhost:7084 or http://localhost:5121
- **API**: https://localhost:7045 or http://localhost:5115
- **API Docs**: https://localhost:7045/swagger

### **Detailed Documentation**
- **Architecture Details**: See `.github/instructions/architecture.md`
- **Development Workflow**: See `.github/instructions/development-workflow.md`
- **Mobile Development**: See `.github/instructions/mobile-development.md`
- **Component Creation**: See `.github/instructions/component-creation.md`

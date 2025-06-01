# Development Workflow Instructions

## Daily Development Workflow

### Starting Development
1. **Check Current State**:
   ```bash
   git status
   dotnet build BlazorMonoRepo.sln
   ```

2. **Start Development Environment**:
   
   **Option A: VS Code Tasks (Recommended)**
   ```bash
   # Use Command Palette (Ctrl+Shift+P) → "Tasks: Run Task"
   start-both           # Start API + UI simultaneously
   start-api           # Start API server only
   start-ui            # Start web UI only
   start-maui-ios      # Start mobile iOS app
   ```

   **Option B: VS Code Launch Configurations**
   ```bash
   # Press F5 and select:
   "Launch Both (API + UI)"        # Debug both web projects
   "Launch API"                    # Debug API only
   "Launch UI"                     # Debug UI only
   "MAUI iOS - Build, Deploy & Run" # iOS development
   ```

   **Option C: Manual Commands**
   ```bash
   # Start API (Terminal 1)
   dotnet run --project src/BlazorMonoRepo.API
   
   # Start Web UI (Terminal 2)
   dotnet run --project src/BlazorMonoRepo.UI
   ```

3. **Verify Everything Works**:
   - Web UI: https://localhost:7084
   - API: https://localhost:7045/swagger
   - Test basic functionality

### Adding New Features

#### 1. Planning Phase
- **Determine Scope**: Is this web-only, mobile-only, or shared?
- **Identify Components**: What UI components are needed?
- **Define Services**: What data/business logic is needed?
- **Choose Location**: Which project(s) will contain the new code?

#### 2. Implementation Order
1. **Models First** (if needed):
   ```bash
   # Add to BlazorMonoRepo.Shared/Models/
   ```

2. **Service Interfaces** (if needed):
   ```bash
   # Add to BlazorMonoRepo.Shared/Services/
   ```

3. **Shared Components** (if UI is shared):
   ```bash
   # Add to BlazorMonoRepo.Components/
   ```

4. **Platform Services** (implement interfaces):
   ```bash
   # Web: BlazorMonoRepo.UI/Services/
   # Mobile: BlazorMonoRepo.MAUI/Services/
   ```

5. **API Endpoints** (if backend needed):
   ```bash
   # Add to BlazorMonoRepo.API/Program.cs
   ```

6. **Platform Pages** (consume shared components):
   ```bash
   # Web: BlazorMonoRepo.UI/Components/Pages/
   # Mobile: BlazorMonoRepo.MAUI/Components/Pages/
   ```

#### 3. Testing Strategy
- **Build After Each Step**:
  ```bash
  # Option A: VS Code Task
  build-solution              # Build entire solution
  build-working-projects      # Build using custom script (safer)
  
  # Option B: Manual command
  dotnet build BlazorMonoRepo.sln
  ```

- **Test Shared Components**:
  - Test in web UI first (faster iteration)
  - Then verify in mobile app using `start-maui-ios` task

- **Test Services**:
  - Unit test interfaces and implementations
  - Integration test API endpoints

### Code Quality Checklist

#### Before Committing
- [ ] Solution builds without warnings
- [ ] No duplicate code between platforms
- [ ] Shared components work on both web and mobile
- [ ] Services follow interface patterns
- [ ] Error handling is consistent
- [ ] Documentation is updated
- [ ] No hardcoded platform detection

#### Code Review Focus Areas
- **Cross-Platform Compatibility**: Does shared code work everywhere?
- **Service Boundaries**: Are responsibilities clearly separated?
- **Error Handling**: Are errors handled gracefully?
- **Performance**: Are there any obvious performance issues?
- **Documentation**: Is the code self-documenting or properly commented?

### Common Development Patterns

#### Creating a New Shared Component
```bash
# 1. Create component file
touch src/BlazorMonoRepo.Components/MyNewComponent.razor

# 2. Optional: Create component-specific CSS
touch src/BlazorMonoRepo.Components/MyNewComponent.razor.css

# 3. Update _Imports.razor if new usings needed
# 4. Test in web UI first
# 5. Test in mobile app
# 6. Build solution to verify
dotnet build BlazorMonoRepo.sln
```

#### Adding a New Service
```bash
# 1. Create interface in Shared
touch src/BlazorMonoRepo.Shared/Services/IMyNewService.cs

# 2. Create web implementation
touch src/BlazorMonoRepo.UI/Services/MyNewService.cs

# 3. Create mobile implementation
touch src/BlazorMonoRepo.MAUI/Services/MauiMyNewService.cs

# 4. Register services in Program.cs files
# 5. Test implementations
# 6. Build and verify
dotnet build BlazorMonoRepo.sln
```

#### Adding a New API Endpoint
```bash
# 1. Add model to Shared (if needed)
# 2. Add endpoint to API/Program.cs
# 3. Update service implementations to call endpoint
# 4. Test with Swagger
# 5. Build and verify
dotnet build BlazorMonoRepo.sln
```

### Debugging Workflow

#### Web Application
1. **Use Browser Dev Tools**: F12 for network, console, and DOM inspection
2. **Server-Side Debugging**: Set breakpoints in VS Code/Visual Studio
3. **API Testing**: Use Swagger UI or Postman for API endpoints

#### Mobile Application
1. **iOS Simulator**: Use Safari Web Inspector for webview debugging
2. **Device Debugging**: Connect physical device for real-world testing
3. **Platform-Specific**: Use Xcode instruments for iOS-specific debugging

#### Common Issues
- **Missing References**: Check project references and using statements
- **Service Registration**: Verify DI registration in Program.cs
- **Component Parameters**: Ensure proper parameter binding
- **Platform Differences**: Test on actual devices, not just simulators

### Git Workflow

#### Branch Strategy
```bash
# Feature development
git checkout -b feature/my-new-feature
git add .
git commit -m "Add shared component for feature X"
git push origin feature/my-new-feature
```

#### Commit Message Format
```
Type: Brief description

- Detail 1
- Detail 2

Affected projects: UI, Components, Shared
Tested on: Web, iOS Simulator
```

### Performance Considerations

#### Web Application
- **Bundle Size**: Monitor JavaScript bundle size
- **Server Resources**: Consider SignalR connection limits
- **Caching**: Implement appropriate caching strategies

#### Mobile Application
- **Battery Usage**: Minimize background processing
- **Network Usage**: Implement offline-first strategies
- **Memory**: Monitor memory usage on resource-constrained devices

#### Shared Components
- **Render Performance**: Minimize re-renders with proper parameter usage
- **Event Handling**: Use efficient event delegation
- **State Management**: Keep component state minimal and focused


# Copilot Instructions

Welcome to the upskill repository! This project is called "upskilling" because it's a personal pet project to help me stay up to speed with new technologies and best practices. My goal is to use this space for both learning and practical purposes—specifically, to see if I can create a Blazor app from scratch and experiment with modern .NET development.

This file provides guidance for using GitHub Copilot and other AI coding assistants effectively in this project.

## Best Practices
- Use Copilot for boilerplate, repetitive code, and suggestions.
- Always review and test Copilot-generated code before committing.
- Add comments to clarify any AI-generated logic that may be unclear to others.

## Prompt Engineering Tips
- Be specific in your comments and function signatures to get better suggestions.
- Use descriptive variable and function names.
- If Copilot gets stuck, try rephrasing your comment or breaking down the problem.


## Fullstack Blazor + API Best Practices

### General Architecture
- **Separation of Concerns:** Keep your UI (Blazor) and API (ASP.NET Core) in separate projects. This makes it easier to test, maintain, and eventually swap out the UI or API independently.
- **Shared Models:** Use a shared class library for DTOs/models that are used by both the UI and API. This avoids duplication and keeps contracts in sync.

### API Best Practices
- **Use `[ApiController]` Attribute:** Enables automatic model validation, binding source inference, and consistent error responses.
- **Attribute Routing:** Use attribute routing for clarity and flexibility.
- **Consistent Status Codes:** Use helper methods like `Ok()`, `CreatedAtAction()`, `BadRequest()`, and `NotFound()` for clear, RESTful responses.
- **Validation:** Rely on automatic model validation, but customize error responses as needed for your client.
- **Swagger/OpenAPI:** Enable Swagger for easy API documentation and testing.

### Blazor UI Best Practices
- **Componentization:** Break your UI into reusable Razor components.
- **Dependency Injection:** Use DI for services and state management.
- **Async Data Loading:** Use `async`/`await` for API calls to keep the UI responsive.
- **Error Handling:** Gracefully handle API errors and show user-friendly messages.
- **State Management:** For larger apps, consider a state container or Flux-like pattern.

### For Future Native/Hybrid Support
- **Blazor Hybrid:** Blazor components can be reused in native apps via .NET MAUI (Blazor Hybrid). Keep business logic and UI components as decoupled as possible.
- **No Browser-Only APIs:** Avoid using browser-specific APIs directly in your components if you want to reuse them in native apps.
- **Service Abstractions:** Abstract platform-specific functionality (like file access, notifications) behind interfaces, and provide implementations for web and native.



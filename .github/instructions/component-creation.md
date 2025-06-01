# Component Creation Instructions

## Creating Shared Components

### Component Design Principles

1. **Platform Agnostic**: Components must work identically on web and mobile
2. **Parameter Driven**: Use `[Parameter]` for all customization, avoid hard-coded values
3. **Single Responsibility**: Each component should have one clear purpose
4. **Composable**: Components should be easily combined with other components
5. **Accessible**: Follow accessibility best practices

### Component Structure Template

```razor
@* BlazorMonoRepo.Components/[ComponentName].razor *@
@using BlazorMonoRepo.Shared.Models
@using BlazorMonoRepo.Shared.Services

<div class="@CssClass">
    @* Component content here *@
    @if (IsLoading)
    {
        <div class="loading-indicator">
            <span>@LoadingText</span>
        </div>
    }
    else if (HasError)
    {
        <div class="error-message">
            <span>@ErrorMessage</span>
            @if (ShowRetryButton)
            {
                <button @onclick="OnRetryClick">@RetryButtonText</button>
            }
        </div>
    }
    else
    {
        @* Main content when loaded successfully *@
        @ChildContent
    }
</div>

@code {
    // Required parameters
    [Parameter] public RenderFragment? ChildContent { get; set; }
    
    // Optional parameters with defaults
    [Parameter] public string CssClass { get; set; } = "";
    [Parameter] public bool IsLoading { get; set; } = false;
    [Parameter] public string LoadingText { get; set; } = "Loading...";
    [Parameter] public bool HasError { get; set; } = false;
    [Parameter] public string ErrorMessage { get; set; } = "An error occurred.";
    [Parameter] public bool ShowRetryButton { get; set; } = false;
    [Parameter] public string RetryButtonText { get; set; } = "Retry";
    
    // Event callbacks
    [Parameter] public EventCallback OnRetryClick { get; set; }
    [Parameter] public EventCallback<ComponentState> OnStateChanged { get; set; }
    
    // Private fields
    private ComponentState _currentState = ComponentState.Idle;
    
    // Lifecycle methods
    protected override async Task OnInitializedAsync()
    {
        await base.OnInitializedAsync();
        await NotifyStateChanged(ComponentState.Initialized);
    }
    
    // Helper methods
    private async Task NotifyStateChanged(ComponentState newState)
    {
        _currentState = newState;
        if (OnStateChanged.HasDelegate)
        {
            await OnStateChanged.InvokeAsync(newState);
        }
    }
}
```

### Component CSS Template

```css
/* BlazorMonoRepo.Components/[ComponentName].razor.css */

/* Base component styles */
.component-container {
    display: flex;
    flex-direction: column;
    gap: 1rem;
    padding: 1rem;
    border-radius: 8px;
    background: var(--component-background, #ffffff);
    border: 1px solid var(--component-border, #e0e0e0);
}

/* Loading state */
.loading-indicator {
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 2rem;
    color: var(--loading-color, #666666);
}

/* Error state */
.error-message {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 1rem;
    padding: 1rem;
    background: var(--error-background, #fef2f2);
    border: 1px solid var(--error-border, #fca5a5);
    border-radius: 4px;
    color: var(--error-color, #dc2626);
}

/* Responsive design */
@media (max-width: 768px) {
    .component-container {
        padding: 0.5rem;
        gap: 0.5rem;
    }
}

/* High contrast mode support */
@media (prefers-contrast: high) {
    .component-container {
        border-width: 2px;
    }
}

/* Reduced motion support */
@media (prefers-reduced-motion: reduce) {
    * {
        animation-duration: 0.01ms !important;
        animation-iteration-count: 1 !important;
        transition-duration: 0.01ms !important;
    }
}
```

### Step-by-Step Creation Process

#### 1. Plan the Component
```markdown
Component Name: ProductCard
Purpose: Display product information in a card format
Platforms: Web and Mobile
Dependencies: BlazorMonoRepo.Shared.Models.Product
Parameters: Product, ShowDetails, OnAddToCart
Events: AddToCart, ViewDetails
States: Loading, Loaded, Error
```

#### 2. Create the Component File
```bash
touch src/BlazorMonoRepo.Components/ProductCard.razor
```

#### 3. Create the CSS File (if needed)
```bash
touch src/BlazorMonoRepo.Components/ProductCard.razor.css
```

#### 4. Implement the Component
```razor
@* ProductCard.razor *@
@using BlazorMonoRepo.Shared.Models

<div class="product-card @CssClass">
    @if (Product != null)
    {
        <div class="product-image">
            <img src="@Product.ImageUrl" alt="@Product.Name" loading="lazy" />
        </div>
        <div class="product-info">
            <h3 class="product-name">@Product.Name</h3>
            <p class="product-price">@Product.Price.ToString("C")</p>
            @if (ShowDescription && !string.IsNullOrEmpty(Product.Description))
            {
                <p class="product-description">@Product.Description</p>
            }
        </div>
        <div class="product-actions">
            <button class="btn btn-primary" @onclick="HandleAddToCart" disabled="@IsLoading">
                @if (IsLoading)
                {
                    <span>Adding...</span>
                }
                else
                {
                    <span>@AddToCartText</span>
                }
            </button>
            @if (ShowDetailsButton)
            {
                <button class="btn btn-secondary" @onclick="HandleViewDetails">
                    @ViewDetailsText
                </button>
            }
        </div>
    }
    else
    {
        <div class="product-placeholder">
            <span>Product information unavailable</span>
        </div>
    }
</div>

@code {
    [Parameter] public Product? Product { get; set; }
    [Parameter] public string CssClass { get; set; } = "";
    [Parameter] public bool ShowDescription { get; set; } = true;
    [Parameter] public bool ShowDetailsButton { get; set; } = true;
    [Parameter] public string AddToCartText { get; set; } = "Add to Cart";
    [Parameter] public string ViewDetailsText { get; set; } = "View Details";
    [Parameter] public bool IsLoading { get; set; } = false;
    
    [Parameter] public EventCallback<Product> OnAddToCart { get; set; }
    [Parameter] public EventCallback<Product> OnViewDetails { get; set; }
    
    private async Task HandleAddToCart()
    {
        if (Product != null && OnAddToCart.HasDelegate)
        {
            await OnAddToCart.InvokeAsync(Product);
        }
    }
    
    private async Task HandleViewDetails()
    {
        if (Product != null && OnViewDetails.HasDelegate)
        {
            await OnViewDetails.InvokeAsync(Product);
        }
    }
}
```

#### 5. Add Component CSS
```css
/* ProductCard.razor.css */
.product-card {
    display: flex;
    flex-direction: column;
    border: 1px solid #e0e0e0;
    border-radius: 8px;
    overflow: hidden;
    background: #ffffff;
    transition: box-shadow 0.2s ease;
}

.product-card:hover {
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.product-image img {
    width: 100%;
    height: 200px;
    object-fit: cover;
}

.product-info {
    padding: 1rem;
    flex: 1;
}

.product-name {
    margin: 0 0 0.5rem 0;
    font-size: 1.25rem;
    font-weight: 600;
}

.product-price {
    margin: 0 0 1rem 0;
    font-size: 1.125rem;
    font-weight: 500;
    color: #059669;
}

.product-description {
    margin: 0;
    color: #666666;
    line-height: 1.5;
}

.product-actions {
    padding: 1rem;
    display: flex;
    gap: 0.5rem;
    border-top: 1px solid #f0f0f0;
}

.btn {
    padding: 0.5rem 1rem;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-weight: 500;
    transition: background-color 0.2s ease;
}

.btn-primary {
    background: #3b82f6;
    color: white;
    flex: 1;
}

.btn-primary:hover:not(:disabled) {
    background: #2563eb;
}

.btn-primary:disabled {
    background: #9ca3af;
    cursor: not-allowed;
}

.btn-secondary {
    background: #f3f4f6;
    color: #374151;
}

.btn-secondary:hover {
    background: #e5e7eb;
}

.product-placeholder {
    padding: 2rem;
    text-align: center;
    color: #9ca3af;
}

/* Mobile adaptations */
@media (max-width: 640px) {
    .product-actions {
        flex-direction: column;
    }
    
    .product-image img {
        height: 150px;
    }
}
```

#### 6. Test the Component

##### Test in Web UI
```razor
@* BlazorMonoRepo.UI/Components/Pages/TestPage.razor *@
@page "/test"
@using BlazorMonoRepo.Shared.Models

<h1>Component Testing</h1>

<div class="component-test">
    <ProductCard 
        Product="@testProduct" 
        OnAddToCart="@HandleAddToCart"
        OnViewDetails="@HandleViewDetails" />
</div>

@code {
    private Product testProduct = new Product
    {
        Id = 1,
        Name = "Test Product",
        Description = "This is a test product for component testing.",
        Price = 29.99m,
        ImageUrl = "https://via.placeholder.com/300x200"
    };
    
    private async Task HandleAddToCart(Product product)
    {
        // Test add to cart functionality
        Console.WriteLine($"Adding {product.Name} to cart");
    }
    
    private async Task HandleViewDetails(Product product)
    {
        // Test view details functionality
        Console.WriteLine($"Viewing details for {product.Name}");
    }
}
```

##### Test in MAUI
```razor
@* BlazorMonoRepo.MAUI/Components/Pages/TestPage.razor *@
@* Same code as above - component should work identically *@
```

#### 7. Update _Imports.razor (if needed)
```razor
@* Add any new using statements if required *@
@using BlazorMonoRepo.Shared.Models
@using BlazorMonoRepo.Shared.Services
```

### Component Testing Checklist

- [ ] Component builds without errors
- [ ] Works on web UI
- [ ] Works on mobile app
- [ ] Responsive design works on different screen sizes
- [ ] All parameters work as expected
- [ ] All events fire correctly
- [ ] Error states display properly
- [ ] Loading states work correctly
- [ ] Accessibility requirements met
- [ ] CSS follows design system

### Common Component Patterns

#### Data Loading Component
```razor
<DataLoader TData="WeatherForecast[]" 
           LoadDataAsync="@weatherService.GetWeatherForecastAsync"
           Context="forecasts">
    <LoadingTemplate>
        <div class="spinner">Loading weather...</div>
    </LoadingTemplate>
    <DataTemplate>
        <WeatherComponent Forecasts="@forecasts" />
    </DataTemplate>
    <ErrorTemplate Context="error">
        <div class="error">Failed to load: @error.Message</div>
    </ErrorTemplate>
</DataLoader>
```

#### Modal Component
```razor
<Modal IsVisible="@showModal" OnClose="@(() => showModal = false)">
    <Header>
        <h2>Confirm Action</h2>
    </Header>
    <Body>
        <p>Are you sure you want to proceed?</p>
    </Body>
    <Footer>
        <button @onclick="@(() => showModal = false)">Cancel</button>
        <button @onclick="@HandleConfirm">Confirm</button>
    </Footer>
</Modal>
```

#### Form Component
```razor
<EditForm Model="@model" OnValidSubmit="@HandleValidSubmit">
    <DataAnnotationsValidator />
    <ValidationSummary />
    
    <FormField Label="Name" For="() => model.Name">
        <InputText @bind-Value="model.Name" />
    </FormField>
    
    <FormField Label="Email" For="() => model.Email">
        <InputText @bind-Value="model.Email" type="email" />
    </FormField>
    
    <button type="submit">Submit</button>
</EditForm>
```

### Best Practices Summary

1. **Keep components focused** - One responsibility per component
2. **Use parameters for configuration** - Avoid hard-coded values
3. **Provide sensible defaults** - Make components easy to use
4. **Handle edge cases** - Null data, loading states, errors
5. **Follow naming conventions** - Clear, descriptive names
6. **Document complex components** - Add XML comments for parameters
7. **Test across platforms** - Verify web and mobile compatibility
8. **Consider accessibility** - Screen readers, keyboard navigation
9. **Optimize performance** - Minimize re-renders, use efficient patterns
10. **Follow design system** - Consistent styling and behavior

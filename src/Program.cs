using Microsoft.AspNetCore.Components.Web;
using Microsoft.AspNetCore.Components.WebAssembly.Hosting;
using Radzen;
using TauriBlazorBoilerplate;
using TauriBlazorBoilerplate.Services;

var builder = WebAssemblyHostBuilder.CreateDefault(args);
builder.Services.AddRadzenComponents();
builder.Services.AddRadzenCookieThemeService(options =>
{
    options.Name = "TauriBlazorBoilerplateTheme";
    options.Duration = TimeSpan.FromDays(365);
});

// Register the custom services
builder.Services.AddScoped<TauriBlazorBoilerplate.Services.VersionService>();

builder.RootComponents.Add<App>("#app");
builder.RootComponents.Add<HeadOutlet>("head::after");

builder.Services.AddScoped(sp => new HttpClient { BaseAddress = new Uri(builder.HostEnvironment.BaseAddress) });

await builder.Build().RunAsync();

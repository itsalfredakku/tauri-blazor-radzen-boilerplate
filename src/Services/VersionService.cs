using Microsoft.JSInterop;
using System.Text.Json;

namespace TauriBlazorBoilerplate.Services
{
    public class VersionInfo
    {
        public string Version { get; set; } = "1.0.0";
        public string ProductName { get; set; } = "Tauri + Blazor Boilerplate";
        public string Copyright { get; set; } = $"Copyright © {DateTime.Now.Year}";
    }

    public class VersionService
    {
        private readonly IJSRuntime _jsRuntime;
        private VersionInfo _versionInfo = new VersionInfo();
        private bool _loaded = false;

        public event Action? OnVersionInfoLoaded;

        public VersionService(IJSRuntime jsRuntime)
        {
            _jsRuntime = jsRuntime;
        }

        public VersionInfo GetVersionInfo() => _versionInfo;

        public async Task LoadVersionInfoAsync()
        {
            if (_loaded) return;

            try
            {
                // Try to get version from Tauri
                var version = await _jsRuntime.InvokeAsync<string>("eval", @"
                    (async function() {
                        if (window.__TAURI__) {
                            try {
                                const appInfo = {
                                    version: window.__TAURI_METADATA__?.version || '1.0.0',
                                    productName: window.__TAURI_METADATA__?.productName || 'Tauri + Blazor Boilerplate',
                                    copyright: `Copyright © ${new Date().getFullYear()}`
                                };
                                return JSON.stringify(appInfo);
                            } catch (e) {
                                return JSON.stringify({
                                    version: '1.0.0',
                                    productName: 'Tauri + Blazor Boilerplate',
                                    copyright: `Copyright © ${new Date().getFullYear()}`
                                });
                            }
                        } else {
                            return JSON.stringify({
                                version: '1.0.0',
                                productName: 'Tauri + Blazor Boilerplate',
                                copyright: `Copyright © ${new Date().getFullYear()}`
                            });
                        }
                    })();
                ");

                if (!string.IsNullOrEmpty(version))
                {
                    _versionInfo = JsonSerializer.Deserialize<VersionInfo>(version) ?? _versionInfo;
                }
            }
            catch
            {
                // If there's an error, use default values
            }
            finally
            {
                _loaded = true;
                OnVersionInfoLoaded?.Invoke();
            }
        }
    }
}

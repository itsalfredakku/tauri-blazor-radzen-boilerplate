// filepath: /Volumes/EXT/repos/devstroop/tauri-blazor-boilerplate/src/Layout/MainLayout.razor.cs
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.JSInterop;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Web;
using Radzen;
using Radzen.Blazor;

namespace TauriBlazorBoilerplate.Layout
{
    public partial class MainLayout
    {
        [Inject]
        public required IJSRuntime JSRuntime { get; set; }

        [Inject]
        public required NavigationManager NavigationManager { get; set; }

        [Inject]
        public required DialogService DialogService { get; set; }

        [Inject]
        public required TooltipService TooltipService { get; set; }

        [Inject]
        public required ContextMenuService ContextMenuService { get; set; }

        [Inject]
        public required NotificationService NotificationService { get; set; }

        private bool sidebarExpanded = true;

        void SidebarToggleClick()
        {
            sidebarExpanded = !sidebarExpanded;
        }
    }
}

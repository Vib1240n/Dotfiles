# Sketchybar Configuration (Lua)

This directory contains the configuration for **Sketchybar**, a programmable status bar for macOS. It utilizes the **SbarLua** interface to define items, layout, and behavior using Lua scripts.

## Project Structure

### Core Files
*   **`sketchybarrc`**: The entry point. It acts as a bootstrapper that sets up the Lua package path and requires `init.lua`.
*   **`init.lua`**: The main configuration file. It initializes the `sketchybar` module, loads the bar properties, default settings, and items.
*   **`bar.lua`**: Defines the global properties of the bar (geometry, position, color, transparency).
*   **`items/init.lua`**: Orchestrates the loading of specific bar items (widgets) in the desired order.

### Directories
*   **`items/`**: Contains Lua scripts for individual bar items (e.g., `apple.lua`, `calendar.lua`, `front_app.lua`) and widgets.
    *   **`widgets/system_stats.lua`**: A complex widget aggregating CPU, GPU, RAM, Disk, Network, Fan, and Battery info. It subscribes to custom events.
*   **`helpers/`**: Contains source code (C, Swift, Shell) for helper binaries that provide data to Sketchybar.
    *   **`makefile`**: Automates the compilation of helpers. This is triggered automatically by `helpers/init.lua` on config load.
    *   **`event_providers/`**: C code for high-performance event generation (e.g., CPU load, Network load).
*   **`plugins/`**: Shell scripts used by items for specific actions or background processes (e.g., `fan_timer.sh`).

## Key Mechanisms

1.  **Helper Compilation**: The configuration automatically attempts to compile helpers located in `helpers/` whenever Sketchybar is reloaded. This ensures binaries are up-to-date.
2.  **Event System**:
    *   **Standard Events**: Items subscribe to events like `routine`, `mouse.clicked`, `wifi_change`.
    *   **Custom Events**: The `stats_provider` helper (launched in `helpers/init.lua`) pushes custom events like `system_stats` to update resource widgets efficiently without polling via shell commands for every update.
3.  **Widget Logic**: Most logic resides in `items/widgets/system_stats.lua`. It handles display logic, popups (e.g., hover for CPU temp), and interactions (click to open `btop` or System Settings).

## Development & Usage

*   **Reloading**: Run `sketchybar --reload` in your terminal to apply changes. This will re-execute `sketchybarrc`, recompile helpers, and reload the Lua state.
*   **Adding Items**: Create a new Lua file in `items/` and add a `require` line in `items/init.lua` to include it.
*   **Debugging**:
    *   Check `sketchybar` logs (usually streamed to stdout/stderr if running in foreground, or check system logs).
    *   Use `print()` in Lua scripts for simple debugging (output typically goes to Sketchybar's log).
*   **Dependencies**:
    *   **Fonts**: Ensure the fonts referenced in `settings.lua` (e.g., SF Pro, customized icon fonts) are installed.
    *   **External Tools**: Some widgets rely on external CLIs like `btop`, `stats`, or `powermetrics`.

## Notes
*   The `temporary-files/` directory contains backups and experimental configurations.
*   `settings.lua` and `colors.lua` are central places to tweak visual styles and themes.

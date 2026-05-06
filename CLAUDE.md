# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Carsontool5** is an iOS jailbreak dylib tweak that injects into **ARK: Survival Evolved** (mobile) to provide a cheat menu overlay. It hooks game methods, reads/writes process memory, and renders an ImGui-based UI over Metal.

## Build System

This is a **Theos/Logos** project. There is no Makefile checked in — build is managed externally via Theos.

Required compiler flags (add to Theos `ADDITIONAL_CFLAGS`):
```
-mllvm -enable-bcfobf -mllvm -enable-indibran -mllvm -enable-strcry -mllvm -enable-subobf
```
These enable LLVM obfuscation passes (bogus control flow, indirect branching, string encryption, subroutine obfuscation).

## Code Architecture

### Injection Entry Point

`Logos/mnkydevtest2Dylib.xm` — Logos `%ctor` block that bootstraps the tweak. It initializes ImGui with a Metal backend (`KittyMemory/imgui_impl_metal.mm`) and loads fonts from `/System/Library/Fonts/AppFonts/Charter.ttc`.

`Logos/PubgLoad.mm` — game library loader; hooks the game's dylib load to install function hooks and start the menu rendering loop.

`Logos/ImGuiDrawView.xm/.mm` — hooks `MTKView` to inject the ImGui render pass into the game's Metal command buffer each frame.

### Singleton Pattern

All major systems are singletons accessed via `getInstance()`. `src/Includes.h` is the master header that includes every subsystem header and declares all singleton references as `static` globals — include it in any `.mm` that needs cross-system access.

### Key Subsystems

| Directory/File | Purpose |
|---|---|
| `src/BaseUtils.mm` | `getOffset()` — translates hardcoded binary offsets to ASLR-adjusted addresses; memory read/write wrappers |
| `src/GameUtils.mm` | UE4-specific helpers: weak pointer resolution, player/dino actor queries, `UObject` traversal |
| `src/Hooks.mm` | Function pointer hooks installed via `BaseUtils::getOffset()` — intercepts `ProcessEvent`, weapon fire, movement |
| `src/Functions.mm` | Callable game functions (teleport, god mode, etc.) resolved the same way |
| `src/ESP.mm` | ESP/wallhack: iterates actor lists, projects world positions to screen |
| `src/Aimbot.mm` | Targeting and auto-fire logic |
| `src/Menu.mm` | ImGui menu rendering and in-menu console log |
| `src/EncryptedPreferences.mm` | AES-encrypted user preference persistence (`AESCrypt-ObjC/`) |
| `src/AdminMenu/` | Item/dino/material spawning, quick commands, waypoints |
| `src/OtherWindows/` | Secondary ImGui windows: minimap, chat, player list, crosshair, aim assist |
| `src/Customize/` | Menu styling, player/weapon color pickers |
| `src/CodeRegistration/` | License/login menu |
| `src/Translations/MenuText.mm` | Localized strings (English, Korean, Japanese, Simplified Chinese) |
| `KittyMemory/` | Memory patching library + full ImGui source (Metal backend) |
| `fishhook/` | Facebook fishhook for C symbol rebinding |
| `Trace/` | `OCMethodTrace` + architecture-specific selector trampolines for Objective-C method tracing |
| `Utils/Structures.h` | UE4/ARK class layout definitions (offsets into game structs) |

### Memory Hooking Pattern

All game function hooks follow this pattern:
```cpp
// Declare original function pointer
static void (*origFoo)(UObject*, UObject*, void*) =
    (void(*)(UObject*,UObject*,void*))utils.getOffset(0xDEADBEEF);

// Hook implementation calls orig to preserve game behavior
static void MyHook(UObject* obj, UObject* fn, void* params) {
    // pre-hook logic
    origFoo(obj, fn, params);
    // post-hook logic
}
```
Offsets in `Hooks.mm` / `Functions.mm` are version-specific binary offsets from the game's `__TEXT` segment start.

### UI Rendering Loop

1. `ImGuiDrawView` (a `UIViewController`) is presented over the game window.
2. Each Metal frame: `ImGui_ImplMetal_NewFrame` → `ImGui::NewFrame` → feature windows → `ImGui::Render` → `ImGui_ImplMetal_RenderDrawData`.
3. Menu is anchored at `SCREEN_WIDTH - 400` (right side of screen).
4. Touch input forwarded through `MTKView+Interactive.m`.

### Background Keep-Alive

`src/RunInBg/RunInBackground` plays a silent audio loop to prevent iOS from suspending the injected process.

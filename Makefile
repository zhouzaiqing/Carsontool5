export THEOS_DEVICE_IP =
export ARCHS = arm64 arm64e
export TARGET = iphone:clang:latest:14.0

# Theos modules
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Carsontool5

# ---- Source files ---------------------------------------------------------
# Logos sources. Note: the .mm in Logos/ is the logos.pl-preprocessed output
# of the original .xm — it has the complete rendering loop (menu.DrawMainMenu,
# Minimap, hooks, ESP, etc.) that the stripped-down .xm in this repo lacks.
# We compile the .mm directly and intentionally skip the .xm.
Carsontool5_FILES  = Logos/mnkydevtest2Dylib.mm
Carsontool5_FILES += Logos/PubgLoad.mm
Carsontool5_FILES += Logos/MTKView+Interactive.m

# Menu / hooks / features
Carsontool5_FILES += $(wildcard src/*.mm)
Carsontool5_FILES += $(wildcard src/AdminMenu/*.mm)
Carsontool5_FILES += $(wildcard src/CodeRegistration/*.mm)
Carsontool5_FILES += $(wildcard src/Customize/*.mm)
Carsontool5_FILES += $(wildcard src/OtherWindows/*.mm)
Carsontool5_FILES += $(wildcard src/RunInBg/*.mm)
Carsontool5_FILES += $(wildcard src/Translations/*.mm)

# Vendored libs
Carsontool5_FILES += $(wildcard KittyMemory/*.cpp)
Carsontool5_FILES += KittyMemory/imgui_impl_metal.mm
Carsontool5_FILES += fishhook/fishhook.c
Carsontool5_FILES += $(wildcard AESCrypt-ObjC/*.m)
Carsontool5_FILES += Utils/UIView+YYAdd.m
Carsontool5_FILES += Utils/Color.cpp

# ---- Compile / link flags -------------------------------------------------
Carsontool5_CFLAGS  = -fobjc-arc -Wno-everything
Carsontool5_CFLAGS += -I. -Isrc -Isrc/Support -ILogos -Ifishhook
Carsontool5_CFLAGS += -IAESCrypt-ObjC -IUtils

Carsontool5_CCFLAGS  = -std=c++17 -stdlib=libc++

# Obfuscation passes (CLAUDE.md). Requires an obfuscator-enabled clang
# (Hikari / OLLVM). Stock Xcode clang will reject these, so they are off
# by default; uncomment if you have such a toolchain installed.
# Carsontool5_CFLAGS += -mllvm -enable-bcfobf -mllvm -enable-indibran \
#                      -mllvm -enable-strcry -mllvm -enable-subobf

Carsontool5_FRAMEWORKS  = UIKit Foundation CoreGraphics QuartzCore Metal MetalKit
Carsontool5_FRAMEWORKS += AVFoundation CoreText AudioToolbox OpenGLES
Carsontool5_PRIVATE_FRAMEWORKS =
Carsontool5_LIBRARIES   = c++

include $(THEOS_MAKE_PATH)/tweak.mk

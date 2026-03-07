# Guidebook: Merging shadPS4-RT with the Qt GUI
Phase 1: The Git Merge (Avoiding the Traps)
The biggest mistake we made initially was telling Git to keep all of your src/common/ files, which deleted the GUI's helper functions. Next time, do it this way to prevent 90% of the compilation errors:

1. Start the merge:

PowerShell
git merge gui-fork/main
2. Fix the corrupted .gitmodules immediately:
(Git will likely crash if you don't do this first)

PowerShell
git checkout gui-fork/main -- .gitmodules
git add .gitmodules
3. Resolve the files strategically:

PowerShell
# 1. Take the GUI's build system and entry points
git checkout --theirs CMakeLists.txt src/main.cpp .github/ externals/

# 2. Take the GUI's common utilities (Prevents the PathToQString and Logging errors!)
git checkout --theirs src/common/

# 3. Protect ONLY your Ray Tracing core and specific modifications
git checkout --ours src/core/ 

# 4. Commit the merge
git add .
git commit -m "Merged GUI and RT core"
Phase 2: The Submodule Sync
Because the GUI branch introduces new dependencies (CLI11, volk, tracy), Git's internal address book will be confused. Run these commands to force-download the missing pieces:

PowerShell
# Sync the URLs from the newly fixed .gitmodules
git submodule sync --recursive

# Force download the missing folders
git submodule update --init --recursive

# If Tracy or CLI11 complain about "No URL found", hardcode them:
git config submodule."externals/tracy".url https://github.com/shadps4-emu/tracy.git
git config submodule."externals/CLI11".url https://github.com/CLIUtils/CLI11.git
git submodule update --init --recursive
Phase 3: CMake Setup & Customizations
Before compiling, you need to make sure CMake finds Vulkan and outputs your .exe with the correct name.

1. Vulkan Check:
Make sure the LunarG Vulkan SDK is installed on your Windows machine (with Validation Layers checked). If you just installed it, completely restart VS Code.

2. Rename the Executable (Optional):
Open CMakeLists.txt, find set_target_properties(shadPS4QtLauncher PROPERTIES, and add:

CMake
OUTPUT_NAME "shadps4-qt"
3. Inject your -v Flag (Optional):
Open src/main.cpp. Right below int main(int argc, char *argv[]) {, add your interceptor:

C++
for (int i = 1; i < argc; ++i) {
    if (std::string(argv[i]) == "-v" || std::string(argv[i]) == "--version") {
        std::cout << "shadPS4-RT GUI Edition" << std::endl; 
        return 0; 
    }
}
Phase 4: Configure and Compile in VS Code
Because we completely replaced the old CMake instructions with the GUI ones, you must wipe CMake's memory.

Press Ctrl + Shift + P.

Run CMake: Delete Cache and Reconfigure.

Watch the Output window. Wait for it to say: -- Configuring done.

Press Ctrl + Shift + P.

Run CMake: Set Build Target and select shadPS4QtLauncher (or shadps4-qt).

Press F7 to Build.

Phase 5: The Deployment (CRITICAL)
If you double-click the newly built .exe, it will crash immediately complaining about missing Qt DLLs. You must run Qt's deployment tool to copy the necessary libraries into your build folder.

Run this in your PowerShell terminal (adjust the paths to match your PC):

PowerShell
C:\Qt\6.x.x\msvc2022_64\bin\windeployqt6.exe "C:\_repositories\shadPS4-RT\out\build\x64-Release\shadps4-qt.exe"
(Once this finishes, your hybrid emulator is fully standalone and ready to run!)

💡 Troubleshooting Quick-Reference:
WrapVulkanHeaders not found? You forgot to restart VS Code after installing the Vulkan SDK.

PathToQString or GetFoolproofInputConfigFile not found? You accidentally kept your old RT version of src/common/. Run git checkout gui-fork/main -- src/common/ to fix it.

tracy/Tracy.hpp not found? Run git submodule update --init externals/tracy and then Delete Cache and Reconfigure in CMake.

How does this look? Save this text, and next time you need to pull updates from the GUI branch, it will take you 5 minutes instead of 2 hours!
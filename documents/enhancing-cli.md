# Guidebook: Enhance the CLI

**Use the correct terminal for VSCode**             

**Option 1:**           
* VSCode doesn't automatically load the Visual Studio environment variables unless you launch it correctly.
* Close VSCode.
* Open your Start Menu and search for "x64 Native Tools Command Prompt for VS 2022".
* In that specific terminal, type code and hit Enter to launch VSCode.
* This ensures ml64 is in the PATH.

**Option 2:**           
* Open VSCode in your project folder.
* Press Ctrl + , to open Settings.
* Search for "CMake: Build Environment".
* Click Edit in settings.json.
* Add the following block (this tells CMake where to look for the tools):
* ```CMake 
    "cmake.buildEnvironment": {
    "PATH": "C:\\Program Files (x86)\\Microsoft Visual Studio\\2022\\BuildTools\\VC\\Tools\\MSVC\\14.44.35207\\bin\\Hostx64\\x64;${env:PATH}"
    },
    "cmake.generator": "Ninja"
  ```

**Option 3:**               
* Use this launch script: [Launch-VSCode-Build.ps1](../Launch-VSCode-Build.ps1)         


**Links that might be usefully:**       

* [NASM 3.00 win64](http://nasm.us/pub/nasm/releasebuilds/3.00/win64/)
* [YASM 1.3.0 win64](https://www.tortall.net/projects/yasm/releases/yasm-1.3.0-win64.exe)
* [Vulkan SDK](https://vulkan.lunarg.com/sdk/home) 


**VS Code Extensions**            
* C/C++ for Visual Studio Code
* C/C++ DevTools
* C/C++ Extension Pack
* C/C++ Themes
* Clang-Format
* clangd
* CMake Tools
* Git Graph
* GitLens — Git supercharged


**VS Code Build Instructions**                      
* Press Ctrl + Shift + P.
* Type CMake: Select Configure Preset.
* A list will drop down. Select Clang x64 Release.
* Press Ctrl + Shift + P again.
* Press F7
* Fresh build: press Ctrl + Shift + P and search for: `Delete Cache and Reconfigure`


**Releases**            
* CLI: `build\x64-Clang-Release\shadps4-cli.exe`

**Keep in sync**                    
* Sync the URLs from the .gitmodules: `git submodule sync --recursive`
* Or force download if you encounter missing folders error(s): `git submodule update --init --recursive`             


**Git commands**
* see all remote branches: `git branch -r`
* see local branches: `git branch`
* show current branch you are working on: `git branch --show-current`
* show remote url: `git remote -v`


**Get the latest updates on top of your changes**               
* only run this once: `git remote add upstream https://github.com/shadps4-emu/shadPS4.git`
* from your feature branch run this: `git fetch upstream`
* from your feature branch run this: `git rebase upstream/main`
* force push: `git push origin develop --force`


**Daily Driver**
* `git fetch upstream`
* `git rebase upstream/main`

---

**Getting the version and build info**               
Search for this line in `main.cpp` > `CLI::App app{"shadPS4 Emulator CLI"};`

Then add this line right below it:               
```CMake
app.set_version_flag("-v,--version", std::string(Common::g_version) + " (Rev: " + std::string(Common::g_scm_rev) + ")");
```

**Changing the build name**                     
Add this line just above `create_target_directory_groups(shadps4)`                  
```CMake
set_target_properties(shadps4 PROPERTIES OUTPUT_NAME "shadps4-cli")

create_target_directory_groups(shadps4)
```
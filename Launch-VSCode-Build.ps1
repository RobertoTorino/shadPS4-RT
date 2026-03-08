# Path to the BuildTools initializer
$vsPath = "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat"

if (Test-Path $vsPath) {
    # Run the batch file, grab the environment variables, and apply them to the current session
    $env_vars = cmd /c "`"$vsPath`" && set"
    foreach ($line in $env_vars) {
        if ($line -match "^([^=]+)=(.*)$") {
            $name = $matches[1]
            $value = $matches[2]
            [System.Environment]::SetEnvironmentVariable($name, $value, "Process")
        }
    }
    Write-Host "Success: MSVC 14.44 environment loaded." -ForegroundColor Green
    code .
} else {
    Write-Error "Could not find vcvars64.bat. Is Visual Studio BuildTools 2022 installed?"
}

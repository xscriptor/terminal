# Ruta al settings.json de Windows Terminal
$settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

$json = Get-Content $settingsPath -Raw | ConvertFrom-Json

$scheme = @{
    name = "Xscriptor"
    background = "#1E1E1E"
    foreground = "#FCE566"
    black = "#000000"
    red = "#FC618D"
    green = "#7BD88F"
    yellow = "#FCE566"
    blue = "#5AD4E6"
    purple = "#948AE3"
    cyan = "#7BD88F"
    white = "#FFFFFF"
    brightBlack = "#808080"
    brightRed = "#FC618D"
    brightGreen = "#7BD88F"
    brightYellow = "#FCE566"
    brightBlue = "#5AD4E6"
    brightPurple = "#948AE3"
    brightCyan = "#7BD88F"
    brightWhite = "#FFFFFF"
}

if (-not ($json.schemes.name -contains "Xscriptor")) {
    $json.schemes += $scheme
}

foreach ($profile in $json.profiles.list) {
    if ($profile.name -like "PowerShell*") {
        $profile.colorScheme = "Xscriptor"
    }
}

$json | ConvertTo-Json -Depth 10 | Set-Content $settingsPath -Encoding UTF8

Write-Host "Xscriptor Theme instalado Installed."

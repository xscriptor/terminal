param(
  [string]$SetSchemeName = "Xscriptor",
  [string]$ThemesDir = (Join-Path $PSScriptRoot "themes"),
  [string]$RawBase = "https://raw.githubusercontent.com/xscriptordev/terminal/main/powershell/themes"
)
$paths = @("$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json", "$env:LOCALAPPDATA\Microsoft\Windows Terminal\settings.json")
$settingsPath = $null
foreach ($p in $paths) { if (Test-Path $p) { $settingsPath = $p; break } }
if (-not $settingsPath) { Write-Host "Windows Terminal settings.json not found"; exit 1 }
$json = Get-Content $settingsPath -Raw | ConvertFrom-Json
if ($null -eq $json.schemes) { $json | Add-Member -NotePropertyName schemes -NotePropertyValue @() }
if (-not (Test-Path $ThemesDir)) {
  $tmp = Join-Path ([System.IO.Path]::GetTempPath()) "xscriptor-ps-themes"
  New-Item -ItemType Directory -Path $tmp -Force | Out-Null
  $names = @(
    "xscriptor-theme.json",
    "xscriptor-theme-light.json",
    "x-retro.json",
    "x-dark-one.json",
    "x-candy-pop.json",
    "x-sense.json",
    "x-summer-night.json",
    "x-nord.json",
    "x-nord-inverted.json",
    "x-greyscale.json",
    "x-greyscale-inverted.json",
    "x-dark-colors.json",
    "x-persecution.json"
  )
  foreach ($n in $names) {
    $u = "$RawBase/$n"
    $d = Join-Path $tmp $n
    try { Invoke-WebRequest -Uri $u -OutFile $d -UseBasicParsing -ErrorAction Stop } catch {}
  }
  $ThemesDir = $tmp
}
$files = Get-ChildItem -Path $ThemesDir -Filter "*.json" -File -ErrorAction SilentlyContinue
foreach ($f in $files) {
  $data = Get-Content $f.FullName -Raw | ConvertFrom-Json
  if ($null -ne $data.schemes) {
    foreach ($s in $data.schemes) {
      $existing = $json.schemes | Where-Object { $_.name -eq $s.name }
      if ($existing) {
        $json.schemes = @($json.schemes | Where-Object { $_.name -ne $s.name })
      }
      $json.schemes += $s
    }
  }
}
$profilesList = $null
if ($json.profiles -is [System.Collections.IDictionary] -and $json.profiles.ContainsKey("list")) {
  $profilesList = $json.profiles.list
} elseif ($json.profiles -is [System.Collections.IEnumerable]) {
  $profilesList = $json.profiles
}
if ($profilesList) {
  foreach ($profile in $profilesList) {
    if ($profile.name -match "PowerShell") { $profile.colorScheme = $SetSchemeName }
  }
}
if ($json.profiles -is [System.Collections.IDictionary] -and $json.profiles.ContainsKey("defaults")) {
  if ($null -eq $json.profiles.defaults) { $json.profiles.defaults = @{} }
  $json.profiles.defaults.colorScheme = $SetSchemeName
}
$ts = Get-Date -Format "yyyyMMddHHmmss"
Copy-Item $settingsPath "$settingsPath.bak.$ts" -ErrorAction SilentlyContinue
$json | ConvertTo-Json -Depth 20 | Set-Content $settingsPath -Encoding UTF8
Write-Host "Schemes imported from $ThemesDir"
Write-Host "PowerShell profiles set to $SetSchemeName"

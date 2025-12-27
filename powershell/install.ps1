param(
  [string]$SetSchemeName = "Xscriptor",
  [string]$ThemesDir = (Join-Path $PSScriptRoot "themes"),
  [string]$RawBase = "https://raw.githubusercontent.com/xscriptordev/terminal/main/powershell/themes"
)
$paths = @("$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json", "$env:LOCALAPPDATA\Microsoft\Windows Terminal\settings.json")
$settingsPath = $null
foreach ($p in $paths) { if (Test-Path $p) { $settingsPath = $p; break } }
if (-not $settingsPath) {
  $candidate1 = Join-Path $env:LOCALAPPDATA "Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
  $candidate2 = Join-Path $env:LOCALAPPDATA "Microsoft\Windows Terminal\settings.json"
  $target = $candidate1
  $dir = Split-Path $target -Parent
  if (-not (Test-Path $dir)) {
    $dir2 = Split-Path $candidate2 -Parent
    if (-not (Test-Path $dir2)) { New-Item -ItemType Directory -Path $dir2 -Force | Out-Null }
    $target = $candidate2
  } else {
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
  }
  $skeleton = @{ '$schema' = 'https://aka.ms/terminal-profiles-schema'; schemes = @(); profiles = @{ defaults = @{} } }
  $skeleton | ConvertTo-Json -Depth 20 | Set-Content $target -Encoding UTF8
  $settingsPath = $target
}
$json = Get-Content $settingsPath -Raw | ConvertFrom-Json
if ($null -eq $json.schemes) { $json | Add-Member -NotePropertyName schemes -NotePropertyValue @() }
if ($null -eq $json.profiles) { $json | Add-Member -NotePropertyName profiles -NotePropertyValue @{} }
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
if ($json.profiles -is [System.Collections.IDictionary]) {
  if (-not $json.profiles.ContainsKey("defaults")) { $json.profiles.defaults = @{} }
  if ($null -eq $json.profiles.defaults) { $json.profiles.defaults = @{} }
  $json.profiles.defaults.colorScheme = $SetSchemeName
}
$ts = Get-Date -Format "yyyyMMddHHmmss"
Copy-Item $settingsPath "$settingsPath.bak.$ts" -ErrorAction SilentlyContinue
$json | ConvertTo-Json -Depth 20 | Set-Content $settingsPath -Encoding UTF8
Write-Host "Schemes imported from $ThemesDir"
Write-Host "PowerShell profiles set to $SetSchemeName"

$rcTargets = @()
if ($PROFILE) { $rcTargets += $PROFILE }
if ($PROFILE -and $PROFILE -ne $PROFILE.CurrentUserAllHosts) { $rcTargets += $PROFILE.CurrentUserAllHosts }
foreach ($rc in $rcTargets) {
  $rcDir = Split-Path $rc -Parent
  if (-not (Test-Path $rcDir)) { New-Item -ItemType Directory -Path $rcDir -Force | Out-Null }
  if (-not (Test-Path $rc)) { New-Item -ItemType File -Path $rc -Force | Out-Null }
  $content = Get-Content $rc -Raw -ErrorAction SilentlyContinue
  if ($content -notmatch 'function\s+pwsx\s*\(') {
    $block = @'
function pwsx([string]$name) {
  $paths = @("$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json", "$env:LOCALAPPDATA\Microsoft\Windows Terminal\settings.json")
  $settingsPath = $null
  foreach ($p in $paths) { if (Test-Path $p) { $settingsPath = $p; break } }
  if (-not $settingsPath) { return }
  $json = Get-Content $settingsPath -Raw | ConvertFrom-Json
  if ($json.profiles -is [System.Collections.IDictionary]) {
    if (-not $json.profiles.ContainsKey("defaults")) { $json.profiles.defaults = @{} }
    if ($null -eq $json.profiles.defaults) { $json.profiles.defaults = @{} }
    $json.profiles.defaults.colorScheme = $name
  }
  $profilesList = $null
  if ($json.profiles -is [System.Collections.IDictionary] -and $json.profiles.ContainsKey("list")) { $profilesList = $json.profiles.list } elseif ($json.profiles -is [System.Collections.IEnumerable]) { $profilesList = $json.profiles }
  if ($profilesList) { foreach ($profile in $profilesList) { if ($profile.name -match "PowerShell") { $profile.colorScheme = $name } } }
  $json | ConvertTo-Json -Depth 20 | Set-Content $settingsPath -Encoding UTF8
}
function pwsxscriptor { pwsx "Xscriptor" }
function pwsxscriptorlight { pwsx "Xscriptor Light" }
function pwsxretro { pwsx "X Retro" }
function pwsxdarkone { pwsx "X Dark One" }
function pwsxcandypop { pwsx "X Candy Pop" }
function pwsxsense { pwsx "X Sense" }
function pwsxsummernight { pwsx "X Summer Night" }
function pwsxnord { pwsx "X Nord" }
function pwsxnordinverted { pwsx "X Nord Inverted" }
function pwsxgreyscale { pwsx "X Greyscale" }
function pwsxgreyscaleinverted { pwsx "X Greyscale Inverted" }
function pwsxdarkcolors { pwsx "X Dark Colors" }
function pwsxpersecution { pwsx "X Persecution" }
'@
    Add-Content -Path $rc -Value $block
    Write-Host "Funciones y aliases añadidos a perfil: $rc"
  }
}

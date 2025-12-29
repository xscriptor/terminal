param(
  [string]$SetSchemeName = "x",
  [string]$ThemesDir = (Join-Path $PSScriptRoot "themes"),
  [string]$RawBase = "https://raw.githubusercontent.com/xscriptordev/terminal/main/powershell/themes"
)
function Get-LocalAppData {
  if (-not [string]::IsNullOrWhiteSpace($env:LOCALAPPDATA)) { return $env:LOCALAPPDATA }
  if (-not [string]::IsNullOrWhiteSpace($env:USERPROFILE)) { return (Join-Path $env:USERPROFILE "AppData\Local") }
  return $null
}
$lad = Get-LocalAppData
if (-not $lad) { Write-Host "LOCALAPPDATA not found. Ensure you are on Windows."; exit 1 }
$paths = @("$lad\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json", "$lad\Microsoft\Windows Terminal\settings.json")
$settingsPath = $null
foreach ($p in $paths) { if (Test-Path $p) { $settingsPath = $p; break } }
if (-not $settingsPath) {
  $candidate1 = Join-Path $lad "Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
  $candidate2 = Join-Path $lad "Microsoft\Windows Terminal\settings.json"
  $target = $candidate1
  $dir = Split-Path $target -Parent
  if (-not (Test-Path $dir)) {
    $dir2 = Split-Path $candidate2 -Parent
    if (-not (Test-Path $dir2)) { New-Item -ItemType Directory -Path $dir2 -Force | Out-Null }
    $target = $candidate2
  } else {
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
  }
  if ([string]::IsNullOrWhiteSpace($target)) { Write-Host "Failed to determine Windows Terminal settings path."; exit 1 }
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
    "x.json",
    "madrid.json",
    "lahabana.json",
    "seul.json",
    "miami.json",
    "paris.json",
    "tokio.json",
    "oslo.json",
    "helsinki.json",
    "berlin.json",
    "london.json",
    "praha.json",
    "bogota.json"
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
function pwsxx { pwsx "x" }
function pwsxmadrid { pwsx "madrid" }
function pwsxlahabana { pwsx "lahabana" }
function pwsxseul { pwsx "seul" }
function pwsxmiami { pwsx "miami" }
function pwsxparis { pwsx "paris" }
function pwsxtokio { pwsx "tokio" }
function pwsxoslo { pwsx "oslo" }
function pwsxhelsinki { pwsx "helsinki" }
function pwsxberlin { pwsx "berlin" }
function pwsxlondon { pwsx "london" }
function pwsxpraha { pwsx "praha" }
function pwsxbogota { pwsx "bogota" }
'@
    Add-Content -Path $rc -Value $block
    Write-Host "Funciones y aliases añadidos a perfil: $rc"
  }
}

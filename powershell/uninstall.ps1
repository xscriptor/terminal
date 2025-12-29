param(
  [switch]$Restore,
  [switch]$Force,
  [string]$ThemesDir,
  [string]$RawBase = "https://raw.githubusercontent.com/xscriptordev/terminal/main/powershell/themes"
)
$ErrorActionPreference = "Stop"
function Get-LocalAppData {
  if (-not [string]::IsNullOrWhiteSpace($env:LOCALAPPDATA)) { return $env:LOCALAPPDATA }
  if (-not [string]::IsNullOrWhiteSpace($env:USERPROFILE)) { return (Join-Path $env:USERPROFILE "AppData\Local") }
  return $null
}
$lad = Get-LocalAppData
if (-not $lad) { Write-Host "LOCALAPPDATA not found."; exit 1 }
$paths = @("$lad\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json", "$lad\Microsoft\Windows Terminal\settings.json")
$settingsPath = $null
foreach ($p in $paths) { if (Test-Path $p) { $settingsPath = $p; break } }
if ($settingsPath) {
  if ($Restore) {
    $backups = Get-ChildItem -Path "$settingsPath.bak.*" -ErrorAction SilentlyContinue
    if ($backups) {
      $latest = $backups | Sort-Object LastWriteTime -Descending | Select-Object -First 1
      if ($latest) {
        Copy-Item $latest.FullName $settingsPath -Force
        Write-Host "Restored settings from backup: $($latest.Name)"
      }
    }
  } else {
    try {
      $json = Get-Content $settingsPath -Raw | ConvertFrom-Json
      $schemeNamesLower = @()
      if ($ThemesDir -and (Test-Path $ThemesDir)) {
        $files = Get-ChildItem -Path $ThemesDir -Filter "*.json" -File -ErrorAction SilentlyContinue
        foreach ($f in $files) {
          $data = Get-Content $f.FullName -Raw | ConvertFrom-Json
          if ($null -ne $data.schemes) {
            foreach ($s in $data.schemes) {
              if ($s.name) { $schemeNamesLower += $s.name.ToLower() }
            }
          }
        }
      } else {
        $tmp = Join-Path ([System.IO.Path]::GetTempPath()) "xscriptor-ps-themes-uninstall"
        New-Item -ItemType Directory -Path $tmp -Force | Out-Null
        $names = @(
          "x.json","madrid.json","lahabana.json","seul.json","miami.json","paris.json",
          "tokio.json","oslo.json","helsinki.json","berlin.json","london.json","praha.json","bogota.json"
        )
        foreach ($n in $names) {
          $u = "$RawBase/$n"
          $d = Join-Path $tmp $n
          try { Invoke-WebRequest -Uri $u -OutFile $d -UseBasicParsing -ErrorAction Stop } catch {}
        }
        $files = Get-ChildItem -Path $tmp -Filter "*.json" -File -ErrorAction SilentlyContinue
        foreach ($f in $files) {
          $data = Get-Content $f.FullName -Raw | ConvertFrom-Json
          if ($null -ne $data.schemes) {
            foreach ($s in $data.schemes) {
              if ($s.name) { $schemeNamesLower += $s.name.ToLower() }
            }
          }
        }
      }
      if ($null -ne $json.schemes) {
        $json.schemes = @($json.schemes | Where-Object { $schemeNamesLower -notcontains $_.name.ToLower() })
      }
      $codes = @("x","madrid","lahabana","seul","miami","paris","tokio","oslo","helsinki","berlin","london","praha","bogota")
      $codesLower = @($codes | ForEach-Object { $_.ToLower() })
      $profilesList = $null
      if ($json.profiles -is [System.Collections.IDictionary] -and $json.profiles.ContainsKey("list")) {
        $profilesList = $json.profiles.list
      } elseif ($json.profiles -is [System.Collections.IEnumerable]) {
        $profilesList = $json.profiles
      }
      if ($json.profiles -is [System.Collections.IDictionary]) {
        if ($json.profiles.ContainsKey("defaults") -and $null -ne $json.profiles.defaults) {
          if ($json.profiles.defaults.PSObject.Properties.Name -contains "colorScheme") {
            $val = "$($json.profiles.defaults.colorScheme)"
            if ($Force -or $schemeNamesLower -contains $val.ToLower() -or $codesLower -contains $val.ToLower()) {
              $json.profiles.defaults.PSObject.Properties.Remove("colorScheme")
            }
          }
        }
      }
      if ($profilesList) {
        foreach ($profile in $profilesList) {
          if ($profile.PSObject.Properties.Name -contains "colorScheme") {
            $val = "$($profile.colorScheme)"
            if ($profile.name -match "PowerShell") {
              if ($Force -or $schemeNamesLower -contains $val.ToLower() -or $codesLower -contains $val.ToLower()) {
                $profile.PSObject.Properties.Remove("colorScheme")
              }
            }
          }
        }
      }
      $ts = Get-Date -Format "yyyyMMddHHmmss"
      Copy-Item $settingsPath "$settingsPath.uninst.bak.$ts" -ErrorAction SilentlyContinue
      $json | ConvertTo-Json -Depth 20 | Set-Content $settingsPath -Encoding UTF8
      Write-Host "Removed schemes and colorScheme assignments."
    } catch {
      Write-Host "Failed to update Windows Terminal settings."
    }
  }
} else {
  Write-Host "Windows Terminal settings.json not found."
}
$rcTargets = @()
if ($PROFILE) { $rcTargets += $PROFILE }
if ($PROFILE -and $PROFILE -ne $PROFILE.CurrentUserAllHosts) { $rcTargets += $PROFILE.CurrentUserAllHosts }
foreach ($rc in $rcTargets) {
  if (Test-Path $rc) {
    $content = Get-Content $rc -Raw -ErrorAction SilentlyContinue
    if ($content) {
      $content = [regex]::Replace($content, "(?ms)function\s+pwsx\s*\(.*?\)\s*\{.*?\}", "")
      $aliases = @('pwsxx','pwsxmadrid','pwsxlahabana','pwsxseul','pwsxmiami','pwsxparis','pwsxtokio','pwsxoslo','pwsxhelsinki','pwsxberlin','pwsxlondon','pwsxpraha','pwsxbogota')
      foreach ($a in $aliases) {
        $content = [regex]::Replace($content, "(?ms)function\s+$a\s*\{.*?\}", "")
      }
      Set-Content -Path $rc -Value $content -Encoding UTF8
      Write-Host "Cleaned profile: $rc"
    }
  }
}
$tmpDir = Join-Path ([System.IO.Path]::GetTempPath()) "xscriptor-ps-themes"
if (Test-Path $tmpDir) {
  try { Remove-Item -Path $tmpDir -Recurse -Force -ErrorAction Stop } catch {}
}
Write-Host "Uninstall completed."

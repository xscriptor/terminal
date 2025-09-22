# Customizations for windows powershell

---

## Previews

<p align="center">
  <img src="./previews//preview.png" alt="Demostración" width="350"/>
  <img src="./previews//preview1.png" alt="Demostración" width="500"/>
</p>

## Instructions:

- Download.
- Run:
     ```ps1
     Set-ExecutionPolicy Bypass -Scope Process -Force
     .\script.ps1
     ```
- Select the schema in the Powershell config.
- Restart Powershell.


- **Themes**:
    - [Xscriptor Theme](./xscriptor-theme/script.ps1)
    - [xtropicalneon](./xtropicalneon/README.md)



Note: To see the current Colors:
```ps1
for ($i=0; $i -lt 16; $i++) {
    Write-Host ("Color {0,2}" -f $i) -ForegroundColor $i
}

```
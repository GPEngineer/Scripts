# 🇵🇱 Skrypt sprawdzający wersje Visual C++ Redistributable w systemie Windows
# 🇬🇧 Script to check installed Visual C++ Redistributables

$paths = @(
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
    "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
)

$vcList = @()

foreach ($path in $paths) {
    Get-ChildItem $path | ForEach-Object {
        $key = $_
        $props = Get-ItemProperty $key.PSPath
        if ($props.DisplayName -and $props.DisplayName -match "Visual C\+\+.*Redistributable") {
            $vcList += [PSCustomObject]@{
                Nazwa        = $props.DisplayName
                Wersja       = $props.DisplayVersion
                Architektura = if ($path -like "*WOW6432Node*") { "x86" } else { "x64" }
            }
        }
    }
}

$vcList | Sort-Object Nazwa, Wersja | Format-Table -AutoSize

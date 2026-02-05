powershell -ExecutionPolicy Bypass -Command "$path='HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3'; $name='Settings'; $value=(Get-ItemProperty -Path $path -Name $name).$name; $value[8]=0x03; Set-ItemProperty -Path $path -Name $name -Value $value"

taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe
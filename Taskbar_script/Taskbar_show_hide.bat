@echo off
setlocal enabledelayedexpansion

:: Verifica privilegi amministratore
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Questo script richiede privilegi di amministratore.
    echo Clicca con il tasto destro e seleziona "Esegui come amministratore"
    pause
    exit /b 1
)

:menu
cls
echo ================================================
echo   GESTIONE VISIBILITA' TASKBAR DI WINDOWS
echo ================================================
echo.
echo 1. Nascondi Taskbar (byte 8 = 03)
echo 2. Mostra Taskbar (byte 8 = 02)
echo 3. Toggle (Attiva/Disattiva)
echo 4. Mostra valore attuale
echo 5. Esci
echo.
set /p scelta="Seleziona un'opzione (1-5): "

if "%scelta%"=="1" goto nascondi
if "%scelta%"=="2" goto mostra
if "%scelta%"=="3" goto toggle
if "%scelta%"=="4" goto mostra_valore
if "%scelta%"=="5" goto fine
goto menu

:nascondi
echo.
echo Nascondo la taskbar (imposto byte 8 a 03)...
powershell -ExecutionPolicy Bypass -Command "$path='HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3'; $name='Settings'; $value=(Get-ItemProperty -Path $path -Name $name).$name; $value[8]=0x03; Set-ItemProperty -Path $path -Name $name -Value $value"
if %errorLevel% equ 0 (
    echo Valore modificato con successo!
    call :riavvia_explorer
) else (
    echo Errore durante la modifica.
    pause
)
goto menu

:mostra
echo.
echo Mostro la taskbar (imposto byte 8 a 02)...
powershell -ExecutionPolicy Bypass -Command "$path='HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3'; $name='Settings'; $value=(Get-ItemProperty -Path $path -Name $name).$name; $value[8]=0x02; Set-ItemProperty -Path $path -Name $name -Value $value"
if %errorLevel% equ 0 (
    echo Valore modificato con successo!
    call :riavvia_explorer
) else (
    echo Errore durante la modifica.
    pause
)
goto menu

:toggle
echo.
echo Cambio stato della taskbar...
powershell -ExecutionPolicy Bypass -Command "$path='HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3'; $name='Settings'; $value=(Get-ItemProperty -Path $path -Name $name).$name; if($value[8] -eq 0x03){$value[8]=0x02; Write-Host 'Taskbar mostrata'}else{$value[8]=0x03; Write-Host 'Taskbar nascosta'}; Set-ItemProperty -Path $path -Name $name -Value $value"
if %errorLevel% equ 0 (
    call :riavvia_explorer
) else (
    echo Errore durante la modifica.
    pause
)
goto menu

:mostra_valore
echo.
echo Valore attuale del byte 8:
powershell -ExecutionPolicy Bypass -Command "$path='HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3'; $name='Settings'; $value=(Get-ItemProperty -Path $path -Name $name).$name; Write-Host ('Byte 8 = 0x{0:X2} ({1})' -f $value[8],$value[8]); if($value[8] -eq 0x02){Write-Host 'Stato: Taskbar MOSTRATA'}elseif($value[8] -eq 0x03){Write-Host 'Stato: Taskbar NASCOSTA'}else{Write-Host 'Stato: Valore non standard'}"
echo.
pause
goto menu

:riavvia_explorer
echo.
echo Riavvio Explorer per applicare le modifiche...
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 2 /nobreak >nul
start explorer.exe
timeout /t 2 /nobreak >nul
echo.
echo Modifiche applicate!
echo.
pause
exit /b

:fine
echo.
echo Chiusura script...
exit /b 0
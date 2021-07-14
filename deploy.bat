@echo off
setlocal
set rev=
if exist VERSION for /f %%i in (VERSION) do if not defined rev set "rev=%%i"
set "name=Inspur Commit"
set "link=https://github.com/islzh/jg"
title %name% v%rev% Deployment
pushd %~dp0

set "climode="
if not "%~1" == "" (
    set "climode=1"
    if "%~2" == "" (
        if "%~1" == "/?" (
            call:Logo
            call:Usage
            exit /b
        ) else if "%~1%" == "1" (
            goto deploy
        ) else if "%~1%" == "0" (
            goto remove
        ) else if /i "%~1%" == "install" (
            goto deploy
        ) else if /i "%~1%" == "uninstall" (
            goto remove
        ) else if /i "%~1%" == "deploy" (
            goto deploy
        ) else if /i "%~1%" == "remove" (
            goto remove
        ) else (
            >&2 echo ERROR: ignored invalid argument: %~1
            >&2 echo;
            >&2 call:Usage
            exit /b 1
        )
    ) else (
        >&2 echo ERROR: too many arguments.
        >&2 echo;
        >&2 call:Usage
        exit /b 1
    )
)

call:Logo
@echo Please choose what to do:
@echo   1  Deploy %name%
@echo   0  Remove %name%

:choose
@echo;
set /p=Please select a number: <NUL
set selection=
set /p selection=
if "%selection%" == "1" goto deploy
if "%selection%" == "0" goto remove
>&2 echo Invalid input.
goto choose

:deploy
if not exist "bin" (
    >&2 echo Error: Could not find the script folder.
    if not defined climode pause
    exit /b 1
)
if not exist "%USERPROFILE%\bin\" (
    md "%USERPROFILE%\bin\"
    @echo Created folder '%USERPROFILE%\bin\'
)
@echo Copying %name% to your PC...
for /r bin\ %%f in (jg*) do copy /Y "%%f" "%USERPROFILE%\bin\"
for /r bin\ %%f in (inspur*) do copy /Y "%%f" "%USERPROFILE%\bin\"
if defined rev (
    echo #!/bin/bash
    echo echo "%name% v%rev%"
    echo echo "%link%"
)>%USERPROFILE%\bin\jgversion || >&2 echo Warning: failed to create jgversion
call:Fin 1
exit /b

:remove
if not exist "%USERPROFILE%\bin\" (
    >&2 echo There is no %name% deployed in your PC.
    if not defined climode pause
    exit /b 1
)
>&2 echo Removing %name% from your PC...
for /r bin\ %%f in (jg*) do del "%USERPROFILE%\bin\%%~nf" 2>NUL
for /r bin\ %%f in (inspur*) do del "%USERPROFILE%\bin\%%~nf" 2>NUL
del "%USERPROFILE%\bin\jgversion" 2>NUL
rd "%USERPROFILE%\bin" 2>NUL
call:Fin 0
exit /b

:Fin
@echo;
if "%~1" == "1" (
    @echo Deployment finished.
) else if "%~1" == "0" (
    @echo Removal finished.
)
if not defined climode pause
exit /b 0

:Logo
@echo;
@echo     %name% v%rev% Deployment
@echo     %link%
@echo;
exit /b

:Usage
@echo Usage:
@echo     deploy.bat [ 1 ^| install ^| deploy ]
@echo     deploy.bat [ 0 ^| uninstall ^| remove ]
exit /b

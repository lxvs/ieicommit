@echo off
setlocal
pushd %~dp0

call:Settings
if "%~1" == "" (
    call:Install
    exit /b
) else (
    if "%~2" == "" (
        if "%~1" == "/?" (
            call:Logo
            call:Usage
            exit /b 0
        ) else if /i "%~1%" == "uninstall" (
            call:Uninstall
            exit /b
        ) else if /i "%~1%" == "install" (
            call:Install
            exit /b
        ) else if "%~1%" == "0" (
            call:Uninstall
            exit /b
        ) else if "%~1%" == "1" (
            call:Install
            exit /b
        ) else (
            >&2 echo error: invalid argument `%~1'
            >&2 call:Usage
            exit /b 1
        )
    ) else (
        >&2 echo error: too many arguments
        >&2 call:Usage
        exit /b 1
    )
)

:Settings
set "target_dir=%USERPROFILE%\bin"
set "name=inspurcommit installation script"
set "link=https://github.com/islzh/inspurcommit"
set "filelist=inspurcommit ChangeHistoryTemplate.txt"
title %name%
exit /b
::Settings

:Install
if not exist "%target_dir%\" (
    mkdir "%target_dir%" || exit /b
)
for %%f in (%filelist%) do (
    copy /y "%%~f" "%target_dir%\" 1>nul || exit /b
)
@echo Install complete.
pause
exit /b 0
::Install

:Uninstall
if not exist "%target_dir%\" (
    >&2 echo error: not installed
    exit /b 1
)
pushd "%target_dir%"
2>nul del %filelist%
popd
2>nul rd "%target_dir%"
@echo Uninstall complete.
pause
exit /b 0
::Uninstall

:Logo
@echo;
@echo     %name%
@echo     %link%
@echo;
exit /b
::Logo

:Usage
@echo usage: install.bat
@echo    or: install.bat uninstall
exit /b
::Usage

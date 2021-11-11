@echo off
setlocal
set "name=Inspur Commit Kit"
set "link=https://github.com/islzh/inspurcommit"
title %name% Installation
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
            >&2 call:Usage
            goto errexit
        )
    ) else (
        >&2 echo ERROR: too many arguments.
        >&2 call:Usage
        goto errexit
    )
)

call:Logo
@echo;
@echo Please choose what to do:
@echo   1  Install
@echo   0  Uninstall

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
    goto errexit
)
if not exist "%USERPROFILE%\bin\" (
    md "%USERPROFILE%\bin\"
    @echo Created folder '%USERPROFILE%\bin\'
)
for /r bin\ %%f in (jg*) do (copy /Y "%%f" "%USERPROFILE%\bin\" 1>nul)
for /r bin\ %%f in (inspur*) do (copy /Y "%%f" "%USERPROFILE%\bin\" 1>nul)
copy /Y "ChangeHistoryTemplate.txt" "%USERPROFILE%\bin\" 1>nul
goto okexit

:remove
if not exist "%USERPROFILE%\bin\" (
    >&2 echo ERROR: Not installed.
    goto errexit
)
for /r bin\ %%f in (jg*) do del "%USERPROFILE%\bin\%%~nf" 2>NUL
for /r bin\ %%f in (inspur*) do del "%USERPROFILE%\bin\%%~nf" 2>NUL
del "%USERPROFILE%\bin\ChangeHistoryTemplate.txt" 2>nul
del "%USERPROFILE%\bin\jgversion" 2>NUL
rd "%USERPROFILE%\bin" 2>NUL
goto okexit

:Logo
@echo;
@echo     %name% Installation
@echo     %link%
exit /b

:Usage
@echo;
@echo Usage:
@echo     INSTALL.bat [ 1 ^| install ]
@echo     INSTALL.bat [ 0 ^| uninstall ]
exit /b

:okexit
@echo Complete.
if not defined climode pause
exit /b 0

:errexit
if not defined climode pause
exit /b 1

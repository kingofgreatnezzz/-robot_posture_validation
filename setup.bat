@echo off
setlocal EnableExtensions
title Setup - Robot Posture Validation (Perfect Pose Checker)
cd /d "%~dp0"

echo ============================================================
echo   SETUP: Robot Posture Validation (Perfect Pose Checker)
echo ============================================================
echo.
echo  What this does:
echo    * creates a private Python environment in this folder: .venv
echo    * installs only the packages THIS project needs
echo    * your normal/global Python is NOT changed
echo.
echo  Run this ONCE. After that, just double-click start.bat.
echo.

if not exist "app.py" (
    echo [ERROR] app.py was not found in this folder:
    echo         %CD%
    echo         Keep app.py, setup.bat, start.bat and requirements.txt together.
    echo.
    pause
    exit /b 1
)

if not exist "requirements.txt" (
    echo [ERROR] requirements.txt is missing from this folder.
    echo.
    pause
    exit /b 1
)

REM ---------- 1. Find Python on this computer ----------
set "PY="
where py >nul 2>nul && set "PY=py -3"
if not defined PY (where python >nul 2>nul && set "PY=python")
if not defined PY (
    echo [ERROR] Python was not found on this computer.
    echo.
    echo   How to fix it:
    echo     1. Go to  https://www.python.org/downloads/
    echo     2. Download the latest Python 3.12
    echo     3. IMPORTANT: tick "Add python.exe to PATH" in the installer
    echo     4. Restart the computer, then double-click setup.bat again
    echo.
    pause
    exit /b 1
)

echo [1/4] Python found. Checking it works ...
%PY% -c "import sys; v=sys.version_info; sys.exit(0 if (v.major==3 and v.minor not in (0,1,2,3,4,5,6,7,8)) else 1)"
if errorlevel 1 (
    echo.
    echo [ERROR] This project needs Python 3.9 or newer.
    echo         Please install a newer Python from https://www.python.org/downloads/
    echo.
    pause
    exit /b 1
)


REM ---------- 2. Create the private virtual environment ----------
if exist ".venv\Scripts\python.exe" (
    echo [2/4] Private environment already exists - skipping creation.
) else (
    echo [2/4] Creating private environment .venv ...
    %PY% -m venv .venv
    if errorlevel 1 (
        echo.
        echo [ERROR] Could not create the virtual environment.
        echo         Re-install Python and tick "Add python.exe to PATH".
        echo.
        pause
        exit /b 1
    )
)

REM ---------- 3. Activate it ----------
call ".venv\Scripts\activate.bat"
if errorlevel 1 (
    echo.
    echo [ERROR] Could not activate the private environment.
    echo         Delete the .venv folder and run setup.bat again.
    echo.
    pause
    exit /b 1
)

echo [3/4] Updating pip ...
python -m pip install --upgrade pip --quiet --disable-pip-version-check --no-input

echo [4/4] Installing this project's packages ...
echo       This usually takes 1-3 minutes.
echo.
python -m pip install -r requirements.txt --disable-pip-version-check --no-input
if errorlevel 1 (
    echo.
    echo [ERROR] Installing the packages failed.
    echo.
    echo   * Is this computer connected to the internet?
    echo   * A firewall or proxy may be blocking pip.
    echo   * Just run setup.bat again - pip often succeeds the second time.
    echo.
    pause
    exit /b 1
)

echo.
echo Checking that the packages work ...
python -c "import streamlit, numpy, plotly"
if errorlevel 1 (
    echo.
    echo [ERROR] The packages were installed but could not be loaded.
    echo         Delete the .venv folder and run setup.bat again.
    echo.
    pause
    exit /b 1
)

echo.
echo ============================================================
echo   SETUP COMPLETE
echo   Now double-click  start.bat  to run this project.
echo ============================================================
echo.
pause
endlocal
exit /b 0

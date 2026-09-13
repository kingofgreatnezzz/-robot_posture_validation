@echo off
setlocal EnableExtensions
title Robot Posture Validation (Perfect Pose Checker)
cd /d "%~dp0"

if not exist ".venv\Scripts\python.exe" (
    echo ============================================================
    echo   This project is not set up yet
    echo ============================================================
    echo.
    echo   Please double-click  setup.bat  first - one time only.
    echo   Then double-click start.bat again.
    echo.
    pause
    exit /b 1
)

call ".venv\Scripts\activate.bat"
if errorlevel 1 (
    echo [ERROR] Could not start the project's environment.
    echo         Delete the .venv folder and run setup.bat again.
    echo.
    pause
    exit /b 1
)

echo ============================================================
echo   STARTING: Robot Posture Validation (Perfect Pose Checker)
echo ============================================================
echo.
echo   * A browser tab should open by itself in a few seconds.
echo   * If it does not, open this address:  http://localhost:8501
echo   * Keep THIS window open while using the app.
echo   * To stop the app: press Ctrl+C in this window.
echo   * If it says the port is already in use, close the other
echo     app window and start again.
echo.

python -m streamlit run app.py --browser.gatherUsageStats false

echo.
echo ------------------------------------------------------------
echo   The app has stopped.
echo   If there is an error message above, copy it or take a
echo   screenshot and show it to your teacher.
echo ------------------------------------------------------------
echo.
pause
endlocal
exit /b 0

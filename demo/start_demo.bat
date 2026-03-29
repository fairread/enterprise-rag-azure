@echo off
setlocal enabledelayedexpansion

:INIT
cls
echo ======================================================
echo  Enterprise RAG - Initializing Local Evaluation Demo
echo ======================================================
echo.

echo [1/3] Checking Python Virtual Environment...
IF NOT EXIST ".venv\Scripts\activate" (
    echo     - No .venv detected. Creating Isolated Virtual Environment...
    python -m venv .venv
) ELSE (
    echo     - Existing .venv detected. Skipping creation...
)
call .venv\Scripts\activate

echo.
echo [2/3] Validating Python Backend Dependencies...
pip install -q -r ../backend/requirements.txt
pip install -q -r requirements.txt

echo.
echo [3/3] Validating React Frontend Dependencies...
if not exist "..\\frontend\\node_modules" (
    echo     - Installing npm packages (this may take a minute)...
    pushd ..\frontend
    call npm install
    popd
) else (
    echo     - Frontend node_modules detected. Skipping npm install...
)

:MENU
cls
echo ======================================================
echo  ENTERPRISE RAG - ASSESSMENT SUITE
echo ======================================================
echo  Current Mode: Local Virtual Environment (.venv)
echo ======================================================
echo.
echo  Please select an assessment mode to evaluate:
echo.
echo  1. [PUBLIC INGESTION] - Live Open-Source Data Demo (Wikipedia)
echo  2. [ENTERPRISE SYNC]  - O365, Rate Limiting ^& Tombstone Logic [+]
echo  3. [MLOPS EVALUATION] - RAGAS Quality Metrics (Faithfulness/Relevance) [+]
echo  4. [FULL-STACK DEMO]  - Launch FastAPI Backend + React Frontend
echo  6. [CLOUD FULL-STACK]  - Deploy ^& Launch on Azure [+]
echo  7. [EXIT]             - Close Assessment Suite
echo.
echo  [+] Requires heavy Enterprise SDKs (Azure, LangChain, OpenAI)
echo ------------------------------------------------------
set /p choice=" Selection (1-7): "

if "%choice%"=="1" (
    echo.
    python ..\backend\extractors\public_data_ingestor.py
    pause
    goto MENU
)
if "%choice%"=="2" (
    echo.
    call :INSTALL_AZURE
    python ..\backend\extractors\enterprise_o365_extractor.py
    pause
    goto MENU
)
if "%choice%"=="3" (
    echo.
    call :INSTALL_AZURE
    python ..\backend\evaluators\ragas_evaluator.py
    pause
    goto MENU
)
if "%choice%"=="4" (
    echo.
    echo Launching Orchestrator...
    python orchestrator.py
    pause
    goto MENU
)
if "%choice%"=="5" (
    echo.
    call :INSTALL_AZURE
    echo Launching Jupyter Lab/Notebook...
    jupyter notebook demo_pipeline.ipynb
    pause
    goto MENU
)
if "%choice%"=="6" (
    echo.
    echo Launching Azure Cloud Deployment...
    echo (Requires Azure CLI ^& Git Bash/WSL/Shell)
    cd ../deploy
    bash azure_deploy.sh
    cd ../demo
    pause
    goto MENU
)
if "%choice%"=="7" (
    echo.
    echo Exiting Assessment Suite. Thank you!
    exit /b 0
)

echo.
echo [!] Invalid selection. Please try again.
timeout /t 2 >nul
goto MENU

:INSTALL_AZURE
if not exist ".azure_ready" (
    echo     - This mode requires heavy Enterprise SDKs.
    echo     - Installing from backend/requirements-azure.txt...
    pip install -q -r ..\backend\requirements-azure.txt
    echo. > .azure_ready
)
goto :EOF

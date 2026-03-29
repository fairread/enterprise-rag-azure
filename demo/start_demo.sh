#!/bin/bash

# Enterprise RAG - Initializing Local Evaluation Demo
clear
echo "======================================================"
echo " Enterprise RAG - Initializing Local Evaluation Demo"
echo "======================================================"
echo ""

# 1. Checking Python Virtual Environment
echo "[1/3] Checking Python Virtual Environment..."
if [ ! -d ".venv" ]; then
    echo "    - No .venv detected. Creating Isolated Virtual Environment..."
    python3 -m venv .venv
else
    echo "    - Existing .venv detected. Skipping creation..."
fi
source .venv/bin/activate

# 2. Validating Python Backend Dependencies
echo ""
echo "[2/3] Validating Python Backend Dependencies..."
pip install -q -r ../backend/requirements.txt
pip install -q -r requirements.txt

# 3. Validating React Frontend Dependencies
echo ""
echo "[3/3] Validating React Frontend Dependencies..."
if [ ! -d "../frontend/node_modules" ]; then
    echo "    - Installing npm packages (this may take a minute)..."
    cd ../frontend
    npm install
    cd ../demo
else
    echo "    - Frontend node_modules detected. Skipping npm install..."
fi

# INSTALL_AZURE FUNCTION
install_azure() {
    if [ ! -f ".azure_ready" ]; then
        echo "    - This mode requires heavy Enterprise SDKs."
        echo "    - Installing from backend/requirements-azure.txt..."
        pip install -q -r ../backend/requirements-azure.txt
        touch .azure_ready
    fi
}

# MENU LOOP
while true
do
    clear
    echo "======================================================"
    echo " ENTERPRISE RAG - ASSESSMENT SUITE"
    echo "======================================================"
    echo " Current Mode: Local Virtual Environment (.venv)"
    echo "======================================================"
    echo ""
    echo " Please select an assessment mode to evaluate:"
    echo ""
    echo " 1. [PUBLIC INGESTION] - Live Open-Source Data Demo (Wikipedia)"
    echo " 2. [ENTERPRISE SYNC]  - O365, Rate Limiting & Tombstone Logic [+]"
    echo " 3. [MLOPS EVALUATION] - RAGAS Quality Metrics (Faithfulness/Relevance) [+]"
    echo " 4. [FULL-STACK DEMO]  - Launch FastAPI Backend + React Frontend"
    echo " 5. [INTERACTIVE]       - Launch Jupyter Notebook (Colab Optimized) [+]"
    echo " 6. [CLOUD FULL-STACK]  - Deploy & Launch on Azure [+]"
    echo " 7. [EXIT]             - Close Assessment Suite"
    echo ""
    echo " [+] Requires heavy Enterprise SDKs (Azure, LangChain, OpenAI)"
    echo "------------------------------------------------------"
    read -p " Selection (1-7): " choice

    case $choice in
        1)
            echo ""
            python3 ../backend/extractors/public_data_ingestor.py
            read -p "Press Enter to return to menu..."
            ;;
        2)
            echo ""
            install_azure
            python3 ../backend/extractors/enterprise_o365_extractor.py
            read -p "Press Enter to return to menu..."
            ;;
        3)
            echo ""
            install_azure
            python3 ../backend/evaluators/ragas_evaluator.py
            read -p "Press Enter to return to menu..."
            ;;
        4)
            echo ""
            echo "Launching Orchestrator..."
            python3 orchestrator.py
            read -p "Press Enter to return to menu..."
            ;;
        5)
            echo ""
            install_azure
            echo "Launching Jupyter Lab/Notebook..."
            jupyter notebook demo_pipeline.ipynb
            read -p "Press Enter to return to menu..."
            ;;
        6)
            echo ""
            echo "Launching Azure Cloud Deployment..."
            cd ../deploy
            bash azure_deploy.sh
            cd ../demo
            read -p "Press Enter to return to menu..."
            ;;
        7)
            echo ""
            echo "Exiting Assessment Suite. Thank you!"
            exit 0
            ;;
        *)
            echo ""
            echo "[!] Invalid selection. Please try again."
            sleep 2
            ;;
    esac
done

#!/bin/bash
# AutoOps AI — One-click environment setup
# Usage: bash scripts/setup_env.sh

set -e
echo "🚀 AutoOps AI — Environment Setup"
echo "=================================="

# Python check
python3 --version >/dev/null 2>&1 || { echo "❌ Python 3 not found. Install Python 3.10+"; exit 1; }
PYVER=$(python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
echo "✅ Python $PYVER found"

# Virtual environment
if [ ! -d "venv" ]; then
    python3 -m venv venv
    echo "✅ Virtual environment created"
else
    echo "✅ Virtual environment already exists"
fi

# Activate + install
source venv/bin/activate
pip install --upgrade pip -q
pip install -r requirements.txt -q
echo "✅ Dependencies installed"

# Download spaCy model (needed by Member 1's NER)
python3 -m spacy download en_core_web_sm -q
echo "✅ spaCy English model downloaded"

# .env setup
if [ ! -f ".env" ]; then
    cp .env.example .env
    echo "⚠️  .env created — EDIT IT with your AWS credentials before running"
else
    echo "✅ .env already exists"
fi

echo ""
echo "=================================="
echo "✅ Setup complete! Next steps:"
echo "  1. Edit .env with your AWS credentials"
echo "  2. source venv/bin/activate"
echo "  3. uvicorn api.main:app --reload    ← start API"
echo "  4. pytest tests/                    ← run tests"
echo "=================================="

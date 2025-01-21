# DHG Baseline Backend

FastAPI backend service for DHG Baseline application.

## Setup

1. Create a virtual environment:

2. Install dependencies:
bash
python -m venv venv
source venv/bin/activate # On Windows: .\venv\Scripts\activate

For development
pip install -r requirements/requirements.development.light.txt
For production
pip install -r requirements/requirements.production.txt

3. Create `.env` file:

bash
cp .env.example .env
Edit .env with your actual values

## Development

Start the development server:

bash
./start.sh development


Run tests:

bash
pytest

## API Documentation

Once running, visit:
- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

## Project Structure



Build for production:

bash
yarn build

## Project Structure

frontend/
├── src/
│ ├── components/ # React components
│ ├── pages/ # Page components
│ └── App.tsx # Main application
└── public/ # Static assets

## Environment Variables

- `VITE_SUPABASE_URL`: Your Supabase project URL
- `VITE_SUPABASE_ANON_KEY`: Your Supabase anon/public key
# DHG Monorepo

A monorepo containing DHG applications and shared packages.

## Applications

### DHG Baseline
A minimal application demonstrating Supabase authentication and queries.
- Frontend: React + Vite
- Backend: FastAPI
- Database: Supabase

### DHG Docs
A documentation viewer for the monorepo.
- Frontend: React + Vite + MDX
- Backend: FastAPI (serving documentation files)

## Project Structure

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

### Prerequisites
- Node.js (v18+)
- Python (v3.9+)
- Yarn
- Git

### Commands

#### Root Level

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

frontend/
├── src/
│ ├── components/ # React components
│ ├── pages/ # Page components
│ └── App.tsx # Main application
└── public/ # Static assets

## Environment Variables

- `VITE_SUPABASE_URL`: Your Supabase project URL
- `VITE_SUPABASE_ANON_KEY`: Your Supabase anon/public key


plaintext
/
├── apps/
│ ├── dhg-baseline/ # Supabase authentication demo
│ │ ├── frontend/ # React + Vite frontend
│ │ └── backend/ # FastAPI backend
│ │
│ └── dhg-docs/ # Documentation viewer
│ ├── frontend/ # React + Vite frontend
│ └── backend/ # FastAPI backend
│
├── packages/ # Shared packages
│ ├── ui-components/ # Shared React components
│ ├── supabase-config/ # Shared Supabase configuration
│ └── types/ # Shared TypeScript types
│
├── docs/ # Project documentation
├── package.json # Root workspace configuration
└── turbo.json # Turborepo configuration


## Getting Started

1. Install dependencies:

bash:apps/dhg-baseline/backend/README.md
yarn install

2. Set up environment variables:

bash
# In each application directory
cp .env.example .env

bash
In each application directory
cp .env.example .env

3. Start development servers:

bash
# Start all applications
yarn dev

# Start specific applications
yarn baseline:frontend
yarn baseline:backend
yarn docs:frontend
yarn docs:backend

bash
Start all applications
yarn dev
Start specific applications
yarn baseline:frontend
yarn baseline:backend
yarn docs:frontend
yarn docs:backend

bash
yarn dev          # Start all applications
yarn build        # Build all applications
yarn test         # Run all tests
yarn lint         # Lint all code
yarn clean        # Clean all builds

#### Application Specific
bash
# DHG Baseline Frontend
yarn baseline:frontend dev
yarn baseline:frontend build

# DHG Baseline Backend
yarn baseline:backend dev
yarn baseline:backend test

# DHG Docs Frontend
yarn docs:frontend dev
yarn docs:frontend build

# DHG Docs Backend
yarn docs:backend dev
yarn docs:backend test

## Testing

Each application contains its own test suite:

bash
# Run all tests
yarn test

# Run specific application tests
yarn baseline:frontend test
yarn baseline:backend test
yarn docs:frontend test
yarn docs:backend test

## Documentation

- Each application has its own README with specific setup instructions
- API documentation is available at `/docs` when running each backend
- Component documentation is available in the DHG Docs application

## Contributing

1. Create a new branch from main
2. Make your changes
3. Submit a pull request

## Environment Variables

### DHG Baseline
```plaintext
# Frontend
VITE_SUPABASE_URL=your-supabase-url
VITE_SUPABASE_ANON_KEY=your-supabase-anon-key

# Backend
SUPABASE_URL=your-supabase-url
SUPABASE_KEY=your-service-role-key
SUPABASE_JWT_SECRET=your-jwt-secret
```

### DHG Docs
```plaintext
# Frontend
VITE_API_URL=http://localhost:8001

# Backend
DOCS_ROOT_PATH=/path/to/docs
```

## License

MIT

## Support

For support, please open an issue in the repository.
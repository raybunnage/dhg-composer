# DHG Baseline Project Structure

## Overview
This document provides a detailed breakdown of the DHG Baseline project structure, explaining each directory and file's purpose.

## Project Tree

.
├── backend/ # Backend service directory
│ ├── README.md # Backend documentation
│ ├── pytest.ini # Python test configuration
│ ├── requirements/ # Python dependency management
│ │ ├── requirements.base.txt # Core dependencies
│ │ ├── requirements.development.light.txt # Minimal dev dependencies
│ │ └── requirements.production.txt # Production dependencies
│ ├── src/ # Source code directory
│ │ ├── api/ # API endpoints
│ │ │ └── auth.py # Authentication endpoints
│ │ ├── core/ # Core functionality
│ │ │ ├── config.py # Application configuration
│ │ │ ├── exceptions.py # Custom exception handling
│ │ │ ├── logging.py # Logging configuration
│ │ │ └── supabase.py # Supabase integration
│ │ ├── main.py # Application entry point
│ │ └── services/ # Business logic services
│ │ └── supabase.py # Supabase service implementation
│ ├── start.sh # Backend startup script
│ └── tests/ # Test directory
│ ├── api/ # API tests
│ │ └── test_auth.py # Authentication tests
│ ├── conftest.py # Test configuration and fixtures
│ └── services/ # Service tests
│ └── test_supabase.py # Supabase service tests
├── frontend/ # Frontend application
│ ├── package.json # Node.js dependencies and scripts
│ ├── src/ # Source code directory
│ │ ├── App.css # Main application styles
│ │ ├── App.tsx # Main application component
│ │ ├── hooks/ # Custom React hooks
│ │ │ └── useAuth.ts # Authentication hook
│ │ ├── index.css # Global styles
│ │ ├── main.tsx # Application entry point
│ │ └── pages/ # Application pages
│ │ └── auth/ # Authentication pages
│ │ └── index.tsx # Main auth page
│ ├── tsconfig.json # TypeScript configuration
│ ├── tsconfig.node.json # Node-specific TS config
│ └── vite.config.ts # Vite bundler configuration
└── packages/ # Shared packages directory
└── ui/ # UI component library
├── packages/ # Package configuration
│ └── ui/
│ └── package.json # UI library dependencies
└── src/ # Source code directory
└── components/ # Shared UI components

## Key Directories Explained

### Backend (`/backend`)
- Contains the FastAPI backend service
- Organized with clear separation of concerns (API, core, services)
- Includes comprehensive testing setup
- Manages dependencies through requirements files

### Frontend (`/frontend`)
- React/Vite application
- TypeScript-based implementation
- Modular structure with hooks, pages, and components
- Configured for modern development practices

### Packages (`/packages`)
- Shared code and components
- UI library for consistent component usage
- Enables code reuse across applications

## Best Practices Implemented
1. Clear separation of concerns
2. Modular architecture
3. Comprehensive testing structure
4. Shared component library
5. Type-safe implementation
6. Organized dependency management

## Notes
- The structure follows modern full-stack development practices
- Enables scalability and maintainability
- Supports team collaboration through clear organization
- Implements testing at all levels
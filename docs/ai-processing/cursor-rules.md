# Cursor Rules Guide

This guide focuses on configuring and using Cursor AI rules effectively in your project.

## Table of Contents
1. [Introduction](#introduction)
2. [Rule Types](#rule-types)
3. [Configuration](#configuration)
4. [Current Rules Analysis](#current-rules-analysis)
5. [Best Practices](#best-practices)
6. [Testing Rules](#testing-rules)
7. [Examples](#examples)

## Introduction

Cursor Rules are configuration directives that guide how Cursor AI generates and modifies code. They help maintain consistency and enforce project standards in AI-assisted development.

## Rule Types

1. **Global Rules**
   - Apply to all projects
   - Set in Cursor Settings
   - Define universal coding standards

2. **Project Rules**
   - Defined in `.cursorrules` file
   - Project-specific standards
   - Override global rules when needed

## Current Rules Analysis

### Core Strengths

1. **FullStackFeature Rule (Core Coordinator)**
   - Provides high-level framework for feature development
   - Coordinates across all layers (frontend, backend, database)
   - Manages feature lifecycle from analysis to deployment
   - Ensures comprehensive documentation and testing

2. **Cross-Layer Integration**
   - Strong coordination between layers
   - Consistent type management
   - Unified error handling
   - Coordinated testing strategies

3. **Testing Framework**
   - Test-Driven Development focus
   - Comprehensive testing patterns
   - Integration testing coverage
   - Database testing strategies

### Areas of Overlap

1. **Testing Definitions**
   - TDD rule
   - TestingPatterns rule
   - Component-specific testing sections
   - Consider consolidation

2. **Exception Handling**
   - Defined in FastAPI
   - Defined in PythonBackendDevelopment
   - Consider unified approach

3. **API Contracts**
   - APIIntegration rule
   - FastAPI rule
   - Consider merging definitions

### Recommended Rule Structure

```json
{
  "core_rules": [
    "FullStackFeature",    // Main coordinator
    "React",               // Frontend (simplified styling)
    "FastAPI",             // Backend core
    "PythonBackendDevelopment", // Service architecture
    "APIIntegration",      // Cross-layer coordination
    "DatabaseMigrations",  // Data management
    "TestDrivenDevelopment" // Testing philosophy
  ]
}
```

### Missing Critical Rules

1. **Security Practices**
   - Authentication/Authorization
   - Data Protection
   - Secure Configuration
   - Security Testing

2. **Deployment Workflow**
   - Environment Management
   - CI/CD Pipeline
   - Monitoring
   - Rollback Procedures

### Recommendations

1. **Simplification**
   - Consolidate testing rules
   - Simplify nested configurations
   - Reduce styling complexity
   - Streamline migration tooling

2. **Additions**
   - Add Security rule
   - Add Deployment rule
   - Enhance monitoring coverage
   - Add performance guidelines

3. **Maintenance**
   - Regular rule review
   - Update based on project needs
   - Remove unused rules
   - Keep documentation current

## Configuration

### .cursorrules Structure
```json
{
  "rules": [
    {
      "type": "React",
      "instructions": "Use functional components with hooks..."
    },
    {
      "type": "PythonBackendDevelopment",
      "description": "Rules for Python backend development",
      "instructions": [
        "Use type hints extensively",
        "Follow SOLID principles",
        "Implement proper error handling"
      ]
    }
  ]
}
```

### Rule Categories

1. **Frontend Development**
   - React patterns
   - TypeScript usage
   - Component structure
   - State management

2. **Backend Development**
   - API design
   - Database access
   - Error handling
   - Service architecture

3. **Code Quality**
   - Testing requirements
   - Documentation standards
   - Error handling patterns
   - Logging standards

## Best Practices

1. **Rule Writing**
   - Be specific and clear
   - Use examples where helpful
   - Focus on one concern per rule
   - Include rationale when needed

2. **Rule Organization**
   - Group related rules
   - Use descriptive names
   - Keep rules focused
   - Maintain hierarchy

3. **Rule Testing**
   - Verify with sample code
   - Test edge cases
   - Check rule interactions
   - Update as needed

## Testing Rules

1. **Verification Process**
```bash
# Create test file
touch src/test-rule.ts

# Ask Cursor to generate code
# Verify output matches rules
```

2. **Checklist**
- [ ] Rules are being applied
- [ ] Output matches expectations
- [ ] No conflicts between rules
- [ ] Documentation is clear

## Examples

### React Component Rule
```json
{
  "type": "ReactComponent",
  "instructions": [
    "Use functional components",
    "Implement proper TypeScript types",
    "Include component documentation",
    "Add error boundaries where needed"
  ]
}
```

### Python Backend Rule
```json
{
  "type": "PythonBackend",
  "instructions": [
    "Use type hints for all functions",
    "Implement proper error handling",
    "Follow repository pattern",
    "Include comprehensive tests"
  ]
}
```

## Resources

- [Cursor Documentation](https://cursor.sh/docs)
- [Rule Examples](https://cursor.sh/examples)
- [Community Guidelines](https://cursor.sh/community)

---

For shell scripting guidelines, see [Shell Scripting Guide](../development/shell/shell-scripting-guide.md)




Recommendations:
Move Middleware and Routes
The src directory at root level seems out of place
Consider moving these into the backend structure

Enhance Backend Services
Add more structure to the services directory

Consider domain-driven design folders

Documentation Improvements
Add API documentation generation
Add more examples in docs

Testing Enhancement
Add more test factories
Include test data generators
Add API contract tests

Configuration Management
Add dedicated config management
Include environment-specific configs
Add validation for configurations
Would you like me to provide specific implementation details for any of these recommendations?
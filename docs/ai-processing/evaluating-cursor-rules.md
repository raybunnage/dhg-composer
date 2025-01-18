# Evaluating and Adding Cursor Rules

## Rule Categories to Consider

### Frontend Rules

1. **Component Architecture**
```json
{
  "type": "ReactComponents",
  "instructions": [
    "Use functional components exclusively",
    "Implement proper prop typing with TypeScript",
    "Follow atomic design principles (atoms, molecules, organisms)",
    "Include component documentation with usage examples",
    "Implement error boundaries where appropriate"
  ]
}
```

2. **State Management**
```json
{
  "type": "StateManagement",
  "instructions": [
    "Use React Query for server state",
    "Implement Context API for global UI state",
    "Follow proper loading/error state patterns",
    "Cache invalidation strategies",
    "Optimistic updates for better UX"
  ]
}
```

3. **Form Handling**
```json
{
  "type": "FormHandling",
  "instructions": [
    "Use React Hook Form for form state",
    "Implement proper validation with Zod",
    "Follow accessibility guidelines",
    "Include proper error messaging",
    "Handle form submission states"
  ]
}
```

### Backend Rules

1. **API Design**
```json
{
  "type": "APIDesign",
  "instructions": [
    "Follow RESTful principles",
    "Implement proper versioning",
    "Use consistent response formats",
    "Include comprehensive error handling",
    "Document all endpoints with OpenAPI"
  ]
}
```

2. **Database Operations**
```json
{
  "type": "DatabaseOperations",
  "instructions": [
    "Use repository pattern",
    "Implement proper transaction handling",
    "Follow migration best practices",
    "Include database indexing strategies",
    "Optimize query performance"
  ]
}
```

3. **Security Patterns**
```json
{
  "type": "SecurityPatterns",
  "instructions": [
    "Implement proper authentication flows",
    "Follow OWASP security guidelines",
    "Use proper password hashing",
    "Implement rate limiting",
    "Handle sensitive data securely"
  ]
}
```

## Evaluation Process

1. **Analyze Current Patterns**
```bash
./scripts/evaluate-cursor-rules.sh
```

2. **Review Generated Code**
- Check if current rules produce desired patterns
- Identify missing patterns
- Note inconsistencies

3. **Test New Rules**
```bash
# Create test file
touch src/test-rule.ts

# Ask Cursor to generate code
# Evaluate output against expectations
```

4. **Iterate and Refine**
- Add new rules incrementally
- Test each addition
- Get team feedback
- Update documentation

## Common Rule Categories

1. **Architecture Patterns**
   - Component structure
   - Service layers
   - Data access
   - State management

2. **Code Quality**
   - Testing patterns
   - Documentation
   - Error handling
   - Logging

3. **Performance**
   - Optimization strategies
   - Caching patterns
   - Query optimization
   - Bundle optimization

4. **Security**
   - Authentication flows
   - Authorization patterns
   - Data validation
   - Error handling

## Implementation Checklist

- [ ] Run evaluation script
- [ ] Review current patterns
- [ ] Identify gaps
- [ ] Draft new rules
- [ ] Test rules
- [ ] Get team feedback
- [ ] Document changes
- [ ] Monitor effectiveness 
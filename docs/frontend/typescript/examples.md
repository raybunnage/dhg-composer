import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import './index.css'
import App from './App.tsx'

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <App />
  </StrictMode>,
) 

### Line-by-Line Explanation
- `import { StrictMode } from 'react'`
  - Imports React's StrictMode component
  - StrictMode helps find potential problems in your app
  - Like a "debug mode" for development

- `import { createRoot } from 'react-dom/client'`
  - Gets the function needed to create a React root
  - This is React 18's way of rendering apps
  - More efficient than older ReactDOM.render

- `import './index.css'`
  - Imports global CSS styles
  - Affects the entire application
  - Vite processes this into the final bundle

- `createRoot(document.getElementById('root')!).render()`
  - Finds the HTML element with id="root"
  - The `!` tells TypeScript "this element definitely exists"
  - Creates a React root and renders into it

## 2. App.tsx - Main Application Component

### Key Concepts
1. **State Management**
   ```typescript
   const [session, setSession] = useState<any>(null)
   ```docs/tsx-files-detailed.md
   - Creates a state variable `session` and function to update it `setSession`
   - `<any>` is the type annotation (could be more specific)
   - `null` is the initial value

2. **Effect Hook**
   ```typescript
   useEffect(() => {
     console.log('App mounted')
   }, [])
   ```
   - Runs when component "mounts" (first appears)
   - Empty array `[]` means "run once only"
   - Good for initialization code

3. **Conditional Rendering**
   ```typescript
   if (!session) {
     return <Login onSuccess={(sessionData) => {
       setSession(sessionData)
     }} />
   }
   ```
   - Shows different content based on conditions
   - Returns entire components
   - Passes callbacks to child components

## 3. Login.tsx - Authentication Component

### Important Features
1. **Props Interface**
   ```typescript
   interface LoginProps {
     onSuccess: (session: any) => void
   }
   ```
   - Defines the shape of props this component accepts
   - Makes the component type-safe
   - Documents required props

2. **Form Handling**
   ```typescript
   const handleSubmit = async (e: React.FormEvent) => {
     e.preventDefault()
   }
   ```
   - `async` for asynchronous operations
   - `React.FormEvent` types the event object
   - `preventDefault()` stops form submission

3. **State Variables**
   ```typescript
   const [email, setEmail] = useState('')
   const [password, setPassword] = useState('')
   ```
   - Each form field has its own state
   - Empty string as initial value
   - Updates on user input

## 4. DataFetch.tsx - Data Display Component

### Key Elements
1. **Type Definition**
   ```typescript
   interface TestUser {
     user_id: string
     // ... other fields
   }
   ```
   - Defines the shape of user data
   - `string | null` means "string or null"
   - Makes data handling type-safe

2. **Array State**
   ```typescript
   const [users, setUsers] = useState<TestUser[]>([])
   ```
   - State variable for array of TestUser objects
   - `[]` as initial value (empty array)
   - TypeScript ensures type safety

3. **Conditional Error Display**
   ```typescript
   {error && <div style={{ color: 'red' }}>{error}</div>}
   ```
   - Only shows error div if error exists
   - Inline styles with TypeScript objects
   - Dynamic content in curly braces

## Common TypeScript/React Patterns

1. **Type Safety in Props**
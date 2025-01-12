import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { DataFetch } from './components/DataFetch'

const queryClient = new QueryClient()

function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <div>
        <h1>My Full Stack App</h1>
        <DataFetch />
      </div>
    </QueryClientProvider>
  )
}

export default App 
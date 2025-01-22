import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],
  server: {
    port: 5173,
    host: '0.0.0.0', // This ensures it binds to all network interfaces
    strictPort: true,
    watch: {
      usePolling: true // This helps with some file system issues
    }
  },
  build: {
    outDir: 'dist',
    sourcemap: true
  }
}) 
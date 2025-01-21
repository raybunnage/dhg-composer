import { createClient, SupabaseClient } from '@supabase/supabase-js'
import type { Database } from '@dhg/types'

export const createSupabaseClient = (
  supabaseUrl: string,
  supabaseKey: string
): SupabaseClient<Database> => {
  return createClient<Database>(supabaseUrl, supabaseKey)
}

export * from './auth'
export * from './queries'

// Base client setup, types, and common utilities
export class BaseSupabaseClient {
  // Common initialization
  // Shared utilities
  // Base error handling
} 
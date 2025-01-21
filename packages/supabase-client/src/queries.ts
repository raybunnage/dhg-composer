import type { SupabaseClient } from '@supabase/supabase-js'
import type { Database } from '@dhg/types'

export async function getProfile(
  client: SupabaseClient<Database>,
  userId: string
) {
  const { data, error } = await client
    .from('profiles')
    .select('*')
    .eq('id', userId)
    .single()
  
  if (error) throw error
  return data
} 
import type { SupabaseClient, User } from '@supabase/supabase-js'
import type { Database } from '@dhg/types'

export async function getUser(client: SupabaseClient<Database>): Promise<User | null> {
  const { data: { user }, error } = await client.auth.getUser()
  if (error) throw error
  return user
}

export async function signIn(
  client: SupabaseClient<Database>,
  email: string,
  password: string
) {
  const { data, error } = await client.auth.signInWithPassword({
    email,
    password,
  })
  if (error) throw error
  return data
}

export async function signOut(client: SupabaseClient<Database>) {
  const { error } = await client.auth.signOut()
  if (error) throw error
} 
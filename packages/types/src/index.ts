export interface Profile {
  id: string
  created_at: string
  updated_at: string
  email: string
  full_name?: string
  avatar_url?: string
}

export interface Database {
  public: {
    Tables: {
      profiles: {
        Row: Profile
        Insert: Omit<Profile, 'created_at' | 'updated_at'>
        Update: Partial<Omit<Profile, 'id'>>
      }
      // Add other tables as needed
    }
  }
}

export interface AuthResponse {
  user: Profile | null
  error: Error | null
}

export * from './supabase' 
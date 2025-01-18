import { createClient } from '@supabase/supabase-js'

const supabaseUrl = 'https://jdksnfkupzywjdfefkyj.supabase.co'
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Impka3NuZmt1cHp5d2pkZmVma3lqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzQxODkwMTMsImV4cCI6MjA0OTc2NTAxM30.035475oKIiE1pSsfQbRoje4-FRT9XDKAk6ScHYtaPsQ'

export const supabase = createClient(supabaseUrl, supabaseKey) 
import { useQuery } from '@tanstack/react-query'
import { supabase } from '../config/supabase'

export const DataFetch = () => {
    const { data, isLoading, error } = useQuery({
        queryKey: ['data'],
        queryFn: async () => {
            const { data, error } = await supabase
                .from('your_table')
                .select('*')
            
            if (error) throw error
            return data
        }
    })

    if (isLoading) return <div>Loading...</div>
    if (error) return <div>Error: {error.toString()}</div>

    return (
        <div>
            <h2>Data from Supabase:</h2>
            <pre>{JSON.stringify(data, null, 2)}</pre>
        </div>
    )
} 
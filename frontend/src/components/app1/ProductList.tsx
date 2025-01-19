import React from 'react';
import { useQuery } from '@tanstack/react-query';
import { supabase } from '@/config/supabase';

export const ProductList = () => {
  const { data: products, isLoading } = useQuery({
    queryKey: ['products'],
    queryFn: async () => {
      const { data } = await supabase
        .from('products')
        .select('*')
        .eq('app_id', 'app1');
      return data;
    }
  });

  if (isLoading) return <div>Loading products...</div>;

  return (
    <div className="grid grid-cols-3 gap-4">
      {products?.map(product => (
        <div key={product.id} className="p-4 border rounded">
          <h3>{product.name}</h3>
          <p>{product.price}</p>
        </div>
      ))}
    </div>
  );
}; 
import React from 'react';
import { useQuery } from '@tanstack/react-query';
import { supabase } from '@/config/supabase';

export const CourseList = () => {
  const { data: courses, isLoading } = useQuery({
    queryKey: ['courses'],
    queryFn: async () => {
      const { data } = await supabase
        .from('courses')
        .select('*')
        .eq('app_id', 'app2');
      return data;
    }
  });

  if (isLoading) return <div>Loading courses...</div>;

  return (
    <div className="space-y-4">
      {courses?.map(course => (
        <div key={course.id} className="p-4 border rounded">
          <h3>{course.title}</h3>
          <p>{course.description}</p>
          <button className="btn">Enroll</button>
        </div>
      ))}
    </div>
  );
}; 
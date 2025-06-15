import { NextResponse } from 'next/server';
import pool from '@/app/lib/db';

export async function GET() {
  try {
    const client = await pool.connect();

    const query = `
      SELECT 
        s.student_name,
        c.course_code,
        c.course_name,
        l.lecturer_name,
        t.ta_name,
        e.enrollment_date
      FROM course_enrollment e
      JOIN students s ON e.student_id = s.student_id
      JOIN courses c ON e.course_id = c.course_id
      LEFT JOIN lecturers l ON c.lecturer_id = l.lecturer_id
      LEFT JOIN ta t ON c.ta_id = t.ta_id
    `;

    const result = await client.query(query);

    client.release();

    return NextResponse.json(result.rows);
  } catch (error) {
    console.error('Error fetching enrollments:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
}

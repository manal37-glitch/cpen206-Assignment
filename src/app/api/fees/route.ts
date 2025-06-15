import { NextResponse } from 'next/server';
import pool from '@/app/lib/db';

export async function GET() {
  try {
    const client = await pool.connect();

    const result = await client.query(`SELECT outstanding_fees()`);
    const data = result.rows[0].outstanding_fees;

    client.release();

    return NextResponse.json(data);
  } catch (error) {
    console.error('Error fetching outstanding fees:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
}

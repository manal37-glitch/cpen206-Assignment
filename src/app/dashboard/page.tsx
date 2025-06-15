'use client';

import { useEffect, useState } from 'react';

interface FeeInfo {
  student_id: number;
  full_name: string;
  total_fees: number;
  amount_paid: number;
  outstanding_balance: number;
}

interface EnrollmentInfo {
  student_name: string;
  course_code: string;
  course_name: string;
  lecturer_name: string;
  ta_name: string;
  enrollment_date: string;
}

export default function Dashboard() {
  const [fees, setFees] = useState<FeeInfo[]>([]);
  const [enrollments, setEnrollments] = useState<EnrollmentInfo[]>([]);

  useEffect(() => {
    fetch('/api/fees')
      .then((res) => res.json())
      .then((data) => setFees(data));

    fetch('/api/enrollments')
      .then((res) => res.json())
      .then((data) => setEnrollments(data));
  }, []);

  return (
    <main style={{ padding: '2rem' }}>
      <h2>📊 Outstanding Fees</h2>
      <table>
        <thead>
          <tr>
            <th>Student ID</th>
            <th>Full Name</th>
            <th>Total Fees</th>
            <th>Amount Paid</th>
            <th>Outstanding Balance</th>
          </tr>
        </thead>
        <tbody>
          {fees.map((fee) => (
            <tr key={fee.student_id}>
              <td>{fee.student_id}</td>
              <td>{fee.full_name}</td>
              <td>₵{fee.total_fees}</td>
              <td>₵{fee.amount_paid}</td>
              <td style={{ color: 'darkred', fontWeight: 'bold' }}>₵{fee.outstanding_balance}</td>
            </tr>
          ))}
        </tbody>
      </table>

      <h2>📚 Enrollments</h2>
      <table>
        <thead>
          <tr>
            <th>Student Name</th>
            <th>Course Code</th>
            <th>Course Name</th>
            <th>Lecturer</th>
            <th>TA</th>
            <th>Enrollment Date</th>
          </tr>
        </thead>
        <tbody>
          {enrollments.map((e, index) => (
            <tr key={index}>
              <td>{e.student_name}</td>
              <td>{e.course_code}</td>
              <td>{e.course_name}</td>
              <td>{e.lecturer_name}</td>
              <td>{e.ta_name}</td>
              <td>{new Date(e.enrollment_date).toLocaleDateString()}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </main>
  );
}

'use client';
import Link from 'next/link';
import { usePathname } from 'next/navigation';

export default function Header() {
  const path = usePathname();

  return (
    <header className="bg-purple-100 text-purple-800 shadow-md p-4 flex justify-between items-center">
      <h1 className="font-bold text-xl">🎓 Student Portal</h1>
      <nav className="space-x-4">
        <Link href="/register" className={path === '/register' ? 'font-bold underline' : ''}>Register</Link>
        <Link href="/login" className={path === '/login' ? 'font-bold underline' : ''}>Login</Link>
        <Link href="/dashboard" className={path === '/dashboard' ? 'font-bold underline' : ''}>Dashboard</Link>
      </nav>
    </header>
  );
}

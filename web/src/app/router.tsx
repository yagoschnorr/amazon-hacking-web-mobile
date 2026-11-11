import { createBrowserRouter, Navigate } from 'react-router';
import { LoginPage } from '@/features/auth';
import { EstandeFormPage, EstandesPage } from '@/features/estandes';
import { QrCodePage } from '@/features/qrcode';

// As rotas de /estandes passam a ser protegidas na etapa W3.
export const router = createBrowserRouter([
  { path: '/', element: <Navigate to="/estandes" replace /> },
  { path: '/login', element: <LoginPage /> },
  { path: '/estandes', element: <EstandesPage /> },
  { path: '/estandes/novo', element: <EstandeFormPage /> },
  { path: '/estandes/:id/editar', element: <EstandeFormPage /> },
  { path: '/estandes/:id/qr', element: <QrCodePage /> },
  { path: '*', element: <Navigate to="/estandes" replace /> },
]);

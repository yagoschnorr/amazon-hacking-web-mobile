import { createBrowserRouter, Navigate } from 'react-router';
import { LoginPage, ProtectedRoute } from '@/features/auth';
import { EstandeFormPage, EstandesPage } from '@/features/estandes';
import { QrCodePage } from '@/features/qrcode';

export const router = createBrowserRouter([
  { path: '/', element: <Navigate to="/estandes" replace /> },
  { path: '/login', element: <LoginPage /> },
  {
    // Rotas que exigem administrador autenticado.
    element: <ProtectedRoute />,
    children: [
      { path: '/estandes', element: <EstandesPage /> },
      { path: '/estandes/novo', element: <EstandeFormPage /> },
      { path: '/estandes/:id/editar', element: <EstandeFormPage /> },
      { path: '/estandes/:id/qr', element: <QrCodePage /> },
    ],
  },
  { path: '*', element: <Navigate to="/estandes" replace /> },
]);

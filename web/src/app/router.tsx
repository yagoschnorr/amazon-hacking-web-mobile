import { createBrowserRouter, Navigate } from 'react-router';
import { LoginPage, ProtectedRoute } from '@/features/auth';
import { EstandeFormPage, EstandesPage } from '@/features/estandes';
import { QrCodePage } from '@/features/qrcode';
import { PainelLayout } from './PainelLayout';

export const router = createBrowserRouter([
  { path: '/', element: <Navigate to="/estandes" replace /> },
  { path: '/login', element: <LoginPage /> },
  {
    // Rotas que exigem administrador autenticado.
    element: <ProtectedRoute />,
    children: [
      {
        element: <PainelLayout />,
        children: [
          { path: '/estandes', element: <EstandesPage /> },
          { path: '/estandes/novo', element: <EstandeFormPage /> },
          { path: '/estandes/:id/editar', element: <EstandeFormPage /> },
        ],
      },
      // QR em tela cheia e impressão, sem a barra do painel.
      { path: '/estandes/:id/qr', element: <QrCodePage /> },
    ],
  },
  { path: '*', element: <Navigate to="/estandes" replace /> },
]);

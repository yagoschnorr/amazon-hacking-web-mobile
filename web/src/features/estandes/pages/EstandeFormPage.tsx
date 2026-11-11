import { useParams } from 'react-router';

// Atende /estandes/novo e /estandes/:id/editar.
export function EstandeFormPage() {
  const { id } = useParams();

  return (
    <main>
      <h1>{id ? `Editar estande ${id}` : 'Novo estande'}</h1>
    </main>
  );
}

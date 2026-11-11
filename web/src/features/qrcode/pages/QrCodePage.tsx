import { useParams } from 'react-router';

export function QrCodePage() {
  const { id } = useParams();

  return (
    <main>
      <h1>QR code do estande {id}</h1>
    </main>
  );
}

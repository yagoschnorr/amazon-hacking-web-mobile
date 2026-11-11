import { Link } from 'react-router';
import { Button, Icon } from '@/shared/components';
import { EstandeQrCode } from '../components/EstandeQrCode';
import styles from './QrCodePage.module.css';

export interface EstandeQr {
  id: string;
  nome: string;
  descricao: string;
  localizacao: string;
}

const INSTRUCAO =
  'Abra o app Circuito de Descobertas, toque em Ler QR code e aponte a câmera para este código.';

// Tela cheia do QR (design 07) e folha A4 de impressão (design 08).
export function QrCodePage({ estande }: { estande: EstandeQr }) {
  return (
    <>
      {/* Versão de tela: some na impressão. */}
      <div className={styles.tela}>
        <header className={styles.barra}>
          <Link to="/estandes" className={styles.voltar}>
            <Icon name="arrow_back" size={20} />
            Voltar para estandes
          </Link>
          <div className={styles.imprimir}>
            <span className={styles.dica}>Folha A4, retrato, sem margens extras.</span>
            <Button icon="print" onClick={() => window.print()}>
              Imprimir
            </Button>
          </div>
        </header>

        <main className={styles.centro}>
          <section className={styles.cartao}>
            <EstandeQrCode estandeId={estande.id} className={styles.qrTela} />

            <div className={styles.info}>
              <p className={styles.overline}>Circuito de Descobertas</p>
              <h1 className={styles.nome}>{estande.nome}</h1>
              <p className={styles.descricao}>{estande.descricao}</p>

              <div className={styles.chips}>
                <span className={`${styles.chip} ${styles.chipCodigo}`}>
                  <Icon name="storefront" size={22} />
                  Código {estande.id}
                </span>
                <span className={styles.chip}>
                  <Icon name="location_on" size={22} />
                  {estande.localizacao}
                </span>
              </div>

              <hr className={styles.divisoria} />

              <p className={styles.instrucao}>
                <Icon name="qr_code_scanner" size={28} />
                {INSTRUCAO}
              </p>
            </div>
          </section>
        </main>
      </div>

      {/* Versão impressa: só aparece na impressão. */}
      <div className={styles.folha} aria-hidden="true">
        <div className={styles.folhaTopo}>
          <p className={styles.folhaOverline}>Circuito de Descobertas · Estande {estande.id}</p>
          <p className={styles.folhaNome}>{estande.nome}</p>
          <p className={styles.descricao}>{estande.descricao}</p>
        </div>

        <EstandeQrCode estandeId={estande.id} className={styles.qrFolha} />

        <div className={styles.folhaRodape}>
          <p className={styles.folhaLocal}>
            <Icon name="location_on" size={28} />
            {estande.localizacao}
          </p>
          <hr className={styles.folhaDivisoria} />
          <p className={styles.folhaInstrucao}>
            <Icon name="qr_code_scanner" size={32} />
            {INSTRUCAO}
          </p>
        </div>
      </div>
    </>
  );
}

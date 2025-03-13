
import styles from "./page.module.css";
import MapComponent from "../components/MapComponent";
export default function Home() {
  return (
    <div className={styles.page}>
      <main className={styles.main}>
        <MapComponent />

      </main>
      <footer className={styles.footer}>

      </footer>
    </div>
  );
}

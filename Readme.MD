```markdown
# 📒 Catatan Kesimpulan: Template Notebook & Monitoring Prometheus

## 1. Struktur Umum Notebook Machine Learning

1. **Import Library**  
   Import semua library yang dibutuhkan (pandas, numpy, sklearn, matplotlib, seaborn, prometheus_client, dll).

2. **Load Dataset**  
   Baca dataset dan tampilkan beberapa baris awal.

3. **Exploratory Data Analysis (EDA)**  
   Analisis data secara statistik dan visual.

4. **Preprocessing**  
   Tangani missing value, encoding, scaling, dsb.

5. **Split Data**  
   Pisahkan data menjadi X_train, X_test, y_train, y_test.

6. **Modeling**  
   Latih model machine learning.

7. **Evaluasi Model**  
   Tampilkan metrik evaluasi (accuracy, precision, recall, dsb).

8. **Monitoring Prometheus**  
   Ekspos metrik model ke Prometheus.

---

## 2. Monitoring Prometheus dari Notebook

### A. Tambahkan Cell Monitoring di Notebook

```python
from prometheus_client import start_http_server, Gauge
import time
from sklearn.metrics import accuracy_score

# Pastikan model sudah dilatih sebelum menjalankan cell ini!
if 'y_test' in globals() and 'final_rf' in globals() and 'X_test' in globals():
    if 'rf_accuracy' not in globals():
        rf_accuracy = Gauge('rf_model_accuracy', 'Akurasi Model Random Forest')
    rf_accuracy.set(accuracy_score(y_test, final_rf.predict(X_test)))
    try:
        start_http_server(8000)
        print("Prometheus metrics server running on http://localhost:8000/")
    except OSError:
        print("Prometheus metrics server already running on http://localhost:8000/")
    while True:
        time.sleep(10)
else:
    print("y_test, X_test, atau final_rf belum didefinisikan. Jalankan cell training & evaluasi model terlebih dahulu.")
```
- **Jalankan cell ini dan biarkan tetap berjalan** selama ingin monitoring.

---

### B. Konfigurasi Prometheus

Edit file `prometheus.yml` Anda seperti berikut:

```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'ml_model'
    static_configs:
      - targets: ['localhost:8000']
```
- **Simpan file** setelah diedit.

---

### C. Jalankan Prometheus

1. **Buka Command Prompt** di folder tempat `prometheus.exe` berada.
2. Jalankan:
   ```
   .\prometheus.exe --config.file="C:\Users\hrahm\OneDrive\Documents\streamlit\MSML\prometheus.yml"
   ```
3. Buka [http://localhost:9090/targets](http://localhost:9090/targets)  
   Pastikan target `localhost:8000` muncul dan statusnya **UP**.

---

### D. Query di Prometheus

1. Buka [http://localhost:9090](http://localhost:9090)
2. Masukkan nama metrik, misal:
   ```
   rf_model_accuracy
   ```
   lalu klik **Execute**.

---

## 3. Tips Penting

- **Jalankan Prometheus dari terminal** dengan argumen `--config.file=...` agar menggunakan file config yang benar.
- **Jangan stop cell Python monitoring** selama ingin expose metrik.
- Untuk eksperimen baru, **ganti nama metrik** jika ingin monitoring model lain.
- Jika error file lock Prometheus, **hapus file `data/queries.active`** di folder Prometheus sebelum menjalankan ulang.

---

## 4. Checklist Sukses Monitoring

- [ ] Cell Python monitoring berjalan (`http://localhost:8000` bisa diakses).
- [ ] File `prometheus.yml` sudah mengarah ke `localhost:8000`.
- [ ] Prometheus dijalankan dengan config yang benar.
- [ ] Target `localhost:8000` muncul di `/targets` dan statusnya UP.
- [ ] Query metrik di Prometheus UI muncul hasilnya.

---

**Gunakan catatan ini setiap kali membuat notebook baru agar proses monitoring Prometheus selalu berjalan lancar dan konsisten.**
```

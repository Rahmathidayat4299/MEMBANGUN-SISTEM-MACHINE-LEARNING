# Gunakan image Python sebagai base
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Salin semua file ke dalam container
COPY . /app

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose port untuk Prometheus
EXPOSE 8000

# Jalankan notebook atau script utama
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
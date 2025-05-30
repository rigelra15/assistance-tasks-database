#!/usr/bin/env bash
set -euo pipefail

# Konfigurasi
DB_NAME="national_weather"
DB_USER="praktikan"
DB_PASS="p4ssw0rd"
CONTAINER="postgres_praktikum"
DATA_DIR="/data"

# Salin CSV ke container
docker cp "../data/weather_data.csv" "$CONTAINER":"$DATA_DIR/weather_data.csv"

# Cek dan buat database
exists=$(docker exec -e PGPASSWORD="$DB_PASS" "$CONTAINER" \
  psql -U "$DB_USER" -d postgres -tAc "SELECT 1 FROM pg_database WHERE datname = '$DB_NAME';")

if [ "$exists" != "1" ]; then
  echo "Creating database '$DB_NAME'..."
  docker exec -e PGPASSWORD="$DB_PASS" "$CONTAINER" \
    psql -U "$DB_USER" -d postgres -c "CREATE DATABASE \"$DB_NAME\";"
fi

# Buat tabel
docker exec -e PGPASSWORD="$DB_PASS" "$CONTAINER" \
  psql -U "$DB_USER" -d "$DB_NAME" -c "
CREATE TABLE IF NOT EXISTS weather_data (
  station_id     SERIAL PRIMARY KEY,
  station_name   TEXT,
  province       TEXT,
  reading_time   TIMESTAMP,
  temperature    NUMERIC(5,2),
  humidity       NUMERIC(5,2),
  wind_speed     NUMERIC(5,2)
);"

# Import CSV
echo "Importing CSV file..."
docker exec -e PGPASSWORD="$DB_PASS" "$CONTAINER" \
  psql -U "$DB_USER" -d "$DB_NAME" -c "\COPY weather_data(station_id,station_name,province,reading_time,temperature,humidity,wind_speed) FROM '$DATA_DIR/weather_data.csv' CSV HEADER;"

echo "✅ All data imported into '$DB_NAME'"

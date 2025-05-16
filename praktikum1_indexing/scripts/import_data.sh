#!/usr/bin/env bash
set -euo pipefail

# ── konfigurasi ────────────────────────────────────────────────────────────────
DB_NAME="tugasasis_indexing"
DB_USER="praktikan"
DB_PASS="p4ssw0rd"
CONTAINER="postgres_praktikum"
CSV_FILE="../data/messages.csv"

# ── 1) Cek & buat database jika belum ada ─────────────────────────────────────
echo "Checking for database '$DB_NAME'..."
exists=$(docker exec -e PGPASSWORD="$DB_PASS" "$CONTAINER" \
  psql -w -U "$DB_USER" -d postgres -tAc \
  "SELECT 1 FROM pg_database WHERE datname = '$DB_NAME';")

if [ "$exists" != "1" ]; then
  echo "Database '$DB_NAME' not found. Creating..."
  docker exec -e PGPASSWORD="$DB_PASS" "$CONTAINER" \
    psql -w -U "$DB_USER" -d postgres -c \
    "CREATE DATABASE \"$DB_NAME\";"
else
  echo "Database '$DB_NAME' already exists."
fi

# ── 2) Buat tabel messages jika belum ada ────────────────────────────────────
echo "Ensuring table 'messages' exists..."
docker exec -e PGPASSWORD="$DB_PASS" "$CONTAINER" \
  psql -w -U "$DB_USER" -d "$DB_NAME" -c \
"CREATE TABLE IF NOT EXISTS messages (
  msg_id       SERIAL PRIMARY KEY,
  sender_id    INTEGER,
  recipient_id INTEGER,
  sent_at      TIMESTAMP,
  is_read      BOOLEAN DEFAULT FALSE,
  content      TEXT
);"

# ── 3) Salin & import CSV ─────────────────────────────────────────────────────
echo "Copying '$CSV_FILE' into container..."
docker exec "$CONTAINER" mkdir -p /data
docker cp "$CSV_FILE" "$CONTAINER":/data/"$CSV_FILE"

echo "Importing messages from CSV..."
docker exec -e PGPASSWORD="$DB_PASS" "$CONTAINER" \
  psql -w -U "$DB_USER" -d "$DB_NAME" \
  -c "\COPY messages(msg_id, sender_id, recipient_id, sent_at, is_read, content) FROM '/data/messages.csv' CSV HEADER;"

# ── 4) ANALYZE ────────────────────────────────────────────────────────────────
echo "Running ANALYZE..."
docker exec -e PGPASSWORD="$DB_PASS" "$CONTAINER" \
  psql -w -U "$DB_USER" -d "$DB_NAME" -c "ANALYZE;"

echo "✅ Done: database, table, import, and ANALYZE completed."

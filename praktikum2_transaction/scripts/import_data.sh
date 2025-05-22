#!/usr/bin/env bash
set -euo pipefail

# Konfigurasi
DB_NAME="library"
DB_USER="praktikan"
DB_PASS="p4ssw0rd"
CONTAINER="postgres_praktikum"
DATA_DIR="/data"

# Salin CSV ke container
for file in books.csv members.csv borrowings.csv; do
  docker cp "../data/$file" "$CONTAINER":"$DATA_DIR/$file"
done

# Cek dan buat database
exists=$(docker exec -e PGPASSWORD="$DB_PASS" "$CONTAINER" \
  psql -U "$DB_USER" -d postgres -tAc "SELECT 1 FROM pg_database WHERE datname = '$DB_NAME';")

if [ "$exists" != "1" ]; then
  echo "Creating database '$DB_NAME'..."
  docker exec -e PGPASSWORD="$DB_PASS" "$CONTAINER" \
    psql -U "$DB_USER" -d postgres -c "CREATE DATABASE \"$DB_NAME\";"
fi

# Buat tabel dan import data
for table_sql in "
CREATE TABLE IF NOT EXISTS books (
  book_id SERIAL PRIMARY KEY,
  title TEXT,
  author TEXT,
  stock INTEGER
);" "
CREATE TABLE IF NOT EXISTS members (
  member_id SERIAL PRIMARY KEY,
  name TEXT,
  joined_date DATE
);" "
CREATE TABLE IF NOT EXISTS borrowings (
  borrowing_id SERIAL PRIMARY KEY,
  member_id INTEGER REFERENCES members(member_id),
  book_id INTEGER REFERENCES books(book_id),
  borrow_date DATE
);"
do
  docker exec -e PGPASSWORD="$DB_PASS" "$CONTAINER" \
    psql -U "$DB_USER" -d "$DB_NAME" -c "$table_sql"
done

# Import CSV
echo "Importing CSV files..."
docker exec -e PGPASSWORD="$DB_PASS" "$CONTAINER" \
  psql -U "$DB_USER" -d "$DB_NAME" -c "\COPY books(book_id,title,author,stock) FROM '$DATA_DIR/books.csv' CSV HEADER;"
docker exec -e PGPASSWORD="$DB_PASS" "$CONTAINER" \
  psql -U "$DB_USER" -d "$DB_NAME" -c "\COPY members(member_id,name,joined_date) FROM '$DATA_DIR/members.csv' CSV HEADER;"
docker exec -e PGPASSWORD="$DB_PASS" "$CONTAINER" \
  psql -U "$DB_USER" -d "$DB_NAME" -c "\COPY borrowings(borrowing_id,member_id,book_id,borrow_date) FROM '$DATA_DIR/borrowings.csv' CSV HEADER;"

echo "✅ All data imported into '$DB_NAME'"
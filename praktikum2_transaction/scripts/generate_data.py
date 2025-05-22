#!/usr/bin/env python3
import os
import random
import datetime
from faker import Faker

random.seed(42)
fake = Faker()
Faker.seed(42)

OUTPUT_DIR = "../data"
os.makedirs(OUTPUT_DIR, exist_ok=True)

NUM_BOOKS = 100
NUM_MEMBERS = 50
NUM_BORROWINGS = 200

# ── Generate books.csv ─────────────────────────────────────────────
books_path = os.path.join(OUTPUT_DIR, "books.csv")
with open(books_path, "w", encoding="utf-8") as f:
    f.write("book_id,title,author,stock\n")
    for i in range(1, NUM_BOOKS + 1):
        title = fake.sentence(nb_words=3).replace(",", "")
        author = fake.name()
        stock = random.randint(1, 10)
        f.write(f"{i},{title},{author},{stock}\n")
print(f"✅ Generated {books_path}")

# ── Generate members.csv ────────────────────────────────────────────
members_path = os.path.join(OUTPUT_DIR, "members.csv")
with open(members_path, "w", encoding="utf-8") as f:
    f.write("member_id,name,joined_date\n")
    for i in range(1, NUM_MEMBERS + 1):
        name = fake.name()
        joined = fake.date_between(start_date='-3y', end_date='today')
        f.write(f"{i},{name},{joined}\n")
print(f"✅ Generated {members_path}")

# ── Generate borrowings.csv ─────────────────────────────────────────
borrowings_path = os.path.join(OUTPUT_DIR, "borrowings.csv")
with open(borrowings_path, "w", encoding="utf-8") as f:
    f.write("borrowing_id,member_id,book_id,borrow_date\n")
    for i in range(1, NUM_BORROWINGS + 1):
        member_id = random.randint(1, NUM_MEMBERS)
        book_id = random.randint(1, NUM_BOOKS)
        borrow_date = fake.date_between(start_date='-1y', end_date='today')
        f.write(f"{i},{member_id},{book_id},{borrow_date}\n")
print(f"✅ Generated {borrowings_path}")
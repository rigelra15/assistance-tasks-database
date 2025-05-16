#!/usr/bin/env python3
import random
import os
import datetime
from faker import Faker

# ── konfigurasi dasar ─────────────────────────────────────────────────────────
random.seed(42)
fake = Faker('en_US')
fake.seed_instance(42)

NUM_EMP    = 200
NUM_MSG    = 1000
OUTPUT_DIR = "../data"

os.makedirs(OUTPUT_DIR, exist_ok=True)

# ── generate employees.csv ────────────────────────────────────────────────────
emp_path = os.path.join(OUTPUT_DIR, "employees.csv")
with open(emp_path, "w", encoding="utf-8") as f:
    f.write("emp_id,department,salary,hire_date,performance\n")
    depts = ["Finance","HR","IT","Marketing","Sales","Support","R&D"]
    for i in range(1, NUM_EMP+1):
        dept        = random.choice(depts)
        salary      = random.randint(5_000_000, 15_000_000)
        hire_date   = fake.date_between(start_date='-5y', end_date='today')
        performance = random.randint(1,5)
        f.write(f"{i},{dept},{salary},{hire_date},{performance}\n")
print(f"-> Generated {emp_path}")

# ── generate messages.csv ─────────────────────────────────────────────────────
msg_path = os.path.join(OUTPUT_DIR, "messages.csv")
with open(msg_path, "w", encoding="utf-8") as f:
    f.write("msg_id,sender_id,recipient_id,sent_at,is_read,content\n")
    for i in range(1, NUM_MSG+1):
        sender    = random.randint(1, NUM_EMP)
        recipient = random.randint(1, NUM_EMP)
        while recipient == sender:
            recipient = random.randint(1, NUM_EMP)
        sentence  = fake.sentence(nb_words=10)
        sent_at   = fake.date_time_between(start_date='-1y', end_date='now')
        ts        = sent_at.strftime("%Y-%m-%d %H:%M:%S")
        is_read   = random.choice([True, False])
        content   = sentence.replace("\n", " ").replace(",", " ")
        f.write(f"{i},{sender},{recipient},{ts},{is_read},{content}\n")
print(f"-> Generated {msg_path}")

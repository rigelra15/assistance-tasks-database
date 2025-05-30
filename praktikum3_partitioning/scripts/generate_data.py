#!/usr/bin/env python3
import os
import random
from faker import Faker
from datetime import datetime, timedelta

random.seed(42)
fake = Faker()
Faker.seed(42)

OUTPUT_DIR = "../data"
os.makedirs(OUTPUT_DIR, exist_ok=True)

NUM_ROWS = 10000
provinces = [
    "Jawa Timur", "Jawa Tengah", "DKI Jakarta", "Sumatera Utara",
    "Riau", "Kalimantan Timur", "Kalimantan Barat", "Sulawesi Selatan"
]

filename = os.path.join(OUTPUT_DIR, "weather_data.csv")
with open(filename, "w", encoding="utf-8") as f:
    f.write("station_id,station_name,province,reading_time,temperature,humidity,wind_speed\n")
    for i in range(1, NUM_ROWS + 1):
        station_name = f"Stasiun {fake.city()}"
        province = random.choice(provinces)
        reading_time = fake.date_time_between(start_date="-1y", end_date="now").strftime("%Y-%m-%d %H:%M:%S")
        temperature = round(random.uniform(20, 38), 2)
        humidity = round(random.uniform(40, 95), 2)
        wind_speed = round(random.uniform(0, 20), 2)
        f.write(f"{i},{station_name},{province},{reading_time},{temperature},{humidity},{wind_speed}\n")

print(f"✅ Generated {filename}")

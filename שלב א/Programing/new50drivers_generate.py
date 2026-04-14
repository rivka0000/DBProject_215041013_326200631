import random
import re
import os

# =========================
# בסיס נתיבים
# =========================

BASE_DIR = os.path.dirname(os.path.dirname(__file__))

def path(*args):
    return os.path.join(BASE_DIR, *args)

# =========================
# טעינת נהגים מכל המקורות
# =========================

def load_all_drivers():

    drivers = set()

    # -------- SEED --------
    with open(path("init-db", "02-seed-data.sql"), encoding="utf-8") as f:
        for line in f:
            if "INSERT INTO DRIVER" in line:
                m = re.search(r"\(\s*'[^']*'\s*,\s*'[^']*'\s*,\s*(\d+)\s*,", line)
                if m:
                    drivers.add(int(m.group(1)))

    # -------- MOCKAROO --------
    with open(path("mockarooFiles", "DRIVER.sql"), encoding="utf-8") as f:
        for line in f:
            m = re.search(r",\s*(\d+)\s*,", line)
            if m:
                drivers.add(int(m.group(1)))

    return drivers

# =========================
# יצירת נהגים
# =========================

def generate_drivers(n, existing_drivers):

    start_id = max(existing_drivers) + 1 if existing_drivers else 1

    statuses = ["Active", "Inactive", "Busy"]

    first_names = ["Noa","Dana","Rivka","Yael","Maya","Sara","Leah","Tamar"]
    last_names = ["Cohen","Levi","Mizrahi","Peretz","Azrad","Biton","Malka","Avraham"]

    with open(path("Programing", "insert_drivers_50.sql"), "w", encoding="utf-8") as f:

        for i in range(n):

            license_number = start_id + i

            phone = f"05{random.randint(10000000,99999999)}"
            status = random.choice(statuses)
            name = random.choice(first_names) + " " + random.choice(last_names)

            sql = f"""INSERT INTO DRIVER
(phoneNumber, status, licenseNumber, fullName)
VALUES ('{phone}', '{status}', {license_number}, '{name}');
"""
            f.write(sql)

    print("✔ drivers created")

# =========================
# MAIN
# =========================

if __name__ == "__main__":

    drivers = load_all_drivers()

    print("Total existing drivers:", len(drivers))

    generate_drivers(50, drivers)

    print("🎉 DONE")
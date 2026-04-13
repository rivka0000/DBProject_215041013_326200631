import random
import re
import csv
import os
from datetime import datetime, timedelta

# =========================
# בסיס נתיבים (חשוב!)
# =========================

BASE_DIR = os.path.dirname(os.path.dirname(__file__))

def path(*args):
    return os.path.join(BASE_DIR, *args)

# =========================
# כלי עזר
# =========================

def get_random_date():
    start = datetime(2024,1,1)
    end = datetime(2026,12,31)
    return (start + timedelta(days=random.randint(0,(end-start).days))).strftime('%Y-%m-%d')

def get_random_time():
    return f"{random.randint(0,23):02}:{random.randint(0,59):02}:00"

# =========================
# קריאת נתונים מה-SEED
# =========================

def load_seed_data():

    drivers = set()
    customers = set()
    ride_ids = set()
    maintenance_keys = set()
    routes = set()
    plates = set()

    with open(path("init-db","02-seed-data.sql"), encoding="utf-8") as f:
        for line in f:

            # DRIVER
            m = re.search(r"\(\s*'[^']*'\s*,\s*'[^']*'\s*,\s*(\d+)\s*,", line)
            if m:
                drivers.add(int(m.group(1)))

            # CUSTOMER
            m = re.search(r"\(\s*(\d+)\s*,", line)
            if m:
                customers.add(int(m.group(1)))

            # RIDE ID
            m = re.search(r"INSERT INTO RIDE.*VALUES\s*\((\d+),", line)
            if m:
                ride_ids.add(int(m.group(1)))

            # MAINTENANCE (date + plate)
            m = re.search(r"\('(\d{4}-\d{2}-\d{2})'.*'(\d{2}-\d{3}-\d{2})'\)", line)
            if m:
                maintenance_keys.add((m.group(1), m.group(2)))

            # ROUTE
            m = re.search(r"\('([^']+)',\s*'([^']+)',", line)
            if m:
                routes.add((m.group(1), m.group(2)))

            # VEHICLE
            m = re.search(r"'(\d{2}-\d{3}-\d{2})'", line)
            if m:
                plates.add(m.group(1))

    return drivers, customers, ride_ids, maintenance_keys, routes, plates

# =========================
# CSV
# =========================

def load_csv_data(routes, plates):

    with open(path("DataImportFiles","VEHICLE.csv"), encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            plates.add(row["plateNumber"])

    with open(path("DataImportFiles","ROUTE.csv"), encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            routes.add((row["origin"], row["destination"]))

    return routes, plates

# =========================
# MOCKAROO
# =========================

def load_mockaroo(drivers, customers):

    with open(path("mockarooFiles","DRIVER.sql"), encoding='utf-8') as f:
        for line in f:
            m = re.search(r",\s*(\d+)\s*,", line)
            if m:
                drivers.add(int(m.group(1)))

    with open(path("mockarooFiles","CUSTOMER.sql"), encoding='utf-8') as f:
        for line in f:
            m = re.search(r"\(\s*(\d+)\s*,", line)
            if m:
                customers.add(int(m.group(1)))

    return drivers, customers

# =========================
# RIDE
# =========================

def generate_rides(n, drivers, customers, plates, routes, existing_ids):

    start_id = max(existing_ids) + 1 if existing_ids else 1

    statuses = ["Completed","Cancelled","Pending"]
    payments = ["Credit Card","Cash","Bit","Apple Pay"]

    with open(path("Programing","insert_rides_20k.sql"),"w",encoding="utf-8") as f:

        for i in range(n):

            ride_id = start_id + i
            status = random.choice(statuses)

            end_time = f"'{get_random_time()}'" if status == "Completed" else "NULL"

            origin, dest = random.choice(list(routes))

            sql = f"""INSERT INTO RIDE
(rideId, orderDate, startTime, status, endTime, paymentMethod, licenseNumber, plateNumber, id, origin, destination)
VALUES ({ride_id}, '{get_random_date()}', '{get_random_time()}', '{status}', {end_time},
'{random.choice(payments)}', {random.choice(list(drivers))}, '{random.choice(list(plates))}',
{random.choice(list(customers))}, '{origin}', '{dest}');
"""
            f.write(sql)

    print("✔ rides done")

# =========================
# MAINTENANCE
# =========================

def generate_maintenance(n, plates, existing_keys):

    types = ["Oil Change","Engine","Battery","Brakes","Inspection"]

    used = set(existing_keys)

    with open(path("Programing","insert_maintenance_20k.sql"),"w",encoding="utf-8") as f:

        count = 0
        while count < n:

            plate = random.choice(list(plates))
            date = get_random_date()

            if (date, plate) in used:
                continue

            used.add((date, plate))

            sql = f"""INSERT INTO MAINTENANCE
(maintenanceDate, MaintenanceType, Cost, Description, plateNumber)
VALUES ('{date}', '{random.choice(types)}', {random.randint(100,5000)}, 'Routine', '{plate}');
"""
            f.write(sql)

            count += 1

    print("✔ maintenance done")

# =========================
# MAIN
# =========================

if __name__ == "__main__":

    drivers, customers, ride_ids, maintenance_keys, routes, plates = load_seed_data()

    routes, plates = load_csv_data(routes, plates)
    drivers, customers = load_mockaroo(drivers, customers)

    print("Drivers:", len(drivers))
    print("Customers:", len(customers))
    print("Vehicles:", len(plates))
    print("Routes:", len(routes))

    generate_rides(20000, drivers, customers, plates, routes, ride_ids)
    generate_maintenance(20000, plates, maintenance_keys)

    print("🎉 PERFECT - ALL DATA CREATED")
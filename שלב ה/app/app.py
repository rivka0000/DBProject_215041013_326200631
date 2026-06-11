import os
import psycopg2
import psycopg2.extras
from flask import Flask, jsonify, request, render_template
from dotenv import load_dotenv

load_dotenv(dotenv_path=os.path.join(os.path.dirname(__file__), '..', '..', '.env'), override=True)

app = Flask(__name__)

db_name = os.getenv('DB_NAME_SECRET', 'restore_final_db')
if db_name == 'Transroute':
    db_name = 'restore_final_db'

DB_CONFIG = {
    'host': 'localhost',
    'port': 5432,
    'dbname': db_name,
    'user': os.getenv('DB_USER_SECRET', 'tirtsa'),
    'password': os.getenv('DB_PASSWORD_SECRET', 'tirtsa'),
}
print("=== DB_CONFIG ACTIVE VALUE ===", DB_CONFIG)

import datetime
import decimal

def serialize_value(val):
    if isinstance(val, (datetime.date, datetime.time, datetime.datetime)):
        return val.isoformat()
    if isinstance(val, decimal.Decimal):
        return float(val)
    return val

def get_conn():
    return psycopg2.connect(**DB_CONFIG)

def query(sql, params=None, fetch=True):
    conn = get_conn()
    try:
        cur = conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
        cur.execute(sql, params)
        if fetch:
            rows = cur.fetchall()
            conn.commit()
            serialized_rows = []
            for r in rows:
                row_dict = dict(r)
                for k, v in row_dict.items():
                    row_dict[k] = serialize_value(v)
                serialized_rows.append(row_dict)
            return serialized_rows
        else:
            conn.commit()
            return cur.rowcount
    finally:
        conn.close()

@app.route('/')
def index():
    return render_template('index.html')

# ── DASHBOARD ──────────────────────────────────────────────────────────────────
@app.route('/api/stats')
def stats():
    tables = ['driver','customer','vehicle','route','ride','maintenance','tour','tourinstance','bookings','guide','station','tourstation']
    result = {}
    for t in tables:
        try:
            r = query(f'SELECT COUNT(*) AS c FROM {t}')
            result[t] = r[0]['c']
        except:
            result[t] = 0
    return jsonify(result)

# ── DRIVER ─────────────────────────────────────────────────────────────────────
@app.route('/api/driver', methods=['GET'])
def get_drivers():
    return jsonify(query('SELECT licensenumber, fullname, phonenumber, status FROM driver ORDER BY fullname'))

@app.route('/api/driver/<int:lic>', methods=['GET'])
def get_driver(lic):
    r = query('SELECT * FROM driver WHERE licensenumber=%s', (lic,))
    return jsonify(r[0] if r else {})

@app.route('/api/driver', methods=['POST'])
def add_driver():
    d = request.json
    query('INSERT INTO driver(licensenumber,fullname,phonenumber,status) VALUES(%s,%s,%s,%s)',
          (d['licensenumber'],d['fullname'],d['phonenumber'],d['status']), fetch=False)
    return jsonify({'ok': True})

@app.route('/api/driver/<int:lic>', methods=['PUT'])
def update_driver(lic):
    d = request.json
    query('UPDATE driver SET fullname=%s, phonenumber=%s, status=%s WHERE licensenumber=%s',
          (d['fullname'],d['phonenumber'],d['status'],lic), fetch=False)
    return jsonify({'ok': True})

@app.route('/api/driver/<int:lic>', methods=['DELETE'])
def delete_driver(lic):
    query('DELETE FROM driver WHERE licensenumber=%s', (lic,), fetch=False)
    return jsonify({'ok': True})

# ── CUSTOMER ───────────────────────────────────────────────────────────────────
@app.route('/api/customer', methods=['GET'])
def get_customers():
    return jsonify(query("SELECT c_id, c_first_name||' '||c_last_name AS fullname, c_phone, c_email FROM customer ORDER BY c_first_name"))

@app.route('/api/customer/<int:cid>', methods=['GET'])
def get_customer(cid):
    r = query('SELECT * FROM customer WHERE c_id=%s', (cid,))
    return jsonify(r[0] if r else {})

@app.route('/api/customer', methods=['POST'])
def add_customer():
    d = request.json
    query('INSERT INTO customer(c_id,c_first_name,c_last_name,c_email,c_phone) VALUES(%s,%s,%s,%s,%s)',
          (d['c_id'],d['c_first_name'],d['c_last_name'],d['c_email'],d['c_phone']), fetch=False)
    return jsonify({'ok': True})

@app.route('/api/customer/<int:cid>', methods=['PUT'])
def update_customer(cid):
    d = request.json
    query('UPDATE customer SET c_first_name=%s,c_last_name=%s,c_email=%s,c_phone=%s WHERE c_id=%s',
          (d['c_first_name'],d['c_last_name'],d['c_email'],d['c_phone'],cid), fetch=False)
    return jsonify({'ok': True})

@app.route('/api/customer/<int:cid>', methods=['DELETE'])
def delete_customer(cid):
    query('DELETE FROM customer WHERE c_id=%s', (cid,), fetch=False)
    return jsonify({'ok': True})

# ── VEHICLE ────────────────────────────────────────────────────────────────────
@app.route('/api/vehicle', methods=['GET'])
def get_vehicles():
    return jsonify(query('SELECT * FROM vehicle ORDER BY model'))

@app.route('/api/vehicle/<plate>', methods=['GET'])
def get_vehicle(plate):
    r = query('SELECT * FROM vehicle WHERE platenumber=%s', (plate,))
    return jsonify(r[0] if r else {})

@app.route('/api/vehicle', methods=['POST'])
def add_vehicle():
    d = request.json
    query('INSERT INTO vehicle(platenumber,model,capacity,carcolor,year,status) VALUES(%s,%s,%s,%s,%s,%s)',
          (d['platenumber'],d['model'],d['capacity'],d['carcolor'],d['year'],d['status']), fetch=False)
    return jsonify({'ok': True})

@app.route('/api/vehicle/<plate>', methods=['PUT'])
def update_vehicle(plate):
    d = request.json
    query('UPDATE vehicle SET model=%s,capacity=%s,carcolor=%s,year=%s,status=%s WHERE platenumber=%s',
          (d['model'],d['capacity'],d['carcolor'],d['year'],d['status'],plate), fetch=False)
    return jsonify({'ok': True})

@app.route('/api/vehicle/<plate>', methods=['DELETE'])
def delete_vehicle(plate):
    query('DELETE FROM vehicle WHERE platenumber=%s', (plate,), fetch=False)
    return jsonify({'ok': True})

# ── ROUTE ──────────────────────────────────────────────────────────────────────
@app.route('/api/route', methods=['GET'])
def get_routes():
    return jsonify(query('SELECT * FROM route ORDER BY origin'))

@app.route('/api/route/<origin>/<destination>', methods=['GET'])
def get_route(origin, destination):
    r = query('SELECT * FROM route WHERE origin=%s AND destination=%s', (origin, destination))
    return jsonify(r[0] if r else {})

@app.route('/api/route', methods=['POST'])
def add_route():
    d = request.json
    query('INSERT INTO route(origin,destination,distancekm,estimatedtraveltime) VALUES(%s,%s,%s,%s)',
          (d['origin'],d['destination'],d['distancekm'],d['estimatedtraveltime']), fetch=False)
    return jsonify({'ok': True})

@app.route('/api/route/<origin>/<destination>', methods=['PUT'])
def update_route(origin, destination):
    d = request.json
    query('UPDATE route SET distancekm=%s,estimatedtraveltime=%s WHERE origin=%s AND destination=%s',
          (d['distancekm'],d['estimatedtraveltime'],origin,destination), fetch=False)
    return jsonify({'ok': True})

@app.route('/api/route/<origin>/<destination>', methods=['DELETE'])
def delete_route(origin, destination):
    query('DELETE FROM route WHERE origin=%s AND destination=%s', (origin,destination), fetch=False)
    return jsonify({'ok': True})

# ── RIDE ───────────────────────────────────────────────────────────────────────
@app.route('/api/ride', methods=['GET'])
def get_rides():
    sql = """
    SELECT r.rideid, r.status, r.origin, r.destination,
           d.fullname AS driver_name, v.model AS vehicle_model, v.platenumber,
           ti.t_date AS ride_date, t.t_name AS tour_name
    FROM ride r
    JOIN driver d ON r.licensenumber=d.licensenumber
    JOIN vehicle v ON r.platenumber=v.platenumber
    LEFT JOIN tourinstance ti ON r.t_i_id=ti.t_i_id
    LEFT JOIN tour t ON ti.t_name=t.t_name
    ORDER BY ti.t_date DESC NULLS LAST
    """
    return jsonify(query(sql))

@app.route('/api/ride/<int:rid>', methods=['GET'])
def get_ride(rid):
    r = query('SELECT * FROM ride WHERE rideid=%s', (rid,))
    return jsonify(r[0] if r else {})

@app.route('/api/ride', methods=['POST'])
def add_ride():
    d = request.json
    query('INSERT INTO ride(rideid,status,origin,destination,licensenumber,platenumber,t_i_id) VALUES(%s,%s,%s,%s,%s,%s,%s)',
          (d['rideid'],d['status'],d['origin'],d['destination'],d['licensenumber'],d['platenumber'],d.get('t_i_id')), fetch=False)
    return jsonify({'ok': True})

@app.route('/api/ride/<int:rid>', methods=['PUT'])
def update_ride(rid):
    d = request.json
    query('UPDATE ride SET status=%s,origin=%s,destination=%s,licensenumber=%s,platenumber=%s,t_i_id=%s WHERE rideid=%s',
          (d['status'],d['origin'],d['destination'],d['licensenumber'],d['platenumber'],d.get('t_i_id'),rid), fetch=False)
    return jsonify({'ok': True})

@app.route('/api/ride/<int:rid>', methods=['DELETE'])
def delete_ride(rid):
    query('DELETE FROM ride WHERE rideid=%s', (rid,), fetch=False)
    return jsonify({'ok': True})

# ── MAINTENANCE ────────────────────────────────────────────────────────────────
@app.route('/api/maintenance', methods=['GET'])
def get_maintenance():
    sql = """
    SELECT m.maintenancedate, m.maintenancetype, m.cost, m.description,
           m.platenumber, v.model AS vehicle_model
    FROM maintenance m JOIN vehicle v ON m.platenumber=v.platenumber
    ORDER BY m.maintenancedate DESC
    """
    return jsonify(query(sql))

@app.route('/api/maintenance', methods=['POST'])
def add_maintenance():
    d = request.json
    query('INSERT INTO maintenance(maintenancedate,maintenancetype,cost,description,platenumber) VALUES(%s,%s,%s,%s,%s)',
          (d['maintenancedate'],d['maintenancetype'],d['cost'],d['description'],d['platenumber']), fetch=False)
    return jsonify({'ok': True})

@app.route('/api/maintenance/<date>/<plate>', methods=['PUT'])
def update_maintenance(date, plate):
    d = request.json
    query('UPDATE maintenance SET maintenancetype=%s,cost=%s,description=%s WHERE maintenancedate=%s AND platenumber=%s',
          (d['maintenancetype'],d['cost'],d['description'],date,plate), fetch=False)
    return jsonify({'ok': True})

@app.route('/api/maintenance/<date>/<plate>', methods=['DELETE'])
def delete_maintenance(date, plate):
    query('DELETE FROM maintenance WHERE maintenancedate=%s AND platenumber=%s', (date,plate), fetch=False)
    return jsonify({'ok': True})

# ── TOUR ───────────────────────────────────────────────────────────────────────
@app.route('/api/tour', methods=['GET'])
def get_tours():
    return jsonify(query('SELECT * FROM tour ORDER BY t_name'))

@app.route('/api/tour/<name>', methods=['GET'])
def get_tour(name):
    r = query('SELECT * FROM tour WHERE t_name=%s', (name,))
    return jsonify(r[0] if r else {})

@app.route('/api/tour', methods=['POST'])
def add_tour():
    d = request.json
    query('INSERT INTO tour(t_name,max_participants,price,t_type,area,accessibility,t_level,t_duration) VALUES(%s,%s,%s,%s,%s,%s,%s,%s)',
          (d['t_name'],d['max_participants'],d['price'],d['t_type'],d['area'],d.get('accessibility',1),d.get('t_level',1),d.get('t_duration',60)), fetch=False)
    return jsonify({'ok': True})

@app.route('/api/tour/<name>', methods=['PUT'])
def update_tour(name):
    d = request.json
    query('UPDATE tour SET max_participants=%s,price=%s,t_type=%s,area=%s WHERE t_name=%s',
          (d['max_participants'],d['price'],d['t_type'],d['area'],name), fetch=False)
    return jsonify({'ok': True})

@app.route('/api/tour/<name>', methods=['DELETE'])
def delete_tour(name):
    query('DELETE FROM tour WHERE t_name=%s', (name,), fetch=False)
    return jsonify({'ok': True})

# ── TOURINSTANCE ───────────────────────────────────────────────────────────────
@app.route('/api/tourinstance', methods=['GET'])
def get_tourinstances():
    sql = """
    SELECT ti.t_i_id, ti.t_date, ti.start_time, ti.end_time,
           ti.t_name AS tour_name,
           g.g_first_name||' '||g.g_last_name AS guide_name
    FROM tourinstance ti
    LEFT JOIN guide g ON ti.g_id=g.g_id
    ORDER BY ti.t_date DESC
    """
    return jsonify(query(sql))

@app.route('/api/tourinstance/<int:tiid>', methods=['GET'])
def get_tourinstance(tiid):
    r = query('SELECT * FROM tourinstance WHERE t_i_id=%s', (tiid,))
    return jsonify(r[0] if r else {})

@app.route('/api/tourinstance', methods=['POST'])
def add_tourinstance():
    d = request.json
    query('INSERT INTO tourinstance(t_i_id,t_date,start_time,end_time,g_id,t_name) VALUES(%s,%s,%s,%s,%s,%s)',
          (d['t_i_id'],d['t_date'],d['start_time'],d.get('end_time'),d['g_id'],d['t_name']), fetch=False)
    return jsonify({'ok': True})

@app.route('/api/tourinstance/<int:tiid>', methods=['PUT'])
def update_tourinstance(tiid):
    d = request.json
    query('UPDATE tourinstance SET t_date=%s,start_time=%s,end_time=%s,g_id=%s,t_name=%s WHERE t_i_id=%s',
          (d['t_date'],d['start_time'],d.get('end_time'),d['g_id'],d['t_name'],tiid), fetch=False)
    return jsonify({'ok': True})

@app.route('/api/tourinstance/<int:tiid>', methods=['DELETE'])
def delete_tourinstance(tiid):
    query('DELETE FROM tourinstance WHERE t_i_id=%s', (tiid,), fetch=False)
    return jsonify({'ok': True})

# ── BOOKINGS ───────────────────────────────────────────────────────────────────
@app.route('/api/bookings', methods=['GET'])
def get_bookings():
    sql = """
    SELECT b.b_id, b.b_date, b.b_status, b.amount_pepole, b.total_price,
           c.c_first_name||' '||c.c_last_name AS customer_name,
           t.t_name AS tour_name, ti.t_date AS tour_date
    FROM bookings b
    JOIN customer c ON b.c_id=c.c_id
    JOIN tourinstance ti ON b.t_i_id=ti.t_i_id
    JOIN tour t ON ti.t_name=t.t_name
    ORDER BY b.b_date DESC
    """
    return jsonify(query(sql))

@app.route('/api/bookings/<int:bid>', methods=['GET'])
def get_booking(bid):
    r = query('SELECT * FROM bookings WHERE b_id=%s', (bid,))
    return jsonify(r[0] if r else {})

@app.route('/api/bookings', methods=['POST'])
def add_booking():
    d = request.json
    query('INSERT INTO bookings(b_id,amount_pepole,b_date,b_status,t_i_id,c_id,total_price) VALUES(%s,%s,%s,%s,%s,%s,%s)',
          (d['b_id'],d['amount_pepole'],d['b_date'],d['b_status'],d['t_i_id'],d['c_id'],d['total_price']), fetch=False)
    return jsonify({'ok': True})

@app.route('/api/bookings/<int:bid>', methods=['PUT'])
def update_booking(bid):
    d = request.json
    query('UPDATE bookings SET amount_pepole=%s,b_status=%s,total_price=%s WHERE b_id=%s',
          (d['amount_pepole'],d['b_status'],d['total_price'],bid), fetch=False)
    return jsonify({'ok': True})

@app.route('/api/bookings/<int:bid>', methods=['DELETE'])
def delete_booking(bid):
    query('DELETE FROM bookings WHERE b_id=%s', (bid,), fetch=False)
    return jsonify({'ok': True})

# ── GUIDE ──────────────────────────────────────────────────────────────────────
@app.route('/api/guide', methods=['GET'])
def get_guides():
    return jsonify(query("SELECT g_id, g_first_name||' '||g_last_name AS fullname, g_phone, g_email, school FROM guide ORDER BY g_first_name"))

@app.route('/api/guide/<int:gid>', methods=['GET'])
def get_guide(gid):
    r = query('SELECT * FROM guide WHERE g_id=%s', (gid,))
    return jsonify(r[0] if r else {})

@app.route('/api/guide', methods=['POST'])
def add_guide():
    d = request.json
    query('INSERT INTO guide(g_id,g_first_name,g_last_name,g_phone,g_email,school) VALUES(%s,%s,%s,%s,%s,%s)',
          (d['g_id'],d['g_first_name'],d['g_last_name'],d['g_phone'],d['g_email'],d.get('school','')), fetch=False)
    return jsonify({'ok': True})

@app.route('/api/guide/<int:gid>', methods=['PUT'])
def update_guide(gid):
    d = request.json
    query('UPDATE guide SET g_first_name=%s,g_last_name=%s,g_phone=%s,g_email=%s,school=%s WHERE g_id=%s',
          (d['g_first_name'],d['g_last_name'],d['g_phone'],d['g_email'],d.get('school',''),gid), fetch=False)
    return jsonify({'ok': True})

@app.route('/api/guide/<int:gid>', methods=['DELETE'])
def delete_guide(gid):
    query('DELETE FROM guide WHERE g_id=%s', (gid,), fetch=False)
    return jsonify({'ok': True})

# ── STATION ────────────────────────────────────────────────────────────────────
@app.route('/api/station', methods=['GET'])
def get_stations():
    return jsonify(query('SELECT * FROM station ORDER BY s_name'))

@app.route('/api/station/<name>', methods=['GET'])
def get_station(name):
    r = query('SELECT * FROM station WHERE s_name=%s', (name,))
    return jsonify(r[0] if r else {})

@app.route('/api/station', methods=['POST'])
def add_station():
    d = request.json
    query('INSERT INTO station(s_name,s_address,descrip) VALUES(%s,%s,%s)',
          (d['s_name'],d['s_address'],d.get('descrip','')), fetch=False)
    return jsonify({'ok': True})

@app.route('/api/station/<name>', methods=['PUT'])
def update_station(name):
    d = request.json
    query('UPDATE station SET s_address=%s,descrip=%s WHERE s_name=%s',
          (d['s_address'],d.get('descrip',''),name), fetch=False)
    return jsonify({'ok': True})

@app.route('/api/station/<name>', methods=['DELETE'])
def delete_station(name):
    query('DELETE FROM station WHERE s_name=%s', (name,), fetch=False)
    return jsonify({'ok': True})

# ── TOURSTATION ────────────────────────────────────────────────────────────────
@app.route('/api/tourstation', methods=['GET'])
def get_tourstations():
    sql = """
    SELECT ts.t_index, ts.s_during, ts.t_name, ts.s_name, s.s_address
    FROM tourstation ts JOIN station s ON ts.s_name=s.s_name
    ORDER BY ts.t_name, ts.t_index
    """
    return jsonify(query(sql))

@app.route('/api/tourstation/<int:t_index>/<t_name>/<s_name>', methods=['GET'])
def get_tourstation(t_index, t_name, s_name):
    r = query('SELECT * FROM tourstation WHERE t_index=%s AND t_name=%s AND s_name=%s',
              (t_index, t_name, s_name))
    return jsonify(r[0] if r else {})

@app.route('/api/tourstation', methods=['POST'])
def add_tourstation():
    d = request.json
    query('INSERT INTO tourstation(t_index,s_during,t_name,s_name) VALUES(%s,%s,%s,%s)',
          (d['t_index'], d['s_during'], d['t_name'], d['s_name']), fetch=False)
    return jsonify({'ok': True})

@app.route('/api/tourstation/<int:t_index>/<t_name>/<s_name>', methods=['PUT'])
def update_tourstation(t_index, t_name, s_name):
    d = request.json
    query('UPDATE tourstation SET s_during=%s WHERE t_index=%s AND t_name=%s AND s_name=%s',
          (d['s_during'], t_index, t_name, s_name), fetch=False)
    return jsonify({'ok': True})

@app.route('/api/tourstation/<int:t_index>/<t_name>/<s_name>', methods=['DELETE'])
def delete_tourstation(t_index, t_name, s_name):
    query('DELETE FROM tourstation WHERE t_index=%s AND t_name=%s AND s_name=%s',
          (t_index, t_name, s_name), fetch=False)
    return jsonify({'ok': True})

# ── STAGE B QUERIES ────────────────────────────────────────────────────────────
@app.route('/api/query/top_drivers')
def query_top_drivers():
    year = request.args.get('year', 2025)
    sql = """
    SELECT d.licensenumber, d.fullname, d.status,
           COUNT(r.rideid) AS total_rides,
           EXTRACT(YEAR FROM ti.t_date) AS ride_year
    FROM driver d
    JOIN ride r ON r.licensenumber=d.licensenumber
    JOIN tourinstance ti ON r.t_i_id=ti.t_i_id
    WHERE EXTRACT(YEAR FROM ti.t_date)=%s
    GROUP BY d.licensenumber,d.fullname,d.status,EXTRACT(YEAR FROM ti.t_date)
    ORDER BY total_rides DESC
    """
    return jsonify(query(sql, (year,)))

@app.route('/api/query/top_customers')
def query_top_customers():
    year = request.args.get('year', 2025)
    month = request.args.get('month', 6)
    sql = """
    SELECT c.c_id, c.c_first_name||' '||c.c_last_name AS full_name, c.c_phone,
           COUNT(r.rideid) AS total_rides,
           EXTRACT(YEAR FROM ti.t_date) AS ride_year,
           EXTRACT(MONTH FROM ti.t_date) AS ride_month
    FROM customer c
    JOIN bookings b ON b.c_id=c.c_id
    JOIN ride r ON r.t_i_id=b.t_i_id
    JOIN tourinstance ti ON ti.t_i_id=r.t_i_id
    WHERE EXTRACT(YEAR FROM ti.t_date)=%s AND EXTRACT(MONTH FROM ti.t_date)=%s
    GROUP BY c.c_id,c.c_first_name,c.c_last_name,c.c_phone,
             EXTRACT(YEAR FROM ti.t_date),EXTRACT(MONTH FROM ti.t_date)
    ORDER BY total_rides DESC
    """
    return jsonify(query(sql, (year, month)))

@app.route('/api/query/unused_vehicles')
def query_unused_vehicles():
    year = request.args.get('year', 2025)
    sql = """
    SELECT v.platenumber,v.model,v.capacity,v.carcolor,v.year,v.status
    FROM vehicle v
    WHERE NOT EXISTS (
        SELECT 1 FROM ride r JOIN tourinstance ti ON r.t_i_id=ti.t_i_id
        WHERE r.platenumber=v.platenumber AND EXTRACT(YEAR FROM ti.t_date)=%s
    )
    ORDER BY v.model
    """
    return jsonify(query(sql, (year,)))

@app.route('/api/query/popular_routes')
def query_popular_routes():
    year = request.args.get('year', 2025)
    sql = """
    SELECT rt.origin, rt.destination, rt.distancekm, rt.estimatedtraveltime,
           COUNT(r.rideid) AS total_rides, EXTRACT(YEAR FROM ti.t_date) AS ride_year
    FROM route rt
    JOIN ride r ON rt.origin=r.origin AND rt.destination=r.destination
    JOIN tourinstance ti ON r.t_i_id=ti.t_i_id
    WHERE EXTRACT(YEAR FROM ti.t_date)=%s
    GROUP BY rt.origin,rt.destination,rt.distancekm,rt.estimatedtraveltime,EXTRACT(YEAR FROM ti.t_date)
    ORDER BY total_rides DESC
    """
    return jsonify(query(sql, (year,)))

# ── STAGE D FUNCTIONS & PROCEDURES ────────────────────────────────────────────
@app.route('/api/proc/transport_tours_report')
def run_transport_tours_report():
    min_price = request.args.get('min_price', 0)
    conn = get_conn()
    try:
        conn.autocommit = False
        cur = conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
        cur.execute('BEGIN')
        cur.execute('SELECT get_transport_tours_report(%s)', (min_price,))
        cursor_name = list(cur.fetchone().values())[0]
        cur.execute(f'FETCH ALL FROM "{cursor_name}"')
        rows = [{k: serialize_value(v) for k, v in dict(r).items()} for r in cur.fetchall()]
        conn.commit()
        return jsonify(rows)
    except Exception as e:
        conn.rollback()
        return jsonify({'error': str(e)}), 500
    finally:
        conn.close()

@app.route('/api/proc/update_pending_rides', methods=['POST'])
def run_update_pending_rides():
    max_updates = request.json.get('max_updates', 5)
    conn = get_conn()
    try:
        cur = conn.cursor()
        cur.execute('CALL update_pending_transport_rides(%s)', (max_updates,))
        conn.commit()
        return jsonify({'ok': True, 'message': f'Updated up to {max_updates} pending rides to Completed'})
    except Exception as e:
        conn.rollback()
        return jsonify({'error': str(e)}), 500
    finally:
        conn.close()

@app.route('/api/proc/customer_bookings_report')
def run_customer_bookings_report():
    min_price = request.args.get('min_price', 0)
    conn = get_conn()
    try:
        conn.autocommit = False
        cur = conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
        cur.execute('BEGIN')
        cur.execute('SELECT get_customer_bookings_report(%s)', (min_price,))
        cursor_name = list(cur.fetchone().values())[0]
        cur.execute(f'FETCH ALL FROM "{cursor_name}"')
        rows = [{k: serialize_value(v) for k, v in dict(r).items()} for r in cur.fetchall()]
        conn.commit()
        return jsonify(rows)
    except Exception as e:
        conn.rollback()
        return jsonify({'error': str(e)}), 500
    finally:
        conn.close()

@app.route('/api/proc/clean_bookings', methods=['POST'])
def run_clean_bookings():
    d = request.json
    conn = get_conn()
    try:
        cur = conn.cursor()
        cur.execute('CALL clean_old_unapproved_bookings(%s, %s)', (d['before_date'], d.get('max_updates', 10)))
        conn.commit()
        return jsonify({'ok': True, 'message': 'Cleaned old unapproved bookings'})
    except Exception as e:
        conn.rollback()
        return jsonify({'error': str(e)}), 500
    finally:
        conn.close()

# ── LOOKUP HELPERS ─────────────────────────────────────────────────────────────
@app.route('/api/lookup/drivers')
def lookup_drivers():
    return jsonify(query('SELECT licensenumber, fullname FROM driver ORDER BY fullname'))

@app.route('/api/lookup/vehicles')
def lookup_vehicles():
    return jsonify(query('SELECT platenumber, model FROM vehicle ORDER BY model'))

@app.route('/api/lookup/routes')
def lookup_routes():
    return jsonify(query('SELECT origin, destination FROM route ORDER BY origin'))

@app.route('/api/lookup/tourinstances')
def lookup_tourinstances():
    return jsonify(query('SELECT t_i_id, t_date, t_name FROM tourinstance ORDER BY t_date DESC'))

@app.route('/api/lookup/customers')
def lookup_customers():
    return jsonify(query("SELECT c_id, c_first_name||' '||c_last_name AS fullname FROM customer ORDER BY c_first_name"))

@app.route('/api/lookup/tours')
def lookup_tours():
    return jsonify(query('SELECT t_name FROM tour ORDER BY t_name'))

@app.route('/api/lookup/stations')
def lookup_stations():
    return jsonify(query('SELECT s_name FROM station ORDER BY s_name'))

@app.route('/api/lookup/guides')
def lookup_guides():
    return jsonify(query("SELECT g_id, g_first_name||' '||g_last_name AS fullname FROM guide ORDER BY g_first_name"))

if __name__ == '__main__':
    app.run(debug=True, port=int(os.getenv('PORT', 5000)))

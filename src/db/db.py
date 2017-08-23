'''db.py'''

import sqlite3
import datetime
import pickle

def store_slots_info(newinfo):
    info = get_slots_info()
    info.update(newinfo)
    store_file_obj('db/plantslots.pickle', info)

def get_slots_info():
    return get_file_obj('db/plantslots.pickle')

def store_setting(newsetting):
    '''newsetting: {'light_hour', 'light_duration', 'temperature_unit', 'language'})'''
    settings = get_setting()
    settings.update(newsetting)
    store_file_obj('db/setting.pickle', settings)

def get_setting():
    '''returns: {'light_hour' int, 'light_duration' int, 'temperature_unit' str, 'language' str}'''
    return get_file_obj('db/setting.pickle')

def store_file_obj(filepath, data):
    with open(filepath, 'wb') as f:
        pickle.dump(data, f, protocol=pickle.HIGHEST_PROTOCOL)

def get_file_obj(filepath):
    with open(filepath, 'rb') as f:
        filedata = pickle.load(f)
    return filedata

def execute_command(cmd, *args):
    '''execute SQLite command'''
    conn = sqlite3.connect('db/main.db', detect_types=sqlite3.PARSE_DECLTYPES)
    cur = conn.cursor()
    cur.execute(cmd, (args))
    data = cur.fetchall()
    conn.commit()
    conn.close()
    return data

def reset():
    '''Reset all db and setting'''

    init_setting = {
        "light_hour" : 7,
        "light_duration": 17,
        "temperature_unit": "c",
        "language": "en"
    }

    plant_slots = {
        "nutrient_last_added": None,
        "notified_slots": None
    }

    with open('db/setting.pickle', 'w+b') as setting_file, open('db/plantslots.pickle', 'w+b') as ps_file:
        pickle.dump(init_setting, setting_file, protocol=pickle.HIGHEST_PROTOCOL)
        pickle.dump(plant_slots, ps_file, protocol=pickle.HIGHEST_PROTOCOL)

    with open('db/setting.pickle', 'rb') as setting_file, open('db/plantslots.pickle', 'rb') as ps_file:
        settings = pickle.load(setting_file)
        pslots = pickle.load(ps_file)
        print(settings)
        print(pslots)

    conn = sqlite3.connect('db/main.db', detect_types=sqlite3.PARSE_DECLTYPES)
    cur = conn.cursor()

    cur.execute("DELETE FROM SLOTS")
    cur.execute("DELETE FROM PLANTS")

    cur.execute("UPDATE SQLITE_SEQUENCE SET SEQ=0 WHERE NAME='PLANTS';")

    cur.execute("INSERT INTO PLANTS (NAME, DAYS) VALUES ('LETTUCE', 21)")
    cur.execute("INSERT INTO PLANTS (NAME, DAYS) VALUES ('PlantA', 21)")
    cur.execute("INSERT INTO PLANTS (NAME, DAYS) VALUES ('PlantB', 21)")

    cur.execute("INSERT INTO SLOTS ( PANEL,SLOT, PLANT, DATE_PLANTED) VALUES (?, ?, ?, ?)",
                ('A', 1, 1, datetime.date(2017, 1, 1)))
    cur.execute("INSERT INTO SLOTS (PANEL,SLOT, PLANT,  DATE_PLANTED) VALUES (?, ?, ?, ?)",
                ('A', 2, 1, datetime.date.today()))
    conn.commit()
    conn.close()

def init():

    conn = sqlite3.connect('db/main.db', detect_types=sqlite3.PARSE_DECLTYPES)
    cur = conn.cursor()
    cur.execute('''CREATE TABLE if not exists PLANTS
         (ID integer primary key AUTOINCREMENT,
         NAME TEXT NOT NULL,
         DAYS INT NOT NULL);''')

    cur.execute('''CREATE TABLE if not exists SLOTS
         (PANEL CHAR(1) NOT NULL,
         SLOT INT NOT NULL,
         PLANT INT NOT NULL,
         DATE_PLANTED date,
         FOREIGN KEY(PLANT) REFERENCES PLANTS(ID) ,
         PRIMARY KEY ( PANEL, SLOT));''')

    conn.commit()

    # d = cur.execute("SELECT * from PLANTS")
    # print(d)
    # for row in d:
    #     print ("ID = ", row[0])
    #     print ("NAME = ", row[1])
    #     print ("DAYS = ", row[2])
    #     print()
    # d = cur.execute("SELECT * from SLOTS")
    # print(d)
    # for row in d:
    #     print ("PANEL = ", row[0])
    #     print ("SLOT = ", row[1])
    #     print ("PLANT_ID = ", row[2])
    #     print ("DATE = ", row[3])
    #     print()
    conn.close()

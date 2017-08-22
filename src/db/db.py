import sqlite3
import datetime

def exectute_command(cmd, *args):
    conn = sqlite3.connect('db/main.db', detect_types=sqlite3.PARSE_DECLTYPES)
    cur = conn.cursor()
    cur.execute(cmd, (args))
    data = cur.fetchall()
    conn.commit()
    conn.close()
    return data

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
         PLANT INT ,
         DATE_PLANTED date,
         PRIMARY KEY ( PANEL, SLOT));''')
    # cur.execute("DELETE FROM SLOTS")
    # cur.execute("DELETE FROM PLANTS")

    # cur.execute("UPDATE SQLITE_SEQUENCE SET SEQ=0 WHERE NAME='PLANTS';")

    # cur.execute("INSERT INTO PLANTS (NAME, DAYS) VALUES ('LETTUCE', 21)")
    # cur.execute("INSERT INTO PLANTS (NAME, DAYS) VALUES ('PlantA', 21)")
    # cur.execute("INSERT INTO PLANTS (NAME, DAYS) VALUES ('PlantB', 21)")
    

    # cur.execute("INSERT INTO SLOTS ( PANEL,SLOT, PLANT, DATE_PLANTED) VALUES (?, ?, ?, ?)", ('A', 1 , 1, datetime.date(2017, 1, 1)))
    # cur.execute("INSERT INTO SLOTS (PANEL,SLOT, PLANT,  DATE_PLANTED) VALUES (?, ?, ?, ?)", ('A', 2 , 1, datetime.date.today()))
    # conn.commit()

    d = cur.execute("SELECT * from PLANTS")
    print(d)
    for row in d:
        print ("ID = ", row[0])
        print ("NAME = ", row[1])
        print ("DAYS = ", row[2])
        print()
    d = cur.execute("SELECT * from SLOTS")
    print(d)
    for row in d:
        print ("PANEL = ", row[0])
        print ("SLOT = ", row[1])
        print ("PLANT_ID = ", row[2])
        print ("DATE = ", row[3])
        print()
    conn.close()
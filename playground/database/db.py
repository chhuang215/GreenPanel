import sqlite3

conn = sqlite3.connect('main.db')

print ("Opened successful")

conn.execute("INSERT INTO PLANTS VALUES (2, 'Bok Choy')")

conn.commit()

print("Records created")

conn.close()

import sqlite3

conn = sqlite3.connect('main.db')

print ("Opened successful")

conn.execute("INSERT INTO PLANTS VALUES (1, 'Lettuce')")

conn.commit()

print("Records created")

conn.close()

import sqlite3

conn = sqlite3.connect('main.db')

for row in conn.execute('SELECT * FROM PLANTS ORDER BY ID'):
	print (row)

conn.close()

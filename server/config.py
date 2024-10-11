import pymysql

DEBUG = False
PORT = 3000
# config for database
DATABASE = {
    'host': 'localhost',
    'port': 3306,
    'user': 'root',
    'password': '1234',
    'database': 'coralsitter',
    'charset': 'utf8mb4',
    'cursorclass': pymysql.cursors.DictCursor,
}
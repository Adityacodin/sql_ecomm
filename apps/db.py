import mariadb
import sys
from dotenv import load_dotenv
import os

load_dotenv()

def connect_db():
    try:
        conn = mariadb.connect(
            user = os.getenv("DB_USER"),
            password = os.getenv("DB_PASSWORD"),
            host = os.getenv("DB_HOST"),
            port = int(os.getenv("DB_PORT")),
            database = os.getenv("DB_NAME")
        )
    except mariadb.Error as e:
        print(f"Error connecting to the MariaDB platform: {e}")
        sys.exit(1)
    else: 
        return conn

# def get_cursor(conn):        -does not really help
#     return conn.cursor()

# params must be a tuple
def execute_query(cursor,query,params = None):
    try:    
        if params is not None:
            cursor.execute(query,params)
        else:
            cursor.execute(query)
    except mariadb.Error as e:
        print(f"Error executing the query: {e}")

def save_changes(conn):
    conn.commit()

def close_db(conn):
    conn.close()
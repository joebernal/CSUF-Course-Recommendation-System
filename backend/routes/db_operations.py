import mysql.connector
import os
from dotenv import load_dotenv

load_dotenv()

DB_CONFIG = {
    "host": os.getenv("DB_HOST", "localhost"),
    "user": os.getenv("DB_USER", "root"),
    "password": os.getenv("DB_PASSWORD"),
    "database": os.getenv("DB_NAME", "tuffyplan")
}

def query_db(query, params=None, one=False):
    conn = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor(dictionary=True)
    
    cursor.execute(query, params or ())
    
    if query.strip().upper().startswith("SELECT"):
        results = cursor.fetchone() if one else cursor.fetchall()
    else:
        conn.commit()
        results = {"message": "Success"}
    
    cursor.close()
    conn.close()
    return results

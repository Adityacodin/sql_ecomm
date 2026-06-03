import sys
sys.path.append("../apps/")
import db

def main():
    conn = db.connect_db()
    cur = conn.cursor()
    db.execute_query(
        cur,
        """INSERT INTO categories (cateory_name) VALUES 
        (''),
        (),
        (),
        (),
        ()
        """)


if __name__ == "__main__":
    main()
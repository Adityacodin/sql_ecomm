import sys
sys.path.append("../apps/")
import db

def main():
    conn = db.connect_db()
    cur = conn.cursor()
    db.execute_query(
        cur,
        """INSERT INTO categories (category_name) VALUES 
        ('Sports & Fitness'),
        ('Beauty & Personal Care'),
        ('Toys & Games'),
        ('Furniture'),
        ('Luggage & Travel')
    """)
    db.save_changes(conn)
    db.close_db(conn)


if __name__ == "__main__":
    main()
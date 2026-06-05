import sys
sys.path.append("../apps/")
import db
from random import choice
from faker import Faker

def main():
    conn = db.connect_db()
    cur = conn.cursor()
    faker = Faker('en_US')
    email_suffix = ['sales','hello','support','contact']
    for i in range(0,10):
        company = faker.company()
        db.execute_query(
            cur,
        """INSERT INTO suppliers 
        (supplier_name,contact_email) VALUE 
        (?,?);
        """,params = (company,choice(email_suffix)+"@"+company+".com")
        )
        db.save_changes(conn)
    db.close_db(conn)

if __name__ == "__main__":
    main()

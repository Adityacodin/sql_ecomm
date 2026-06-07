import sys
sys.path.append("../apps/")
import db
from random import choice
from faker import Faker

def get_email(f_name,l_name):
    domain_name = ["example","xyz","gmail","yahoo"]
    email_end = ["net","com","org"]
    return f_name.lower()+l_name.lower()+"@"+choice(domain_name)+"."+choice(email_end)

def main():
    conn = db.connect_db()
    cur = conn.cursor()
    faker = Faker('en_US')
    for i in range(200):
        f_n = faker.first_name()
        l_n = faker.last_name()
        email = get_email(f_n,l_n)
        phone = faker.basic_phone_number()
        db.execute_query(
            cur,
        """INSERT INTO customers 
        (first_name,last_name,
        email, phone) VALUE 
        (?,?,?,?);
        """,params = (f_n,l_n,email,phone)
        )
        db.save_changes(conn)
    db.close_db(conn)

if __name__ == "__main__":
    main()

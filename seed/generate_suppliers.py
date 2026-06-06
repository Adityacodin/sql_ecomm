import sys
sys.path.append("../apps/")
import db
from random import choice
from faker import Faker

def strip_keywords(text):
    return ''.join(char for char in text if char.isalnum()).lower()

def main():
    conn = db.connect_db()
    cur = conn.cursor()
    faker = Faker('en_US')
    email_suffix = ['sales','hello','support','contact']
    for i in range(20):
        company = faker.company()
        email = choice(email_suffix)+"@"+strip_keywords(company)+".com"
        db.execute_query(
            cur,
        """INSERT INTO suppliers 
        (supplier_name,contact_email) VALUE 
        (?,?);
        """,params = (company,email)
        )
        db.save_changes(conn)
    db.close_db(conn)

if __name__ == "__main__":
    main()

import sys
sys.path.append("../apps/")
import db
from random import choice
from faker import Faker


def get_max_min(cur,table_name,col_name):
    db.execute_query(
        cur,
        f"""
        SELECT MIN({col_name}),MAX({col_name}) from {table_name};
        """
    )
    return cur.fetchone()

def main():
    conn = db.connect_db()
    cur = conn.cursor()
    faker = Faker('en_US')
    cust_id_info = get_max_min(cur,'customers','customer_id')
    c_id = cust_id_info[0]
    for i in range(200):
        if c_id <= cust_id_info[1]:
            c_id += 1
            city = faker.city()
            street_address = faker.street_address()
            state = faker.state()
            country = faker.country()
            postalcode = faker.postalcode()
            db.execute_query(
                cur,
            """INSERT INTO addresses 
            (customer_id,address_line1,
            city, state, country, postal_code) VALUE 
            (?,?,?,?,?,?);
            """,params = (c_id,street_address,city,state,country,postalcode)
            )
        db.save_changes(conn)
    db.close_db(conn)

if __name__ == "__main__":
    main()

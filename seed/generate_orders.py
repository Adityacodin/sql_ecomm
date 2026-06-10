import sys
sys.path.append("../apps/")
import db
from random import shuffle,randint
from faker import Faker

def main():
    conn = db.connect_db()
    cur = conn.cursor()
    db.execute_query(cur,"""
        select customer_id from customers;
    """)
    ids = cur.fetchall()
    shuffle(ids)
    print(ids)
    # vip = ids[0:20]
    # vip_ord = randint(10,20)
    # regular = ids[21:140]
    # reg_ord = randint(2,6)
    # inactive = ids[141:]
    # in_ord = randint(0,2)
    statuses = [
    ('delivered', 85),
    ('shipped', 10),
    ('pending', 3),
    ('returned', 1),
    ('cancelled', 1)
    ]
    fk = Faker()
    date_time = faker.date_time_between(
    start_date="-1y",
    end_date="now"
    )
    count = 0
    orders = 0
    for id in ids:
        if count < 21:
            order_n = randint(10,20)
        elif count >= 21 and count < 141:
            order_n = randint(2,6)
        else :
            order_n = randint(0,2)
        
        for ord in order_n:
            date_time = faker.date_time_between(
                start_date="-1y",
                end_date="now"
            )
            db.execute_query(
                cur,
                """
                INSERT INTO orders (customer_id,orderdate,status,total_amount) values 
                (?,?,?,0)
                """,(id[0],date_time,get_status())
            )
        

if __name__ == "__main__":
    main()
import sys
sys.path.append("../apps/")
import db
from random import shuffle,randint

def main():
    conn = db.connect_db()
    cur = conn.cursor()
    db.execute_query(cur,"""
        select customer_id from customers;
    """)
    ids = cur.fetchall()
    shuffle(ids)
    print(ids)
    vip = ids[0:20]
    vip_ord = randint(10,20)
    regular = ids[21:140]
    reg_ord = randint(2,6)
    inactive = ids[141:]
    in_ord = randint(0,2)

    statuses = [
    ('delivered', 85),
    ('shipped', 10),
    ('pending', 3),
    ('returned', 1),
    ('cancelled', 1)
    ]
    
    print(len(vip),len(regular),len(inactive))


if __name__ == "__main__":
    main()
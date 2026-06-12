import sys
sys.path.append("../apps")

import db
from faker import Faker
from random import shuffle, randint, choices

def get_customer_ids(cur):
    db.execute_query(
    cur,
    """
    SELECT customer_id
    FROM customers;
    """
    )
    return [row[0] for row in cur.fetchall()]


def create_order(cur, customer_id, faker):
    order_date = faker.date_time_between(
        start_date="-1y",
        end_date="now"
    )

    status = choices(
        population=[
            "delivered",
            "shipped",
            "pending",
            "returned",
            "cancelled"
        ],
        weights=[
            130,
            50,
            10,
            8,
            7
        ],
        k=1
    )[0]

    db.execute_query(
        cur,
        """
        INSERT INTO orders
        (
            customer_id,
            orderdate,
            status,
            total_amount
        )
        VALUES
        (?,?,?,?);
        """,
        (
            customer_id,
            order_date,
            status,
            0
        )
    )

def main():
    conn = db.connect_db()
    cur = conn.cursor()

    faker = Faker()

    customer_ids = get_customer_ids(cur)

    shuffle(customer_ids)

    vip = customer_ids[:20]
    regular = customer_ids[20:140]
    inactive = customer_ids[140:]

    total_orders = 0

    for customer_id in vip:

        num_orders = randint(8, 15)

        for _ in range(num_orders):
            create_order(cur, customer_id, faker)
            total_orders += 1

    for customer_id in regular:

        num_orders = randint(2, 5)

        for _ in range(num_orders):
            create_order(cur, customer_id, faker)
            total_orders += 1

    for customer_id in inactive:

        num_orders = randint(0, 2)

        for _ in range(num_orders):
            create_order(cur, customer_id, faker)
            total_orders += 1

    db.save_changes(conn)

    print(f"{total_orders} orders inserted.")

    db.close_db(conn)

if __name__ == "__main__":
    main()

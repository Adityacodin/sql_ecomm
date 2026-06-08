import sys
sys.path.append("../apps")

import db
from faker import Faker
from random import shuffle

CITY_DISTRIBUTION = [
{"city": "Bengaluru", "state": "Karnataka", "count": 35},
{"city": "Mumbai", "state": "Maharashtra", "count": 30},
{"city": "Delhi", "state": "Delhi", "count": 30},
{"city": "Hyderabad", "state": "Telangana", "count": 25},
{"city": "Pune", "state": "Maharashtra", "count": 20},
{"city": "Chennai", "state": "Tamil Nadu", "count": 18},
{"city": "Kolkata", "state": "West Bengal", "count": 15},
{"city": "Ahmedabad", "state": "Gujarat", "count": 12},
{"city": "Jaipur", "state": "Rajasthan", "count": 8},
{"city": "Surat", "state": "Gujarat", "count": 5},
{"city": "Lucknow", "state": "Uttar Pradesh", "count": 4},
{"city": "Indore", "state": "Madhya Pradesh", "count": 3}
]

def get_customer_ids(cur):
    db.execute_query(
        cur,
        """
        SELECT customer_id
        FROM customers
        ORDER BY customer_id;
        """
    )
    return cur.fetchall()

def build_city_pool():
    pool = []
    for entry in CITY_DISTRIBUTION:
        for _ in range(entry["count"]):
            pool.append(
                {
                    "city": entry["city"],
                    "state": entry["state"]
                }
            )
    shuffle(pool)  
    return pool

def main():
    conn = db.connect_db()
    cur = conn.cursor()
    faker = Faker("en_IN")

    customer_ids = get_customer_ids(cur)
    city_pool = build_city_pool()

    for customer, location in zip(customer_ids, city_pool):

        customer_id = customer[0]

        db.execute_query(
            cur,
            """
            INSERT INTO addresses
            (
                customer_id,
                address_line1,
                city,
                state,
                country,
                postal_code
            )
            VALUES
            (?,?,?,?,?,?);
            """,
            (
                customer_id,
                faker.street_address(),
                location["city"],
                location["state"],
                "India",
                faker.postcode()
            )
        )
    db.save_changes(conn)
    db.close_db(conn)

if __name__ == "__main__":
    main()

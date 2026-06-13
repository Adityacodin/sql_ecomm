import sys
sys.path.append("../apps")

import db
from random import choices


def get_orders(cur):

    db.execute_query(
        cur,
        """
        SELECT
            order_id,
            orderdate,
            status,
            total_amount
        FROM orders;
        """
    )

    return cur.fetchall()


def get_payment_status(order_status):

    mapping = {
        "delivered": "paid",
        "shipped": "paid",
        "pending": "authorized",
        "cancelled": "refunded",
        "returned": "refunded"
    }

    return mapping[order_status]


def get_payment_method():

    return choices(
        population=[
            "upi",
            "card_debit",
            "card_credit",
            "wallet_phonepe",
            "wallet_paytm",
            "cod",
            "net_banking"
        ],
        weights=[
            40,
            15,
            15,
            10,
            5,
            10,
            5
        ],
        k=1
    )[0]


def main():

    conn = db.connect_db()
    cur = conn.cursor()

    orders = get_orders(cur)

    count = 0

    for order_id, order_date, order_status, amount in orders:

        payment_method = get_payment_method()

        payment_status = get_payment_status(
            order_status
        )

        db.execute_query(
            cur,
            """
            INSERT INTO payments
            (
                order_id,
                payment_method,
                payment_status,
                payment_date,
                amount
            )
            VALUES
            (?,?,?,?,?);
            """,
            (
                order_id,
                payment_method,
                payment_status,
                order_date,
                amount
            )
        )

        count += 1

    db.save_changes(conn)

    print(f"{count} payments inserted.")

    db.close_db(conn)


if __name__ == "__main__":
    main()
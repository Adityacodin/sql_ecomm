import sys
sys.path.append("../apps")

import db
from random import randint, sample, choices


def get_orders(cur):
    db.execute_query(
        cur,
        """
        SELECT order_id
        FROM orders;
        """
    )

    return [row[0] for row in cur.fetchall()]


def get_products(cur):
    db.execute_query(
        cur,
        """
        SELECT product_id, price
        FROM products;
        """
    )

    return cur.fetchall()


def get_num_products():

    return choices(
        population=[1, 2, 3, 4, 5],
        weights=[30, 30, 20, 15, 5],
        k=1
    )[0]


def main():

    conn = db.connect_db()
    cur = conn.cursor()

    orders = get_orders(cur)
    products = get_products(cur)

    total_order_items = 0

    for order_id in orders:

        num_products = get_num_products()

        selected_products = sample(
            products,
            k=min(num_products, len(products))
        )

        order_total = 0

        for product_id, price in selected_products:

            quantity = randint(1, 3)

            db.execute_query(
                cur,
                """
                INSERT INTO order_items
                (
                    order_id,
                    product_id,
                    quantity,
                    price_per_unit
                )
                VALUES
                (?,?,?,?);
                """,
                (
                    order_id,
                    product_id,
                    quantity,
                    price
                )
            )

            order_total += quantity * float(price)
            total_order_items += 1

        db.execute_query(
            cur,
            """
            UPDATE orders
            SET total_amount = ?
            WHERE order_id = ?;
            """,
            (
                round(order_total, 2),
                order_id
            )
        )

    db.save_changes(conn)

    print(f"{total_order_items} order items inserted.")

    db.close_db(conn)


if __name__ == "__main__":
    main()
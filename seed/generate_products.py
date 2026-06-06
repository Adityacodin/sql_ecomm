import sys
sys.path.append("../apps/")
import db
from random import choice
from faker import Faker
import faker_commerce
import random as rn

def strip_keywords(text):
    return ''.join(char for char in text if char.isalnum())

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
    faker = Faker()
    faker.add_provider(faker_commerce.Provider)
    cat_id_info = get_max_min(cur,'categories','category_id')
    sup_id_info = get_max_min(cur,'suppliers','supplier_id')
    for i in range(100):
        product = faker.ecommerce_name()
        price = faker.ecommerce_price(as_float = True)
        quantity = rn.randint(50,200)   
        cat_id = rn.randint(cat_id_info[0],cat_id_info[1])
        sup_id = rn,randint(sup_id_info[0],sup_id_info[1])
        db.execute_query(
            cur,
        """I
        INSERT INTO products values 
        (category_id,supplier_id,product_name,price,stock_quantity)
        VALUES 
        (?,?,?,?,?)
        """,
        params = (cat_id,sup_id,product,price,quantity)
        )
        db.save_changes(conn)
    db.close_db(conn)

if __name__ == "__main__":
    main()

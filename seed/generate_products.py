import sys
sys.path.append("../apps/")
import db
# from random import choice
# from faker import Faker
# import faker_commerce
# import random as rn

# def strip_keywords(text):
#     return ''.join(char for char in text if char.isalnum())

# def get_max_min(cur,table_name,col_name):
#     db.execute_query(
#         cur,
#         f"""
#         SELECT MIN({col_name}),MAX({col_name}) from {table_name};
#         """
#     )
#     return cur.fetchone()

def main():
    conn = db.connect_db()
    cur = conn.cursor()
    # faker = Faker()
    # faker.add_provider(faker_commerce.Provider)
    # cat_id_info = get_max_min(cur,'categories','category_id')
    # sup_id_info = get_max_min(cur,'suppliers','supplier_id')
    # for i in range(100):
    #     product = faker.ecommerce_name()
    #     price = float(faker.ecommerce_price())
    #     quantity = rn.randint(50,200)   
    #     cat_id = rn.randint(cat_id_info[0],cat_id_info[1])
    #     sup_id = rn.randint(sup_id_info[0],sup_id_info[1])
    #     db.execute_query(
    #         cur,
    #     """
    #     INSERT INTO products (category_id,supplier_id,product_name,price,stock_quantity)
    #     VALUES 
    #     (?,?,?,?,?);
    #     """,
    #     params = (cat_id,sup_id,product,price,quantity)
    #     )
    #     db.save_changes(conn)

    db.execute_query(cur,"""
    INSERT INTO products(category_id,supplier_id,product_name,price,stock_quantity) VALUES
    (100,100,'Samsung Galaxy M35',18999,35),
    (100,100,'Redmi Note 13 5G',16999,45),
    (100,101,'Boat Rockerz 450',1499,300),
    (100,101,'Logitech Wireless Mouse',899,250),
    (101,102,'Men Cotton Hoodie',1199,180),
    (101,102,'Women Casual Kurti',899,150),
    (101,103,'Slim Fit Blue Jeans',1499,130),
    (101,103,'Polo T-Shirt Navy',799,250),
    (102,104,'Prestige Mixer Grinder',3499,35),
    (102,104,'Electric Kettle 1.5L',1299,85),
    (102,105,'Kitchen Storage Container Set',899,140),
    (102,105,'Vegetable Chopper',399,220),
    (103,106,'Atomic Habits',499,300),
    (103,106,'Clean Code',699,140),
    (103,107,'Python Crash Course',899,110),
    (103,107,'Deep Work',449,180),
    (104,108,'USB-C Fast Charger',699,300),
    (104,108,'Wireless Earbuds',2499,90),
    (104,109,'Laptop Sleeve 15 Inch',799,150),
    (104,109,'Phone Tripod Stand',599,200),
    (105,100,'Yoga Mat Premium',999,120),
    (105,100,'Adjustable Dumbbells 10kg',3999,40),
    (105,101,'Resistance Bands Set',799,180),
    (105,101,'Skipping Rope Pro',299,250),
    (106,102,'Vitamin C Face Serum',599,140),
    (106,102,'Hair Dryer Professional',1999,60),
    (106,103,'Body Wash Aloe Vera',349,220),
    (106,103,'Electric Trimmer',1299,100),
    (107,104,'LEGO Classic Building Set',2499,50),
    (107,104,'Remote Control Car',1799,70),
    (107,105,'Chess Board Wooden',699,120),
    (107,105,'UNO Card Game',199,300),
    (108,106,'Office Chair Ergonomic',6999,20),
    (108,106,'Study Table Compact',4999,25),
    (108,107,'Bookshelf 5 Tier',3999,30),
    (108,107,'Shoe Rack Wooden',2499,45),
    (109,108,'Cabin Trolley Bag 55cm',3499,40),
    (109,108,'Travel Backpack 45L',1999,75),
    (109,109,'Passport Holder Leather',499,200),
    (109,109,'Packing Cubes Set',799,120);
    """)
    db.save_changes(conn)
    db.close_db(conn)

if __name__ == "__main__":
    main()

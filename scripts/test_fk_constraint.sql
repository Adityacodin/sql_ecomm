use ecomm_db;

show tables;
desc addresses;
select * from customers c
join addresses a on c.customer_id = a.customer_id;

desc products;
select * from products p
join categories c on p.category_id = c.category_id
join suppliers s on p.supplier_id = s.supplier_id;

desc orders;
select * from orders o
join customers c on o.customer_id = c.customer_id;

desc order_items;
select * FROM order_items oi
join orders o on oi.order_id = o.order_id;

desc payments;
select * FROM payments p
join orders o on p.order_id = p.order_id;

desc suppliers;

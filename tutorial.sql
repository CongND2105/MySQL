insert into employees values
	(1, "Teo", "Nguyen", 50.50, "2026-10-20"),
    (2, "Nam", "Nguyen", 26.21, "2026-10-11"),
    (3,"Giang", "Nguyen", 25.50, "2026-11-11"),
    (4,"Hung","Nguyen", 12.30, "2026-12-10"),
    (5,"Tien", "Nguyen", 21.20, "2026-12-11");
    
select * from employees;
delete from employees;
SET AUTOCOMMIT = OFF;
rollback;
use myDB;

-- tạo table product
create table product(
	product_id INT,
    product_name varchar(30) UNIQUE,
    price decimal (5,2)
);

-- cách thêm ràng buộc khi đã lỡ tạo bảng mà chưa thêm ràng buộc
alter table product
add constraint 
unique(product_name);

select * from product;

-- insert dữ liệu product
insert into product values
	(100, "Hambuger", 12.93),
    (101, "chicken", 23.12),
    (102, "soda", 11.10),
    (103, "ice cream", 1.50),
    (104, "pen",12.20);
    
-- ràng buộc notnull
alter table product 
modify price decimal(4,2) not null;

-- test insert dữ liệu product có null
insert into product values(105, "car toy", null);

-- update dữ liệu
update product
set price = 11.50 where product_id = 103;

-- thêm check table 
alter table product 
add constraint chk_hourly_pay check(price >= 10.00);

-- insert dữ liệu test check
insert into product values(105, "car toy", 5.0);

-- Tạo khoá chính và id tự tăng dần

create table transactions(
	transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    price DECIMAL(5,2)
);

ALTER TABLE transactions 
AUTO_INCREMENT = 1000;

INSERT INTO transactions (price) values
	(2.23),
    (1.23),
    (6.12),
    (21.05);

SELECT * FROM transactions;

-- table customers
CREATE TABLE customers(
	customer_id INT PRIMARY KEY AUTO_INCREMENT ,
    fullname varchar(100)
);
DROP TABLE customers;
INSERT INTO customers (fullname) VALUES
	("Nguyen Van A"),
    ("Nguyen Van B"),
    ("Nguyen Van C"),
    ("Nguyen Van D");
    
SELECT * FROM customers;

DROP TABLE transactions;

-- table transactions with foreign key
CREATE TABLE transactions (
	transactions_id INT PRIMARY KEY AUTO_INCREMENT,
    amount DECIMAL(5,2),
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO transactions (amount , customer_id) VALUES
	(4.99,3),
    (1.23,2),
    (10.21,2),
    (2.92,1),
    (7.28,3),
    (5,1);
-- insert them du lieu mau
INSERT INTO transactions (amount , customer_id) VALUES
	(9.99,null);
    
DELETE FROM transactions;

SELECT * FROM transactions;

-- inner join
SELECT * FROM transactions a
INNER JOIN customers b
on a.customer_id = b.customer_id;

-- left join
SELECT * FROM transactions a 
LEFT JOIN customers b 
on a.customer_id = b.customer_id;

-- righjoin
SELECT * FROM transactions a 
RIGHT JOIN customers b 
on a.customer_id = b.customer_id;
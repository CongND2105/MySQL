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

-- add colum job in employees
ALTER TABLE employees
ADD COLUMN job VARCHAR (50);

ALTER TABLE employees 
MODIFY COLUMN job VARCHAR (50) AFTER last_name;

-- insert data in job of employees
UPDATE employees
SET job = "asst. manager"
WHERE employees_id = 5 ;

SELECT * FROM employees;

-- logical operator
SELECT * FROM employees 
where hire_date < "2026-12-01";

SELECT * FROM employees 
where hire_date < "2026-12-01" AND job = "cook";

SELECT * FROM employees 
where hire_date < "2026-12-01" AND job = "cook" OR job = "cashier";

SELECT * FROM employees 
WHERE NOT job = "cook" ;

-- wildcard
SELECT * FROM employees 
WHERE job LIKE "_a%";

SELECT * FROM employees 
WHERE hire_date LIKE "____-__-20";

SELECT * FROM employees
WHERE job LIKE "__sh___";

-- ORDER BY -- DEFAULT WITH ASC 
SELECT * FROM employees
ORDER BY job;

SELECT * FROM transactions
ORDER BY amount;

SELECT * FROM transactions
ORDER BY amount DESC;

-- limit clause , pagination

SELECT * FROM employees
LIMIT 4,2;

-- UNION - ghép 2 bảng lại với nhau qua SELECT

-- create table income (thu nhập)
CREATE TABLE income (
	income_name VARCHAR(50),
    amount DECIMAL (8,2)
);
-- INSERT DATA in TABLE income
INSERT INTO income VALUES
	("orders",100000),
    ("merchandise", 50000),
    ("services",125000);
    
SELECT * FROM income;

-- CREATE TABLE expenses
CREATE TABLE expenses(
	expense_name VARCHAR (50),
    amount DECIMAL (10,2)
);

-- INSERT DATA in TABLE expenses
INSERT INTO expenses VALUES
	("wages",-250000),
    ("tax", -50000),
    ("repairs", -15000);
    
SELECT * FROM income
UNION  
SELECT * FROM expenses;

-- SEFL JOINS
SELECT * FROM customers;

ALTER TABLE customers 
ADD COLUMN referral_id INT ;

UPDATE customers
SET referral_id = 3
WHERE customer_id = 4;

SELECT a.fullname, b.fullname AS "Duoc Gioi Thieu Boi" FROM customers a
LEFT JOIN customers b
ON a.referral_id = b.customer_id;

SELECT * FROM employees;

ALTER TABLE employees
ADD COLUMN supervisor_id INT ;

UPDATE employees
SET supervisor_id = 1
WHERE employees_id =5;
SELECT * FROM employees;

SELECT nv.first_name, nv.last_name, CONCAT(ql.first_name, " ", ql.last_name) AS "quan ly"
FROM employees nv
LEFT JOIN employees ql 
ON nv.supervisor_id = ql.employees_id;

-- VIEW

ALTER TABLE customers
ADD COLUMN email VARCHAR(50);

UPDATE customers
SET email = "D@gmail.com"
WHERE customer_id = 4;
SELECT * FROM customers;

INSERT INTO customers VALUES (5, "NGUYEN VAN E", null, "E@gmail.com");

CREATE VIEW emailOfCustomer AS
SELECT email FROM customers;

SELECT * FROM emailOFCustomer;

-- INDEX in SQL là 1 loại cấu trúc dữ liệu dùng để tìm giá trị nhanh hơn trong 1 cột cụ thể

SHOW INDEXES FROM customers;

SELECT * FROM customers;

CREATE INDEX fullname_email_idx
ON customers(fullname,email);

-- SUBQUERY - là 1 query trong 1 query khác
SELECT * ,
		(SELECT AVG(hourly_pay) AS "Gio lam trung binh cua nhan vien" FROM employees) 
FROM employees;

SELECT first_name ,last_name , hourly_pay FROM employees 
	WHERE hourly_pay < (SELECT AVG(hourly_pay) AS "Gio lam trung binh cua nhan vien" FROM employees); 
    
(SELECT DISTINCT customer_id FROM transactions
WHERE customer_id IS NOT NULL) ;

SELECT fullname AS "Nguoi da tung mua hang" FROM customers
WHERE customer_id IN (SELECT DISTINCT customer_id FROM transactions
WHERE customer_id IS NOT NULL) ;

SELECT * FROM customers;

-- GROUP BY

SELECT * FROM transactions;

ALTER TABLE transactions 
ADD COLUMN order_date DATE;

UPDATE transactions 
SET order_date = "2026-10-12"
WHERE transactions_id = 7;
SELECT * FROM transactions;

-- QUERY GROUP BY 
SELECT SUM(amount) AS "Tong thu nhap", order_date
FROM transactions 
GROUP BY order_date;

SELECT MAX(amount) AS "Thu nhap lon nhat trong ngay", order_date
FROM transactions 
GROUP BY order_date;

SELECT MIN(amount) AS "Thu nhap nho nhat trong ngay", order_date
FROM transactions 
GROUP BY order_date;

SELECT AVG(amount) AS "Thu nhap trung binh trong ngay", order_date
FROM transactions 
GROUP BY order_date;

SELECT COUNT(amount) AS "so lan phat sinh order", order_date
FROM transactions 
GROUP BY order_date;

SELECT SUM(amount) AS "Tong so tien khach hang da chi " , customer_id
FROM transactions 
GROUP BY customer_id;

SELECT MAX(amount) AS "Lan chi lon nhat cua moi khach hang  " , customer_id
FROM transactions 
GROUP BY customer_id;

SELECT COUNT(amount) AS "Tong so lan mua hang cua khach hang" , b.fullname
FROM transactions a
LEFT JOIN customers b
on a.customer_id = b.customer_id
GROUP BY a.customer_id;

SELECT * FROM customers;
SELECT * FROM transactions;

-- ROLLUP là 1 extendsion , 1 tiện ích mở rộng của GROUP BY , nó tạo ra 1 hàng thể hiện tổng của hàng đó

SELECT SUM(amount), customer_id FROM transactions
WHERE customer_id IS NOT NULL
	GROUP BY customer_id WITH ROLLUP;
-- ON DELETE SET NULL : khi nó là khoá ngoại , nó sẽ không xoá row mà set giá trị thành null
-- ON DELETE CASCADE : nó sẽ xoá luôn row ở bảng con (FK)
SELECT * FROM transactions;

ALTER TABLE transactions DROP FOREIGN KEY fk_customer_id;

ALTER TABLE transactions 
ADD CONSTRAINT fk_customer_id FOREIGN KEY(customer_id) REFERENCES customers(customer_id)
ON DELETE SET NULL ;

ALTER TABLE transactions 
ADD CONSTRAINT fk_customer_id FOREIGN KEY(customer_id) REFERENCES customers(customer_id)
ON DELETE CASCADE;

SELECT * FROM customers;

INSERT INTO customers VALUES (4, "Nguyen Van D", null, "D@gmail.com");

SELECT * FROM transactions;

DELETE FROM customers 
WHERE customer_id = 4;

UPDATE transactions 
SET customer_id = 4 
WHERE transactions_id = 7;

/*
Stored Proceduce là 1 đoạn code SQL được ta viết sẵn ra - 
và khi nào cần chúng ta sẽ gọi nó ra - 
cơ chế hoạt động giống như ta tạo 1 function trong các ngôn ngữ lập trình khác, 
và điều đó thật tuyệt với nếu chúng ta có những đoạn SQL thường xuyên phải viết 
lại nhiều lần.
Cơ chế bảo mật cao , khi cấp quyền hạn cho thì mới được sử dụng các Proceduce
tránh lạm quyền và bị hack
*/ 
DELIMITER $$
CREATE PROCEDURE getAll_customer ()
BEGIN 
	SELECT * FROM customers;
END$$
DELIMITER ;

DROP PROCEDURE getById_customer;

DELIMITER $$
CREATE PROCEDURE getById_customer(IN id INT)
BEGIN
	SELECT * FROM customers
    WHERE customer_id = id ;
END $$
DELIMITER ;

CALL getALL_customer();
CALL getByID_customer(1);
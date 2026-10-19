CREATE DATABASE mini_ecommerce
CHARACTER SET utf8mb4
COLLATE utf8mb4_0900_ai_ci;

-- ===========================================================--
USE mini_ecommerce;

-- ============================================================ --
/*
CREATE TABLE ZONE 
*/
CREATE TABLE users (
	user_id INT AUTO_INCREMENT PRIMARY KEY ,
    user_name VARCHAR (50) ,
    user_email VARCHAR(50),
    user_password VARCHAR(50),
    creation_date DATE 
    
);

CREATE TABLE categories (
	category_id INT PRIMARY KEY,
    category_name VARCHAR (50)
);

CREATE TABLE products(
	product_id INT PRIMARY KEY ,
    product_name VARCHAR (50),
    product_decription VARCHAR (100),
    price DECIMAL (10,2),
    inventory_quantity INT ,
    category_id INT, 
    CONSTRAINT FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE orders(
	order_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    total DECIMAL (10,2),
    order_sattus ENUM ("PENDING", "PROCESSING","COMPLETED","CANCELLED")
    NOT NULL DEFAULT "PENDING",
    order_date DATE,
    CONSTRAINT FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE order_details (
	order_id INT,
    product_id INT,
    quantity INT ,
    unit_price DECIMAL (12,2),
    CONSTRAINT PRIMARY KEY (order_id,product_id),
    CONSTRAINT FOREIGN KEY (order_id) REFERENCES orders(order_id),
    CONSTRAINT FOREIGN KEY (product_id) REFERENCES products(product_id)
);
-- ============================================================ --

-- ============================================================ --
/*
EDIT TABLE ZONE 
*/

-- Email user không được trùng lặp 
AlTER TABLE users 
MODIFY COLUMN user_email VARCHAR(50) UNIQUE NOT NULL;

-- Số lượng tồn kho và giá phải luôn lớn hơn hoặc bằng 0 
ALTER TABLE products 
ADD CONSTRAINT chk_product_price 
	CHECK (price >=0),
ADD CONSTRAINT chk_product_inventory_quantity
	CHECK (inventory_quantity >= 0);

-- Xoá ORDER , toàn bộ dữ liệu của đơn hàng đó trong order_details cũng được xoá theo
ALTER TABLE order_details
DROP FOREIGN KEY order_details_ibfk_1;

ALTER TABLE order_details
ADD FOREIGN KEY (order_id) REFERENCES orders(order_id)
ON DELETE CASCADE;
-- ============================================================ --

-- ============================================================ --
/*
INSERT DATA ZONE 
*/

SELECT * FROM users;
INSERT INTO users (user_name, user_email, user_password, creation_date)
VALUES
    ('Nguyen Trung Nam', 'nam@gmail.com', 'nam@123', '2026-09-22'),
    ('Nguyen Van A', 'A@gmail.com', 'A@123', '2026-09-22'),
    ('Nguyen Van B', 'B@gmail.com', 'B@123', '2026-09-20'),
    ('Nguyen Van C', 'C@gmail.com', 'C@123', '2026-09-20'),
    ('Nguyen Van D', 'D@gmail.com', 'D@123', '2026-10-12'),
    ('Nguyen Van E', 'E@gmail.com', 'E@123', '2026-10-15');

SELECT * FROM categories;
INSERT INTO categories VALUES
	(1,"PHONE"),
    (2,"PC"),
    (3,"LATOP");

SELECT * FROM products;
INSERT INTO products VALUES
	(1,"Laptop ASUS", "LAPTOP thuong hieu ASUS , man 2K", 1000, 72,3),
    (2,"Laptop HP", "LAPTOP thuong hieu HP , man FULLHD", 970, 60,3),
    (3,"Laptop MSI", "LAPTOP thuong hieu MSI , man 4k, RTX 5070", 1500, 20,3),
    (4, "IPHONE 17 PRO MAX", "120HZ , FULL HD, CHIP A17", 1200, 120, 1),
    (5, "SAMSUNG GALAXY Ultra MAX", "160HZ , FULL HD, SNAPDRAGON 1020", 1120, 57, 1),
    (6, "XIAOMIE", "7020Mah, 240HZ, FULL HD", 950, 12, 1),
    (7,"PC VAN PHONG", "I3 10300H, GTX 1650, RAM 8GB", 2200, 40, 2),
	(8,"PC GAMING", "I9 13900K , RTX 5070TI , RAM 32GB", 3000, 30, 2),
	(9,"PC STREAMER", "I9 19900K , RTX 5090TI , RAM 64GB, 8K, 360HZ", 5000, 5, 2);
    
SELECT * FROM orders;
INSERT INTO orders(user_id, total,order_date)VALUES
	(1,2200,"2026-08-22"),
    (2,3000,"2026-09-19"),
    (3,1200,"2026-07-12"),
    (4,950,"2026-09-18"),
    (5,5000,"2026-10-10");
    
SELECT * FROM order_details;

INSERT INTO order_details VALUES 
	(1,1,1,1000),
    (1,4,1,1200),
    (2,8,1,3000),
    (3,4,1,1200),
    (4,6,1,950),
    (5,9,1,5000);
-- ============================================================ --
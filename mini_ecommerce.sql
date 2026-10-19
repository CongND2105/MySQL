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
TRIGGER ZONE
*/

select * from products;
select * from order_details;

DELIMITER $$ 
CREATE TRIGGER after_insert_order_details
AFTER INSERT ON order_details
FOR EACH ROW
BEGIN
	UPDATE products
    SET inventory_quantity = inventory_quantity - NEW.quantity
    WHERE product_id = NEW.product_id ;
END $$
DELIMITER ;
-- ============================================================ --

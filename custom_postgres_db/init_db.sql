-- Create customers table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    email VARCHAR(255)
);

-- Create products table
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255),
    main_price DECIMAL(10, 2)
);

-- Create orders table
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Create orderitems table
CREATE TABLE orderitems (
    orderitem_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Add data to the tables

INSERT INTO customers VALUES
(0, 'Peter', 'Alfred', 'peter.alfred@example.com'),
(1, 'John', 'Doe', 'john.doe@example.com'),
(2, 'Jane', 'Smith', 'jane.smith@example.com'),
(3, 'Alice', 'Johnson', 'alice.johnson@example.com'),
(4, 'Bob', 'Williams', 'bob.williams@example.com'),
(5, 'Eva', 'Miller', 'eva.miller@example.com'),
(6, 'David', 'Brown', 'david.brown@example.com'),
(7, 'Sophie', 'Anderson', 'sophie.anderson@example.com'),
(8, 'Ryan', 'Garcia', 'ryan.garcia@example.com'),
(9, 'Emma', 'Taylor', 'emma.taylor@example.com'),
(10, 'Matthew', 'Clark', 'matthew.clark@example.com'),
(11, 'Olivia', 'Walker', 'olivia.walker@example.com'),
(12, 'Daniel', 'White', 'daniel.white@example.com'),
(13, 'Ava', 'Hill', 'ava.hill@example.com'),
(14, 'William', 'Carter', 'william.carter@example.com'),
(15, 'Grace', 'Martin', 'grace.martin@example.com'),
(16, 'Michael', 'Evans', 'michael.evans@example.com'),
(17, 'Sofia', 'Moore', 'sofia.moore@example.com'),
(18, 'James', 'Turner', 'james.turner@example.com'),
(19, 'Lily', 'Baker', 'lily.baker@example.com'),
(20, 'Christopher', 'Ward', 'christopher.ward@example.com');

INSERT INTO products VALUES
(0, 'Product 0', 9.99),
(1, 'Product A', 19.99),
(2, 'Product B', 29.99),
(3, 'Product C', 49.99),
(4, 'Product D', 14.99),
(5, 'Product E', 39.99),
(6, 'Product F', 19.99),
(7, 'Product G', 29.99),
(8, 'Product H', 49.99),
(9, 'Product I', 14.99),
(10, 'Product J', 34.99),
(11, 'Product K', 24.99),
(12, 'Product L', 54.99),
(13, 'Product M', 9.99),
(14, 'Product N', 44.99),
(15, 'Product O', 29.99),
(16, 'Product P', 19.99),
(17, 'Product Q', 39.99),
(18, 'Product R', 14.99),
(19, 'Product S', 24.99),
(20, 'Product T', 64.99),
(21, 'Product U', 19.99),
(22, 'Product V', 29.99),
(23, 'Product W', 49.99),
(24, 'Product X', 14.99),
(25, 'Product Y', 39.99),
(26, 'Product Z', 59.99),
(27, 'Product AA', 19.99),
(28, 'Product BB', 34.99),
(29, 'Product CC', 24.99),
(30, 'Product DD', 44.99);


CREATE OR REPLACE PROCEDURE generate_orders(nb_customers integer, nb_products integer)
 LANGUAGE plpgsql
 AS $$
 DECLARE
   counter INT := 1;
    rand_order_id INT;
    rand_customer_id INT;
    rand_product_id INT;
    rand_order_date DATE;
    rand_quantity INT;
    price DECIMAL(10, 2);

 BEGIN
    -- Generate 100 random orders
	counter := 0;
    WHILE counter <= 100
    LOOP
        rand_customer_id := ROUND(RANDOM() * nb_customers-1) + 1;
        rand_order_date := NOW() + (random() * (NOW()+'90 days' - NOW())) + '30 days';
       
        -- Add orders
        INSERT INTO orders (order_id, customer_id, order_date) VALUES (counter, rand_customer_id, rand_order_date);
		
        counter := counter + 1;
    END LOOP;
   
    -- Generate 1000 random order items
    counter := 0;
    WHILE counter <= 1000
    LOOP
        rand_order_id := ROUND(RANDOM() * 100-1) + 1;
        rand_product_id := ROUND(RANDOM() * nb_products-1) + 1;
        rand_quantity := ROUND(RANDOM() * 5) + 1;
        price := (SELECT main_price FROM products WHERE products.product_id = rand_product_id) * rand_quantity;
		
        -- Add orderitems
        INSERT INTO orderitems (orderitem_id, order_id, product_id, quantity, price) VALUES (counter, rand_order_id, rand_product_id, rand_quantity, price);

        counter := counter + 1;
    END LOOP;
 END;
 $$;
 
CALL generate_orders(20, 30);
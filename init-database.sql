-- Create database
CREATE DATABASE shopsphere;

-- Create user
CREATE USER shopsphere_user WITH ENCRYPTED PASSWORD 'ShopSphere2024!';

-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE shopsphere TO shopsphere_user;

-- Connect to database
\c shopsphere

-- Create products table
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    category VARCHAR(50),
    material VARCHAR(50),
    stock INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create customers table
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    email VARCHAR(100) UNIQUE NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    country VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create orders table
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(id),
    total_amount DECIMAL(10, 2),
    status VARCHAR(20),
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create order_items table
CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(id),
    product_id INTEGER REFERENCES products(id),
    quantity INTEGER,
    price DECIMAL(10, 2)
);

-- Insert sample products
INSERT INTO products (name, description, price, category, material, stock) VALUES
('Eco Minimal Case', 'Sleek biodegradable design with minimalist aesthetic', 24.99, 'Minimal', 'PLA Bioplastic', 150),
('Artistic Expression', 'Custom-designed patterns and vibrant colors', 29.99, 'Artistic', 'Recycled PET', 120),
('Ultra Protect Pro', 'Maximum protection with recycled materials', 34.99, 'Protection', 'TPU Recycled', 200),
('Glitter Galaxy', 'Sustainable glitter embedded in biodegradable resin', 27.99, 'Glitter', 'Bio-resin', 80),
('Ocean Wave', 'Made from recycled ocean plastics', 32.99, 'Eco', 'Ocean Plastic', 95),
('Night Sky Edition', 'Glow-in-the-dark sustainable case', 26.99, 'Special', 'Glow PLA', 110),
('Wood Grain Natural', 'Real wood fiber composite case', 35.99, 'Natural', 'Wood Composite', 75),
('Marble Elegance', 'Recycled marble dust composite', 31.99, 'Luxury', 'Marble Composite', 60),
('Sunset Gradient', 'Multi-color biodegradable gradient', 28.99, 'Colorful', 'PLA Blend', 130),
('Carbon Fiber Look', 'Sustainable carbon alternative', 33.99, 'Sport', 'Recycled Carbon', 90);

-- Insert sample customers
INSERT INTO customers (email, first_name, last_name, country) VALUES
('marie.dubois@email.fr', 'Marie', 'Dubois', 'France'),
('lucas.martin@email.fr', 'Lucas', 'Martin', 'France'),
('emma.schmidt@email.de', 'Emma', 'Schmidt', 'Germany'),
('luca.rossi@email.it', 'Luca', 'Rossi', 'Italy'),
('sofia.garcia@email.es', 'Sofia', 'Garcia', 'Spain'),
('jan.kowalski@email.pl', 'Jan', 'Kowalski', 'Poland'),
('nina.jensen@email.dk', 'Nina', 'Jensen', 'Denmark'),
('erik.andersson@email.se', 'Erik', 'Andersson', 'Sweden'),
('laura.mueller@email.at', 'Laura', 'Mueller', 'Austria'),
('tom.bakker@email.nl', 'Tom', 'Bakker', 'Netherlands'),
('anna.novak@email.cz', 'Anna', 'Novak', 'Czech Republic'),
('pierre.bernard@email.be', 'Pierre', 'Bernard', 'Belgium'),
('helena.silva@email.pt', 'Helena', 'Silva', 'Portugal'),
('mikko.virtanen@email.fi', 'Mikko', 'Virtanen', 'Finland'),
('claire.dubois@email.lu', 'Claire', 'Dubois', 'Luxembourg');

-- Insert sample orders
INSERT INTO orders (customer_id, total_amount, status) VALUES
(1, 24.99, 'delivered'),
(2, 59.98, 'delivered'),
(3, 34.99, 'shipped'),
(4, 87.97, 'delivered'),
(5, 27.99, 'processing'),
(6, 32.99, 'delivered'),
(7, 62.98, 'shipped'),
(8, 24.99, 'delivered'),
(9, 119.96, 'delivered'),
(10, 35.99, 'processing'),
(11, 58.98, 'delivered'),
(12, 31.99, 'delivered'),
(13, 92.97, 'shipped'),
(14, 28.99, 'delivered'),
(15, 67.98, 'delivered');

-- Insert sample order items
INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
(1, 1, 1, 24.99),
(2, 1, 1, 24.99),
(2, 4, 1, 34.99),
(3, 3, 1, 34.99),
(4, 2, 1, 29.99),
(4, 5, 1, 32.99),
(4, 1, 1, 24.99),
(5, 4, 1, 27.99),
(6, 5, 1, 32.99),
(7, 3, 2, 34.99),
(8, 1, 1, 24.99),
(9, 7, 2, 35.99),
(9, 8, 1, 31.99),
(9, 6, 1, 26.99),
(10, 7, 1, 35.99),
(11, 3, 1, 34.99),
(11, 1, 1, 24.99),
(12, 8, 1, 31.99),
(13, 9, 2, 28.99),
(13, 3, 1, 34.99),
(14, 9, 1, 28.99),
(15, 2, 1, 29.99),
(15, 6, 1, 26.99),
(15, 1, 1, 24.99);

-- Grant table privileges
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO shopsphere_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO shopsphere_user;

-- Create views for analytics
CREATE VIEW monthly_revenue AS
SELECT
    DATE_TRUNC('month', order_date) as month,
    SUM(total_amount) as revenue,
    COUNT(*) as order_count
FROM orders
WHERE status = 'delivered'
GROUP BY month
ORDER BY month DESC;

CREATE VIEW top_products AS
SELECT
    p.name,
    p.category,
    SUM(oi.quantity) as units_sold,
    SUM(oi.quantity * oi.price) as total_revenue
FROM products p
JOIN order_items oi ON p.id = oi.product_id
JOIN orders o ON oi.order_id = o.id
WHERE o.status = 'delivered'
GROUP BY p.id, p.name, p.category
ORDER BY units_sold DESC;

CREATE VIEW customer_stats AS
SELECT
    c.country,
    COUNT(DISTINCT c.id) as customer_count,
    COUNT(o.id) as order_count,
    COALESCE(SUM(o.total_amount), 0) as total_spent
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
GROUP BY c.country
ORDER BY total_spent DESC;

GRANT SELECT ON monthly_revenue TO shopsphere_user;
GRANT SELECT ON top_products TO shopsphere_user;
GRANT SELECT ON customer_stats TO shopsphere_user;

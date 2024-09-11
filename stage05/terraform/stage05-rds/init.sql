CREATE DATABASE IF NOT EXISTS testdb;

USE testdb;

CREATE TABLE employees (
  id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  email VARCHAR(100),
  hire_date DATE
);

INSERT INTO employees (first_name, last_name, email, hire_date) 
VALUES 
('John', 'Doe', 'john.doe@example.com', '2023-01-01'),
('Jane', 'Smith', 'jane.smith@example.com', '2022-05-15');

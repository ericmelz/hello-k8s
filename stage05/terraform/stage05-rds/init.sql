USE hello;
CREATE TABLE messages (
  id INT AUTO_INCREMENT PRIMARY KEY,
  message VARCHAR(255)
);
INSERT INTO messages (message)
VALUES
  ('Greetings from planet kubelet, coming from sunny RDS'),
  ('The number you have dialed is now in service.');    


TRUNCATE TABLE users RESTART IDENTITY CASCADE; -- replace with your own table name.
TRUNCATE TABLE posts RESTART IDENTITY;

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO users (email_address, username) VALUES ('test@test.com', 'alice1');
INSERT INTO users (email_address, username) VALUES ('anothertest@test.com', 'alicew2');


-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO posts 
  (title, contents, view_count, user_id) 
  VALUES ('test title 1', 'test contents 1', 100, 1);
INSERT INTO posts 
  (title, contents, view_count, user_id) 
  VALUES ('test title 2', 'test contents 2', 200, 2);
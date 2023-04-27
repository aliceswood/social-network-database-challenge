# Post class Model and Repository Classes Design Recipe

_Copy this recipe template to design and implement Model and Repository classes for a database table._

## 1. Design and create the Table

If the table is already created in the database, you can skip this step.

Otherwise, [follow this recipe to design and create the SQL schema for your table](./single_table_design_recipe_template.md).

```
# EXAMPLE

Table: posts

Columns:
id | title | contents | view_count | user_id
```

## 2. Create Test SQL seeds

Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

```sql
-- EXAMPLE
-- (file: spec/seeds_social_network.sql)

-- Write your SQL seed here. 

-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)

TRUNCATE TABLE posts RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO posts 
  (title, contents, view_count, user_id) 
  VALUES ('test title 1', 'test contents 1', 100, 1);
INSERT INTO posts 
  (title, contents, view_count, user_id) 
  VALUES ('test title 2', 'test contents 2', 200, 2);
```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 social_network_test < spec/seeds_social_network.sql
```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
# EXAMPLE
# Table name: posts

# Model class
# (in lib/post.rb)
class Post
end

# Repository class
# (in lib/post_repository.rb)
class PostRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# EXAMPLE
# Table name: posts

# Model class
# (in lib/post.rb)

class Post

  # Replace the attributes by your own columns.
  attr_accessor :id, :title, :contents, :view_count, :user_id
end

```

*You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.*

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# EXAMPLE
# Table name: posts

# Repository class
# (in lib/post_repository.rb)

class PostRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, title, contents, view_count, user_id FROM posts;

    # Returns an array of Post objects.
  end

  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    # Executes the SQL query:
    # SELECT id, title, contents, view_count, user_id FROM posts WHERE id = $1;

    # Returns a single Post object.
  end

  # Creates a single post
  # Taking a Post object as an argument
  def create(post)
    # Executes the SQL query:
    # INSERT INTO posts (title, contents, view_count, user_id) VALUES ('test title 3', 'test content 3', 300, 1)

    # returns nil - just creates a post
  end

  # Updates a post
  # will take post object - new details confirmed in class instance
  def update(post)
    # Executes the SQL query:
    # UPDATE posts SET title = $1, contents = $2, view_count = $3, user_id = $4 WHERE id = $5;

    # returns nil - just updates a post
  end

  # Deletes a post
  # takes id number as an argument
  def delete(id)
    # Executes the SQL query:
    # DELETE FROM posts WHERE id = $1

    # returns nil - just deletes a post
  end
end
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES

# 1
# Get all posts
# 'test title 1', 'test contents 1', 100, 1

repo = PostRepository.new

posts = repo.all

posts.length # => 2
posts.first.id # => '1'
posts.first.title # => 'test title 1'
posts.first.contents # => 'test contents 1'
posts.first.view_count # => '100'
posts.first.user_id # => '1'

# 2
# Get a single post

repo = PostRepository.new

post = repo.find(1)

post.id # => 1
post.title # => 'test title 1'
post.contents # => 'test contents 1'
post.view_count # => 100
post.user_id # => 1

# 3
# Get a single post
# ('test title 2', 'test contents 2', 200, 2);
repo = PostRepository.new

post = repo.find(2)

post.id # => 2
post.title # => 'test title 2'
post.contents # => 'test contents 2'
post.view_count # => 200
post.user_id # => 2

# 4 
# Create a post 

repo = PostRepository.new

post = Post.new
post.title = 'test title 3'
post.contents = 'test contents 3'
post.view_count = 300
post.user_id = 1

repo.create(post)

posts = repo.all

latest_post = posts.last
latest_post.title # = 'test title 3'
latest_post.contents # = 'test contents 3'
latest_post.view_count # = 300
latest_post.user_id # = 1

# 5 
# updating all post details

repo = PostRepository.new

post_to_update = repo.find(1)
post_to_update.title = 'updated title'
post_to_update.contents = 'updated contents'
post_to_update.view_count = 600
post_to_update.user_id = 2

repo.update(post_to_update)

updated_post = repo.find(1)
updated_post.title # = 'updated title'
updated_post.contents  # = 'updated contents'
updated_post.view_count # = 600
updated_post.user_id  # = 2


# 6
# updating some post details
# 'test title 1', 'test contents 1', 100, 1
repo = PostRepository.new

post_to_update = repo.find(1)
post_to_update.title = 'updated title'
post_to_update.contents = 'updated contents'

repo.update(post_to_update)

updated_post = repo.find(1)
updated_post.title # = 'updated title'
updated_post.contents  # = 'updated contents'
updated_post.view_count # = 100
updated_post.user_id  # = 1

# 7 
# deletes a post
repo = PostRepository.new

post_to_delete = 1

repo.delete(post_to_delete)

all_posts = repo.all

all_posts.length # => 1
all_posts.first.id # => '2'

# 8 
# deletes both posts
repo = PostRepository.new

repo.delete(1)
repo.delete(2)

all_posts = repo.all

all_posts.length # => 0

```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/post_repository_spec.rb

def reset_posts_table
  seed_sql = File.read('spec/seeds_social_network_test.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
  connection.exec(seed_sql)
end

describe PostRepository do
  before(:each) do 
    reset_posts_table
  end

  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._

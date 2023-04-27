require_relative './post'

class PostRepository
  def all
    sql ='SELECT id, title, contents, view_count, user_id FROM posts;'

    result_set = DatabaseConnection.exec_params(sql, [])

    posts = []

    result_set.each do |record|
      post = Post.new
      post.id = record['id'].to_i
      post.title = record['title']
      post.contents = record['contents']
      post.view_count = record['view_count'].to_i
      post.user_id = record['user_id'].to_i

      posts << post
    end
    return posts
  end

  def find(id)
    sql = 'SELECT id, title, contents, view_count, user_id FROM posts WHERE id = $1;'
    sql_params = [id]

    result_set = DatabaseConnection.exec_params(sql, sql_params)

    record = result_set[0]
    post = Post.new
    post.id = record['id'].to_i
    post.title = record['title']
    post.contents = record['contents']
    post.view_count = record['view_count'].to_i
    post.user_id = record['user_id'].to_i

    return post 
  end

  def create(post)
    sql = 'INSERT INTO posts (title, contents, view_count, user_id) VALUES ($1, $2, $3, $4);'
    sql_params = [post.title, post.contents, post.view_count, post.user_id]

    DatabaseConnection.exec_params(sql, sql_params)

    return nil
  end

  def update(post)
    sql = 'UPDATE posts SET title = $1, contents = $2, view_count = $3, user_id = $4 WHERE id = $5;'
    sql_params = [post.title, post.contents, post.view_count, post.user_id, post.id]

    DatabaseConnection.exec_params(sql, sql_params)

    return nil
  end

  # Deletes a post
  # takes id number as an argument
  def delete(id)
    sql = 'DELETE FROM posts WHERE id = $1'
    sql_params = [id]

    DatabaseConnection.exec_params(sql, sql_params)

    return nil
  end
end
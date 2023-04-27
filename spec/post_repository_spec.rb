require 'post_repository'

RSpec.describe PostRepository do
  def reset_posts_table
    seed_sql = File.read('spec/seeds_social_network.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
    connection.exec(seed_sql)
  end

    before(:each) do
      reset_posts_table
    end

  it 'returns a list of posts' do
    repo = PostRepository.new

    posts = repo.all

    expect(posts.length).to eq(2)
    expect(posts.first.id).to eq(1)
    expect(posts.first.title).to eq('test title 1')
    expect(posts.first.contents).to eq('test contents 1')
    expect(posts.first.view_count).to eq(100)
    expect(posts.first.user_id).to eq(1)
  end

  it 'returns a single post at id 1' do
    repo = PostRepository.new

    post = repo.find(1)

    expect(post.id).to eq(1)
    expect(post.title).to eq('test title 1')
    expect(post.contents).to eq('test contents 1')
    expect(post.view_count).to eq(100)
    expect(post.user_id).to eq(1)
  end

  it 'returns a single post at id 2' do
    repo = PostRepository.new

    post = repo.find(2)

    expect(post.id).to eq(2)
    expect(post.title).to eq('test title 2')
    expect(post.contents).to eq('test contents 2')
    expect(post.view_count).to eq(200)
    expect(post.user_id).to eq(2)
  end

  it 'creates a new post' do
    repo = PostRepository.new

    post = Post.new
    post.title = 'test title 3'
    post.contents = 'test contents 3'
    post.view_count = '300'
    post.user_id = '1'

    repo.create(post)

    posts = repo.all

    latest_post = posts.last
    expect(latest_post.title).to eq('test title 3')
    expect(latest_post.contents).to eq('test contents 3')
    expect(latest_post.view_count).to eq(300)
    expect(latest_post.user_id).to eq(1)
  end

  it 'updates all details of a post' do
    repo = PostRepository.new

    post_to_update = repo.find(1)
    post_to_update.title = 'updated title'
    post_to_update.contents = 'updated contents'
    post_to_update.view_count = 600
    post_to_update.user_id = '2'

    repo.update(post_to_update)
    updated_post = repo.find(1)

    expect(updated_post.title).to eq('updated title')
    expect(updated_post.contents ).to eq('updated contents')
    expect(updated_post.view_count).to eq(600)
    expect(updated_post.user_id ).to eq(2)
  end

  it 'updates some of the code details' do
    repo = PostRepository.new

    post_to_update = repo.find(1)
    post_to_update.title = 'updated title'
    post_to_update.contents = 'updated contents'

    repo.update(post_to_update)

    updated_post = repo.find(1)
    expect(updated_post.title).to eq('updated title')
    expect(updated_post.contents ).to eq('updated contents')
    expect(updated_post.view_count).to eq(100)
    expect(updated_post.user_id ).to eq(1)
  end

  it 'deletes one post at id 1' do
    repo = PostRepository.new

    post_to_delete = 1

    repo.delete(post_to_delete)

    all_posts = repo.all

    expect(all_posts.length).to eq(1)
    expect(all_posts.first.id).to eq(2)
  end

  it 'deletes both entries' do
    repo = PostRepository.new

    repo.delete(1)
    repo.delete(2)

    all_posts = repo.all

    expect(all_posts.length).to eq(0)
  end
end
require 'user_repository'

RSpec.describe UserRepository do
  def reset_users_table
    seed_sql = File.read('spec/seeds_social_network.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
    connection.exec(seed_sql)
  end

    before(:each) do 
      reset_users_table
    end

  it 'returns all users' do
    repo = UserRepository.new

    users = repo.all

    expect(users.length).to eq(2)
    expect(users.first.email_address).to eq('test@test.com')
    expect(users.first.username).to eq('alice1')
  end

  it 'returns 1 user at id 1' do
    repo = UserRepository.new

    user = repo.find(1)

    expect(user.id).to eq(1)
    expect(user.email_address).to eq('test@test.com')
    expect(user.username).to eq('alice1')
  end

  it 'returns 1 user at id 2' do
    repo = UserRepository.new

    user = repo.find(2)

    expect(user.id).to eq(2)
    expect(user.email_address).to eq('anothertest@test.com')
    expect(user.username).to eq('alicew2')
  end

  it 'creates a new user' do
    repo = UserRepository.new

    new_user = User.new
    new_user.email_address = 'test3@test.com'
    new_user.username =  'alicewood'

    repo.create(new_user)

    users = repo.all
    latest_user = users.last

    expect(latest_user.email_address).to eq('test3@test.com')
    expect(latest_user.username).to eq('alicewood')
  end

  it 'updates all info for a user' do
    repo = UserRepository.new

    user_to_update = repo.find(1)

    user_to_update.email_address = 'updatedtest@test.com'
    user_to_update.username =  'updatedusername'

    repo.update(user_to_update)

    updated_user = repo.find(1)

    expect(updated_user.email_address).to eq('updatedtest@test.com')
    expect(updated_user.username).to eq('updatedusername')
  end
    
  it 'updates some of the user details' do
    repo = UserRepository.new

    user_to_update = repo.find(1)

    user_to_update.username =  'updatedusername'

    repo.update(user_to_update)

    updated_user = repo.find(1)

    updated_user.email_address = 'test@test.com'
    updated_user.username =  'updatedusername'
  end

  it 'deletes the user at id 1' do
      repo = UserRepository.new

      id_to_delete = 1
      repo.delete(id_to_delete)

      all_users = repo.all
      expect(all_users.length).to eq(1)
      expect(all_users.first.id).to eq('2')
  end
    
  it 'deletes both users' do
     repo = UserRepository.new

    repo.delete(1)
    repo.delete(2)

    all_users = repo.all
    expect(all_users.length).to eq(0)
  end
end
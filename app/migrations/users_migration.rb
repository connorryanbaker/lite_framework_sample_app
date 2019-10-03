require_relative '../../db/migration'
class UsersMigration < Migration
  create_table 'users' do |t|
    t.string 'username'
    t.string 'password_digest'
    t.string 'session_token'
  end
end



UsersMigration.run


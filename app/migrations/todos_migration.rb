require_relative '../../db/migration'
class TodosMigration < Migration
  create_table 'todos' do |t|
    t.string 'title'
    t.string 'description'
    t.integer 'user_id'
  end
end

TodosMigration.run
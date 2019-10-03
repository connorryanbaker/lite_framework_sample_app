require 'sqlite3'
require_relative '../db/migration'

describe MigrationIterator do
  let(:iterator) { MigrationIterator.new }

  describe '#columns' do
    it 'is a hash' do
      expect(iterator.columns).to be_a(Hash)
    end

    it 'is getable and setable' do
      iterator['hola'] = 'cunao'
      expect(iterator['hola']).to eq('cunao')
    end
  end

  describe '#string' do
    it 'sets a key in columns equal to its argument, pointing to string' do
      iterator.string('username')
      expect(iterator['username']).to eq('string')
    end
  end

  describe '#integer' do
    it 'sets a key in columns equal to its argument, pointing to integer' do
      iterator.integer('team_id')
      expect(iterator['team_id']).to eq('integer')
    end
  end
end

describe Migration do
  let(:hash) { { 'name': 'string', 'id': 'integer' } }
  let(:db) { SQLite3::Database.open 'app.db' }

  describe '::gen_column_str' do
    it 'takes a hash and returns comma separated string of columnnames and types' do
      expect(Migration.gen_column_str(hash)).to be_a(String)
      expect(Migration.gen_column_str(hash)).to eq('name string NOT NULL, id integer NOT NULL')
    end
  end

  describe '::gen_create_query' do
    it 'takes a table name and column hash, returning a string' do
      expect(Migration.gen_create_query('users',{ 'name': 'string' })).to be_a(String)
    end

    it 'returns a create_table sql statement' do
      expect(Migration.gen_create_query('users', { 'name': 'string' })).to eq('create table if not exists users(id integer PRIMARY KEY, name string NOT NULL);')
    end
  end

  describe '::create_table' do
    before :each do
      class LusersMigration < Migration
        create_table 'lusers' do |t|
          t.string 'username'
        end
        self.run
      end
    end

    after :each do
    end

    it 'creates a table with the appropriate name' do
      tables = db.execute <<-SQL
        select name from sqlite_master 
        where type='table';
      SQL
      expect(tables.flatten(1)).to include('users')
    end

    it 'creates an id column automatically' do
      cols = db.execute2('select * from lusers')[0]
      expect(cols).to include('id')
    end

    it 'creates the columns listed in the block' do
      cols = db.execute2('select * from lusers')[0]
      expect(cols).to include('username')
    end
  end

  describe '::drop_table' do
    before :each do
      class LusersMigration < Migration
        create_table 'lusers' do |t|
          t.string 'username'
        end
        self.run
      end
    end

    it 'drops the table with name matching the argument' do
      tables = db.execute <<-SQL
        select name from sqlite_master 
        where type='table';
      SQL
      Migration.drop_table('lusers').run
      tables2 = db.execute <<-SQL
        select name from sqlite_master 
        where type='table';
      SQL
      expect(tables2.length + 1).to eq(tables.length)
    end

    it 'will not raise an error if table does not exist' do
      expect{ Migration.drop_table('shabba_ranks').run }.to_not raise_error
    end
  end
end

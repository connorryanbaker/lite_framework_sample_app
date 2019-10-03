require_relative 'db_connection'
class Migration
  attr_reader :create_command

  def self.create_table(name, &block)
    iterator = MigrationIterator.new
    block.call(iterator)
    gen_create_query(name, iterator.columns)
    self
  end

  def self.drop_table(name)
    @command = "drop table if exists #{name}"
    self
  end

  def self.gen_create_query(name, hash)
    @command = "create table if not exists #{name}(id integer PRIMARY KEY, #{gen_column_str(hash)});"
  end

  def self.gen_column_str(hash)
    hash.map {|k,v| "#{k} #{v} NOT NULL"}.join(', ')
  end

  def self.run
    raise 'sql command not yet generated' unless @command
    DBConnection.execute(@command)
  end
end

class MigrationIterator
  attr_reader :columns
  def initialize
    @columns = {}
  end

  def string(col_name)
    columns[col_name] = 'string'
  end

  def integer(col_name)
    columns[col_name] = 'integer'
  end

  def [](key)
    columns[key]
  end

  def []=(key, val)
    columns[key] = val
  end
end

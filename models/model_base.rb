require_relative '../db/db_connection'
require_relative 'searchable'
require_relative 'associatable'
require_relative 'validatable'

class ModelBase 
  extend Validatable
  extend Searchable
  extend Associatable
  def self.columns
    return @columns unless @columns.nil?
    col = DBConnection.execute2(<<-SQL)
      SELECT *
      FROM #{self.table_name}
      LIMIT 1
    SQL
    @columns = col[0].map(&:to_sym)
  end

  def self.finalize!
    self.columns.each do |col|
      define_method("#{col}") { self.attributes[col] }
      define_method("#{col}=") { |val| self.attributes[col] = val }
    end
    define_method('id') { self.attributes[:id] }
    define_method('id=') do |n|
      if !self.attributes[:id]
        self.attributes[:id] = n 
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name || self.to_s.tableize
  end

  def self.all
    res = DBConnection.execute(<<-SQL)
      SELECT *
      FROM #{self.table_name}
    SQL
    self.parse_all(res)
  end

  def self.parse_all(results)
    results.map {|params| self.send(:new, params)}
  end

  def self.find(id)
    res = DBConnection.execute(<<-SQL, id: id)
    SELECT *
    FROM #{self.table_name}
    WHERE id = :id
    SQL
    if res[0]
      return self.new(res[0])
    end
    nil
  end

  def initialize(params = {})
    params.each do |k, v|
      if !self.class.columns.include?(k.to_sym)
        raise Exception.new("unknown attribute '#{k}'")
      else
        self.send("#{k}=", v)
      end 
    end 
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    self.class.writeable_columns.map {|col| self.send("#{col}")}
  end

  def self.writeable_columns
    self.columns.reject {|col| col == :id}
  end

  def insert
    col_names = self.class.writeable_columns.join(", ")
    qs = self.class.writeable_columns.map {|e| "?"}.join(", ")
    DBConnection.execute(<<-SQL, *attribute_values)
    INSERT INTO
      #{self.class.table_name} (#{col_names})
    VALUES
      (#{qs})
    SQL
    self.id = DBConnection.last_insert_row_id
  end

  def update
    set = self.class.writeable_columns.map do |col|
      "#{col} = ?"
    end
    DBConnection.execute(<<-SQL, *attribute_values, id)
      UPDATE
        #{self.class.table_name}
      SET
        #{set.join(", ")}
      WHERE
        id = ?
    SQL
  end

  def save
    self.id.nil? ? insert : update
  end
  
  def remove
    DBConnection.execute(<<-SQL, self.id)
      DELETE FROM #{self.class.table_name}
      WHERE id = ?
    SQL
  end 
end

require_relative '../db/db_connection'

module Searchable
  def where(params)
    where_line = params.keys.map {|k| "#{k} = ?"}.join(" AND ")
    res = DBConnection.execute(<<-SQL, *params.values)
      SELECT *
      FROM #{self.table_name}
      WHERE #{where_line}
    SQL
    if res.length > 0 
      res.length > 1 ? res.map {|r| self.send(:new, r)} : self.send(:new, res[0])
    else
      []
    end
  end
end

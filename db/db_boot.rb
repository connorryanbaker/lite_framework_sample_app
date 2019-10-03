require_relative 'db_connection'

DBConnection.open('app.db')
# app_dir = Dir.pwd + '/app'

# Dir.foreach(app_dir) do |f| 
#   if f.end_with?('.rb')
#     table_name = f[0..-4] + 's'
#     DBConnection.execute <<-SQL
#       create table if not exists #{table_name} (
#         id integer primary key
#         )
#     SQL
#   end
# end

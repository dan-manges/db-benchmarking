require "benchmark"

require "bundler"
Bundler.require


# ----- sqlite --------------------

db = SQLite3::Database.new(":memory:")

# Create a table
rows = db.execute <<-SQL
  create table numbers (
    name varchar(30),
    val int
  );
SQL

insert_iterations = 1000
insert_runtime = Benchmark.realtime do
  # Execute a few inserts
  insert_iterations.times do |i|
    db.execute "insert into numbers values ( ?, ? )", [i.to_s, i]
  end
end
puts "sqlite insert runtime (#{insert_iterations} iterations): #{(insert_runtime * 1000).round(3)}ms"

select_runtime = Benchmark.realtime do
  insert_iterations.times do |i|
    db.execute("select * from numbers where val = ?", [i]) do |row|
    end
  end
end
puts "sqlite select runtime (#{insert_iterations} iterations): #{(select_runtime * 1000).round(3)}ms"
puts ""

# ----- postgres --------------------

conn = PG.connect(host: "db", user: "postgres", password: "password")
conn.exec "drop table if exists numbers"
conn.exec <<-SQL
  create table numbers (
    name varchar(30),
    val int
  );
SQL

insert_iterations = 1000
insert_runtime = Benchmark.realtime do
  # Execute a few inserts
  insert_iterations.times do |i|
    conn.exec "insert into numbers values ('#{i}', #{i})"
  end
end
puts "postgres insert runtime (#{insert_iterations} iterations): #{(insert_runtime * 1000).round(3)}ms"

select_runtime = Benchmark.realtime do
  insert_iterations.times do |i|
    conn.exec("select * from numbers where val = #{i}") do |row|
    end
  end
end
puts "postgres select runtime (#{insert_iterations} iterations): #{(select_runtime * 1000).round(3)}ms"

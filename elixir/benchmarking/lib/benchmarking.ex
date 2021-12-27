defmodule Benchmarking do
  @moduledoc """
  Documentation for `Benchmarking`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Benchmarking.hello()
      :world

  """
  def run_all do
    sqlite()
    IO.puts("")
    postgres()
  end

  def sqlite do
    {:ok, conn} = Exqlite.Sqlite3.open(":memory:")
    :ok = Exqlite.Sqlite3.execute(conn, "create table numbers (name varchar(30), val int)")

    insert_runtime = Benchmarking.measure(fn -> Benchmarking.sqlite_inserts(conn) end)
    IO.puts("sqlite insert runtime (1000 iterations): #{Float.round(insert_runtime * 1000, 3)}ms")

    :ok = Exqlite.Sqlite3.execute(conn, "delete from numbers")

    insert2_runtime = Benchmarking.measure(fn -> Benchmarking.sqlite_inserts2(conn) end)
    IO.puts("sqlite insert2 runtime (1000 iterations): #{Float.round(insert2_runtime * 1000, 3)}ms")

    select_runtime = Benchmarking.measure(fn -> Benchmarking.sqlite_selects(conn) end)
    IO.puts("sqlite select runtime (1000 iterations): #{Float.round(select_runtime * 1000, 3)}ms")

    :ok
  end

  def sqlite_inserts(conn) do
    {:ok, statement} = Exqlite.Sqlite3.prepare(conn, "insert into numbers (name, val) values (?1, ?2)")
    Enum.each((1..1000), fn i ->
      # IO.puts(i)
      :ok = Exqlite.Sqlite3.bind(conn, statement, [Integer.to_string(i), i])
      :done = Exqlite.Sqlite3.step(conn, statement)
    end)
  end

  def sqlite_inserts2(conn) do
    Enum.each((1..1000), fn i ->
      :ok = Exqlite.Sqlite3.execute(conn, "insert into numbers (name, val) values ('#{i}', #{i})")
    end)
  end

  def sqlite_selects(conn) do
    Enum.each((1..1000), fn i ->
      {:ok, statement} = Exqlite.Sqlite3.prepare(conn, "select * from numbers where val = #{i}")
      {:row, _} = Exqlite.Sqlite3.step(conn, statement)
      :done = Exqlite.Sqlite3.step(conn, statement)
    end)
  end

  def postgres do
    {:ok, pid} = Postgrex.start_link(hostname: "db", username: "postgres", password: "password", database: "postgres")
    Postgrex.query!(pid, "drop table if exists numbers", [])
    Postgrex.query!(pid, "create table numbers (name varchar(30), val int)", [])

    insert_runtime = Benchmarking.measure(fn -> Benchmarking.postgres_inserts(pid) end)
    IO.puts("postgres insert runtime (1000 iterations): #{Float.round(insert_runtime * 1000, 3)}ms")

    select_runtime = Benchmarking.measure(fn -> Benchmarking.postgres_selects(pid) end)
    IO.puts("postgres select runtime (1000 iterations): #{Float.round(select_runtime * 1000, 3)}ms")

    IO.puts("end postgres")
  end

  def postgres_inserts(pid) do
    Enum.each((1..1000), fn i ->
      _result = Postgrex.query!(pid, "insert into numbers (name, val) values ($1, $2)", [Integer.to_string(i), i])
    end)
  end

  def postgres_selects(pid) do
    Enum.each((1..1000), fn i ->
      _result = Postgrex.query!(pid, "select * from numbers where val = $1", [i])
    end)
  end

  def measure(function) do
    function
    |> :timer.tc
    |> elem(0)
    |> Kernel./(1_000_000)
  end
end

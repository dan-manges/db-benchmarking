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
  def hello do
    {:ok, conn} = Exqlite.Sqlite3.open(":memory:")
    :ok = Exqlite.Sqlite3.execute(conn, "create table numbers (name varchar(30), val int)")

    insert_runtime = Benchmarking.measure(fn -> Benchmarking.inserts(conn) end)
    IO.puts("sqlite insert runtime (1000 iterations): #{Float.round(insert_runtime * 1000, 3)}ms")

    :ok = Exqlite.Sqlite3.execute(conn, "delete from numbers")

    insert2_runtime = Benchmarking.measure(fn -> Benchmarking.inserts2(conn) end)
    IO.puts("sqlite insert2 runtime (1000 iterations): #{Float.round(insert2_runtime * 1000, 3)}ms")

    select_runtime = Benchmarking.measure(fn -> Benchmarking.selects(conn) end)
    IO.puts("sqlite select runtime (1000 iterations): #{Float.round(select_runtime * 1000, 3)}ms")

    IO.puts("hello world")
    :world
  end

  def inserts(conn) do
    {:ok, statement} = Exqlite.Sqlite3.prepare(conn, "insert into numbers (name, val) values (?1, ?2)")
    Enum.each((1..1000), fn i ->
      # IO.puts(i)
      :ok = Exqlite.Sqlite3.bind(conn, statement, [Integer.to_string(i), i])
      :done = Exqlite.Sqlite3.step(conn, statement)
    end)
  end

  def inserts2(conn) do
    Enum.each((1..1000), fn i ->
      :ok = Exqlite.Sqlite3.execute(conn, "insert into numbers (name, val) values ('#{i}', #{i})")
    end)
  end

  def selects(conn) do
    Enum.each((1..1000), fn i ->
      {:ok, statement} = Exqlite.Sqlite3.prepare(conn, "select * from numbers where val = #{i}")
      {:row, _} = Exqlite.Sqlite3.step(conn, statement)
      :done = Exqlite.Sqlite3.step(conn, statement)
    end)
  end

  def measure(function) do
    function
    |> :timer.tc
    |> elem(0)
    |> Kernel./(1_000_000)
  end
end

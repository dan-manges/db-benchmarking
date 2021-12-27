package main

import (
	"database/sql"
	"fmt"
	"log"
	"time"
	_ "github.com/lib/pq"
	_ "github.com/mattn/go-sqlite3"
)

func main() {
	sqliteDb, err := sql.Open("sqlite3", ":memory:")
	if err != nil { log.Fatal(err); return }
	defer sqliteDb.Close()

	pgDb, err := sql.Open("postgres", "host=db user=postgres dbname=postgres password=password sslmode=disable")
	if err != nil { log.Fatal(err); return }
	defer pgDb.Close()

	createTable(sqliteDb)
	createTable(pgDb)

	sqliteInserts(sqliteDb)
	sqliteSelects(sqliteDb)

	fmt.Println("")

	postgresInserts(pgDb)
	postgresSelects(pgDb)
}

func createTable(db *sql.DB) {
	sqlStmt := "create table if not exists numbers (name varchar(30), val int)"
	_, err := db.Exec(sqlStmt)
	if err != nil { log.Printf("%q: %s\n", err, sqlStmt); return }
}

func sqliteInserts(db *sql.DB) {
	defer timeTrack(time.Now(), "sqlite inserts")

	stmt, err := db.Prepare("insert into numbers(name, val) values(?, ?)")
	if err != nil { log.Fatal(err); return }
	defer stmt.Close()

	for i := 0; i < 1000; i++ {
		_, err = stmt.Exec(fmt.Sprintf("%d", i), i)
		if err != nil { log.Fatal(err); return }
	}
}


func postgresInserts(db *sql.DB) {
	defer timeTrack(time.Now(), "postgres inserts")

	stmt, err := db.Prepare("insert into numbers(name, val) values($1, $2)")
	if err != nil { log.Fatal(err); return }
	defer stmt.Close()

	for i := 0; i < 1000; i++ {
		_, err = stmt.Exec(fmt.Sprintf("%d", i), i)
		if err != nil { log.Fatal(err); return }
	}
}

func sqliteSelects(db *sql.DB) {
	defer timeTrack(time.Now(), "sqlite selects")

	stmt, err := db.Prepare("select name from numbers where val = ?")
	if err != nil { log.Fatal(err); return }
	defer stmt.Close()

	var name string
	for i := 0; i < 1000; i++ {
		err = stmt.QueryRow(i).Scan(&name)
		if err != nil { log.Fatal(err); return }
		// fmt.Println(name)
	}
}

func postgresSelects(db *sql.DB) {
	defer timeTrack(time.Now(), "postgres selects")

	stmt, err := db.Prepare("select name from numbers where val = $1")
	if err != nil { log.Fatal(err); return }
	defer stmt.Close()

	var name string
	for i := 0; i < 1000; i++ {
		err = stmt.QueryRow(i).Scan(&name)
		if err != nil { log.Fatal(err); return }
		// fmt.Println(name)
	}
}

func timeTrack(start time.Time, name string) {
	elapsed := time.Since(start)
	log.Printf("%s took %s", name, elapsed)
}

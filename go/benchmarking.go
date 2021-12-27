package main

import (
	"database/sql"
	"fmt"
	_ "github.com/mattn/go-sqlite3"
	"log"
	"time"
)

func main() {
	db, err := sql.Open("sqlite3", ":memory:")
	if err != nil { log.Fatal(err) }
	defer db.Close()

	sqlStmt := "create table numbers (name varchar(30), val int)"
	_, err = db.Exec(sqlStmt)
	if err != nil { log.Printf("%q: %s\n", err, sqlStmt); return }


  sqliteInserts(db)
  sqliteSelects(db)

	fmt.Println("Hello, World!")
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

func timeTrack(start time.Time, name string) {
  elapsed := time.Since(start)
	log.Printf("%s took %s", name, elapsed)
}

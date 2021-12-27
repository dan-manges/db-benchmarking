use rusqlite::{params, Connection};

use postgres::{Client, NoTls};

fn main() {
    // sqlite
    let _ = sqlite().unwrap_or_else( |error| {
        panic!("Problem with sqlite: {:?}", error);
    });

    println!("");

    let _ = pg().unwrap_or_else( |error| {
        panic!("Problem with postgres: {:?}", error);
    });

    println!("Done running rust");
}

fn sqlite() -> rusqlite::Result<()> {
    let conn = Connection::open_in_memory()?;
    conn.execute("create table numbers (name varchar(30), val int)", [])?;

    let time_before = std::time::Instant::now();
    for n in 1..1000 {
      conn.execute("insert into numbers (name, val) values (?1, ?2)", params![n, n])?;
    }
    let runtime = (std::time::Instant::now() - time_before).as_micros();
    println!("sqlite insert runtime {0}ms", (runtime as f32) / 1000.0);

    return Ok(());
}

fn pg() -> Result<Client, postgres::Error> {
   let mut client = Client::connect("host=db user=postgres password=password", NoTls)?;
   client.batch_execute("create table if not exists numbers (name varchar(30), val int)")?;

   let time_before = std::time::Instant::now();
   for _n in 1..1000 {
     client.execute("INSERT INTO numbers (name, val) VALUES ('1', 1)", &[])?;
   }
   let runtime = (std::time::Instant::now() - time_before).as_micros();
   println!("postgres insert runtime {0}ms", (runtime as f32) / 1000.0);

   return Ok(client);
}

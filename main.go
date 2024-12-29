package main

import (
	"database/sql"
	"fmt"
	"log"

	_ "github.com/go-sql-driver/mysql"
)

func main() {
	// Use IPv4 loopback (127.0.0.1) instead of IPv6 (::1)
	dsn := "root:password@tcp(127.0.0.1:3306)/exampledb"
	db, err := sql.Open("mysql", dsn)
	if err != nil {
		log.Fatal("Failed to connect to MySQL:", err)
	}
	defer db.Close()

	if err := db.Ping(); err != nil {
		log.Fatal("Ping failed:", err)
	}
	fmt.Println("Connected to MySQL!")
}

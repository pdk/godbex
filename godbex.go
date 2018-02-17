package main

import (
	"database/sql"
	"fmt"
	"log"
	"time"

	_ "github.com/lib/pq"
)

type JoinedLineItem struct {
	InvoiceNumber int64
	InvoiceDate   time.Time
	CustomerName  string
	Notes         sql.NullString
	LineItemID    int64
	ProductName   string
	ItemCount     int
	CostPerItem   float32
}

func main() {
	db, err := sql.Open("postgres", "user=godbex password=s3kr1tW0r9 host=localhost port=5432 dbname=godbex sslmode=disable")
	dieIfErr(err)

	rows, err := db.Query(`
		select
			invoice.invoice_number,
			invoice.invoice_date,
			invoice.customer_name,
			invoice.notes,
			line_item.line_item_id,
			line_item.product_name,
			line_item.item_count,
			line_item.cost_per_item
		from invoice 
		inner join line_item 
		on invoice.invoice_number = line_item.invoice_number
	`)
	dieIfErr(err)

	for rows.Next() {

		dbResult := JoinedLineItem{}

		err := rows.Scan(
			&dbResult.InvoiceNumber,
			&dbResult.InvoiceDate,
			&dbResult.CustomerName,
			&dbResult.Notes,
			&dbResult.LineItemID,
			&dbResult.ProductName,
			&dbResult.ItemCount,
			&dbResult.CostPerItem,
		)
		dieIfErr(err)

		fmt.Printf("%d %s %f",
			dbResult.LineItemID,
			dbResult.CustomerName,
			dbResult.CostPerItem*float32(dbResult.ItemCount))

		if dbResult.Notes.Valid {
			fmt.Printf(" %s", dbResult.Notes.String)
		}

		fmt.Println()
	}
}

func dieIfErr(err error) {
	if err != nil {
		log.Fatalf("%s", err)
	}
}

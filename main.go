package main

import (
	"log"
	"net/http"

	"github.com/nikimanoledaki/date-setter/pkg/handlers"

	"github.com/gorilla/mux"
)

const (
	port = ":8080"
)

func main() {
	r := mux.NewRouter()
	r.HandleFunc("/date", handlers.Date)

	log.Printf("listening on port %s\n", port)
	log.Fatal(http.ListenAndServe(port, r))
}

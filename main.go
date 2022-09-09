package main

import (
	"bytes"
	"io"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/gorilla/mux"
	"gopkg.in/yaml.v1"
	v1 "k8s.io/api/apps/v1"
	kyaml "k8s.io/apimachinery/pkg/util/yaml"
)

const port = ":8080"

func main() {
	r := mux.NewRouter()
	r.HandleFunc("/date", Date)

	log.Printf("listening on port %s\n", port)
	log.Fatal(http.ListenAndServe(port, r))
}

func Date(w http.ResponseWriter, r *http.Request) {
	f, err := os.ReadFile("./default-deployment.yaml")
	if err != nil {
		log.Fatal(err)
	}

	decoder := kyaml.NewYAMLOrJSONDecoder(bytes.NewReader(f), 100)

	for {
		var dep v1.Deployment
		if err = decoder.Decode(&dep); err != nil {
			if err == io.EOF {
				break
			}
			log.Fatal(err)
		}

		newDep := makeDeploymentName(&dep)

		newManifest, err := yaml.Marshal(newDep)
		if err != nil {
			log.Fatal(err)
		}

		if err := os.WriteFile("./new-deployment.yaml", []byte(newManifest), 0666); err != nil {
			log.Fatal(err)
		}
	}
}

func makeDeploymentName(d *v1.Deployment) *v1.Deployment {
	t := time.Now()
	d.Name = t.Format("01-02-2006-15-04-05")
	return d
}

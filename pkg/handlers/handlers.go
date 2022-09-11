package handlers

import (
	"bytes"
	"io"
	"log"
	"net/http"
	"os"
	"time"

	"gopkg.in/yaml.v1"
	"k8s.io/apimachinery/pkg/apis/meta/v1/unstructured"
	kyaml "k8s.io/apimachinery/pkg/util/yaml"
)

const (
	defaultFilePath   = "build/default-deployment.yaml"
	formattedFilePath = "build/formatted-deployment.yaml"
	defaultTimeFormat = "01-02-2006-15-04-05"
)

func Date(w http.ResponseWriter, r *http.Request) {
	f, err := os.ReadFile(defaultFilePath)
	if err != nil {
		log.Fatal(err)
	}

	decoder := kyaml.NewYAMLOrJSONDecoder(bytes.NewReader(f), 100)

	for {
		var obj unstructured.Unstructured
		if err = decoder.Decode(&obj); err != nil {
			if err == io.EOF {
				break
			}
			log.Fatal(err)
		}

		formattedObj := setName(&obj)

		newManifest, err := yaml.Marshal(formattedObj)
		if err != nil {
			log.Fatal(err)
		}

		if err := os.WriteFile(formattedFilePath, []byte(newManifest), 0666); err != nil {
			log.Fatal(err)
		}
	}
}

func setName(d *unstructured.Unstructured) *unstructured.Unstructured {
	t := time.Now()
	d.SetName(t.Format(defaultTimeFormat))
	return d
}

package main

import (
	"bytes"
	"fmt"
	"io"
	"log"
	"os"
	"time"

	"gopkg.in/yaml.v1"
	"k8s.io/apimachinery/pkg/apis/meta/v1/unstructured"
	kyaml "k8s.io/apimachinery/pkg/util/yaml"
)

const (
	defaultFilePath   = "build/default-deployment.yaml"
	formattedFilePath = "clusters/formatted-deployment.yaml"
	defaultTimeFormat = "01-02-2006-15-04-05"
)

func main() {
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
	os.Exit(0)
}

func setName(d *unstructured.Unstructured) map[string]interface{} {
	t := time.Now()
	d.SetName(fmt.Sprintf("podinfo-%v", t.Format(defaultTimeFormat)))
	return d.UnstructuredContent()
}

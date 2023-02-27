package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"time"
)

// readLines reads a whole file into memory
// and returns a slice of its lines.
func readLines(path string) ([]string, error) {
	file, err := os.Open(path)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	var lines []string
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		lines = append(lines, scanner.Text())
	}
	return lines, scanner.Err()
}

// writeLines writes the lines to the given file.
func writeLines(lines []string, path string) error {
	file, err := os.Create(path)
	if err != nil {
		return err
	}
	defer file.Close()

	w := bufio.NewWriter(file)
	for _, line := range lines {
		fmt.Fprintln(w, line)
	}
	return w.Flush()
}

func weGotWork() bool {
	lines, err := readLines("/tmp/work/items")
	if err == nil && len(lines) > 0 {
		lines = lines[:len(lines)-1]
		if err := writeLines(lines, "/tmp/work/items"); err != nil {
			log.Fatalf("writeLines: %s", err)
		}
		return true
	} else {
		return false
	}
}

func main() {
	counter := 0
	for {
		time.Sleep(5 * time.Second)
		if weGotWork() {
			fmt.Print("We got some work!!!\n")
			for start := time.Now(); time.Since(start) < 120*time.Second; {
				continue
			}
			fmt.Print("Work is done, time to chill!!!\n")
		}
		counter++
		if counter == 12 {
			fmt.Print("--- 60 sec nice heartbeat ---\n")
			counter = 0
		}
	}
}

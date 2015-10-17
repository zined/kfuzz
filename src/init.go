package main

import (
	"log"
	"os"
	"syscall"
)

func main() {
	log.Println("HELLO FROM INIT!\n")

	err := syscall.Mount("udev", "/dev", "devtmpfs", syscall.MS_MGC_VAL|syscall.MS_RELATIME, "")
	if err != nil {
		log.Println("error mounting /dev:", err)
		os.Exit(1)
	}

	log.Println("mounted dev")
	os.Exit(0)
}

all: docker kernel trinity initrd_trinity kvm

docker:
	@echo "#-----------------------------------"
	@echo "#- setup docker"
	@echo "#-----------------------------------"
	docker build -t kernel .

kernel: FORCE
	@echo "#-----------------------------------"
	@echo "#- building kernel inside docker box"
	@echo "#-----------------------------------"
	@mkdir kernel || true
	docker run -t \
		-v $(shell pwd)/scripts:/scripts \
		-v $(shell pwd)/kernel:/kernel \
		kernel /scripts/bzImage_x86_64
FORCE:

init_trinity:
	@echo "#-----------------------------------"
	@echo "#- building trinity inside docker box"
	@echo "#-----------------------------------"
	@mkdir initrd || true
	@rm -vf initrd.gz || true
	@rm -vf initrd/* || true
	docker run -t \
		-v $(shell pwd)/scripts:/scripts \
		-v $(shell pwd)/initrd:/initrd \
		kernel /scripts/trinity

init_c: src/init.c
	@echo "#-----------------------------------"
	@echo "#- building C initrd"
	@echo "#-----------------------------------"
	@mkdir initrd || true
	@rm -vf initrd.gz || true
	@rm -vf initrd/* || true
	gcc -o initrd/init -static src/init.c

init_go: src/init.go
	@echo "#-----------------------------------"
	@echo "#- building GO initrd"
	@echo "#-----------------------------------"
	@mkdir initrd || true
	@rm -vf initrd.gz || true
	@rm -vf initrd/* || true
	( cd initrd && go build ../src/init.go )

initrd: initrd/init
	@echo "#-----------------------------------"
	@echo "#- building initrd"
	@echo "#-----------------------------------"
	( cd initrd/ && find . | cpio -o -H newc ) | gzip > initrd.gz

kvm:
	@echo "#-----------------------------------"
	@echo "#- starting VM"
	@echo "#-----------------------------------"
	# sudo kvm -curses -kernel kernel/bzImage -initrd initrd.gz
	# sudo kvm -vnc :1 -kernel kernel/bzImage -initrd initrd.gz
	sudo kvm -smp cpus=4 -nographic -kernel kernel/bzImage -append "console=ttyS0" -initrd initrd.gz

clean:
	@echo "#-----------------------------------"
	@echo "#- cleaning up"
	@echo "#-----------------------------------"
	@rm -vf initrd.gz || true
	@rm -vf initrd/* || true
	@rm -vf kernel/bzImage || true

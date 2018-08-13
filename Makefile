.PHONY: build
build:
	@docker build -t cobbler_base:0.1 .

.PHONY: fakerun
fakerun:
	@docker run -itd --name cobbler \
        --privileged \
        --net host \
        -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
        -v $(shell pwd)/etc/cobbler/settings:/etc/cobbler/settings \
        -v $(shell pwd)/etc/cobbler/dhcp.template:/etc/cobbler/dhcp.template \
        -v $(shell pwd)/etc/cobbler/dnsmasq.template:/etc/cobbler/dnsmasq.template \
        -v $(shell pwd)/dist/centos:/mnt:ro \
        -v $(shell pwd)/var/www/cobbler/images:/var/www/cobbler/images \
        -v $(shell pwd)/var/www/cobbler/ks_mirror:/var/www/cobbler/ks_mirror \
        -v $(shell pwd)/var/www/cobbler/links:/var/www/cobbler/links \
        -v $(shell pwd)/var/lib/cobbler/config:/var/lib/cobbler/config \
        -v $(shell pwd)/var/lib/tftpboot:/var/lib/tftpboot \
	-v $(shell pwd)/var/log/cobbler:/var/log/cobbler \
	-v $(shell pwd)/vfiles:/vfiles \
        -p 69:69 \
        -p 80:80 \
        -p 443:443 \
        -p 25151:25151 \
        cobbler_base:0.1

.PHONY: run
run:
	@docker run -itd --name cobbler \
	--privileged \
	--net host \
	-v /sys/fs/cgroup:/sys/fs/cgroup:ro \
	-v $(shell pwd)/etc/cobbler/settings:/etc/cobbler/settings \
	-v $(shell pwd)/etc/cobbler/dhcp.template:/etc/cobbler/dhcp.template \
        -v $(shell pwd)/etc/cobbler/dnsmasq.template:/etc/cobbler/dnsmasq.template \
	-v $(shell pwd)/dist/centos:/mnt:ro \
	-v $(shell pwd)/vfiles:/vfiles \
	-p 69:69 \
	-p 80:80 \
	-p 443:443 \
	-p 25151:25151 \
	cobbler_base:0.1

.PHONY: mountos_all
mountos_all:
	sudo mount -t iso9660 -o loop,ro -v ~/CentOS-7-x86_64-Everything-1804.iso $(shell pwd)/dist/centos

.PHONY: mountos_mini
mountos_mini:
	sudo mount -t iso9660 -o loop,ro -v ~/CentOS-7-x86_64-Minimal-1804.iso $(shell pwd)/dist/centos

.PHONY: umount
umount:
	sudo umount $(shell pwd)/dist/centos

.PHONY: tty
tty:
	@docker exec -it cobbler /bin/bash

.PHONY: restart
restart:
	@docker stop cobbler; docker rm -vf cobbler ; make umount; make mountos_all; make fakerun

.PHONY: rmrun
rmrun:
	docker stop cobbler; docker rm cobbler

.PHONY: clean
clean:
	@docker rm cobbler > /dev/null



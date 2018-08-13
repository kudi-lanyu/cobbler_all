FROM centos:7.5.1804

MAINTAINER mengliang1268@gmail.com

# epel-release
RUN yum -y install epel-release
RUN yum -y install wget

RUN wget -O /etc/yum.repos.d/cobbler28.repo http://download.opensuse.org/repositories/home:/libertas-ict:/cobbler28/CentOS_7/home:libertas-ict:cobbler28.repo

# cobbler and cobbler web
RUN yum -y install cobbler cobbler-web 
# httpd for the webfrontend of cobbler-web
RUN yum -y install httpd xinetd
# dhcp arrange ip
RUN yum -y install dhcp 
# tftp for pxe
RUN yum -y install tftp-server
# dns server management . 
RUN yum -y install dnsmasq bind
# pykickstart checkout the right of kickstart config. 
RUN yum -y install pykickstart
# syslinux
RUN yum -y install syslinux 
# tools
RUN ["yum","-y","install","vim","which"] 

# RUN yum -y update
RUN yum clean all
#RUN yum makecache

VOLUME [ "/sys/fs/cgroup" ]

# https://container-solutions.com/cobbler-in-a-docker-container/
RUN systemctl enable cobblerd
RUN systemctl enable httpd
RUN systemctl enable dhcpd
RUN systemctl enable xinetd
RUN systemctl enable rsyncd

# Then we change the tftp xinetd config file to enable the tftp service.
# enable tftp
RUN sed -i -e 's/\(^.*disable.*=\) yes/\1 no/' /etc/xinetd.d/tftp

# make sure the rsync file exists, or else Cobbler will fail to start
# create rsync file
RUN touch /etc/xinetd.d/rsync

EXPOSE 69
EXPOSE 80
EXPOSE 443
EXPOSE 25151

CMD  ["/sbin/init"]

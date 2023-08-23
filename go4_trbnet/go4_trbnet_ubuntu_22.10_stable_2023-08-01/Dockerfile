##################################################
##        get minimal distro from cloud         ##
##################################################

FROM ubuntu:22.10



##################################################
##                prerequisites                 ##
##################################################

### install system packages with ubuntu package manager

RUN \
  apt update && \
  apt upgrade -y && \
  apt dist-upgrade -y && \
  DEBIAN_FRONTEND=noninteractive \
  DEBCONF_NONINTERACTIVE_SEEN=true \
  TZ=Etc/UTC \
  apt install -y \
    bash rsyslog wget \
    xterm screen xvfb x11vnc tigervnc-tools tigervnc-viewer tigervnc-standalone-server openbox \
    cmake gcc g++ gfortran binutils \
    rpcbind isc-dhcp-server iptables \
    net-tools iputils-ping \
    git tig subversion perl \
    libxml-libxml-perl libfile-chdir-perl libtimedate-perl \
    libdata-treedumper-perl \
    libtirpc-dev libcgi-pm-perl \
    firefox \
    gnuplot imagemagick graphviz-dev mesa-common-dev \
    vim emacs \
    htop which psmisc \
    tmux lxpanel ncdu \
    libx11-dev libxpm-dev libxft-dev libxext-dev libglu-dev libglew-dev \
    libpcre2-dev libxml2-dev libkrb5-dev libgsl-dev \
    libcurl4-openssl-dev libldap-dev fftw3-dev libcfitsio-dev \
    patch pkg-config \
    qt5-qmake qtbase5-dev \
    libmysqlclient-dev \
    libboost-dev \
    python3-pip python3-prettytable python3-dialog \
    python3-dev python3-setuptools python3-numpy

## cleanup of files from setup
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


### install perl modules from cpan ###
# RUN cpan Data::TreeDumper CGI::Carp
# RUN cpan CGI::Carp

### install python modules from pip ###
# RUN pip install --upgrade pip && pip install prettytable pythondialog



##################################################
##              Go4 + dabc + root               ##
##################################################

# newest commit
ENV DABC_TRB3_REV=HEAD

# newest commit from 2018-02-28
#ENV DABC_TRB3_REV=4242 

##################################################

RUN mkdir /cern; cd /cern; \
    wget https://root.cern/download/root_v6.28.04.Linux-ubuntu22-x86_64-gcc11.3.tar.gz; \
    tar -xzf root_v6.28.04.Linux-ubuntu22-x86_64-gcc11.3.tar.gz

ENV ROOTSYS /cern/root

RUN svn checkout -r $DABC_TRB3_REV https://subversion.gsi.de/dabc/trb3; \
    sed -e "s/source /. /g" -i /trb3/Makefile;


RUN cd /trb3; \
  > /tmp/trb3_make_exit_value; \
  { make -j4; echo $? > /tmp/trb3_make_exit_value; killall tail; }& \
  echo -e "\n\n---- display make log: ----\n\n"; \
  tail -F ./stream/makelog.txt & \
  tail -F ./go4/makelog.txt & \
  tail -F ./dabc/makelog.txt & \
  wait; \
  echo -e "\n\n---- end of make log: ----\n\n"; \
  $( exit $(cat /tmp/trb3_make_exit_value) )



##################################################
##                    trbnet                    ##
##################################################

# newest commit
ENV TRBNET_COMMIT=master

# last stable commit
#ENV TRBNET_COMMIT=02cf41a486d64bc894986fe87c174bfe1b07fc9b 
# newest version of trbnettools does not work with this system ... revert to older commit ###
# has something to do with commit 0cd022a9b0bda2213989eef118a1dda077794ba9 
# 2019-01-24 00:17 Michael Traxler ----  added -ltirpc in Makesfiles for a working RPC implementation, mt 
# commit breaks rpc communication

##################################################

ADD libtrbnet_tirpc_includes.patch /

RUN git clone git://jspc29.x-matter.uni-frankfurt.de/projects/trbnettools.git &&\
  cd /trbnettools &&\
  patch -p1 < /libtrbnet_tirpc_includes.patch && \
  git checkout $TRBNET_COMMIT &&\
  cd /trbnettools/libtrbnet_perl && \
  perl Makefile.PL && \
  cd /trbnettools/libtrbnet_python && \
  python3 setup.py install && \
  cd /trbnettools && \
  make clean && \
  make TRB3=1 && \
  make TRB3=1 -j4 install && \
  echo "/trbnettools/liblocal" >> /etc/ld.so.conf.d/trbnet.conf && \
  ldconfig -v

ENV PATH=$PATH:/trbnettools/bin




##################################################
##                   daqtools                   ##
##################################################

# newest commit
ENV DAQTOOLS_COMMIT=master

# newest commit from 2018-02-28
#ENV DAQTOOLS_COMMIT=4840d304ad9cce93ffe972ef8cff4c325d7ac198

##################################################

RUN git clone git://jspc29.x-matter.uni-frankfurt.de/projects/daqtools.git && \
  cd /daqtools && \
  git checkout $DAQTOOLS_COMMIT && \
  cd /daqtools/xml-db && \
 ./xml-db.pl

### replace httpi with a modified version, because the httpi in daqtools won't run as root
COPY build_files/httpi /daqtools/web/httpi

COPY build_files/bash_aliases /root/.bash_aliases














##################################################
##          additional changes/updates          ##
##################################################

# go ahead, customize your container 
# delete/comment out changes to revert them again and return
# to a previous state

### install additional perl modules from cpan ###
#RUN cpan ExamplePerlModule

### install python modules from pip ###
#RUN pip install --upgrade pip && pip install example_python_module

### install additional system packages with opensuse package manager
#RUN zypper refresh && zypper --non-interactive in \
#  example_package_1 \
#  example_package_2 \
#  example_package_3


##################################################
## update dabc/stream/go4 to the newest version ##
##################################################

RUN cd /trb3/; . /trb3/trb3login;  make -j4 update



##################################################
##               update daqtools                ##
##################################################

RUN cd /daqtools; git checkout master; git pull &&\
  cd /daqtools/xml-db && \
 ./xml-db.pl

### overwrite httpi again with a custom version so it can run as root
COPY build_files/httpi /daqtools/web/httpi


##################################################
##              update trbnettools              ##
##################################################

RUN  cd /trbnettools &&\
  git checkout master &&\
  git pull &&\
  cd /trbnettools/libtrbnet_perl && \
  perl Makefile.PL && \
  cd /trbnettools && \
  make clean && \
  make TRB3=1 -j4 && \
  make TRB3=1 install && \
  ldconfig -v

ARG STEP10=1

RUN git clone https://github.com/HADES-Cracovia/pasttrectools && \
  cd /pasttrectools && \
  git checkout trb_3_5_merge && \
  python3 setup.py install

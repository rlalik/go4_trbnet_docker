##################################################
##     get prebuilt image from docker cloud     ##
##################################################

FROM acidbourbon/go4_trbnet_leap_15.0:stable_2019-03-01
# see prebuilt_Dockerfile for "content" of prebuilt image


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

#RUN cd /trb3/; . /trb3/trb3login;  make -j4 update



##################################################
##               update daqtools                ##
##################################################

#RUN cd /daqtools; git checkout master; git pull &&\
#  cd /daqtools/xml-db && \
# ./xml-db.pl

### overwrite httpi again with a custom version so it can run as root
#COPY build_files/httpi /daqtools/web/httpi 


##################################################
##              update trbnettools              ##
##################################################

#RUN  cd /trbnettools &&\
#  git checkout master &&\
#  git pull &&\
#  cd /trbnettools/libtrbnet_perl && \
#  perl Makefile.PL && \
#  cd /trbnettools && \
#  make clean && \
#  make TRB3=1 && \
#  make TRB3=1 install && \
#  ldconfig -v





FROM alpine:3.6
MAINTAINER xxmyj.k@gmail.com

# add install.sh script
ADD ./script/install.sh /opt/install.sh
#ADD ./script/my.conf /opt/my.conf

# run install.sh
RUN sh -c /opt/install.sh

# start
#CMD echo hello, world.

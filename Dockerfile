FROM ubuntu:12.10
MAINTAINER Gary Turovsky "gary@spantree.net"

RUN apt-get -y update
RUN apt-get -y install rubygems git 
RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc
RUN gem install puppet librarian-puppet

ADD puppet/hiera.yaml /etc/puppet/
ADD puppet /puppet

WORKDIR /puppet

RUN librarian-puppet install

ENV FACTER_LSBDISTID debian

RUN puppet apply --verbose --debug --modulepath=modules manifests/default.pp  

# Define working directory.
WORKDIR /data

VOLUME ["/data"]

# Define default command.
CMD ["java", "-Djetty.home=/opt/jetty", "-jar", "/opt/jetty/start.jar"]

# Expose ports.
#   - 9200: HTTP
#   - 9300: transport
EXPOSE 9200
EXPOSE 9300
EXPOSE 54328
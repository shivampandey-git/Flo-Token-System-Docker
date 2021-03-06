# getting base image ubuntu
FROM python:3.9.0-slim
ENV DEBIAN_FRONTEND=noninteractive

MAINTAINER shivam<mailbox.shivampandey@gmail.com>

CMD {"echo","Ranchi Mall"}

FROM ubuntu:latest

RUN apt-get update
RUN apt-get -y install python3-pip
RUN pip install --upgrade pip
RUN apt-get install
RUN apt-get -y install git

## for apt to be noninteractive
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

#RUN apt-get -y install python-chardet
RUN apt-get -y install libsecp256k1-dev
RUN apt-get -y install libssl-dev build-essential automake pkg-config libtool libffi-dev libgmp-dev libyaml-cpp-dev
Run git clone https://github.com/ranchimall/ranchimallflo-api
WORKDIR ranchimallflo-api

RUN pip3 install -r requirements.txt
RUN pip3 install apscheduler
RUN touch config.py
RUN echo "dbfolder = '/home/production/dev/shivam/ranchimallflo-api' \n\
sse_pubKey = '''''''' \n\
apiUrl = 'https://flosight.duckdns.org/api/' \n\
apilayerAccesskey = ''''''' \n\
FLO_DATA_DIR = '/home/production/.flo' " >> /ranchimallflo-api/config.py
RUN python3 ranchimallflo_api.py
RUN git clone https://github.com/vivekteega/ftt-docker
WORKDIR ftt-docker
RUN sed -i "s|chardet==4.0.0|chardet|g" /ftt-docker/requirements.txt
RUN pip3 install -r requirements.txt

RUN touch config.ini
RUN echo "[DEFAULT] \n\
NET = testnet \n\
FLO_CLI_PATH = /usr/local/bin/flo-cli \n\
START_BLOCK = 740400" >> /ftt-docker/config.ini

RUN touch config.py
RUN echo "committeeAddressList = ['''''''''] \n\
sseAPI_url = 'https://ranchimallflo-testnet.duckdns.org/' \n\
privKey = ''''''' " >> /ftt-docker/config.py
RUN git clone https://github.com/ranchimall/pyflo
WORKDIR pyflo
RUN python3 setup.py install
WORKDIR ../
Run python3 tracktokens-smartcontracts.py

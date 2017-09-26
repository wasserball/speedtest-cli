FROM python:3.6.2

MAINTAINER Nick "wasserball@me.com"

ENV SPEEDTEST_CLI_VERSION 1.0.6

RUN pip install speedtest-cli==$SPEEDTEST_CLI_VERSION

RUN mkdir /data
COPY output.csv /data/
COPY entrypoint.sh /



CMD bash /entrypoint.sh
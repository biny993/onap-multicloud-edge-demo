FROM python:2

ARG HTTP_PROXY=${HTTP_PROXY}
ARG HTTPS_PROXY=${HTTPS_PROXY}

ENV http_proxy $HTTP_PROXY
ENV https_proxy $HTTPS_PROXY

ENV MSB_ADDR "127.0.0.1"
ENV MSB_PORT "80"
ENV AAI_ADDR "aai.api.simpledemo.openecomp.org"
ENV AAI_PORT "8443"
ENV AAI_SCHEMA_VERSION "v13"
ENV AAI_USERNAME "AAI"
ENV AAI_PASSWORD "AAI"

EXPOSE 9010

# COPY ./ /opt/dmaapclient/
COPY ./multicloud-openstack-dmaapclient-1.2.0-SNAPSHOT.zip /opt/multicloud-openstack-dmaapclient.zip

RUN apt-get update && \
    apt-get install -y memcached && \
    apt-get install -y rabbitmq-server && \
    apt-get install -y unzip && \
    cd /opt/ && \
    unzip -q -o -B multicloud-openstack-dmaapclient.zip && \
    chmod +x /opt/dmaapclient/*.sh && \
    rm -f multicloud-openstack-dmaapclient.zip && \
    pip install -r /opt/dmaapclient/requirements.txt

WORKDIR /opt/dmaapclient
CMD /bin/sh -c /opt/dmaapclient/run.sh

1, Build docker image:

$ git clone https://github.com/biny993/onap-multicloud-edge-demo.git

$ cd onap-multicloud-edge-demo/docker4dmaapclient
$ sudo docker build -t openstack-dmaapclient:latest .

2, launch docker container:
### make sure the docker container runs on ONAP VMs (vm0-multi-service) which has access to other ONAP VMs (aai, message router, etc.)

export DMAAP_IP=10.0.11.1

export AAI_IP1=10.0.1.1
export AAI_PORT1=8443

export MULTISERVICE_IP=10.0.14.1

export MSB_EP_PORT=80
export MC_TIC_PORT=9005
export DC_EP_PORT=9010


#### launch docker container
### note: dmaapclient must register to msb where could redirect the api to multicloud-titaniumcloud
docker run -d -t -e MSB_ADDR=$MULTISERVICE_IP -e MSB_PORT=$MSB_EP_PORT -e AAI_ADDR=$AAI_IP1 -e AAI_PORT=$AAI_PORT1 -p 9010:$DC_EP_PORT --name  dmaapclient openstack-dmaapclient

### verify dmaapclient health
curl -v -s -H "Content-Type: application/json" -X GET  http://$MULTISERVICE_IP:$DC_EP_PORT/sample


### retrieve the configuration rules
curl -v -s -H "Content-Type: application/json" -X GET  http://$MULTISERVICE_IP:$DC_EP_PORT/api/multicloud-dmaapclient/v1/dmaapclient

### delete the configuration rules
curl -v -s -H "Content-Type: application/json" -X DELETE  http://$MULTISERVICE_IP:$DC_EP_PORT/api/multicloud-dmaapclient/v1/dmaapclient


### exercise dmaapclient:

curl -v -s -H "Content-Type: application/json" http://$MULTISERVICE_IP:$DC_EP_PORT/api/multicloud-dmaapclient/v1/dmaapclient -X POST -d '{"dmaapclient_config":{"topic_subscribe_url":"http://$DMAAP_IP:3904/events/APPC-LCM-READ/dmaapclient/304?timeout=6000&limit=10&filter="} }'

curl -v -s -H "Content-Type: application/json" -X GET  http://$MULTISERVICE_IP:$DC_EP_PORT/api/multicloud-dmaapclient/v1/dmaapclient

curl -v -s -H "Content-Type: application/json" -X DELETE  http://$MULTISERVICE_IP:$DC_EP_PORT/api/multicloud-dmaapclient/v1/dmaapclient


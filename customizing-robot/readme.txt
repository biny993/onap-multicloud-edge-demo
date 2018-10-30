Note: verified with HEAT based ONAP beijing release. 


1, prerequistes
	### login to Robot VM
	$ export ROBOT_IP=<robot VM IP>
	$ ssh -o StrictHostKeychecking=no -i ~/.ssh/onap_key ubuntu@$ROBOT_IP
	### execute the init script
	$ sudo /opt/demo.sh init
	
2, Build the customize the robot service
	1, clone and branch
		$ git clone https://gerrit.onap.org/r/testsuite
		$ cd testsuite
		$ git  branch customization1
		$ git checkout customization1
		$ git clone https://gerrit.onap.org/r/testsuite/heatbridge
		$ git clone https://gerrit.onap.org/r/testsuite/properties
		$ git clone https://gerrit.onap.org/r/testsuite/python-testing-utils
		$ git fetch https://gerrit.onap.org/r/testsuite refs/changes/29/64929/1 && git cherry-pick FETCH_HEAD

	
	2, build docker images
		$ cd testsuites
		$ cp docker/* .
		$ sudo docker -D build -t my_testsuite .
		

3 Deploy customized robot service onto robot VM:
	### bring down the original container
	$ sudo docker stop myrobot
	$ sudo docker rm myrobot

	### start the docker container
	$sudo docker run -d --name myrobot -v /opt/eteshare:/share -p 98:98 my_testsuite

	### customize the demo.sh
	$ sudo wget https://github.com/biny993/onap-multicloud-edge-demo/tree/master/customizing-robot/mydemo.sh /opt/mydemo.sh
	$ sudo chmod +x /opt/mydemo.sh

	
*** Appendix/exercises:

Prerequist: init customer and models
sudo /opt/mydemo.sh init

Exercise 1: Add complex

### using robot script, add complex object clli3:
sudo /opt/mydemo.sh add_complex clli3 10 20

Exercise 2:

### using robot script, add customer democust1 with service type: vLB
sudo /opt/mydemo.sh add_customer democust1 vLB

Exercise 3:

### using ESR GUI Portal, on-board a cloud region: (CloudOwner/pod01, tenant name: VIM)
http://msb.api.simpledemo.onap.org/iui/aai-esr-gui/extsys/vim/vimView.html


### using robot script, associate the customer with the on-boarded cloud region (CloudOwner/pod01) and tenant name "VIM"
sudo /opt/mydemo.sh associate_customer democust1 vLB CloudOwner pod01 VIM


Exercise 4: preload VNF data

### Prepare the heat env file as VF module preload data
	ubuntu@vm0-robot:~/testsuite$ cat /opt/eteshare/vfmoduledata/vlb-vfmodule-1.env 
	parameters:
	  vlb_image_name: ubuntu-16-04-cloud-amd64
	  vlb_flavor_name: m1.large
	  public_net_id: 00000000-0000-0000-0000-000000000000


### using VID, create a service instance, add generic vnf:
http://portal.api.simpledemo.onap.org:8989/ONAPPORTAL/login.htm

### using robot script, Preload the VF Module data with vlb-vfmodule-1.env
sudo /opt/mydemo.sh preload_vfmodule  vlb-vnf-1 vlb-vfmodule-1 vlb..module-0 vlb-vfmodule-1.env

### using browser, check the preloaded data
http://:8282/restconf/config/VNF-API:preload-vnfs/vnf-preload-list/vlb-vfmodule-1/E1b6744dD69a4c4eA8b3..base_vlb..module-0
	user: admin
	pass: Kp8bJ4SXszM0WXlhak3eHlcse2gAw84vaoGGmJvUy2U

#!/bin/bash

function build_image {
    docker build build -t openstack-dmaapclient:latest .
}

build_image
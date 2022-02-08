#!/bin/bash
export HOST_IP=$(ipconfig | grep IPv4 | cut -d: -f2 | sed -n 3p)
echo $HOST_IP
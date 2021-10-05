#!/bin/bash

sudo  wget  -O Dynatrace-OneAgent-Linux-1.225.146.sh "https://dhu43296.live.dynatrace.com/api/v1/deployment/installer/agent/unix/default/latest?arch=x86&flavor=default" --header="Authorization: Api-Token dt0c01.JKFX2ELPFPRA5O5N64GCR25Z.BQNRJ7X2IWQ7XMWCJMGZGVXXCOAORSGVHQJT7FKCPJDEJVC7IWZIBDT7XHLOWAXL"

sudo wget https://ca.dynatrace.com/dt-root.cert.pem ; ( echo 'Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha-256"; boundary="--SIGNED-INSTALLER"'; echo ; echo ; echo '----SIGNED-INSTALLER' ; cat Dynatrace-OneAgent-Linux-1.225.146.sh ) | openssl cms -verify -CAfile dt-root.cert.pem > /dev/null

sudo /bin/sh Dynatrace-OneAgent-Linux-1.225.146.sh

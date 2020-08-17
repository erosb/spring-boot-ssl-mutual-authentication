#!/bin/bash

rm $(find . -name '*.jks')
rm $(find . -name '*.cer')


SRV_RES="secure-server/src/main/resources"
CL1_RES="secure-client/src/main/resources"
CL2_RES="secure-client2/src/main/resources"


# Generate server keypair
keytool -genkeypair -alias secure-server -keyalg RSA -dname "CN=localhost,OU=myorg,O=myorg,L=mycity,S=mystate,C=es" \
 -keypass secret \
 -keystore "${SRV_RES}/server-keystore.jks"  \
 -storepass secret

# Generate client1 keypair
keytool -genkeypair -alias secure-client -keyalg RSA -dname "CN=codependent-client,OU=myorg,O=myorg,L=mycity,S=mystate,C=es" \
 -keypass secret \
 -keystore "${CL1_RES}/client-keystore.jks" \
 -storepass secret
 
# Put client cert into server TrustS
keytool -exportcert -alias secure-client -file client-public.cer -keystore "${CL1_RES}/client-keystore.jks" -storepass secret
keytool -importcert -keystore "${SRV_RES}/server-truststore.jks" -alias clientcert -file client-public.cer -storepass secret

# Put server cert into client TrustS
keytool -exportcert -alias secure-server -file server-public.cer -keystore "${SRV_RES}/server-keystore.jks" -storepass secret
keytool -importcert -keystore "${CL1_RES}/client-truststore.jks" -alias servercert -file server-public.cer -storepass secret


rm server-public.cer client-public.cer

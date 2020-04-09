# VPN Quick docs

Instruction to create a peer cert, ca key in SSM

```
export USER_ID=username
strongswan pki --gen -t rsa -s 4096 -f pem > ${USER_ID}.key
strongswan pki --issue --in ${USER_ID}.key -f pem --type priv --cacert ca.cert --cakey ca.key \
    --dn "C=GB, O=HMPPS, CN=${USER_ID}" --san ${USER_ID} > ${USER_ID}.cert


openssl pkcs12 -in ${USER_ID}.cert -inkey ${USER_ID}.key -certfile ca.cert  -export -out ${USER_ID}.p12


Mac client setup

server address: XXXXXXXXXXX
remote id: server
local id: username

```

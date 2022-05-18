# source scriptUtils.sh
export PATH=${PWD}/../bin:$PATH

certificatesForFarmer() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p consortium/crypto-config/peerOrganizations/farmer/
  export FABRIC_CA_CLIENT_HOME=${PWD}/consortium/crypto-config/peerOrganizations/farmer/

   
  fabric-ca-client enroll -u https://admin:adminpw@localhost:1010 --caname ca.farmer --tls.certfiles ${PWD}/consortium/fabric-ca/farmer/tls-cert.pem
   

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-1010-ca-farmer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-1010-farmer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-1010-farmer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-1010-farmer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/consortium/crypto-config/peerOrganizations/farmer/msp/config.yaml

  echo
  echo "Register peer0 (farmer)"
  echo
  fabric-ca-client register --caname ca.farmer --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/consortium/fabric-ca/farmer/tls-cert.pem

  echo
  echo "Register peer1 (farmer)"
  echo
  fabric-ca-client register --caname ca.farmer --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/consortium/fabric-ca/farmer/tls-cert.pem

  echo
  echo "Register user (farmer)"
  echo
  fabric-ca-client register --caname ca.farmer --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/consortium/fabric-ca/farmer/tls-cert.pem

  echo
  echo "Register the org admin (farmer)"
  echo
  fabric-ca-client register --caname ca.farmer --id.name farmeradmin --id.secret farmeradminpw --id.type admin --tls.certfiles ${PWD}/consortium/fabric-ca/farmer/tls-cert.pem


# Create a directory for peers
  mkdir -p consortium/crypto-config/peerOrganizations/farmer/peers

  # -----------------------------------------------------------------------------------
  #  Peer 0
  mkdir -p consortium/crypto-config/peerOrganizations/farmer/peers/peer0.farmer

  echo
  echo "## Generate the peer0 msp (farmer)"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:1010 --caname ca.farmer -M ${PWD}/consortium/crypto-config/peerOrganizations/farmer/peers/peer0.farmer/msp --csr.hosts peer0.farmer --tls.certfiles ${PWD}/consortium/fabric-ca/farmer/tls-cert.pem

  cp ${PWD}/consortium/crypto-config/peerOrganizations/farmer/msp/config.yaml ${PWD}/consortium/crypto-config/peerOrganizations/farmer/peers/peer0.farmer/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates (farmer)"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:1010 --caname ca.farmer -M ${PWD}/consortium/crypto-config/peerOrganizations/farmer/peers/peer0.farmer/tls --enrollment.profile tls --csr.hosts peer0.farmer --csr.hosts localhost --tls.certfiles ${PWD}/consortium/fabric-ca/farmer/tls-cert.pem

  cp ${PWD}/consortium/crypto-config/peerOrganizations/farmer/peers/peer0.farmer/tls/tlscacerts/* ${PWD}/consortium/crypto-config/peerOrganizations/farmer/peers/peer0.farmer/tls/ca.crt
  cp ${PWD}/consortium/crypto-config/peerOrganizations/farmer/peers/peer0.farmer/tls/signcerts/* ${PWD}/consortium/crypto-config/peerOrganizations/farmer/peers/peer0.farmer/tls/server.crt
  cp ${PWD}/consortium/crypto-config/peerOrganizations/farmer/peers/peer0.farmer/tls/keystore/* ${PWD}/consortium/crypto-config/peerOrganizations/farmer/peers/peer0.farmer/tls/server.key

  mkdir ${PWD}/consortium/crypto-config/peerOrganizations/farmer/msp/tlscacerts
  cp ${PWD}/consortium/crypto-config/peerOrganizations/farmer/peers/peer0.farmer/tls/tlscacerts/* ${PWD}/consortium/crypto-config/peerOrganizations/farmer/msp/tlscacerts/ca.crt

  mkdir ${PWD}/consortium/crypto-config/peerOrganizations/farmer/tlsca
  cp ${PWD}/consortium/crypto-config/peerOrganizations/farmer/peers/peer0.farmer/tls/tlscacerts/* ${PWD}/consortium/crypto-config/peerOrganizations/farmer/tlsca/tlsca.farmer-cert.pem

  mkdir ${PWD}/consortium/crypto-config/peerOrganizations/farmer/ca
  cp ${PWD}/consortium/crypto-config/peerOrganizations/farmer/peers/peer0.farmer/msp/cacerts/* ${PWD}/consortium/crypto-config/peerOrganizations/farmer/ca/ca.farmer-cert.pem

  # ------------------------------------------------------------------------------------------------

  # Peer1

  mkdir -p consortium/crypto-config/peerOrganizations/farmer/peers/peer1.farmer

  echo
  echo "## Generate the peer1 msp (farmer)"
  echo
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:1010 --caname ca.farmer -M ${PWD}/consortium/crypto-config/peerOrganizations/farmer/peers/peer1.farmer/msp --csr.hosts peer1.farmer --tls.certfiles ${PWD}/consortium/fabric-ca/farmer/tls-cert.pem

  cp ${PWD}/consortium/crypto-config/peerOrganizations/farmer/msp/config.yaml ${PWD}/consortium/crypto-config/peerOrganizations/farmer/peers/peer1.farmer/msp/config.yaml

  echo
  echo "## Generate the peer1-tls certificates (farmer)"
  echo
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:1010 --caname ca.farmer -M ${PWD}/consortium/crypto-config/peerOrganizations/farmer/peers/peer1.farmer/tls --enrollment.profile tls --csr.hosts peer1.farmer --csr.hosts localhost --tls.certfiles ${PWD}/consortium/fabric-ca/farmer/tls-cert.pem

  cp ${PWD}/consortium/crypto-config/peerOrganizations/farmer/peers/peer1.farmer/tls/tlscacerts/* ${PWD}/consortium/crypto-config/peerOrganizations/farmer/peers/peer1.farmer/tls/ca.crt
  cp ${PWD}/consortium/crypto-config/peerOrganizations/farmer/peers/peer1.farmer/tls/signcerts/* ${PWD}/consortium/crypto-config/peerOrganizations/farmer/peers/peer1.farmer/tls/server.crt
  cp ${PWD}/consortium/crypto-config/peerOrganizations/farmer/peers/peer1.farmer/tls/keystore/* ${PWD}/consortium/crypto-config/peerOrganizations/farmer/peers/peer1.farmer/tls/server.key

  # --------------------------------------------------------------------------------------------------

  mkdir -p consortium/crypto-config/peerOrganizations/farmer/users
  mkdir -p consortium/crypto-config/peerOrganizations/farmer/users/User1@farmer

  echo
  echo "## Generate the user msp (farmer)"
  echo
  fabric-ca-client enroll -u https://user1:user1pw@localhost:1010 --caname ca.farmer -M ${PWD}/consortium/crypto-config/peerOrganizations/farmer/users/User1@farmer/msp --tls.certfiles ${PWD}/consortium/fabric-ca/farmer/tls-cert.pem

  mkdir -p consortium/crypto-config/peerOrganizations/farmer/users/Admin@farmer

  echo
  echo "## Generate the org admin msp (farmer)"
  echo
  fabric-ca-client enroll -u https://farmeradmin:farmeradminpw@localhost:1010 --caname ca.farmer -M ${PWD}/consortium/crypto-config/peerOrganizations/farmer/users/Admin@farmer/msp --tls.certfiles ${PWD}/consortium/fabric-ca/farmer/tls-cert.pem

  cp ${PWD}/consortium/crypto-config/peerOrganizations/farmer/msp/config.yaml ${PWD}/consortium/crypto-config/peerOrganizations/farmer/users/Admin@farmer/msp/config.yaml

}


certificatesForMill() {
  echo
  echo "Enroll the CA admin (mill)"
  echo
  mkdir -p consortium/crypto-config/peerOrganizations/mill/
  export FABRIC_CA_CLIENT_HOME=${PWD}/consortium/crypto-config/peerOrganizations/mill/

   
  fabric-ca-client enroll -u https://admin:adminpw@localhost:1020 --caname ca.mill --tls.certfiles ${PWD}/consortium/fabric-ca/mill/tls-cert.pem
   

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-1020-ca-mill.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-1020-mill.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-1020-mill.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-1020-mill.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/consortium/crypto-config/peerOrganizations/mill/msp/config.yaml

  echo
  echo "Register peer0 (mill)"
  echo
  fabric-ca-client register --caname ca.mill --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/consortium/fabric-ca/mill/tls-cert.pem

  echo
  echo "Register peer1 (mill)"
  echo
  fabric-ca-client register --caname ca.mill --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/consortium/fabric-ca/mill/tls-cert.pem

  echo
  echo "Register user (mill)"
  echo
  fabric-ca-client register --caname ca.mill --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/consortium/fabric-ca/mill/tls-cert.pem

  echo
  echo "Register the org admin (mill)"
  echo
  fabric-ca-client register --caname ca.mill --id.name milladmin --id.secret milladminpw --id.type admin --tls.certfiles ${PWD}/consortium/fabric-ca/mill/tls-cert.pem


# Create a directory for peers
  mkdir -p consortium/crypto-config/peerOrganizations/mill/peers

  # -----------------------------------------------------------------------------------
  #  Peer 0
  mkdir -p consortium/crypto-config/peerOrganizations/mill/peers/peer0.mill

  echo
  echo "## Generate the peer0 msp (mill)"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:1020 --caname ca.mill -M ${PWD}/consortium/crypto-config/peerOrganizations/mill/peers/peer0.mill/msp --csr.hosts peer0.mill --tls.certfiles ${PWD}/consortium/fabric-ca/mill/tls-cert.pem

  cp ${PWD}/consortium/crypto-config/peerOrganizations/mill/msp/config.yaml ${PWD}/consortium/crypto-config/peerOrganizations/mill/peers/peer0.mill/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates (mill)"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:1020 --caname ca.mill -M ${PWD}/consortium/crypto-config/peerOrganizations/mill/peers/peer0.mill/tls --enrollment.profile tls --csr.hosts peer0.mill --csr.hosts localhost --tls.certfiles ${PWD}/consortium/fabric-ca/mill/tls-cert.pem

  cp ${PWD}/consortium/crypto-config/peerOrganizations/mill/peers/peer0.mill/tls/tlscacerts/* ${PWD}/consortium/crypto-config/peerOrganizations/mill/peers/peer0.mill/tls/ca.crt
  cp ${PWD}/consortium/crypto-config/peerOrganizations/mill/peers/peer0.mill/tls/signcerts/* ${PWD}/consortium/crypto-config/peerOrganizations/mill/peers/peer0.mill/tls/server.crt
  cp ${PWD}/consortium/crypto-config/peerOrganizations/mill/peers/peer0.mill/tls/keystore/* ${PWD}/consortium/crypto-config/peerOrganizations/mill/peers/peer0.mill/tls/server.key

  mkdir ${PWD}/consortium/crypto-config/peerOrganizations/mill/msp/tlscacerts
  cp ${PWD}/consortium/crypto-config/peerOrganizations/mill/peers/peer0.mill/tls/tlscacerts/* ${PWD}/consortium/crypto-config/peerOrganizations/mill/msp/tlscacerts/ca.crt

  mkdir ${PWD}/consortium/crypto-config/peerOrganizations/mill/tlsca
  cp ${PWD}/consortium/crypto-config/peerOrganizations/mill/peers/peer0.mill/tls/tlscacerts/* ${PWD}/consortium/crypto-config/peerOrganizations/mill/tlsca/tlsca.mill-cert.pem

  mkdir ${PWD}/consortium/crypto-config/peerOrganizations/mill/ca
  cp ${PWD}/consortium/crypto-config/peerOrganizations/mill/peers/peer0.mill/msp/cacerts/* ${PWD}/consortium/crypto-config/peerOrganizations/mill/ca/ca.mill-cert.pem

  # ------------------------------------------------------------------------------------------------

  # Peer1

  mkdir -p consortium/crypto-config/peerOrganizations/mill/peers/peer1.mill

  echo
  echo "## Generate the peer1 msp (mill)"
  echo
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:1020 --caname ca.mill -M ${PWD}/consortium/crypto-config/peerOrganizations/mill/peers/peer1.mill/msp --csr.hosts peer1.mill --tls.certfiles ${PWD}/consortium/fabric-ca/mill/tls-cert.pem

  cp ${PWD}/consortium/crypto-config/peerOrganizations/mill/msp/config.yaml ${PWD}/consortium/crypto-config/peerOrganizations/mill/peers/peer1.mill/msp/config.yaml

  echo
  echo "## Generate the peer1-tls certificates (mill)"
  echo
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:1020 --caname ca.mill -M ${PWD}/consortium/crypto-config/peerOrganizations/mill/peers/peer1.mill/tls --enrollment.profile tls --csr.hosts peer1.mill --csr.hosts localhost --tls.certfiles ${PWD}/consortium/fabric-ca/mill/tls-cert.pem

  cp ${PWD}/consortium/crypto-config/peerOrganizations/mill/peers/peer1.mill/tls/tlscacerts/* ${PWD}/consortium/crypto-config/peerOrganizations/mill/peers/peer1.mill/tls/ca.crt
  cp ${PWD}/consortium/crypto-config/peerOrganizations/mill/peers/peer1.mill/tls/signcerts/* ${PWD}/consortium/crypto-config/peerOrganizations/mill/peers/peer1.mill/tls/server.crt
  cp ${PWD}/consortium/crypto-config/peerOrganizations/mill/peers/peer1.mill/tls/keystore/* ${PWD}/consortium/crypto-config/peerOrganizations/mill/peers/peer1.mill/tls/server.key

  # --------------------------------------------------------------------------------------------------

  mkdir -p consortium/crypto-config/peerOrganizations/mill/users
  mkdir -p consortium/crypto-config/peerOrganizations/mill/users/User1@mill

  echo
  echo "## Generate the user msp (mill)"
  echo
  fabric-ca-client enroll -u https://user1:user1pw@localhost:1020 --caname ca.mill -M ${PWD}/consortium/crypto-config/peerOrganizations/mill/users/User1@mill/msp --tls.certfiles ${PWD}/consortium/fabric-ca/mill/tls-cert.pem

  mkdir -p consortium/crypto-config/peerOrganizations/mill/users/Admin@mill

  echo
  echo "## Generate the org admin msp (mill)"
  echo
  fabric-ca-client enroll -u https://milladmin:milladminpw@localhost:1020 --caname ca.mill -M ${PWD}/consortium/crypto-config/peerOrganizations/mill/users/Admin@mill/msp --tls.certfiles ${PWD}/consortium/fabric-ca/mill/tls-cert.pem

  cp ${PWD}/consortium/crypto-config/peerOrganizations/mill/msp/config.yaml ${PWD}/consortium/crypto-config/peerOrganizations/mill/users/Admin@mill/msp/config.yaml

}



certificatesForDistributer() {
  echo
  echo "Enroll the CA admin (distributer)"
  echo
  mkdir -p consortium/crypto-config/peerOrganizations/distributer/
  export FABRIC_CA_CLIENT_HOME=${PWD}/consortium/crypto-config/peerOrganizations/distributer/

   
  fabric-ca-client enroll -u https://admin:adminpw@localhost:1030 --caname ca.distributer --tls.certfiles ${PWD}/consortium/fabric-ca/distributer/tls-cert.pem
   

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-1030-ca-distributer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-1030-distributer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-1030-distributer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-1030-distributer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/consortium/crypto-config/peerOrganizations/distributer/msp/config.yaml

  echo
  echo "Register peer0 (distributer)"
  echo
  fabric-ca-client register --caname ca.distributer --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/consortium/fabric-ca/distributer/tls-cert.pem

  echo
  echo "Register peer1 (distributer)"
  echo
  fabric-ca-client register --caname ca.distributer --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/consortium/fabric-ca/distributer/tls-cert.pem

  echo
  echo "Register user (distributer)"
  echo
  fabric-ca-client register --caname ca.distributer --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/consortium/fabric-ca/distributer/tls-cert.pem

  echo
  echo "Register the org admin (distributer)"
  echo
  fabric-ca-client register --caname ca.distributer --id.name distributeradmin --id.secret distributeradminpw --id.type admin --tls.certfiles ${PWD}/consortium/fabric-ca/distributer/tls-cert.pem


# Create a directory for peers
  mkdir -p consortium/crypto-config/peerOrganizations/distributer/peers

  # -----------------------------------------------------------------------------------
  #  Peer 0
  mkdir -p consortium/crypto-config/peerOrganizations/distributer/peers/peer0.distributer

  echo
  echo "## Generate the peer0 msp (distributer)"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:1030 --caname ca.distributer -M ${PWD}/consortium/crypto-config/peerOrganizations/distributer/peers/peer0.distributer/msp --csr.hosts peer0.distributer --tls.certfiles ${PWD}/consortium/fabric-ca/distributer/tls-cert.pem

  cp ${PWD}/consortium/crypto-config/peerOrganizations/distributer/msp/config.yaml ${PWD}/consortium/crypto-config/peerOrganizations/distributer/peers/peer0.distributer/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates (distributer)"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:1030 --caname ca.distributer -M ${PWD}/consortium/crypto-config/peerOrganizations/distributer/peers/peer0.distributer/tls --enrollment.profile tls --csr.hosts peer0.distributer --csr.hosts localhost --tls.certfiles ${PWD}/consortium/fabric-ca/distributer/tls-cert.pem

  cp ${PWD}/consortium/crypto-config/peerOrganizations/distributer/peers/peer0.distributer/tls/tlscacerts/* ${PWD}/consortium/crypto-config/peerOrganizations/distributer/peers/peer0.distributer/tls/ca.crt
  cp ${PWD}/consortium/crypto-config/peerOrganizations/distributer/peers/peer0.distributer/tls/signcerts/* ${PWD}/consortium/crypto-config/peerOrganizations/distributer/peers/peer0.distributer/tls/server.crt
  cp ${PWD}/consortium/crypto-config/peerOrganizations/distributer/peers/peer0.distributer/tls/keystore/* ${PWD}/consortium/crypto-config/peerOrganizations/distributer/peers/peer0.distributer/tls/server.key

  mkdir ${PWD}/consortium/crypto-config/peerOrganizations/distributer/msp/tlscacerts
  cp ${PWD}/consortium/crypto-config/peerOrganizations/distributer/peers/peer0.distributer/tls/tlscacerts/* ${PWD}/consortium/crypto-config/peerOrganizations/distributer/msp/tlscacerts/ca.crt

  mkdir ${PWD}/consortium/crypto-config/peerOrganizations/distributer/tlsca
  cp ${PWD}/consortium/crypto-config/peerOrganizations/distributer/peers/peer0.distributer/tls/tlscacerts/* ${PWD}/consortium/crypto-config/peerOrganizations/distributer/tlsca/tlsca.distributer-cert.pem

  mkdir ${PWD}/consortium/crypto-config/peerOrganizations/distributer/ca
  cp ${PWD}/consortium/crypto-config/peerOrganizations/distributer/peers/peer0.distributer/msp/cacerts/* ${PWD}/consortium/crypto-config/peerOrganizations/distributer/ca/ca.distributer-cert.pem

  # ------------------------------------------------------------------------------------------------

  # Peer1

  mkdir -p consortium/crypto-config/peerOrganizations/distributer/peers/peer1.distributer

  echo
  echo "## Generate the peer1 msp (distributer)"
  echo
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:1030 --caname ca.distributer -M ${PWD}/consortium/crypto-config/peerOrganizations/distributer/peers/peer1.distributer/msp --csr.hosts peer1.distributer --tls.certfiles ${PWD}/consortium/fabric-ca/distributer/tls-cert.pem

  cp ${PWD}/consortium/crypto-config/peerOrganizations/distributer/msp/config.yaml ${PWD}/consortium/crypto-config/peerOrganizations/distributer/peers/peer1.distributer/msp/config.yaml

  echo
  echo "## Generate the peer1-tls certificates (distributer)"
  echo
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:1030 --caname ca.distributer -M ${PWD}/consortium/crypto-config/peerOrganizations/distributer/peers/peer1.distributer/tls --enrollment.profile tls --csr.hosts peer1.distributer --csr.hosts localhost --tls.certfiles ${PWD}/consortium/fabric-ca/distributer/tls-cert.pem

  cp ${PWD}/consortium/crypto-config/peerOrganizations/distributer/peers/peer1.distributer/tls/tlscacerts/* ${PWD}/consortium/crypto-config/peerOrganizations/distributer/peers/peer1.distributer/tls/ca.crt
  cp ${PWD}/consortium/crypto-config/peerOrganizations/distributer/peers/peer1.distributer/tls/signcerts/* ${PWD}/consortium/crypto-config/peerOrganizations/distributer/peers/peer1.distributer/tls/server.crt
  cp ${PWD}/consortium/crypto-config/peerOrganizations/distributer/peers/peer1.distributer/tls/keystore/* ${PWD}/consortium/crypto-config/peerOrganizations/distributer/peers/peer1.distributer/tls/server.key

  # --------------------------------------------------------------------------------------------------

  mkdir -p consortium/crypto-config/peerOrganizations/distributer/users
  mkdir -p consortium/crypto-config/peerOrganizations/distributer/users/User1@distributer

  echo
  echo "## Generate the user msp (distributer)"
  echo
  fabric-ca-client enroll -u https://user1:user1pw@localhost:1030 --caname ca.distributer -M ${PWD}/consortium/crypto-config/peerOrganizations/distributer/users/User1@distributer/msp --tls.certfiles ${PWD}/consortium/fabric-ca/distributer/tls-cert.pem

  mkdir -p consortium/crypto-config/peerOrganizations/distributer/users/Admin@distributer

  echo
  echo "## Generate the org admin msp (distributer)"
  echo
  fabric-ca-client enroll -u https://distributeradmin:distributeradminpw@localhost:1030 --caname ca.distributer -M ${PWD}/consortium/crypto-config/peerOrganizations/distributer/users/Admin@distributer/msp --tls.certfiles ${PWD}/consortium/fabric-ca/distributer/tls-cert.pem

  cp ${PWD}/consortium/crypto-config/peerOrganizations/distributer/msp/config.yaml ${PWD}/consortium/crypto-config/peerOrganizations/distributer/users/Admin@distributer/msp/config.yaml

}


certificatesForRetailer() {
  echo
  echo "Enroll the CA admin (retailer)"
  echo
  mkdir -p consortium/crypto-config/peerOrganizations/retailer/
  export FABRIC_CA_CLIENT_HOME=${PWD}/consortium/crypto-config/peerOrganizations/retailer/

   
  fabric-ca-client enroll -u https://admin:adminpw@localhost:1040 --caname ca.retailer --tls.certfiles ${PWD}/consortium/fabric-ca/retailer/tls-cert.pem
   

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-1040-ca-retailer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-1040-retailer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-1040-retailer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-1040-retailer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/consortium/crypto-config/peerOrganizations/retailer/msp/config.yaml

  echo
  echo "Register peer0 (retailer)"
  echo
  fabric-ca-client register --caname ca.retailer --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/consortium/fabric-ca/retailer/tls-cert.pem

  echo
  echo "Register peer1 (retailer)"
  echo
  fabric-ca-client register --caname ca.retailer --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/consortium/fabric-ca/retailer/tls-cert.pem

  echo
  echo "Register user (retailer)"
  echo
  fabric-ca-client register --caname ca.retailer --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/consortium/fabric-ca/retailer/tls-cert.pem

  echo
  echo "Register the org admin (retailer)"
  echo
  fabric-ca-client register --caname ca.retailer --id.name retaileradmin --id.secret retaileradminpw --id.type admin --tls.certfiles ${PWD}/consortium/fabric-ca/retailer/tls-cert.pem


# Create a directory for peers
  mkdir -p consortium/crypto-config/peerOrganizations/retailer/peers

  # -----------------------------------------------------------------------------------
  #  Peer 0
  mkdir -p consortium/crypto-config/peerOrganizations/retailer/peers/peer0.retailer

  echo
  echo "## Generate the peer0 msp (retailer)"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:1040 --caname ca.retailer -M ${PWD}/consortium/crypto-config/peerOrganizations/retailer/peers/peer0.retailer/msp --csr.hosts peer0.retailer --tls.certfiles ${PWD}/consortium/fabric-ca/retailer/tls-cert.pem

  cp ${PWD}/consortium/crypto-config/peerOrganizations/retailer/msp/config.yaml ${PWD}/consortium/crypto-config/peerOrganizations/retailer/peers/peer0.retailer/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates (retailer)"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:1040 --caname ca.retailer -M ${PWD}/consortium/crypto-config/peerOrganizations/retailer/peers/peer0.retailer/tls --enrollment.profile tls --csr.hosts peer0.retailer --csr.hosts localhost --tls.certfiles ${PWD}/consortium/fabric-ca/retailer/tls-cert.pem

  cp ${PWD}/consortium/crypto-config/peerOrganizations/retailer/peers/peer0.retailer/tls/tlscacerts/* ${PWD}/consortium/crypto-config/peerOrganizations/retailer/peers/peer0.retailer/tls/ca.crt
  cp ${PWD}/consortium/crypto-config/peerOrganizations/retailer/peers/peer0.retailer/tls/signcerts/* ${PWD}/consortium/crypto-config/peerOrganizations/retailer/peers/peer0.retailer/tls/server.crt
  cp ${PWD}/consortium/crypto-config/peerOrganizations/retailer/peers/peer0.retailer/tls/keystore/* ${PWD}/consortium/crypto-config/peerOrganizations/retailer/peers/peer0.retailer/tls/server.key

  mkdir ${PWD}/consortium/crypto-config/peerOrganizations/retailer/msp/tlscacerts
  cp ${PWD}/consortium/crypto-config/peerOrganizations/retailer/peers/peer0.retailer/tls/tlscacerts/* ${PWD}/consortium/crypto-config/peerOrganizations/retailer/msp/tlscacerts/ca.crt

  mkdir ${PWD}/consortium/crypto-config/peerOrganizations/retailer/tlsca
  cp ${PWD}/consortium/crypto-config/peerOrganizations/retailer/peers/peer0.retailer/tls/tlscacerts/* ${PWD}/consortium/crypto-config/peerOrganizations/retailer/tlsca/tlsca.retailer-cert.pem

  mkdir ${PWD}/consortium/crypto-config/peerOrganizations/retailer/ca
  cp ${PWD}/consortium/crypto-config/peerOrganizations/retailer/peers/peer0.retailer/msp/cacerts/* ${PWD}/consortium/crypto-config/peerOrganizations/retailer/ca/ca.retailer-cert.pem

  # ------------------------------------------------------------------------------------------------

  # Peer1

  mkdir -p consortium/crypto-config/peerOrganizations/retailer/peers/peer1.retailer

  echo
  echo "## Generate the peer1 msp (retailer)"
  echo
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:1040 --caname ca.retailer -M ${PWD}/consortium/crypto-config/peerOrganizations/retailer/peers/peer1.retailer/msp --csr.hosts peer1.retailer --tls.certfiles ${PWD}/consortium/fabric-ca/retailer/tls-cert.pem

  cp ${PWD}/consortium/crypto-config/peerOrganizations/retailer/msp/config.yaml ${PWD}/consortium/crypto-config/peerOrganizations/retailer/peers/peer1.retailer/msp/config.yaml

  echo
  echo "## Generate the peer1-tls certificates (retailer)"
  echo
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:1040 --caname ca.retailer -M ${PWD}/consortium/crypto-config/peerOrganizations/retailer/peers/peer1.retailer/tls --enrollment.profile tls --csr.hosts peer1.retailer --csr.hosts localhost --tls.certfiles ${PWD}/consortium/fabric-ca/retailer/tls-cert.pem

  cp ${PWD}/consortium/crypto-config/peerOrganizations/retailer/peers/peer1.retailer/tls/tlscacerts/* ${PWD}/consortium/crypto-config/peerOrganizations/retailer/peers/peer1.retailer/tls/ca.crt
  cp ${PWD}/consortium/crypto-config/peerOrganizations/retailer/peers/peer1.retailer/tls/signcerts/* ${PWD}/consortium/crypto-config/peerOrganizations/retailer/peers/peer1.retailer/tls/server.crt
  cp ${PWD}/consortium/crypto-config/peerOrganizations/retailer/peers/peer1.retailer/tls/keystore/* ${PWD}/consortium/crypto-config/peerOrganizations/retailer/peers/peer1.retailer/tls/server.key

  # --------------------------------------------------------------------------------------------------

  mkdir -p consortium/crypto-config/peerOrganizations/retailer/users
  mkdir -p consortium/crypto-config/peerOrganizations/retailer/users/User1@retailer

  echo
  echo "## Generate the user msp (retailer)"
  echo
  fabric-ca-client enroll -u https://user1:user1pw@localhost:1040 --caname ca.retailer -M ${PWD}/consortium/crypto-config/peerOrganizations/retailer/users/User1@retailer/msp --tls.certfiles ${PWD}/consortium/fabric-ca/retailer/tls-cert.pem

  mkdir -p consortium/crypto-config/peerOrganizations/retailer/users/Admin@retailer

  echo
  echo "## Generate the org admin msp (retailer)"
  echo
  fabric-ca-client enroll -u https://retaileradmin:retaileradminpw@localhost:1040 --caname ca.retailer -M ${PWD}/consortium/crypto-config/peerOrganizations/retailer/users/Admin@retailer/msp --tls.certfiles ${PWD}/consortium/fabric-ca/retailer/tls-cert.pem

  cp ${PWD}/consortium/crypto-config/peerOrganizations/retailer/msp/config.yaml ${PWD}/consortium/crypto-config/peerOrganizations/retailer/users/Admin@retailer/msp/config.yaml

}


certificatesForEndUser() {
  echo
  echo "Enroll the CA admin (Enduser)"
  echo
  mkdir -p consortium/crypto-config/peerOrganizations/enduser/
  export FABRIC_CA_CLIENT_HOME=${PWD}/consortium/crypto-config/peerOrganizations/enduser/

   
  fabric-ca-client enroll -u https://admin:adminpw@localhost:1050 --caname ca.enduser --tls.certfiles ${PWD}/consortium/fabric-ca/enduser/tls-cert.pem
   

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-1050-ca-enduser.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-1050-enduser.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-1050-enduser.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-1050-enduser.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/consortium/crypto-config/peerOrganizations/enduser/msp/config.yaml

  echo
  echo "Register peer0 (Enduser)"
  echo
  fabric-ca-client register --caname ca.enduser --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/consortium/fabric-ca/enduser/tls-cert.pem

  echo
  echo "Register peer1 (Enduser)"
  echo
  fabric-ca-client register --caname ca.enduser --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/consortium/fabric-ca/enduser/tls-cert.pem

  echo
  echo "Register user (Enduser)"
  echo
  fabric-ca-client register --caname ca.enduser --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/consortium/fabric-ca/enduser/tls-cert.pem

  echo
  echo "Register the org admin (Enduser)"
  echo
  fabric-ca-client register --caname ca.enduser --id.name enduseradmin --id.secret enduseradminpw --id.type admin --tls.certfiles ${PWD}/consortium/fabric-ca/enduser/tls-cert.pem


# Create a directory for peers
  mkdir -p consortium/crypto-config/peerOrganizations/enduser/peers

  # -----------------------------------------------------------------------------------
  #  Peer 0
  mkdir -p consortium/crypto-config/peerOrganizations/enduser/peers/peer0.enduser

  echo
  echo "## Generate the peer0 msp (Enduser)"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:1050 --caname ca.enduser -M ${PWD}/consortium/crypto-config/peerOrganizations/enduser/peers/peer0.enduser/msp --csr.hosts peer0.enduser --tls.certfiles ${PWD}/consortium/fabric-ca/enduser/tls-cert.pem

  cp ${PWD}/consortium/crypto-config/peerOrganizations/enduser/msp/config.yaml ${PWD}/consortium/crypto-config/peerOrganizations/enduser/peers/peer0.enduser/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates (Enduser)"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:1050 --caname ca.enduser -M ${PWD}/consortium/crypto-config/peerOrganizations/enduser/peers/peer0.enduser/tls --enrollment.profile tls --csr.hosts peer0.enduser --csr.hosts localhost --tls.certfiles ${PWD}/consortium/fabric-ca/enduser/tls-cert.pem

  cp ${PWD}/consortium/crypto-config/peerOrganizations/enduser/peers/peer0.enduser/tls/tlscacerts/* ${PWD}/consortium/crypto-config/peerOrganizations/enduser/peers/peer0.enduser/tls/ca.crt
  cp ${PWD}/consortium/crypto-config/peerOrganizations/enduser/peers/peer0.enduser/tls/signcerts/* ${PWD}/consortium/crypto-config/peerOrganizations/enduser/peers/peer0.enduser/tls/server.crt
  cp ${PWD}/consortium/crypto-config/peerOrganizations/enduser/peers/peer0.enduser/tls/keystore/* ${PWD}/consortium/crypto-config/peerOrganizations/enduser/peers/peer0.enduser/tls/server.key

  mkdir ${PWD}/consortium/crypto-config/peerOrganizations/enduser/msp/tlscacerts
  cp ${PWD}/consortium/crypto-config/peerOrganizations/enduser/peers/peer0.enduser/tls/tlscacerts/* ${PWD}/consortium/crypto-config/peerOrganizations/enduser/msp/tlscacerts/ca.crt

  mkdir ${PWD}/consortium/crypto-config/peerOrganizations/enduser/tlsca
  cp ${PWD}/consortium/crypto-config/peerOrganizations/enduser/peers/peer0.enduser/tls/tlscacerts/* ${PWD}/consortium/crypto-config/peerOrganizations/enduser/tlsca/tlsca.enduser-cert.pem

  mkdir ${PWD}/consortium/crypto-config/peerOrganizations/enduser/ca
  cp ${PWD}/consortium/crypto-config/peerOrganizations/enduser/peers/peer0.enduser/msp/cacerts/* ${PWD}/consortium/crypto-config/peerOrganizations/enduser/ca/ca.enduser-cert.pem

  # ------------------------------------------------------------------------------------------------

  # Peer1

  mkdir -p consortium/crypto-config/peerOrganizations/enduser/peers/peer1.enduser

  echo
  echo "## Generate the peer1 msp (Enduser)"
  echo
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:1050 --caname ca.enduser -M ${PWD}/consortium/crypto-config/peerOrganizations/enduser/peers/peer1.enduser/msp --csr.hosts peer1.enduser --tls.certfiles ${PWD}/consortium/fabric-ca/enduser/tls-cert.pem

  cp ${PWD}/consortium/crypto-config/peerOrganizations/enduser/msp/config.yaml ${PWD}/consortium/crypto-config/peerOrganizations/enduser/peers/peer1.enduser/msp/config.yaml

  echo
  echo "## Generate the peer1-tls certificates (Enduser)"
  echo
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:1050 --caname ca.enduser -M ${PWD}/consortium/crypto-config/peerOrganizations/enduser/peers/peer1.enduser/tls --enrollment.profile tls --csr.hosts peer1.enduser --csr.hosts localhost --tls.certfiles ${PWD}/consortium/fabric-ca/enduser/tls-cert.pem

  cp ${PWD}/consortium/crypto-config/peerOrganizations/enduser/peers/peer1.enduser/tls/tlscacerts/* ${PWD}/consortium/crypto-config/peerOrganizations/enduser/peers/peer1.enduser/tls/ca.crt
  cp ${PWD}/consortium/crypto-config/peerOrganizations/enduser/peers/peer1.enduser/tls/signcerts/* ${PWD}/consortium/crypto-config/peerOrganizations/enduser/peers/peer1.enduser/tls/server.crt
  cp ${PWD}/consortium/crypto-config/peerOrganizations/enduser/peers/peer1.enduser/tls/keystore/* ${PWD}/consortium/crypto-config/peerOrganizations/enduser/peers/peer1.enduser/tls/server.key

  # --------------------------------------------------------------------------------------------------

  mkdir -p consortium/crypto-config/peerOrganizations/enduser/users
  mkdir -p consortium/crypto-config/peerOrganizations/enduser/users/User1@enduser

  echo
  echo "## Generate the user msp (Enduser)"
  echo
  fabric-ca-client enroll -u https://user1:user1pw@localhost:1050 --caname ca.enduser -M ${PWD}/consortium/crypto-config/peerOrganizations/enduser/users/User1@enduser/msp --tls.certfiles ${PWD}/consortium/fabric-ca/enduser/tls-cert.pem

  mkdir -p consortium/crypto-config/peerOrganizations/enduser/users/Admin@enduser

  echo
  echo "## Generate the org admin msp (Enduser)"
  echo
  fabric-ca-client enroll -u https://enduseradmin:enduseradminpw@localhost:1050 --caname ca.enduser -M ${PWD}/consortium/crypto-config/peerOrganizations/enduser/users/Admin@enduser/msp --tls.certfiles ${PWD}/consortium/fabric-ca/enduser/tls-cert.pem

  cp ${PWD}/consortium/crypto-config/peerOrganizations/enduser/msp/config.yaml ${PWD}/consortium/crypto-config/peerOrganizations/enduser/users/Admin@enduser/msp/config.yaml

}

certificatesForOrderer() {
  echo
  echo "Enroll the CA admin (Orderer)"
  echo
  mkdir -p consortium/crypto-config/ordererOrganizations/example.com
  export FABRIC_CA_CLIENT_HOME=${PWD}/consortium/crypto-config/ordererOrganizations/example.com

   
  fabric-ca-client enroll -u https://admin:adminpw@localhost:1060 --caname ca.orderer --tls.certfiles ${PWD}/consortium/fabric-ca/ordererOrg/tls-cert.pem
   

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-1060-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-1060-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-1060-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-1060-orderer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/consortium/crypto-config/ordererOrganizations/example.com/msp/config.yaml

  echo
  echo "Register orderer"
  echo
  fabric-ca-client register --caname ca.orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/consortium/fabric-ca/ordererOrg/tls-cert.pem

  echo
  echo "Register orderer2"
  echo
  fabric-ca-client register --caname ca.orderer --id.name orderer2 --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/consortium/fabric-ca/ordererOrg/tls-cert.pem

  echo
  echo "Register orderer3"
  echo
  fabric-ca-client register --caname ca.orderer --id.name orderer3 --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/consortium/fabric-ca/ordererOrg/tls-cert.pem

  echo
  echo "Register the orderer admin"
  echo
  fabric-ca-client register --caname ca.orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/consortium/fabric-ca/ordererOrg/tls-cert.pem



  mkdir -p consortium/crypto-config/ordererOrganizations/example.com/orderers
  mkdir -p consortium/crypto-config/ordererOrganizations/example.com/orderers/example.com

  # -----------------------------------------------------------------------------------
  #  Orderer 
  mkdir -p consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com

  echo
  echo "## Generate the orderer msp"
  echo
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:1060 --caname ca.orderer -M ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp --csr.hosts orderer.example.com --tls.certfiles ${PWD}/consortium/fabric-ca/ordererOrg/tls-cert.pem

  cp ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/msp/config.yaml ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:1060 --caname ca.orderer -M ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls --enrollment.profile tls --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles ${PWD}/consortium/fabric-ca/ordererOrg/tls-cert.pem

  cp ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt
  cp ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/signcerts/* ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt
  cp ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/keystore/* ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.key

  mkdir ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts
  cp ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tlsca
  cp ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tlsca/tlsca.orderer-cert.pem

  mkdir ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/ca
  cp ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/cacerts/* ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/ca/ca.orderer-cert.pem

  # ------------------------------------------------------------------------------------------------

  # Orderer 2 

  mkdir -p consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com


  echo
  echo "## Generate the orderer 2 msp"
  echo
  fabric-ca-client enroll -u https://orderer2:ordererpw@localhost:1060 --caname ca.orderer -M ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/msp --csr.hosts orderer2.example.com --tls.certfiles ${PWD}/consortium/fabric-ca/ordererOrg/tls-cert.pem

  cp ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/msp/config.yaml ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/msp/config.yaml

  echo
  echo "## Generate the orderer 2-tls certificates"
  echo
  fabric-ca-client enroll -u https://orderer2:ordererpw@localhost:1060 --caname ca.orderer -M ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/tls --enrollment.profile tls --csr.hosts orderer2.example.com --csr.hosts localhost --tls.certfiles ${PWD}/consortium/fabric-ca/ordererOrg/tls-cert.pem

  cp ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/tlscacerts/* ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/ca.crt
  cp ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/signcerts/* ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/server.crt
  cp ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/keystore/* ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com//tls/server.key

  
  mkdir ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/msp/tlscacerts
  cp ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/tlscacerts/* ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/msp/tlscacerts/tlsca.example.com-cert.pem



  #  Orderer 3
    mkdir -p consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com 


    echo
    echo "## Generate the orderer 3 msp"
    echo
    
    fabric-ca-client enroll -u https://orderer3:ordererpw@localhost:1060 --caname ca.orderer -M ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/msp --csr.hosts orderer3.example.com --csr.hosts localhost --tls.certfiles ${PWD}/consortium/fabric-ca/ordererOrg/tls-cert.pem
    

    cp ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/msp/config.yaml ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/msp/config.yaml

    echo
    echo "## Generate the orderer 3-tls certificates"
    echo
    
    fabric-ca-client enroll -u https://orderer3:ordererpw@localhost:1060 --caname ca.orderer -M ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/tls --enrollment.profile tls --csr.hosts orderer3.example.com --csr.hosts localhost --tls.certfiles ${PWD}/consortium/fabric-ca/ordererOrg/tls-cert.pem
    

    cp ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/tlscacerts/* ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/ca.crt
    cp ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/signcerts/* ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/server.crt
    cp ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/keystore/* ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/server.key

    mkdir ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/msp/tlscacerts
    cp ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/tlscacerts/* ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/msp/tlscacerts/tlsca.example.com-cert.pem


  
  # --------------------------------------------------------------------------------------------------

  mkdir -p consortium/crypto-config/ordererOrganizations/example.com/users
  mkdir -p consortium/crypto-config/ordererOrganizations/example.com/users/User1@example.com

  # echo
  # echo "## Generate the user msp"
  # echo
  # fabric-ca-client enroll -u https://user1:user1pw@localhost:1060 --caname ca.orderer -M ${PWD}/consortium/crypto-config/peerOrganizations/orderer/users/User1@orderer/msp --tls.certfiles ${PWD}/consortium/fabric-ca/orderer/tls-cert.pem

  # mkdir -p consortium/crypto-config/peerOrganizations/orderer/users/Admin@orderer

  echo
  echo "## Generate the admin msp"
  echo
  fabric-ca-client enroll -u https://ordereradmin:ordereradminpw@localhost:1060 --caname ca.orderer -M ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/users/Admin@example.com/msp --tls.certfiles ${PWD}/consortium/fabric-ca/ordererOrg/tls-cert.pem

  cp ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/msp/config.yaml ${PWD}/consortium/crypto-config/ordererOrganizations/example.com/users/Admin@example.com/msp/config.yaml

}

#certificate authorities compose file

# COMPOSE_FILE_CA=docker/docker-compose-ca.yaml
sudo chmod 666 /var/run/docker.sock
# IMAGE_TAG=docker-compose -f $COMPOSE_FILE_CA up -d 2>&1
docker-compose -f docker/docker-compose-ca.yaml up -d 2>&1

docker ps

# infoln "Creating Farmer Identities"
certificatesForFarmer

# infoln "Creating Mill Identities"
certificatesForMill

# infoln "Creating Distributer Identities"
certificatesForDistributer

# infoln "Creating Retailer Identities"
certificatesForRetailer

# infoln "Creating EndUser Identities"
certificatesForEndUser

# infoln "Creating Orderer Identities"
certificatesForOrderer

# infoln "Generating CCP files for all the Organizations"
# consortium/ccp-generate.sh
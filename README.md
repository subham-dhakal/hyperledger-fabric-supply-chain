# hyperledger-fabric-supply-chain

<h2> Steps to start the project </h2>
  <b>Move to supply_chain_network folder </b><br>
  <code>cd supply_chain_network </code>

  <b> Create and run the docker containers  </b><br>
  <code>docker-compose -f ./docker/docker-compose-ca.yaml up -d </code>
  
  <b> Generate the crypto materials for all the participants </b><br>
  <code>./create-certificate.sh</code>  

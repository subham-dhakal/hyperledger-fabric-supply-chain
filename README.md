# hyperledger-fabric-supply-chain

<h2> Steps to start the project </h2>
<p>Move to supply-chain-network folder </p>
<code>cd supply-chain-network </code>

  <b> Create and run the docker containers  </b><br>
  <code>docker-compose -f ./docker/docker-compose-ca.yaml up -d </code>
  
  <b> Generate the crypto materials for all the participants </b><br>
  <code>./create-certificate.sh</code>  

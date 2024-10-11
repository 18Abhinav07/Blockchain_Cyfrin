
# Project Overview

This repository contains all the code and notes made while working on the Cyfrin Blockchain Course. The course covers various aspects of blockchain technology, including blockchain basics, Solidity, smart contracts, and zkSync with Foundry.

## Table of Contents

1. [Blockchain Basics](#blockchain-basics)
2. [Foundry](#foundry)
    - [Deploying a Contract](#deploying-a-contract)
    - [Deploying a Script](#deploying-a-script)
    - [Secure Private Key](#secure-private-key)
    - [Interact with the Contract](#interact-with-the-contract)
    - [Use of .env File](#use-of-env-file)
    - [Call a Contract Function](#call-a-contract-function)
3. [ZkSync Foundry](#zksync-foundry)
    - [Setup zkSync](#setup-zksync)
    - [Deploy a Contract with zkSync](#deploy-a-contract-with-zksync)
    - [Deploy a Script with zkSync](#deploy-a-script-with-zksync)
4. [Gas Cost Records](#gas-cost-records)
5. [Inspect Storage](#inspect-storage)
6. [Function Signature](#function-signature)
7. [Docker Management](#docker-management)
    - [Check Docker Status](#check-docker-status)
    - [Start and Enable Docker](#start-and-enable-docker)
    - [Set Docker Host](#set-docker-host)
    - [Configure and Start zkSync CLI](#configure-and-start-zksync-cli)
    - [Check User Groups](#check-user-groups)
    - [Add User to Docker Group](#add-user-to-docker-group)
    - [Apply New Group Membership](#apply-new-group-membership)
    - [List Docker Containers](#list-docker-containers)
8. [Forge Tests with Forking](#forge-tests-with-forking)
    - [Run Forge Tests](#run-forge-tests)
    - [Converge Tests](#converge-tests)
9. [Docker Context Error Explanation](#docker-context-error-explanation)
10. [Get Chain ID](#get-chain-id)
11. [Make a New Address](#make-a-new-address)
12. [Set Next Transaction Sender](#set-next-transaction-sender)
13. [Send Dummy ETH](#send-dummy-eth)

## Blockchain Basics

* Blockchain Basics.
* Solidity and Smart Contracts.

## Foundry

### Deploying a Contract

To deploy a contract using Foundry, use the following command:

```sh
forge create src/<filename>.sol:<contract-name> --rpc-url <url> --private-key <xxx>
```

### Deploying a Script

To deploy a script, use the following command:

```sh
forge script script/DeploySimpleStorage.s.sol --rpc-url <rpc-url> --private-key <private-key> --broadcast
```

You can specify the contract by using `---.s.sol:<contract-name>` after the script name.

### Secure Private Key

To import a wallet interactively, use:

```sh
cast wallet import <account-name-you-want-for-the-key> --interactive
```

Keep the account name, password, and deployed address safe.

To deploy a script with a specific account, use:

```sh
forge script script/DeploySimpleStorage.s.sol --rpc-url <url> --account <account-name-you-want-for-the-key> --sender <deployed address> --broadcast
```

* `--broadcast` sends the transaction on-chain; without it, the transaction is just simulated.

### Interact with the Contract

To send a transaction to the contract, use:

```sh
cast send <contract-address> "function(with type of return value)" 1000 --rpc-url $RPC_URL --private-key $PRIVATE_KEY
```

### Use of .env File

Store keys and URLs in a `.env` file for security.

### Call a Contract Function

To call a contract function without sending a transaction on-chain, use:

```sh
cast call <contract-address> <function> --rpc-url <url>
```

To convert hexadecimal to decimal, use:

```sh
cast --to-base <hex> dec
```

## ZkSync Foundry

### Setup zkSync

To set up zkSync with Foundry, use the following commands:

```sh
foundryup-zksync
npx zksync-cli dev config
npx zksync-cli dev start
```

### Deploy a Contract with zkSync

To deploy a contract with zkSync, use:

```sh
forge create src/SimpleStorage.sol:SimpleStorage --rpc-url <http://127.0.0.1:8011> --private-key xxx --legacy --zksync
```

### Deploy a Script with zkSync

To deploy a script with zkSync, use:

```sh
forge script script/DeploySimpleStorage.s.sol --private-key xxx --rpc-url <http://127.0.0.1:8011> --legacy --zksync --broadcast
```

## Gas Cost Records

To get the gas cost records for the code, use:

```sh
forge snapshot
```

## Inspect Storage

To inspect the storage, use:

```sh
forge inspect
```

To get the value at a specific slot of the contract, use:

```sh
cast storage <contract address> <slot no>
```

## Function Signature

To get the signature of a function, use:

```sh
cast sig <function_name()>
```

To decode the arguments of a function, use:

```sh
cast --calldata-decode <function_name()> signature
```

## Docker Management

### Check Docker Status

To check the status of Docker, use:

```sh
sudo systemctl status docker
sudo systemctl status docker.socket
```

### Start and Enable Docker

To start and enable Docker, use:

```sh
sudo systemctl start docker
sudo systemctl enable docker
```

### Set Docker Host

To set the Docker host, use:

```sh
export DOCKER_HOST=unix:///var/run/docker.sock
```

### Configure and Start zkSync CLI

To configure and start zkSync CLI, use:

```sh
npx zksync-cli dev config
npx zksync-cli dev start
```

### Check User Groups

To check user groups, use:

```sh
groups
```

### Add User to Docker Group

To add a user to the Docker group, use:

```sh
sudo usermod -aG docker $USER
```

### Apply New Group Membership

To apply new group membership, use:

```sh
newgrp docker
```

### List Docker Containers

To list Docker containers, use:

```sh
docker ps
```

### Start zkSync CLI

To start zkSync CLI, use:

```sh
npx zksync-cli dev start
```

## Forge Tests with Forking

### Run Forge Tests

To run Forge tests with forking, use:

```sh
forge test -vvv --fork-url $SEPOLIA_KEY
```

* `--fork-url` helps to fork the test to the network being simulated.

### Converge Tests

To converge tests with forking, use:

```sh
forge converge --fork-url <address>
```

* This shows all the lines of code tested.

## Docker Context Error Explanation

The command `docker context use default` switches Docker to the default context, pointing to the local Docker Engine using the correct socket at `unix:///var/run/docker.sock`. This resolves issues caused by using an incorrect context.

## Get Chain ID

To get the chain ID, use:

```sh
cast chain-id --rpc-url <http://127.0.0.1:8011>
```

* This retrieves the chain ID of any chain.

## Make a New Address

To make a new address, use:

```sh
makeAddr("<string>")
```

## Set Next Transaction Sender

To set the next transaction sender, use:

```sh
vm.prank(USER)
```

* This sets the `USER` as the next transaction sender.

## Send Dummy ETH

To send dummy ETH, use:

```sh
vm.deal(USER, BALANCE)
```

* This sends some dummy ETH.
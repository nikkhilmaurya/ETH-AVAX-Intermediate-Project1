# ETH-AVAX-Intermediate-Project1

This Solidity program includes a simple contract which provides an implementation of assert(), require() and revert() functions.

## Description

This Solidity contract implements a basic voting system on the Ethereum blockchain. It features functionalities for adding candidates, casting votes, and determining the winner. Only the contract owner can add candidates, while any user can cast a vote for a candidate. This contract serves as a foundational component for creating decentralized voting applications and can be used as a learning resource for understanding Solidity programming and smart contract development.

### Prerequisites

- Access to a web browser
- Internet connection
  
## Getting Started

### Executing program

1. To run this program, we can use Remix at https://remix.ethereum.org/.
2. Create a new file by clicking on the "+" icon in the left-hand sidebar.
3. Save the file with a .sol extension 

```javascript
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LaptopService {
    address public owner;
    enum Status { NotRequested, Requested, InProgress, Completed }
    struct Service {
        address customer;
        string model;
        Status state;
        uint256 cost;
    }

    mapping(uint256 => Service) public data;  //services
    uint256 public reqCount;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    // Function to submit a new service request
    function submitRequest(string memory model) public {
        require(bytes(model).length > 0, "Model cannot be empty");

        uint256 previousCount = reqCount;
        reqCount++;
        data[reqCount] = Service(
            msg.sender,
            model,
            Status.Requested,
            0
        );
        assert(reqCount == previousCount + 1); 
    }

    // Function to start the service for a given request
    function startService(uint256 reqId, uint256 cost) public onlyOwner {
        require(data[reqId].state == Status.Requested, "Service must be requested first");
        require(cost >= 0, "Invalid cost amount");  

        data[reqId].state = Status.InProgress;
        data[reqId].cost = cost;
    }

    // Function to complete the service for a given request
    function completeService(uint256 reqId) public onlyOwner {
        require(data[reqId].state == Status.InProgress, "Service must be in progress");
        data[reqId].state = Status.Completed;
        
        assert(data[reqId].state == Status.Completed);
    }

    // Function to pay for a completed service
    function payForService(uint256 reqId) public payable {
        Service storage serv = data[reqId];
        require(serv.customer == msg.sender, "Only the customer can pay for this service");

        if(serv.state != Status.Completed){
            revert("Service must be completed to make payment");
        }  
        if(msg.value != serv.cost){
            revert("Incorrect amount of Ether sent");
        }
        payable(owner).transfer(msg.value);
    }
}

```

Compile the code. Once compiled,

1. Go to the 'Deploy & Run Transactions' tab on the left.
2. Click on Deploy.

After deploying, we can interact with the contract. 

## Authors

Nikhil Maurya


## License

This project is licensed under the MIT License - see the LICENSE.md file for details

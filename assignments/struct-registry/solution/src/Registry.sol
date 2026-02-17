// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Registry {
    struct Record {
        string name;
        address account;
        uint256 score;
    }

    mapping(uint256 => Record) private records;
    mapping(uint256 => bool) private exists;

    event Registered(uint256 indexed id, string name, address indexed account, uint256 score);

    function register(uint256 id, string memory name, address account, uint256 score) public {
        require(!exists[id], "ALREADY_EXISTS");
        records[id] = Record({name: name, account: account, score: score});
        exists[id] = true;
        emit Registered(id, name, account, score);
    }

    function get(uint256 id) public view returns (string memory, address, uint256) {
        require(exists[id], "NOT_FOUND");
        Record storage rec = records[id];
        return (rec.name, rec.account, rec.score);
    }
}

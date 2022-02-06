// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BibToken is ERC721, Ownable {
    uint256 COUNTER;
    uint256 fee = 1 ether;

    struct Bib {
        string name;
        uint256 id;
        uint256 dna;
        uint8 level;
        uint8 rarity;
    }

    Bib[] public bibs;

    event NewBib(address indexed owner, uint256 id, uint256 dna);

    constructor(string memory _name, string memory _symbol)
        ERC721(_name, _symbol)
    {}

    // Helpers

    function _createRandomNum(uint256 _mod) internal view returns (uint256) {
        uint256 randomNum = uint256(
            keccak256(abi.encodePacked(block.timestamp, msg.sender))
        );
        return randomNum % _mod;
    }

    function updateFee(uint256 _fee) external onlyOwner {
        fee = _fee;
    }

    function withdraw() external payable onlyOwner {
        address _owner = owner();
        payable(_owner).transfer(address(this).balance);
    }

    //Creation

    function _createBib(string memory _name) internal {
        uint8 randRarity = uint8(_createRandomNum(100));
        uint256 randDna = _createRandomNum(10**16);
        Bib memory newBib = Bib(_name, COUNTER, randDna, 1, randRarity);
        bibs.push(newBib);
        _safeMint(msg.sender, COUNTER);

        emit NewBib(msg.sender, COUNTER, randDna);
        COUNTER++;
    }

    function createRandomBib(string memory _name) public payable {
        require(msg.value == fee, "Not enough money for fee");
        _createBib(_name);
    }

    // Check
    function getBibs() public view returns (Bib[] memory) {
        return bibs;
    }
}

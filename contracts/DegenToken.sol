// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {
    uint256[] internal itemIds;
    mapping(uint256 => Item) public items;

    struct Item {
        string itemName;
        uint256 amount;
    }

    constructor(uint256 initialSupply) ERC20("Degen", "DGN") Ownable(msg.sender) {
        _mint(msg.sender, initialSupply);
    }

    function mintDegenToken(address _to, uint256 _value) external onlyOwner {
        _mint(_to, _value);
    }

    function transferDegenToken(address _recipient, uint256 _amount) external returns (bool) {
        require(balanceOf(msg.sender) >= _amount, "Insufficient balance");
        _transfer(msg.sender, _recipient, _amount);
        return true;
    }

    function redeemItem(uint256 _itemId) external {
        require(items[_itemId].amount > 0, "Item does not exist");
        require(balanceOf(msg.sender) >= items[_itemId].amount, "Insufficient balance");

        _transfer(msg.sender, address(this), items[_itemId].amount);

        delete items[_itemId];
    }

    function checkDegenTokenBalance() external view returns (uint256) {
        return balanceOf(msg.sender);
    }

    function burnDegenToken(uint256 _value) external {
        _burn(msg.sender, _value);
    }

    function createItem(string memory _itemName, uint256 _amount) external onlyOwner {
        Item memory newItem = Item({itemName: _itemName, amount: _amount});
        items[itemIds.length] = newItem;

        itemIds.push(itemIds.length);
    }
}
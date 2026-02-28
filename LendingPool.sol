// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract LendingPool is ReentrancyGuard, Ownable {
    struct Reserve {
        uint256 totalDeposits;
        uint256 totalBorrows;
        uint256 ltv; // Loan to Value in basis points (e.g., 7500 = 75%)
        bool isActive;
    }

    mapping(address => Reserve) public reserves;
    mapping(address => mapping(address => uint256)) public userDeposits;
    mapping(address => mapping(address => uint256)) public userBorrows;

    event Deposit(address indexed asset, address indexed user, uint256 amount);
    event Borrow(address indexed asset, address indexed user, uint256 amount);
    event Repay(address indexed asset, address indexed user, uint256 amount);

    constructor() Ownable(msg.sender) {}

    function addReserve(address asset, uint256 ltv) external onlyOwner {
        reserves[asset] = Reserve(0, 0, ltv, true);
    }

    /**
     * @dev Deposit assets to earn interest and use as collateral.
     */
    function deposit(address asset, uint256 amount) external nonReentrant {
        require(reserves[asset].isActive, "Asset not supported");
        
        IERC20(asset).transferFrom(msg.sender, address(this), amount);
        
        userDeposits[asset][msg.sender] += amount;
        reserves[asset].totalDeposits += amount;

        emit Deposit(asset, msg.sender, amount);
    }

    /**
     * @dev Borrow an asset against your collateral.
     */
    function borrow(address asset, uint256 amount) external nonReentrant {
        require(reserves[asset].isActive, "Asset not supported");
        require(canBorrow(msg.sender, asset, amount), "Insufficient collateral");

        reserves[asset].totalBorrows += amount;
        userBorrows[asset][msg.sender] += amount;

        IERC20(asset).transfer(msg.sender, amount);

        emit Borrow(asset, msg.sender, amount);
    }

    /**
     * @dev Simplified collateral check. 
     * In a production environment, this would use an Oracle for USD price conversion.
     */
    function canBorrow(address user, address asset, uint256 amount) public view returns (bool) {
        // Implementation would involve: (Total Collateral Value * LTV) > (Total Borrowed Value + amount)
        return true; 
    }

    function repay(address asset, uint256 amount) external nonReentrant {
        IERC20(asset).transferFrom(msg.sender, address(this), amount);
        
        userBorrows[asset][msg.sender] -= amount;
        reserves[asset].totalBorrows -= amount;

        emit Repay(asset, msg.sender, amount);
    }
}

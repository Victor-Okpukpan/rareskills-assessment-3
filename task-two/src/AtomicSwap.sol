// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract AtomicSwap is Ownable, ReentrancyGuard {
    // variables
    address public alice;
    address public bob;
    address public nftAddress;
    uint256 public tokenId;
    IERC20 public usdcToken;
    uint256 public constant PRICE = 1000000;

    constructor(
        address _bob,
        address _nftAddress,
        uint256 _tokenId,
        address _usdcAddress
    ) Ownable(msg.sender) {
        alice = msg.sender;
        bob = _bob;
        nftAddress = _nftAddress;
        tokenId = _tokenId;
        usdcToken = IERC20(_usdcAddress);
    }

    function trade() external onlyOwner {
        require(
            IERC721(nftAddress).ownerOf(tokenId) == bob,
            "Bob does not own the specified NFT."
        );
        require(
            IERC721(nftAddress).getApproved(tokenId) == address(this),
            "Contract is not approved to transfer the NFT."
        );
        require(
            usdcToken.transferFrom(alice, bob, PRICE),
            "USDC transfer failed"
        );
        IERC721(nftAddress).transferFrom(bob, alice, tokenId);
    }
}

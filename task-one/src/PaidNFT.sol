// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @title PaidNFT
 * @dev ERC721 token that requires USDC payment for minting
 * @notice Users must pay 1 USDC to mint an NFT
 */
contract PaidNFT is ERC721, Ownable, ReentrancyGuard {
    uint256 private _nextTokenId;
    IERC20 public usdcToken;
    uint256 public constant MINT_PRICE = 1000000;

    event NFTMinted(address indexed minter, uint256 tokenId);

    constructor(
        address _usdcAddress
    ) ERC721("Victor's NFT", "VNT") Ownable(msg.sender) {
        usdcToken = IERC20(_usdcAddress);
    }

    function mintNFT() external nonReentrant returns (uint256) {
        uint256 balance = usdcToken.balanceOf(msg.sender);
        require(balance >= MINT_PRICE, "Insufficient USDC balance");

        bool success = usdcToken.transferFrom(
            msg.sender,
            address(this),
            MINT_PRICE
        );
        require(success, "USDC transfer failed");

        uint256 newTokenId = _nextTokenId;
        _nextTokenId++;
        _safeMint(msg.sender, newTokenId);

        emit NFTMinted(msg.sender, newTokenId);

        return newTokenId;
    }
}

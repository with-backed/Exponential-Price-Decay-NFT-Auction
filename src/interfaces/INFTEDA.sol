// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import {ERC721} from "solmate/tokens/ERC721.sol";
import {ERC20} from "solmate/tokens/ERC20.sol";

interface INFTEDA {
    /// @notice struct containing all auction info
    /// @dev this struct is never stored, only a hash of it
    struct Auction {
        // the nft owner
        address nftOwner;
        // the nft token id
        uint256 auctionAssetID;
        // the nft contract address
        ERC721 auctionAssetContract;
        // How much the auction price should decay in each period
        // expressed as percent scaled by 1e18, i.e. 1e18 = 100%
        uint256 perPeriodDecayPercentWad;
        // the number of seconds in the period over which perPeriodDecay occurs
        uint256 secondsInPeriod;
        // the auction start price
        uint256 startPrice;
        // the payment asset
        ERC20 paymentAsset;
    }

    event StartAuction(
        uint256 indexed auctionID,
        uint256 indexed auctionAssetID,
        ERC721 indexed auctionAssetContract,
        address nftOwner,
        uint256 perPeriodDecayPercentWad,
        uint256 secondsInPeriod,
        uint256 startPrice,
        ERC20 paymentAsset
    );

    event EndAuction(uint256 indexed auctionID, uint256 price);

    /// @notice Returns the current price of the passed auction, reverts if no such auction exists
    /// @param auction The auction for which the caller wants to know the current price
    /// @return price the current amount required to purchase the NFT being sold in this auction
    function auctionCurrentPrice(Auction calldata auction) external view returns (uint256);

    /// @notice Returns a uint256 used to identify the auction
    /// @dev Derived from the auction. Identitical auctions cannot exist simultaneously
    /// @param auction The auction to get an ID for
    /// @return id the id of this auction
    function auctionID(Auction memory auction) external pure returns (uint256);

    /// @notice Returns the time at which startAuction was most recently successfully called for the given auction id
    /// @param id The id of the auction
    function auctionStartTime(uint256 id) external view returns (uint256);
}

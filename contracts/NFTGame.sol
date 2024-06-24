// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFTGame is ERC721{
    address public implementation;
    address public admin;
    struct nftX {
        uint256 nftId;
        uint8 nftType;
        uint256 level;
        uint256 rarity;
        uint256 score;
    }
    mapping(uint256=>nftX) private info;


    mapping(uint256=>bool) private hasExisted;
    mapping(uint256=>uint256) private lastSignInTime;

    modifier IsValidNftX(uint256 tokenId_) {
        //TODO
        require(info[tokenId_].nftType==1 | info[tokenId_].nftType==2,"invalid type");
        require(info[tokenId_].level<=30,"invalid level");
        require(info[tokenId_].rarity<=5,"invalid rarity");
        require(info[tokenId_].score<=100000,"invalid score");
        _;
    }

    error TokenNotExist();

    constructor(string name_,string symbol_) ERC721(name_,symbol_){
    }

    function upgradeLevel(uint256 tokenId_, uint256 levelsUp_) external IsValidNftX(tokenId_){
        if (ownerOf(tokenId_)==address(0)) {
            revert TokenNotExist();
        }
        require(ownerOf(tokenId_)==_msgSender() || getApproved(tokenId_)==_msgSender(),"Operation Not Allowed");

        //TODO
    }

    function upgradeRarity(uint256 tokenId_,uint256 rarityUp_) external{
        if (ownerOf(tokenId_)==address(0)) {
            revert TokenNotExist();
        }
        require(ownerOf(tokenId_)==_msgSender() || getApproved(tokenId_)==_msgSender(),"Operation Not Allowed");
        //TODO
    }

    function claimScore(uint256 tokenId_) external{
        if (ownerOf(tokenId_)==address(0)) {
            revert TokenNotExist();
        }
        require(ownerOf(tokenId_)==_msgSender() || getApproved(tokenId_)==_msgSender(),"Operation Not Allowed");
        //TODO
    }

    function deliverScore(uint256 tokenId_) public{
        require(admin==_msgSender(),"Only admin is allowed");
        if (ownerOf(tokenId_)==address(0)) {
            revert TokenNotExist();
        }
        //TODO
    }

    function signInDaily(uint256 tokenId_) external {
        if (ownerOf(tokenId_)==address(0)) {
            revert TokenNotExist();
        }
        require(ownerOf(tokenId_)==_msgSender() || getApproved(tokenId_)==_msgSender(),"Operation Not Allowed");

        uint256 currentTime = block.timestamp;
        uint256 lastSignIn = lastSignInTime[tokenId_];

        require(currentTime - lastSignIn >= 1 days, "Already signed in today");
        require(info[tokenId_].score<=100000,"Score over range");
        lastSignInTime[tokenId_] = currentTime;
        // TODO 签到奖励逻辑,比如增加积分
        info[tokenId_].score += 100;
    }

    function changeScore(uint256 tokenId_, uint256 score_) external {
        if (ownerOf(tokenId_)==address(0)) {
            revert TokenNotExist();
        }
        require(_msgSender()==admin,"Only admin is allowed");

        require(info[tokenId_].score<=100000,"Score over range");
        info[tokenId_].score=score_;
    }

    function mint(address to_, uint256 tokenId_,bytes memory data_) external {
        require(to_ !=address(0),"address invalid");
        require(!hasExisted[tokenId_],"Id has been minted");

        (uint8 nftType, uint256 level, uint256 rarity, uint256 score) = abi.decode(data_, (uint8, uint256, uint256, uint256));
        require(info[tokenId_].score<=100000,"Score over range");
        require();
        nftX memory newNFT = nftX({
            nftId: tokenId_,
            nftType: nftType,
            level: level,
            rarity: rarity,
            score: score
        });
        info[tokenId_] = newNFT;
        hasExisted[tokenId_] = true;
        _safeMint(to_, tokenId_,"");
    }

    function getNFTInfo(uint256 tokenId_) external returns(bytes){
        return abi.encodePacked(info[tokenId_]);
    }

    function getNFTLevel(uint256 tokenId_) external returns(uint256) {
        return info[tokenId_].level;
    }

    function getNFTRarity(uint256 tokenId_) external returns(uint256) {
        return info[tokenId_].rarity;
    }

    function getNFTType(uint256 tokenId_) external returns(uint8) {
        return info[tokenId_].nftType;
    }

    function getNFTScore(uint256 tokenId_) external returns(uint256) {
        return info[tokenId_].score;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return "";
    }

}
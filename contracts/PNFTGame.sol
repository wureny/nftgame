import "@openzeppelin/contracts/proxy/Proxy.sol";

contract PNFTGame is Proxy{
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

    constructor (address _implementation) {
        implementation=_implementation;
    }

    function _implementation() internal view virtual override returns (address){
        return implementation;
    }
}
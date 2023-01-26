// SPDX-License-Identifier: MIT
/*

Mocos 🤧 are 100 uniquely drawn doodle-like chibi NFTpfps made with love. some mocos are little demons, some mocos are just high, some are misfits and others are good vibes, mocos 🤧

@0xbluecow
@mocos_nft
#banned
#moo

            
*/


pragma solidity ^0.8.14;
import "https://github.com/ProjectOpenSea/operator-filter-registry/src/DefaultOperatorFilterer.sol";
import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract MOCOS is ERC721A, DefaultOperatorFilterer, Ownable {           
    address public constant MILADY_MAKER = 0x5Af0D9827E0c53E4799BB226655A1de152A425a5;
    address public constant SONORA_MAKER = 0x9a051C1794C2f0ED9518Fcb68973DA84f756e29E;
    address public constant MILADY_AURA = 0x2fC722C1c77170A61F17962CC4D039692f033b43;
    address public constant BORED_MILADY = 0xafe12842e3703a3cC3A71d9463389b1bF2c5BC1C;
    address public constant MILAIDY = 0x0D8A3359182DCa59CCAF36F5c6C6008b83ceB4A6;
    address public constant PIXELADY_MAKER = 0x8Fc0D90f2C45a5e7f94904075c952e0943CFCCfd;
    address public constant REMILIO = 0xD3D9ddd0CF0A5F0BFB8f7fcEAe075DF687eAEBaB;
    address public constant MILADY_RAVE = 0x880a965fAe95f72fe3a3C8e87ED2c9478C8e0a29;
    address public constant GHIBLADY_MAKER = 0x186E74aD45bF81fb3712e9657560f8f6361cbBef;
    address public constant PIXELADY_MAKER_BC = 0x4D40C64A8E41aC96b85eE557A434410672221750;

    address public constant FRIENDS = 0xE83C9F09B0992e4a34fAf125ed4FEdD3407c4a23;
    
    uint256 public cost = 1 ether;
    uint256 public WLcost = 0 ether;
    uint256 public freecost = 0.00 ether;
    uint256 public maxSupply = 100;
    uint256 public maxMintAmount = 1;
    uint256 public maxOwnerMintAmount = 3;
    uint16 public maxFriendMintAmount = 1;
    uint16 public totalFriend = 0;
    bool public PublicActive = false;        
    mapping(address => uint16) private _Friend;
    bool MiladyFriendsActive = false;    
    string public baseURI = "";    
    mapping(address => bool) public claimed;


    constructor(
        string memory _name,
        string memory _symbol) ERC721A(_name, _symbol) {               
        }

    modifier miladyFriends() {
        require(
            (ERC721(MILADY_MAKER).balanceOf(msg.sender) >= 1) ||
            (ERC721(SONORA_MAKER).balanceOf(msg.sender) >= 1) ||
            (ERC721(MILADY_AURA).balanceOf(msg.sender) >= 1) ||
            (ERC721(BORED_MILADY).balanceOf(msg.sender) >= 1) ||
            (ERC721(MILAIDY).balanceOf(msg.sender) >= 1) ||
            (ERC721(PIXELADY_MAKER).balanceOf(msg.sender) >= 1) ||
            (ERC721(REMILIO).balanceOf(msg.sender) >= 1) ||
            (ERC721(MILADY_RAVE).balanceOf(msg.sender) >= 1) ||
            (ERC721(GHIBLADY_MAKER).balanceOf(msg.sender) >= 1) ||            
            (ERC721(PIXELADY_MAKER_BC).balanceOf(msg.sender) >= 1),            
            "You need at least one Milady friend"
        );
        _;
    }
    modifier Friend() {
        require(
            (ERC721(FRIENDS).balanceOf(msg.sender) >= 1),            
            "You are not a friend"
        );
        _;
    }
    modifier publicMintActive(){
        require(PublicActive,
        "Mocos is coming soon");
        _;
    }
    modifier WLMintActive(){
        require(MiladyFriendsActive,
        "Mocos is coming soon");
        _;
    }

    function mint(uint16 _mintAmount) 
    external 
    payable
    publicMintActive
     {
        // _safeMint's second argument now takes in a quantity, not a tokenId.
        require(totalSupply() + _mintAmount <= maxSupply, "Not enough left to mint");
        require(_mintAmount + _numberMinted(msg.sender) <= maxMintAmount, "Only 10 mints per address");
        require(_mintAmount > 0, "Select at least 1 mocos");
        require(msg.value >= (cost * _mintAmount), "Pay Up");
        _safeMint(msg.sender, _mintAmount);
    }
    function wlMint(uint16 _mintAmount) 
    external 
    payable
    miladyFriends
    WLMintActive
     {
        // _safeMint's second argument now takes in a quantity, not a tokenId.
        require(totalSupply() + _mintAmount <= maxSupply, "Not enough left to mint");        
        require(_mintAmount + _numberMinted(msg.sender) <= maxMintAmount, "Only 10 mints per address");
        require(_mintAmount > 0,"Need to mint at least 1 mocos");       
        require(msg.value >= (WLcost * _mintAmount), "Pay Up");        
        _safeMint(msg.sender, _mintAmount);
    }
    function FriendMint()
    external 
    payable
    Friend
    WLMintActive
    {   
        require(_Friend[msg.sender] < maxFriendMintAmount);      
        require(totalFriend < 100);
        totalFriend = totalFriend + 1;
        _Friend[msg.sender] = 1;
        _safeMint(msg.sender, 1);
    }
    function ownerMint(uint16 _mintAmount) external payable onlyOwner {                
        require(_mintAmount + _numberMinted(msg.sender) <= maxOwnerMintAmount, "Greedy");
        require(totalSupply() + _mintAmount <= maxSupply, "Rip");        
        _safeMint(msg.sender, _mintAmount);
    }

    function toBytes32(address addr) pure internal returns (bytes32){
        return bytes32(uint256(uint160(addr)));
    }

    function withdraw() external payable onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    function setMintRate(uint256 _mintRate) public onlyOwner {
        cost = _mintRate;
    }

    function setMintAmount(uint256 _mintAmount) public onlyOwner {
        maxMintAmount = _mintAmount;
    }

    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }

    function setActive(bool _newStatus) public onlyOwner {
        PublicActive = _newStatus;
    }

    function setMiladyFriendsActive(bool _newStatus) public onlyOwner {
        MiladyFriendsActive = _newStatus;
    }
     function _startTokenId() internal view override returns (uint256) {
        return 1;
    }

    function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
        super.setApprovalForAll(operator, approved);
    }

    function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
        super.approve(operator, tokenId);
    }

    function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
        super.transferFrom(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
        super.safeTransferFrom(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
        public
        payable 
        override
        onlyAllowedOperator(from)
    {
        super.safeTransferFrom(from, to, tokenId, data);
    }
}

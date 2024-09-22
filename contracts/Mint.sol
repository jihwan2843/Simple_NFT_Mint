// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity >0.8.0 <=0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Mint is ERC721, Ownable{
    using Strings for uint256;

    // 현재 발행된 NFT 개수
    uint256 currentSupply;
    // 발행 할 수 있는 총 NFT의 개수
    uint256 MAX_SUPPLY = 100;
    bool isMintActive;
    //      tokenId => 1 ~ 8
    mapping (uint256 => uint256) tokenMetadataNo;

    constructor() ERC721("TEST","TS")Ownable(msg.sender){}

    function _baseURI() internal override pure returns (string memory) {
        return "ipfs://study";
    }
    // 관리자가 설정한 특정 상태일때 NFT를 민팅할 수 있음
    function setSale(bool _active) public onlyOwner{
        isMintActive = _active;
    }
    function mintNFT(uint count) external payable{
        require(isMintActive, "Minting is not allowed");
        require(msg.value > 0.001 ether, "sufficient ether");
        require(count <= 10, "count excced");

        for(uint i=0; i<count; i++){
            require(currentSupply < MAX_SUPPLY, "CurrentSupply exceed");
                                            // 블록 해쉬 값 생성을 사용하여 간단한 랜덤 숫자 생성
            tokenMetadataNo[currentSupply] = 1 + uint256(blockhash(block.number)) % 8 ;
            _safeMint(msg.sender, currentSupply++);
        }
        
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        _requireOwned(tokenId);

        string memory baseURI = _baseURI();
        return string.concat(baseURI, tokenMetadataNo[tokenId].toString());
    }

    // 관리자가 수익 인출하기
    function withdraw() external onlyOwner{
        payable(msg.sender).transfer(address(this).balance);
    }

}
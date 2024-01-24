// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NewsMint is ERC721, Ownable {
    uint256 public tokenIdCounter;

    // News structure
    struct News {
        string title;
        string content;
        uint256 timestamp;
        string username;
    }

    // Mapping from token ID to News article
    mapping(uint256 => News) private _newsArticles;

    // Mapping to track token existence
    mapping(uint256 => bool) private _tokenExists;

    // Mapping from username to array of token IDs
    mapping(string => uint256[]) private _userArticles;

    constructor() ERC721("NewsMint", "DCN") Ownable(msg.sender) {
        tokenIdCounter = 1;
    }

    // Mint a new NFT with a news article
    function mint(
        string memory title,
        string memory content,
        string memory username
    ) external onlyOwner {
        uint256 tokenId = tokenIdCounter;
        _safeMint(msg.sender, tokenId);
        _setNewsArticle(tokenId, title, content, username);
        tokenIdCounter++;
    }

    // Retrieve details of a specific NFT
    function getNewsArticle(
        uint256 tokenId
    )
        external
        view
        returns (
            string memory title,
            string memory content,
            uint256 timestamp,
            string memory username
        )
    {
        require(_tokenExists[tokenId], "Token does not exist");
        News memory newsArticle = _newsArticles[tokenId];
        return (
            newsArticle.title,
            newsArticle.content,
            newsArticle.timestamp,
            newsArticle.username
        );
    }

    // Retrieve all articles of a particular user
    function getArticlesByUser(
        string memory username
    ) external view returns (News[] memory) {
        uint256[] memory userTokens = _userArticles[username];
        News[] memory userArticles = new News[](userTokens.length);

        for (uint256 i = 0; i < userTokens.length; i++) {
            uint256 tokenId = userTokens[i];
            userArticles[i] = _newsArticles[tokenId];
        }

        return userArticles;
    }

    // Retrieve all articles
    function getAllArticles() external view returns (News[] memory) {
        News[] memory allArticles = new News[](tokenIdCounter - 1);

        for (uint256 i = 1; i < tokenIdCounter; i++) {
            allArticles[i - 1] = _newsArticles[i];
        }

        return allArticles;
    }

    // Internal function to set news article details
    function _setNewsArticle(
        uint256 tokenId,
        string memory title,
        string memory content,
        string memory username
    ) internal {
        require(!_tokenExists[tokenId], "Token already exists");
        _newsArticles[tokenId] = News(
            title,
            content,
            block.timestamp,
            username
        );
        _tokenExists[tokenId] = true;
        _userArticles[username].push(tokenId);
    }
}

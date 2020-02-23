pragma solidity 0.4.26;


/**
 * @notice - This is interface of yToken（YErc20）
 * @dev - Reference from https://docs.iearn.finance/yield-tokens/ydai
 */
interface IYErc20 {
    function balanceOf(address who) external view returns (uint256);

    function isYToken() external view returns (bool);

    function approve(address spender, uint256 value) external returns (bool);

    function calcPoolValueInToken(address account) external returns (uint256);

    function getPricePerFullShare() external returns (uint256);

    function deposit(uint256 _amount) external;

    function withdraw(uint256 _shares) external;

    function transfer(address recipient, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

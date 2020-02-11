pragma solidity 0.4.26;

import "../../bancor-protocol/token/interfaces/IERC20Token.sol";

/**
 * @title ERC20 Mock
 * @dev Mock class using ERC20
 */
contract ERC20Mock {
    /**
     * @dev Allows anyone to mint tokens to any address
     * @param to The address that will receive the minted tokens.
     * @param amount The amount of tokens to mint.
     * @return A boolean that indicates if the operation was successful.
     */
    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}

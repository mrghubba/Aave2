pragma solidity >=0.8.15;

import "./FlashLoanReceiverBase.sol";
import "./ILendingPool.sol";
import "./ILendingPoolAddressesProvider.sol";

// The following is the mainnet address for the LendingPoolAddressProvider. Get the correct address for your network from: https://docs.aave.com/developers/developing-on-aave/deployed-contract-instances
contract MyFlashloanContract is FlashLoanReceiverBase(address(0x24a42fD28C976A61Df5D00D0599C34c4f90748c8)) {

    function executeOperation(
        address _reserve,
        uint256 _amount,
        uint256 _fee,
        bytes calldata _params
    )
        external override
    {
        require(_amount <= getBalanceInternal(address(this), _reserve), "Invalid balance, was the flashLoan successful?");

        //
        // do your thing here
        //

        // Time to transfer the funds back
        uint totalDebt = _amount.add(_fee);
        transferFundsBackToPoolInternal(_reserve, totalDebt);
    }

    function flashloan() public onlyOwner {
        bytes memory data = "";
        uint amount = 1 ether;
        address asset = address(0x428D4b75c90eF87d6c586D9423a07c3a7E0a968A); // mainnet DAI, for more asset addresses, see: https://docs.aave.com/developers/developing-on-aave/deployed-contract-instances

        ILendingPool lendingPool = ILendingPool(addressesProvider.getLendingPool());
        lendingPool.flashLoan(address(this), asset, amount, data);
    }
}

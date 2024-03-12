//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { DappFunctionality, BySelector } from "./FunctionalitiesAPIs.sol";

contract Dapp {

    constructor(address initializer, bytes memory initData) payable {
        return _delegateCall(initializer, initData, true);
    }

    fallback() external payable {
        return _delegateCall(msg.sig, msg.data);
    }

    receive() external payable {
        return _delegateCall(0xe71ebeed, abi.encodeWithSelector(0xe71ebeed));//onETHReceived()
    }

    function _delegateCall(bytes4 selector, bytes memory data) private {
        DappFunctionality memory dappFunctionality = BySelector.bySelector(selector);
        require(dappFunctionality.location != address(0), "unavailable");
        require(!dappFunctionality.isPrivate || msg.sender == address(this), "unauthorized");
        _delegateCall(dappFunctionality.authorizationVerifier, abi.encodeWithSelector(0x29a0d99a, selector, data), true);//verifyAuthorization(bytes4,bytes)
        return _delegateCall(dappFunctionality.location, data, false);
    }

    function _delegateCall(address location, bytes memory data, bool noResult) private {
        if(location == address(0)) {
            return;
        }
        (bool result, bytes memory response) = location.delegatecall(data);
        assembly {
            switch result
                case 0 {revert(add(response, 0x20), mload(response))}
                default { switch noResult case 0 {return(add(response, 0x20), mload(response))}}
        }
    }
}
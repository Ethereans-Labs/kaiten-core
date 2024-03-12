//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { BaseVar } from "./DappUtilities.sol";
import { SetVar, ClearVar } from "./StorageAPIs.sol";
import { Bool } from "./StorageUtilities.sol";
import { DappFunctionality, SetFunctionality } from "./FunctionalitiesAPIs.sol";

import { ReflectionUtilities, BehaviorUtilities, BytesUtilities } from "./GeneralUtilities.sol";

contract DappInitializer {
    using BytesUtilities for bytes;

    function init(bytes memory initPayload) external {
        require(!Bool.setBool(BaseVar.INITIALIZED, true));
        _init(initPayload);
    }

    function _init(bytes memory initPayload) private {
        if(initPayload.length == 0) {
            return;
        }
        bytes memory current;
        (initPayload, current) = abi.decode(initPayload, (bytes, bytes));
        _init(initPayload);
        if(current.length > 0) {
            address location;
            (location, current) = abi.decode(current, (address, bytes));
            if(current.length > 0) {
                if(location != address(0)) {
                    _deployOrDelegateCall(location, current);
                } else {
                    _initSequence(current);
                }
            }
        }
    }

    function _initSequence(bytes memory initPayload) private {

        (bytes memory tempVars, bytes memory beforeInit, bytes memory initVars, bytes memory functionalities, bytes memory afterInit) = abi.decode(initPayload, (bytes, bytes, bytes, bytes, bytes));

        _setVars(tempVars, false);
        _deployOrDelegateCall(beforeInit);
        _setVars(initVars, false);
        _setupFunctionalities(functionalities);
        _deployOrDelegateCall(afterInit);
        _setVars(tempVars, true);
    }

    function _setVars(bytes memory data, bool clear) private {
        if(data.length == 0) {
            return;
        }
        bytes memory current;
        (data, current) = abi.decode(data, (bytes, bytes));
        _setVars(data, clear);
        if(current.length > 0) {
            (string memory varName, bytes memory additionalData, bytes32 varType, bytes memory value) = abi.decode(current, (string, bytes, bytes32, bytes));
            if(clear) {
                ClearVar.clearVar(varName, additionalData);
            } else {
                SetVar.setVar(varName, additionalData, varType, value);
            }
        }
    }

    function _deployOrDelegateCall(bytes memory data) private {
        if(data.length == 0) {
            return;
        }
        bytes memory current;
        (data, current) = abi.decode(data, (bytes, bytes));
        _deployOrDelegateCall(data);
        if(current.length > 0) {
            (address location, bytes memory payload) = abi.decode(current, (address, bytes));
            _deployOrDelegateCall(location, payload);
        }
    }

    function _deployOrDelegateCall(address location, bytes memory payload) private {
        if(location != address(0)) {
            ReflectionUtilities.delegateCall(location, payload);
        } else {
            _deploy(payload);
        }
    }

    function _deploy(bytes memory initPayload) private {
        if(initPayload.length == 0) {
            return;
        }
        uint256 value;
        (value, initPayload) = abi.decode(initPayload, (uint256, bytes));

        _deploy(value, initPayload);
    }

    function _deploy(uint256 value, bytes memory initPayload) private returns (address productAddress) {
        assembly {
            productAddress := create(value, add(initPayload, 0x20), mload(initPayload))
            switch extcodesize(productAddress) case 0 {
                invalid()
            }
        }
    }

    function _setupFunctionalities(bytes memory data) private {
        if(data.length == 0) {
            return;
        }
        bytes memory current;
        (data, current) = abi.decode(data, (bytes, bytes));
        _setupFunctionalities(data);
        if(current.length > 0) {
            uint256 value;
            DappFunctionality[] memory dappFunctionalities;
            (value, current, dappFunctionalities) = abi.decode(current, (uint256, bytes, DappFunctionality[]));
            if(current.length != 0) {
                address location = _deploy(value, current);
                for(uint256 i = 0; i < dappFunctionalities.length; i++) {
                    dappFunctionalities[i].location = location;
                }
            }
            for(uint256 i = 0; i < dappFunctionalities.length; i++) {
                SetFunctionality.setFunctionality(dappFunctionalities[i]);
            }
        }
    }
}
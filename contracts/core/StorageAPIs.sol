//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./LowLevelStorageAPIs.sol";

library VarExists {

    function varExists(string memory name) internal view returns(bytes32 entryType, bool isMapping, bytes32 entryTypeLocation) {
        entryTypeLocation = keccak256(abi.encodePacked(name, bytes32(0x9c8cb07ed5968ca86b70234b0b931d7a39d7037e00b24a7c0ea4e5be210934e4)));//keccak256('storageVarType')
        assembly {
            entryType := sload(entryTypeLocation)
            switch iszero(entryType) case 0 {
                isMapping := iszero(sload(keccak256(add(name, 0x20), mload(name))))
            }
        }
    }
}

library GetVarFull {

    function getVar(string memory name, bytes memory additional) internal view returns(bytes memory value, bytes32 entryType) {
        (entryType,,) = VarExists.varExists(name);
        value = entryType == bytes32(0) ? value : LowLevelStorageGetter.getVar(keccak256(abi.encodePacked(name, additional)));
    }

    function getVar(string memory name) internal view returns(bytes memory value, bytes32 entryType) {
        return getVar(name, "");
    }
}

library GetVar {

    function getVar(string memory name, bytes memory additional) internal view returns(bytes memory value) {
        (bytes32 entryType,,) = VarExists.varExists(name);
        value = entryType == bytes32(0) ? value : LowLevelStorageGetter.getVar(keccak256(abi.encodePacked(name, additional)));
    }

    function getVar(string memory name) internal view returns(bytes memory value) {
        return getVar(name, "");
    }
}

library SetVar {

    event StorageKey(string indexed nameHash, string name);

    function setVar(string memory name, bytes memory additional, bytes32 entryType, bytes memory newValue) internal returns(bytes memory oldValue) {
        (bytes32 entryTypeResult, bool isMapping, bytes32 entryTypeLocation) = VarExists.varExists(name);

        if(entryTypeResult == bytes32(0)) {
            if(newValue.length == 0) {
                return oldValue;
            }
            require(entryType != bytes32(0), "type");
            assembly {
                sstore(entryTypeLocation, entryType)
                log2(add(name, 0x20), mload(name), 0x02f39e5f06a4b3c1afc21c80516e91954a980ac0b37dbbd638b2912f628173ee, keccak256(add(name, 0x20), mload(name)))//keccak256('StorageKey(string,string)')
            }
        } else {
            require(newValue.length == 0 || entryType == entryTypeResult, "type");
            require(newValue.length == 0 || (additional.length == 0 && !isMapping) || ((additional.length != 0 && isMapping)), "mapping");
            assembly {
                switch and(iszero(mload(newValue)), iszero(isMapping)) case 1 {
                    sstore(entryTypeLocation, 0)
                }
            }
        }

        oldValue = LowLevelStorageSetter.setVar(keccak256(abi.encodePacked(name, additional)), newValue);
    }

    function setVar(string memory name, bytes32 entryType, bytes memory newValue) internal returns(bytes memory oldValue) {
        return setVar(name, "", entryType, newValue);
    }
}

library ClearVar {
    function clearVar(string memory name, bytes memory additional) internal returns(bytes memory oldValue) {
        return SetVar.setVar(name, additional, bytes32(0), "");
    }

    function clearVar(string memory name) internal returns(bytes memory oldValue) {
        return SetVar.setVar(name, "", bytes32(0), "");
    }
}

library ListVars {
    function listVars(string[] memory names, bytes[] memory additionals) internal view returns(bytes[] memory values, bytes32[] memory entryTypes) {
        values = new bytes[](names.length);
        entryTypes = new bytes32[](names.length);
        for(uint256 i = 0; i < names.length; i++) {
            (values[i], entryTypes[i]) = GetVarFull.getVar(names[i], i < additionals.length ? additionals[i] : bytes(""));
        }
    }

    function listVars(string[] memory names) internal view returns(bytes[] memory values, bytes32[] memory entryTypes) {
        return listVars(names, new bytes[](0));
    }
}
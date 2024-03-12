//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { GetVar, ClearVar, SetVar } from "./StorageAPIs.sol";

struct DappFunctionality {
    address location;
    string methodSignature;
    bool submittable;
    string returnABIParametersJSONArray;
    bool isPrivate;
    address authorizationVerifier;
    bytes4 selectorToReplace;
}

library Grimoire {
    string public constant FUNCTIONALITY_MAPPING_NAME = "functionality";

    bytes32 public constant FUNCTIONALITY_TYPE = bytes32(0xc67c0557677de598aea3bc400f2521d22fc5d747821318461ac406b96a37cf73);
}

library BySelector {
    function bySelector(bytes4 selector) internal view returns(DappFunctionality memory result) {
        bytes memory data = GetVar.getVar(Grimoire.FUNCTIONALITY_MAPPING_NAME, abi.encodePacked(selector));
        result = data.length == 0 ? result : abi.decode(data, (DappFunctionality));
    }
}

library SetFunctionality {
    function setFunctionality(DappFunctionality memory newValue) internal returns(DappFunctionality memory oldValue) {

        bytes4 thisSelector = bytes4(keccak256(bytes(newValue.methodSignature)));

        bytes4 selectorToReplace = newValue.selectorToReplace;

        DappFunctionality memory copy = abi.decode(abi.encode(newValue), (DappFunctionality));
        copy.selectorToReplace = bytes4(0);

        if(selectorToReplace == bytes4(0) || thisSelector == selectorToReplace) {
            bytes memory oldDataValue = copy.location == address(0)
                ? ClearVar.clearVar(Grimoire.FUNCTIONALITY_MAPPING_NAME, abi.encodePacked(thisSelector))
                : SetVar.setVar(Grimoire.FUNCTIONALITY_MAPPING_NAME, abi.encodePacked(thisSelector), Grimoire.FUNCTIONALITY_TYPE, abi.encode(copy));
            return oldValue = (oldDataValue.length == 0 ? oldValue : abi.decode(oldDataValue, (DappFunctionality)));
        }

        if(selectorToReplace != bytes4(0)) {
            bytes memory oldDataValue = ClearVar.clearVar(Grimoire.FUNCTIONALITY_MAPPING_NAME, abi.encodePacked(selectorToReplace));
            oldValue = (oldDataValue.length == 0 ? oldValue : abi.decode(oldDataValue, (DappFunctionality)));
        }

        SetVar.setVar(Grimoire.FUNCTIONALITY_MAPPING_NAME, abi.encodePacked(thisSelector), Grimoire.FUNCTIONALITY_TYPE, abi.encode(copy));
    }
}

library FunctionalitiesManager {

}
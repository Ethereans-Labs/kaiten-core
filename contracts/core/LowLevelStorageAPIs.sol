//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library LowLevelStorageGetter {
    function getVar(bytes32 key) internal view returns (bytes memory value) {
        assembly {
            let size := sload(key)
            switch iszero(size) case 0 {
                let l_32 := 0x20
                value := mload(0x40)
                mstore(value, size)
                let payloadStart := add(value, l_32)
                mstore(0x40, add(payloadStart, size))
                for { let i := 0 let cursor := add(key, 1) } lt(i, size) { i := add(i, l_32) } {
                    mstore(add(payloadStart, i), sload(add(cursor, i)))
                }
            }
        }
    }
}

library LowLevelStorageSetter {

    function setVar(bytes32 key, bytes memory value) internal returns (bytes memory oldValue) {
        uint256 size = (oldValue = LowLevelStorageGetter.getVar(key)).length;
        assembly {
            let zero := 0x00
            let l_32 := 0x20
            let newLengthSize := mload(value)
            sstore(key, newLengthSize)
            switch lt(size, newLengthSize) case 1 {
                size := newLengthSize
            }
            let payloadStart := add(value, l_32)
            for { let i := zero let cursor := add(key, 1) } lt(i, size) { i := add(i, l_32) } {
                switch lt(i, newLengthSize) case 1 {
                    sstore(add(cursor, i), mload(add(payloadStart, i)))
                }
                default {
                    sstore(add(cursor, i), zero)
                }
            }
        }
    }
}
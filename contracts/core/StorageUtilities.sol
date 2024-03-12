// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { BytesUtilities } from "./GeneralUtilities.sol";
import { GetVar, SetVar } from "./StorageAPIs.sol";

library BaseType {
    bytes32 constant public ADDRESS = 0x421683f821a0574472445355be6d2b769119e8515f8376a1d7878523dfdecf7b;
    bytes32 constant public ADDRESS_ARRAY = 0x23d8ff3dc5aed4a634bcf123581c95e70c60ac0e5246916790aef6d4451ff4c1;
    bytes32 constant public BOOL = 0xc1053bdab4a5cf55238b667c39826bbb11a58be126010e7db397c1b67c24271b;
    bytes32 constant public BOOL_ARRAY = 0x8761250c4d2c463ce51f91f5d2c2508fa9142f8a42aa9f30b965213bf3e6c2ac;
    bytes32 constant public BYTES32 = 0x9878dbb4b82cd531125f404fb8b4e286be6caa0f6c53cbd7232eacf63b84cbca;
    bytes32 constant public BYTES32_ARRAY = 0xc0427979afaacd6700c565f1ebd818363531736212863c1c3c9b5b30dac10314;
    bytes32 constant public BYTES = 0xb963e9b45d014edd60cff22ec9ad383335bbc3f827be2aee8e291972b0fadcf2;
    bytes32 constant public BYTES_ARRAY = 0x084b42f8a8730b98eb0305d92103d9107363192bb66162064a34dc5716ebe1a0;
    bytes32 constant public STRING = 0x97fc46276c172633607a331542609db1e3da793fca183d594ed5a61803a10792;
    bytes32 constant public STRING_ARRAY = 0xa227fd7a847724343a7dda3598ee0fb2d551b151b73e4a741067596daa6f5658;
    bytes32 constant public UINT256 = 0xec13d6d12b88433319b64e1065a96ea19cd330ef6603f5f6fb685dde3959a320;
    bytes32 constant public UINT256_ARRAY = 0xc1b76e99a35aa41ed28bbbd9e6c7228760c87b410ebac94fa6431da9b592411f;
}

library Uint256 {
    using BytesUtilities for bytes;

    function getUint256(string memory name) internal view returns(uint256) {
        return GetVar.getVar(name).asUint256();
    }

    function setUint256(string memory name, uint256 val) internal returns(uint256 oldValue) {
        return SetVar.setVar(name, BaseType.UINT256, abi.encode(val)).asUint256();
    }

    function increaseUint256(string memory name) internal returns (uint256 oldValue) {
        return setUint256(name, getUint256(name) + 1);
    }

    function decreaseUint256(string memory name) internal returns (uint256 oldValue) {
        return setUint256(name, getUint256(name) - 1);
    }
}

library Bool {
    using BytesUtilities for bytes;

    function getBool(string memory name) internal view returns(bool) {
        return GetVar.getVar(name).asBool();
    }

    function setBool(string memory name, bool val) internal returns(bool oldValue) {
        return SetVar.setVar(name, BaseType.BOOL, abi.encode(val ? 1 : 0)).asBool();
    }
}

library Bytes32 {
    using BytesUtilities for bytes;

    function getBytes32(string memory name) internal view returns(bytes32) {
        return GetVar.getVar(name).asBytes32();
    }

    function setBytes32(string memory name, bytes32 val) internal returns(bytes32 oldValue) {
        return SetVar.setVar(name, BaseType.BYTES32, abi.encode(val)).asBytes32();
    }
}

library State {
    using BytesUtilities for bytes;

    function getAddress(string memory name) internal view returns(address) {
        return GetVar.getVar(name).asAddress();
    }

    function setAddress(string memory name, address val) internal returns(address oldValue) {
        return SetVar.setVar(name, BaseType.ADDRESS, abi.encodePacked(val)).asAddress();
    }

    function getAddressArray(string memory name) internal view returns(address[] memory) {
        return GetVar.getVar(name).asAddressArray();
    }

    function setAddressArray(string memory name, address[] memory val) internal returns(address[] memory oldValue) {
        return SetVar.setVar(name, BaseType.ADDRESS_ARRAY, abi.encode(val)).asAddressArray();
    }

    function getBool(string memory name) internal view returns(bool) {
        return GetVar.getVar(name).asBool();
    }

    function setBool(string memory name, bool val) internal returns(bool oldValue) {
        return SetVar.setVar(name, BaseType.BOOL, abi.encode(val ? 1 : 0)).asBool();
    }

    function getBoolArray(string memory name) internal view returns(bool[] memory) {
        return GetVar.getVar(name).asBoolArray();
    }

    function setBoolArray(string memory name, bool[] memory val) internal returns(bool[] memory oldValue) {
        return SetVar.setVar(name, BaseType.BOOL_ARRAY, abi.encode(val)).asBoolArray();
    }

    function getBytes(string memory name) internal view returns(bytes memory) {
        return GetVar.getVar(name);
    }

    function setBytes(string memory name, bytes memory val) internal returns(bytes memory oldValue) {
        return SetVar.setVar(name, BaseType.BYTES, val);
    }

    function getBytesArray(string memory name) internal view returns(bytes[] memory) {
        return GetVar.getVar(name).asBytesArray();
    }

    function setBytesArray(string memory name, bytes[] memory val) internal returns(bytes[] memory oldValue) {
        return SetVar.setVar(name, BaseType.BYTES_ARRAY, abi.encode(val)).asBytesArray();
    }

    function getString(string memory name) internal view returns(string memory) {
        return string(GetVar.getVar(name));
    }

    function setString(string memory name, string memory val) internal returns(string memory oldValue) {
        return string(SetVar.setVar(name, BaseType.STRING, bytes(val)));
    }

    function getStringArray(string memory name) internal view returns(string[] memory) {
        return GetVar.getVar(name).asStringArray();
    }

    function setStringArray(string memory name, string[] memory val) internal returns(string[] memory oldValue) {
        return SetVar.setVar(name, BaseType.STRING_ARRAY, abi.encode(val)).asStringArray();
    }

    function getUint256Array(string memory name) internal view returns(uint256[] memory) {
        return GetVar.getVar(name).asUint256Array();
    }

    function setUint256Array(string memory name, uint256[] memory val) internal returns(uint256[] memory oldValue) {
        return SetVar.setVar(name, BaseType.UINT256_ARRAY, abi.encode(val)).asUint256Array();
    }
}
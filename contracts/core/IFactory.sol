//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IFactory {
    function generateInitPayload(bytes memory payload) external payable returns(uint256 value, bytes memory initPayload);
}
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IFactoryOfFactories {

    function size() external view returns (uint256);
    function all() external view returns (address[] memory hosts, address[][] memory factoryLists);
    function partialList(uint256 start, uint256 offset) external view returns (address[] memory hosts, address[][] memory factoryLists);

    function get(uint256 index) external view returns(address factoryHost, address[] memory factoryList);

    function create(address[] calldata hosts, bytes[][] calldata factoryBytecodes) external returns (address[][] memory factoryLists, uint256[] memory listPositions);
    function setFactoryListsMetadata(uint256[] calldata listPositions, address[] calldata newHosts) external returns (address[] memory replacedHosts);
    event FactoryList(uint256 indexed listPosition, address indexed fromHost, address indexed toHost);

    function add(uint256[] calldata listPositions, bytes[][] calldata factoryBytecodes) external returns(address[][] memory factoryLists, uint256[][] memory factoryPositions);
    event FactoryAdded(uint256 indexed listPosition, address indexed host, address indexed factoryAddress, uint256 factoryPosition);

    function payFee(address sender, address tokenAddress, uint256 value, bytes calldata permitSignature, uint256 feePercentage, address feeReceiver) external payable returns (uint256 feeSentOrBurnt, uint256 feePaid);
    function burnOrTransferTokenAmount(address sender, address tokenAddress, uint256 value, bytes calldata permitSignature, address receiver) external payable returns(uint256 feeSentOrBurnt, uint256 amountTransferedOrBurnt);

    struct DeployData {
        address deployer;
        uint256 list;
        uint256 position;
        bool singleton;
    }

    event Deployed(address indexed productAddress, address indexed deployer);
    event Deployed(address indexed productAddress, uint256 indexed list, uint256 indexed position);

    function host() external view returns (address hostAddress);
    function setHost(address newValue) external returns(address oldValue);

    function deployData(address productAddress) external view returns(address deployer, uint256 list, uint256 position, bool singleton);
    function multipleDeployData(address[] calldata productAddresses) external view returns(DeployData[] memory result);

    function deploy(uint256 list, uint256 position, bytes memory initPayload) external payable returns(address productAddress);

    function deploySingleton(bytes memory initPayload) external payable returns(address productAddress);
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.34;

interface IERC20MinimalV11 {
    function transfer(address to, uint256 amount) external returns (bool);
}

contract AgentVaultV11 {
    address public owner;
    address public pendingOwner;

    address public agent;
    address public pendingAgent;

    address public guardian;

    bool public paused;

    uint256 public maxPerTx;
    uint256 public dailyLimit;
    uint256 public spentToday;
    uint256 public currentDay;

    uint256 public decisionNonce;

    mapping(address => bool) public allowedTargets;
    mapping(address => mapping(bytes4 => bool)) public allowedSelectors;

    mapping(bytes32 => bool) public usedDecisionHashes;

    struct TokenPolicy {
        bool enabled;
        uint256 maxPerTx;
        uint256 dailyLimit;
        uint256 spentToday;
        uint256 currentDay;
    }

    mapping(address => TokenPolicy) public tokenPolicies;
    mapping(address => bool) public tokenPolicyConfigured;
    mapping(address => mapping(address => bool)) public allowedTokenRecipients;

    uint256 private constant NOT_ENTERED = 1;
    uint256 private constant ENTERED = 2;

    uint256 private reentrancyStatus;

    bytes32 public constant NATIVE_EXECUTION_TYPE =
        keccak256("AGENTVAULT_V11_NATIVE_EXECUTION");

    bytes32 public constant TOKEN_TRANSFER_TYPE =
        keccak256("AGENTVAULT_V11_TOKEN_TRANSFER");

    event Deposited(address indexed from, uint256 amount);
    event Withdrawn(address indexed to, uint256 amount);

    event OwnershipTransferStarted(
        address indexed currentOwner,
        address indexed pendingOwner
    );

    event OwnershipTransferCancelled(address indexed owner);

    event OwnershipTransferred(
        address indexed oldOwner,
        address indexed newOwner
    );

    event AgentTransferStarted(
        address indexed currentAgent,
        address indexed pendingAgent
    );

    event AgentUpdated(
        address indexed oldAgent,
        address indexed newAgent
    );

    event AgentDisabled(address indexed oldAgent);

    event GuardianUpdated(
        address indexed oldGuardian,
        address indexed newGuardian
    );

    event TargetUpdated(
        address indexed target,
        bool allowed
    );

    event SelectorUpdated(
        address indexed target,
        bytes4 indexed selector,
        bool allowed
    );

    event PolicyUpdated(
        uint256 maxPerTx,
        uint256 dailyLimit
    );

    event TokenPolicyUpdated(
        address indexed token,
        bool enabled,
        uint256 maxPerTx,
        uint256 dailyLimit
    );

    event TokenRecipientUpdated(
        address indexed token,
        address indexed recipient,
        bool allowed
    );

    event PauseUpdated(
        address indexed caller,
        bool paused
    );

    event AgentExecution(
        address indexed agent,
        address indexed target,
        bytes4 indexed selector,
        uint256 value,
        uint256 nonce,
        bytes32 decisionHash,
        bytes returnData
    );

    event AgentTokenTransfer(
        address indexed agent,
        address indexed token,
        address indexed recipient,
        uint256 amount,
        uint256 nonce,
        bytes32 decisionHash
    );

    event TokenRescued(
        address indexed token,
        address indexed to,
        uint256 amount
    );

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier onlyAgent() {
        require(msg.sender == agent, "Not agent");
        _;
    }

    modifier whenNotPaused() {
        require(!paused, "Vault paused");
        _;
    }

    modifier nonReentrant() {
        require(
            reentrancyStatus != ENTERED,
            "Reentrant call"
        );

        reentrancyStatus = ENTERED;
        _;
        reentrancyStatus = NOT_ENTERED;
    }

    constructor(
        address initialAgent,
        uint256 initialMaxPerTx,
        uint256 initialDailyLimit
    ) {
        require(
            initialAgent != address(0),
            "Invalid agent"
        );

        require(
            initialMaxPerTx <= initialDailyLimit,
            "Max tx > daily limit"
        );

        owner = msg.sender;
        agent = initialAgent;

        maxPerTx = initialMaxPerTx;
        dailyLimit = initialDailyLimit;

        currentDay =
            block.timestamp / 1 days;

        reentrancyStatus = NOT_ENTERED;
    }

    receive() external payable {
        require(
            msg.value > 0,
            "Zero deposit"
        );

        emit Deposited(
            msg.sender,
            msg.value
        );
    }

    function deposit()
        external
        payable
    {
        require(
            msg.value > 0,
            "Zero deposit"
        );

        emit Deposited(
            msg.sender,
            msg.value
        );
    }

    // ============================================================
    // OWNERSHIP
    // ============================================================

    function transferOwnership(
        address newOwner
    )
        external
        onlyOwner
    {
        require(
            newOwner != address(0),
            "Invalid owner"
        );

        require(
            newOwner != owner,
            "Already owner"
        );

        pendingOwner = newOwner;

        emit OwnershipTransferStarted(
            owner,
            newOwner
        );
    }

    function cancelOwnershipTransfer()
        external
        onlyOwner
    {
        pendingOwner = address(0);

        emit OwnershipTransferCancelled(
            owner
        );
    }

    function acceptOwnership()
        external
    {
        require(
            msg.sender == pendingOwner,
            "Not pending owner"
        );

        address oldOwner = owner;

        owner = pendingOwner;
        pendingOwner = address(0);

        emit OwnershipTransferred(
            oldOwner,
            owner
        );
    }

    // ============================================================
    // AGENT
    // ============================================================

    function proposeAgent(
        address newAgent
    )
        external
        onlyOwner
    {
        require(
            newAgent != address(0),
            "Invalid agent"
        );

        require(
            newAgent != agent,
            "Already agent"
        );

        pendingAgent = newAgent;

        /*
         * Security hardening:
         * starting an agent rotation automatically
         * freezes agent execution.
         */
        paused = true;

        emit AgentTransferStarted(
            agent,
            newAgent
        );

        emit PauseUpdated(
            msg.sender,
            true
        );
    }

    function acceptAgent()
        external
    {
        require(
            msg.sender == pendingAgent,
            "Not pending agent"
        );

        address oldAgent = agent;

        agent = pendingAgent;
        pendingAgent = address(0);

        /*
         * Vault intentionally stays paused.
         * Owner must explicitly review and unpause.
         */

        emit AgentUpdated(
            oldAgent,
            agent
        );
    }

    function disableAgent()
        external
        onlyOwner
    {
        address oldAgent = agent;

        agent = address(0);
        pendingAgent = address(0);
        paused = true;

        emit AgentDisabled(
            oldAgent
        );

        emit PauseUpdated(
            msg.sender,
            true
        );
    }

    // ============================================================
    // GUARDIAN / PAUSE
    // ============================================================

    function setGuardian(
        address newGuardian
    )
        external
        onlyOwner
    {
        address oldGuardian =
            guardian;

        guardian = newGuardian;

        emit GuardianUpdated(
            oldGuardian,
            newGuardian
        );
    }

    function setPaused(
        bool state
    )
        external
    {
        if (state) {
            require(
                msg.sender == owner ||
                msg.sender == guardian,
                "Not authorized to pause"
            );
        } else {
            require(
                msg.sender == owner,
                "Only owner can unpause"
            );

            require(
                agent != address(0),
                "No active agent"
            );
        }

        paused = state;

        emit PauseUpdated(
            msg.sender,
            state
        );
    }

    // ============================================================
    // TARGET + FUNCTION SELECTOR PERMISSIONS
    // ============================================================

    function setTarget(
        address target,
        bool allowed
    )
        external
        onlyOwner
    {
        require(
            target != address(0),
            "Invalid target"
        );

        require(
            target != address(this),
            "Vault target forbidden"
        );

        allowedTargets[target] =
            allowed;

        emit TargetUpdated(
            target,
            allowed
        );
    }

    function setSelector(
        address target,
        bytes4 selector,
        bool allowed
    )
        external
        onlyOwner
    {
        require(
            target != address(0),
            "Invalid target"
        );

        require(
            target != address(this),
            "Vault target forbidden"
        );

        allowedSelectors[target][selector] =
            allowed;

        emit SelectorUpdated(
            target,
            selector,
            allowed
        );
    }

    // ============================================================
    // NATIVE SVP POLICY
    // ============================================================

    function setPolicy(
        uint256 newMaxPerTx,
        uint256 newDailyLimit
    )
        external
        onlyOwner
    {
        require(
            newMaxPerTx <= newDailyLimit,
            "Max tx > daily limit"
        );

        maxPerTx =
            newMaxPerTx;

        dailyLimit =
            newDailyLimit;

        emit PolicyUpdated(
            newMaxPerTx,
            newDailyLimit
        );
    }

    // ============================================================
    // ERC20 POLICY
    // ============================================================

    function setTokenPolicy(
        address token,
        bool enabled,
        uint256 tokenMaxPerTx,
        uint256 tokenDailyLimit
    )
        external
        onlyOwner
    {
        require(
            token != address(0),
            "Invalid token"
        );

        require(
            tokenMaxPerTx <= tokenDailyLimit,
            "Max tx > daily limit"
        );

        TokenPolicy storage policy =
            tokenPolicies[token];

        tokenPolicyConfigured[token] = true;

        policy.enabled =
            enabled;

        policy.maxPerTx =
            tokenMaxPerTx;

        policy.dailyLimit =
            tokenDailyLimit;

        if (policy.currentDay == 0) {
            policy.currentDay =
                block.timestamp / 1 days;
        }

        emit TokenPolicyUpdated(
            token,
            enabled,
            tokenMaxPerTx,
            tokenDailyLimit
        );
    }

    function setTokenRecipient(
        address token,
        address recipient,
        bool allowed
    )
        external
        onlyOwner
    {
        require(
            token != address(0),
            "Invalid token"
        );

        require(
            recipient != address(0),
            "Invalid recipient"
        );

        allowedTokenRecipients[token][recipient] =
            allowed;

        emit TokenRecipientUpdated(
            token,
            recipient,
            allowed
        );
    }

    // ============================================================
    // DECISION HASH
    // ============================================================

    function computeDecisionHash(
        address target,
        uint256 value,
        bytes calldata data,
        uint256 nonce
    )
        public
        view
        returns (bytes32)
    {
        return keccak256(
            abi.encode(
                NATIVE_EXECUTION_TYPE,
                block.chainid,
                address(this),
                agent,
                target,
                value,
                keccak256(data),
                nonce
            )
        );
    }

    function computeTokenTransferDecisionHash(
        address token,
        address recipient,
        uint256 amount,
        uint256 nonce
    )
        public
        view
        returns (bytes32)
    {
        return keccak256(
            abi.encode(
                TOKEN_TRANSFER_TYPE,
                block.chainid,
                address(this),
                agent,
                token,
                recipient,
                amount,
                nonce
            )
        );
    }

    // ============================================================
    // GENERIC AGENT EXECUTION
    // ============================================================

    function execute(
        address target,
        uint256 value,
        bytes calldata data,
        bytes32 decisionHash
    )
        external
        onlyAgent
        whenNotPaused
        nonReentrant
        returns (bytes memory)
    {
        require(
            target != address(0),
            "Invalid target"
        );

        require(
            target != address(this),
            "Self call not allowed"
        );

        require(
            !tokenPolicyConfigured[target],
            "Token must use token execution path"
        );

        require(
            allowedTargets[target],
            "Target not allowed"
        );

        bytes4 selector;

        if (data.length == 0) {
            selector = bytes4(0);
        } else {
            require(
                data.length >= 4,
                "Invalid calldata"
            );

            assembly {
                selector := calldataload(data.offset)
            }
        }

        require(
            allowedSelectors[target][selector],
            "Selector not allowed"
        );

        require(
            value <= maxPerTx,
            "Per-tx limit exceeded"
        );

        require(
            address(this).balance >= value,
            "Insufficient vault balance"
        );

        uint256 today =
            block.timestamp / 1 days;

        if (today != currentDay) {
            currentDay = today;
            spentToday = 0;
        }

        require(
            spentToday + value <= dailyLimit,
            "Daily limit exceeded"
        );

        uint256 nonce =
            decisionNonce;

        bytes32 expected =
            computeDecisionHash(
                target,
                value,
                data,
                nonce
            );

        require(
            decisionHash == expected,
            "Invalid decision hash"
        );

        require(
            !usedDecisionHashes[decisionHash],
            "Decision already used"
        );

        usedDecisionHashes[decisionHash] =
            true;

        decisionNonce =
            nonce + 1;

        spentToday +=
            value;

        (bool success, bytes memory result) =
            target.call{value: value}(data);

        require(
            success,
            "Execution failed"
        );

        emit AgentExecution(
            msg.sender,
            target,
            selector,
            value,
            nonce,
            decisionHash,
            result
        );

        return result;
    }

    // ============================================================
    // CONTROLLED ERC20 TRANSFER
    // ============================================================

    function executeTokenTransfer(
        address token,
        address recipient,
        uint256 amount,
        bytes32 decisionHash
    )
        external
        onlyAgent
        whenNotPaused
        nonReentrant
    {
        require(
            token != address(0),
            "Invalid token"
        );

        require(
            recipient != address(0),
            "Invalid recipient"
        );

        require(
            allowedTokenRecipients[token][recipient],
            "Recipient not allowed"
        );

        TokenPolicy storage policy =
            tokenPolicies[token];

        require(
            policy.enabled,
            "Token policy disabled"
        );

        require(
            amount <= policy.maxPerTx,
            "Token per-tx limit exceeded"
        );

        uint256 today =
            block.timestamp / 1 days;

        if (today != policy.currentDay) {
            policy.currentDay = today;
            policy.spentToday = 0;
        }

        require(
            policy.spentToday + amount <=
            policy.dailyLimit,
            "Token daily limit exceeded"
        );

        uint256 nonce =
            decisionNonce;

        bytes32 expected =
            computeTokenTransferDecisionHash(
                token,
                recipient,
                amount,
                nonce
            );

        require(
            decisionHash == expected,
            "Invalid decision hash"
        );

        require(
            !usedDecisionHashes[decisionHash],
            "Decision already used"
        );

        usedDecisionHashes[decisionHash] =
            true;

        decisionNonce =
            nonce + 1;

        policy.spentToday +=
            amount;

        bytes memory callData =
            abi.encodeWithSelector(
                IERC20MinimalV11.transfer.selector,
                recipient,
                amount
            );

        (bool success, bytes memory result) =
            token.call(callData);

        require(
            success,
            "Token transfer failed"
        );

        if (result.length > 0) {
            require(
                abi.decode(result, (bool)),
                "Token transfer returned false"
            );
        }

        emit AgentTokenTransfer(
            msg.sender,
            token,
            recipient,
            amount,
            nonce,
            decisionHash
        );
    }

    // ============================================================
    // OWNER RECOVERY
    // ============================================================

    function withdraw(
        address payable to,
        uint256 amount
    )
        external
        onlyOwner
        nonReentrant
    {
        require(
            to != address(0),
            "Invalid recipient"
        );

        require(
            amount > 0,
            "Zero withdrawal"
        );

        require(
            address(this).balance >= amount,
            "Insufficient balance"
        );

        (bool success, ) =
            to.call{value: amount}("");

        require(
            success,
            "Withdraw failed"
        );

        emit Withdrawn(
            to,
            amount
        );
    }

    function rescueToken(
        address token,
        address recipient,
        uint256 amount
    )
        external
        onlyOwner
        nonReentrant
    {
        require(
            token != address(0),
            "Invalid token"
        );

        require(
            recipient != address(0),
            "Invalid recipient"
        );

        bytes memory callData =
            abi.encodeWithSelector(
                IERC20MinimalV11.transfer.selector,
                recipient,
                amount
            );

        (bool success, bytes memory result) =
            token.call(callData);

        require(
            success,
            "Token rescue failed"
        );

        if (result.length > 0) {
            require(
                abi.decode(result, (bool)),
                "Token rescue returned false"
            );
        }

        emit TokenRescued(
            token,
            recipient,
            amount
        );
    }

    // ============================================================
    // VIEWS
    // ============================================================

    function vaultBalance()
        external
        view
        returns (uint256)
    {
        return address(this).balance;
    }

    function remainingDailyLimit()
        external
        view
        returns (uint256)
    {
        uint256 today =
            block.timestamp / 1 days;

        if (today != currentDay) {
            return dailyLimit;
        }

        if (spentToday >= dailyLimit) {
            return 0;
        }

        return dailyLimit - spentToday;
    }

    function remainingTokenDailyLimit(
        address token
    )
        external
        view
        returns (uint256)
    {
        TokenPolicy storage policy =
            tokenPolicies[token];

        if (!policy.enabled) {
            return 0;
        }

        uint256 today =
            block.timestamp / 1 days;

        if (today != policy.currentDay) {
            return policy.dailyLimit;
        }

        if (
            policy.spentToday >=
            policy.dailyLimit
        ) {
            return 0;
        }

        return
            policy.dailyLimit -
            policy.spentToday;
    }
}
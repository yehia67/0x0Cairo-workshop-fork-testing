// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "lib/v3-core/contracts/interfaces/IUniswapV3Factory.sol";
import "lib/v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "lib/v3-periphery/contracts/interfaces/ISwapRouter.sol";

import {VmSafe} from "./Vm.sol";

contract UniswapV3ForkTest is Test {
    IUniswapV3Factory public uniswapV3Factory;

    IUniswapV3Pool public uniswapV3Pool;
    ERC20 public tokenWETH;
    ERC20 public tokenUSDC;

    address public constant UNISWAP_V3_FACTORY = 0x1F98431c8aD98523631AE4a59f267346ea31F984;
    address public constant UNISWAP_V3_SWAP_ROUTER = 0x1F98431c8aD98523631AE4a59f267346ea31F984;

    address public constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address public constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    uint24 public constant POOL_FEE = 3000; // 0.3%

    function setUp() public {
        // Setup contracts
        uniswapV3Factory = IUniswapV3Factory(UNISWAP_V3_FACTORY);
        tokenWETH = ERC20(WETH);
        tokenUSDC = ERC20(USDC);

        // Get the pool
        address poolAddress = uniswapV3Factory.getPool(USDC, WETH, POOL_FEE);
        require(poolAddress != address(0), "Pool does not exist");
        uniswapV3Pool = IUniswapV3Pool(poolAddress);
    }

  
   // Add test cases here...
      
    }
}

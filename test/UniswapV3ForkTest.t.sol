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

    function testPoolExistence() public {
        address poolAddress = uniswapV3Factory.getPool(USDC, WETH, POOL_FEE);
        assertTrue(poolAddress != address(0), "Pool should exist");
    }

    function testPoolTokens() public {
        assertEq(uniswapV3Pool.token0(), USDC, "Incorrect tokenUSDC");
        assertEq(uniswapV3Pool.token1(), WETH, "Incorrect tokenWETH");
        assertEq(uniswapV3Pool.fee(), POOL_FEE, "Incorrect fee");
    }

    function testFactoryOwner() public {
        address owner = uniswapV3Factory.owner();
        assertTrue(owner != address(0), "Factory should have an owner");
    }

    function testPoolImmutables() public {
        assertEq(uniswapV3Pool.factory(), address(uniswapV3Factory), "Incorrect factory address");
        assertTrue(uniswapV3Pool.token0() < uniswapV3Pool.token1(), "Tokens should be sorted");
    }

    function testPoolLiquidity() public {
        uint128 liquidity = uniswapV3Pool.liquidity();
        assertTrue(liquidity > 0, "Pool should have liquidity");
    }

    function testPoolSlot0() public {
        (
            uint160 sqrtPriceX96,
            int24 tick,
            uint16 observationIndex,
            uint16 observationCardinality,
            uint16 observationCardinalityNext,
            uint8 feeProtocol,
            bool unlocked
        ) = uniswapV3Pool.slot0();

        assertTrue(sqrtPriceX96 > 0, "Square root price should be positive");
        assertTrue(tick != 0, "Tick should not be zero");
        assertTrue(observationIndex < observationCardinality, "Observation index should be less than cardinality");
        assertTrue(observationCardinality > 0, "Observation cardinality should be positive");
        assertTrue(
            observationCardinalityNext >= observationCardinality, "Next cardinality should be >= current cardinality"
        );
        assertTrue(feeProtocol <= 4, "Fee protocol should be <= 4");
        assertTrue(unlocked, "Pool should be unlocked");
    }

    function testTokenDecimals() public {
        uint8 usdcDecimals = tokenUSDC.decimals();
        uint8 wethDecimals = tokenWETH.decimals();

        assertEq(usdcDecimals, 6, "USDC should have 6 decimals");
        assertEq(wethDecimals, 18, "WETH should have 18 decimals");
    }

    function testTimeManipulatedObservations() public {
        // Get initial observation
          (
        uint160 initialSqrtPriceX96,
        int24 initialTick,
       ,
        uint16 initialObservationCardinality,
        ,
        ,
        bool unlocked
    ) = uniswapV3Pool.slot0();

    // Store initial timestamp
    uint256 initialTimestamp = block.timestamp;
    
    // Verify initial state
    assertTrue(initialSqrtPriceX96 > 0, "Initial price should be positive");
    assertTrue(unlocked, "Pool should be unlocked");
    
    // Warp time forward by 1 hour
    vm.warp(block.timestamp + 1 hours);
    
    // Get new pool state after time manipulation
    (
        uint160 newSqrtPriceX96,
        int24 newTick,
        ,
        uint16 newObservationCardinality,
        ,
        ,
        bool stillUnlocked
    ) = uniswapV3Pool.slot0();
    
    // Verify state after time manipulation
    assertTrue(stillUnlocked, "Pool should still be unlocked after time warp");
    assertEq(newSqrtPriceX96, initialSqrtPriceX96, "Price should not change just by time passing");
    assertEq(newTick, initialTick, "Tick should not change just by time passing");
    assertEq(newObservationCardinality, initialObservationCardinality, "Observation cardinality should remain the same");
    
    // Verify time changed
    assertEq(block.timestamp, initialTimestamp + 1 hours, "Time should have increased by 1 hour");

      
    }
}

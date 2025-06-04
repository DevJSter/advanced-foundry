// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Test, console2} from "forge-std/Test.sol";
import {ITriCrypto} from "../../../src/interfaces/curve/ITriCrypto.sol";
import {CURVE_TRI_CRYPTO} from "../../../src/Constants.sol";

uint256 constant PRECISIONS = 1e18;

/*
forge test \
--evm-version cancun \
--fork-url $FORK_URL \
--match-path test/curve-v2/solutions/CurveV2PriceScale.test.sol -vvv
*/

contract CurveV2PriceScaleTest is Test {
    ITriCrypto private constant pool = ITriCrypto(CURVE_TRI_CRYPTO);

    // Exercise 1
    // Calculate transformed balances
    function test_calc_transformed_bals() public {
        uint256[3] memory xp = [uint256(0), uint256(0), uint256(0)];
        uint256[3] memory precisions = pool.precisions();

        // Write your code here
        xp[0] = pool.balances(0) * precisions[0];
        for (uint256 i = 1; i < 3; i++) {
            uint256 bal = pool.balances(i);
            uint256 p = pool.price_scale(i - 1);
            xp[i] = bal * p * precisions[i] / PRECISIONS;
        }

        console2.log("xp[0] = %e", xp[0]);
        console2.log("xp[1] = %e", xp[1]);
        console2.log("xp[2] = %e", xp[2]);

        assertGt(xp[0] / PRECISIONS, 0);
        assertGt(xp[1] / PRECISIONS, 0);
        assertGt(xp[2] / PRECISIONS, 0);
    }
}

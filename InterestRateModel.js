/**
 * Simple Kinked Interest Rate Model
 * @param {number} utilization - The current ratio of borrows to deposits (0-1)
 * @returns {number} The current interest rate in basis points
 */
function calculateInterestRate(utilization) {
    const baseRate = 200; // 2%
    const kink = 0.8; // 80% utilization
    const slope1 = 400; // 4% slope before kink
    const slope2 = 5000; // 50% slope after kink

    if (utilization <= kink) {
        return baseRate + (utilization / kink) * slope1;
    } else {
        return baseRate + slope1 + ((utilization - kink) / (1 - kink)) * slope2;
    }
}

module.exports = { calculateInterestRate };

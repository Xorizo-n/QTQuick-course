function calculatePrice(primaryColorAmt, secondaryColorAmt, orderAmt, basePrice) {
    return (primaryColorAmt + secondaryColorAmt) * (1200 / orderAmt + 6) + basePrice;
}

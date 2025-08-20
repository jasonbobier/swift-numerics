//===--- GreatestCommonDivisor.swift --------------------------*- swift -*-===//
//
// This source file is part of the Swift Numerics open source project
//
// Copyright (c) 2021-2025 Apple Inc. and the Swift Numerics project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
//
//===----------------------------------------------------------------------===//

/// The [greatest common divisor][gcd] of `a` and `b`.
///
/// If both inputs are zero, the result is zero. If one input is zero, the
/// result is the absolute value of the other input.
///
/// The result must be representable within its type. In particular, the gcd
/// of a signed, fixed-width integer type's minimum with itself (or zero)
/// cannot be represented, and results in a trap.
///
///     gcd(Int.min, Int.min)   // Overflow error
///     gcd(Int.min, 0)         // Overflow error
///
/// [gcd]: https://en.wikipedia.org/wiki/Greatest_common_divisor
@inlinable
public func gcd<T: BinaryInteger>(_ a: T, _ b: T) -> T {
    let gcd = greatestCommonDivisorFullWidth(a, b)
    
    guard let result = T(exactly: gcd) else {
        fatalError("GCD (\(gcd)) is not representable as \(T.self).")
    }
    
    return result
}

/// Returns the [greatest common divisor][gcd] of `a` and `b`, along with a Boolean value indicating whether overflow occurred in the operation.
///
/// If both inputs are zero, the result is zero. If one input is zero, the
/// result is the absolute value of the other input.
///
/// - Returns: A tuple containing the result of the function along with a Boolean value indicating whether overflow occurred. If the overflow component is false, the partialValue component contains the entire result. If the
/// overflow component is true, an overflow occurred and the partialValue component contains the truncated result of the operation.
///
/// [gcd]: https://en.wikipedia.org/wiki/Greatest_common_divisor
@inlinable
public func greatestCommonDivisorReportingOverflow<T: BinaryInteger>(_ a: T, _ b: T) -> (partialValue: T, overflow: Bool) {
    let gcd = greatestCommonDivisorFullWidth(a, b)
    
    guard let result = T(exactly: gcd) else {
        return (partialValue: T(truncatingIfNeeded: gcd), overflow: true)
    }
    
    return (partialValue: result, overflow: false)
}

/// The [greatest common divisor][gcd] of `a` and `b`.
///
/// If both inputs are zero, the result is zero. If one input is zero, the
/// result is the absolute value of the other input.
///
/// [gcd]: https://en.wikipedia.org/wiki/Greatest_common_divisor
@inlinable
public func greatestCommonDivisorFullWidth<T: BinaryInteger>(_ a: T, _ b: T) -> T.Magnitude {
    var x = a.magnitude
    var y = b.magnitude

    if x < y {
        swap(&x, &y)
    }

    // Euclidean algorithm for GCD. It's worth using Lehmer instead for larger
    // integer types, but for now this is good and dead-simple and faster than
    // the other obvious choice, the binary algorithm.
    while y != 0 {
        (x, y) = (y, x % y)
    }

    return x
}

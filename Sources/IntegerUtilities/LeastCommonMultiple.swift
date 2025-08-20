//===--- LeastCommonMultiple.swift ----------------------------*- swift -*-===//
//
// This source file is part of the Swift Numerics open source project
//
// Copyright (c) 2021-2025 Apple Inc. and the Swift Numerics project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
//
//===----------------------------------------------------------------------===//

/// The [least common multiple][lcm] of `a` and `b`.
///
/// If either input is zero, the result is zero.
///
/// The result must be representable within its type.
///
/// [lcm]: https://en.wikipedia.org/wiki/Least_common_multiple
@inlinable
public func lcm<T: BinaryInteger>(_ a: T, _ b: T) -> T {
	guard (a != 0) && (b != 0) else {
		return 0
	}

    return T(a.magnitude / gcd(a.magnitude, b.magnitude) * b.magnitude)
}

/// The [least common multiple][lcm] of `a` and `b`.
///
/// If either input is zero, the result is zero.
///
/// Throws `LeastCommonMultipleOverflowError` containing the full width result if it is not representable within its type.
///
/// [lcm]: https://en.wikipedia.org/wiki/Least_common_multiple
@inlinable
public func leastCommonMultiple<T: FixedWidthInteger>(_ a: T, _ b: T) throws(LeastCommonMultipleOverflowError<T>) -> T {
	guard (a != 0) && (b != 0) else {
		return 0
	}

    let reduced = a.magnitude / gcd(a.magnitude, b.magnitude)

	// We could use the multipliedFullWidth directly here, but we optimize instead for the non-throwing case because multipliedReportingOverflow is much faster.
	let (partialValue, overflow) = reduced.multipliedReportingOverflow(by: b.magnitude)

	guard !overflow, let result = T(exactly: partialValue) else {
		let fullWidth = reduced.multipliedFullWidth(by: b.magnitude)

		throw LeastCommonMultipleOverflowError(high: fullWidth.high, low: fullWidth.low)
	}

	return result
}

/// Returns the [least common multiple][lcm] of `a` and `b`, along with a Boolean value indicating whether overflow occurred in the operation.
///
/// If either input is zero, the result is zero.
///
/// - Returns: A tuple containing the result of the function along with a Boolean value indicating whether overflow occurred. If the overflow component is false, the partialValue component contains the entire result. If the
/// overflow component is true, an overflow occurred and the partialValue component contains the truncated result of the operation.
///
/// [lcm]: https://en.wikipedia.org/wiki/Least_common_multiple
@inlinable
public func leastCommonMultipleReportingOverflow<T: FixedWidthInteger>(_ a: T, _ b: T) -> (partialValue: T, overflow: Bool) {
    guard (a != 0) && (b != 0) else {
        return (partialValue: 0, overflow: false)
    }

    let reduced = a.magnitude / gcd(a.magnitude, b.magnitude)

    let (partialValue, overflow) = reduced.multipliedReportingOverflow(by: b.magnitude)

    guard !overflow, let result = T(exactly: partialValue) else {
        return (partialValue: T(truncatingIfNeeded: partialValue), overflow: true)
    }

    return (partialValue: result, overflow: false)
}

/// Returns a tuple containing the high and low parts of the result of the [least common multiple][lcm] of `a` and `b`.
///
/// If either input is zero, the result is zero.
///
/// You can combine `high` and `low` into a double width integer to access the result.
///
/// For example `leastCommonMultipleFullWidth<Int8>` has `UInt8` as its `Magnitude` and contains the result in `high: UInt8` and `low: UInt8`.
/// These can be combined into a `UInt16` result as `UInt16(high) << 8 | UInt16(low)`.
///
/// - Returns: A tuple containing the high and low parts of the result.
///
/// [lcm]: https://en.wikipedia.org/wiki/Least_common_multiple
@inlinable
public func leastCommonMultipleFullWidth<T: FixedWidthInteger>(_ a: T, _ b: T) -> (high: T.Magnitude, low: T.Magnitude) {
    guard (a != 0) && (b != 0) else {
        return (high: 0, low: 0)
    }
    
    let reduced = a.magnitude / gcd(a.magnitude, b.magnitude)
    
    return reduced.multipliedFullWidth(by: b.magnitude)
}

/// Error thrown by `leastCommonMultiple`.
///
/// Thrown when the result of the lcm isn't representable within its type. You can combine `high` and `low` into a double width integer to access the result.
///
/// For example a `LeastCommonMultipleOverflowError<Int8>` has `UInt8` as its `Magnitude` and contains the result in `high: UInt8` and `low: UInt8`.
/// These can be combined into a `UInt16` result as `UInt16(high) << 8 | UInt16(low)`.
public struct LeastCommonMultipleOverflowError<T: FixedWidthInteger>: Error, Equatable {
	public let high: T.Magnitude
	public let low: T.Magnitude

	@inlinable
	public init(high: T.Magnitude, low: T.Magnitude) {
		self.high = high
		self.low = low
	}
}

extension LeastCommonMultipleOverflowError: Sendable where T.Magnitude: Sendable { }

//===--- Rational.swift ---------------------------------*- swift -*-===//
//
// This source file is part of the Swift Numerics open source project
//
// Copyright (c) 2025 Apple Inc. and the Swift Numerics project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
//
//===----------------------------------------------------------------------===//

import IntegerUtilities

public struct Rational<TermType: BinaryInteger> {
	@inlinable
	public var numerator: TermType {
		_numerator
	}

	@usableFromInline
	internal var _numerator: TermType

	@inlinable
	public var denominator: TermType {
		_denominator
	}

	@usableFromInline
	internal var _denominator: TermType

	@inlinable
	public init() {
		_numerator = 0
		_denominator = 1
	}

	@inlinable
	public init(_ integer: TermType) {
		_numerator = integer
		_denominator = 1
	}

	@inlinable
	public init(numerator: TermType, denominator: TermType) {
		precondition(denominator > 0, "Rational denominator must be greater than zero.")

		_numerator = numerator
		_denominator = denominator
		reduce()
	}

	@inlinable
	public func mixedNumber() -> (integer: TermType, fraction: Self) {
		let result = _numerator.quotientAndRemainder(dividingBy: _denominator)

		return (integer: result.quotient, fraction: Self(numerator: result.remainder, denominator: _denominator))
	}

	@inlinable
	internal mutating func reduce() {
		guard _denominator != 1 else {
			return
		}
		guard _numerator != 0 else {
			_denominator = 1
			return
		}

		// No runtime error possible here because gcd <= min(abs(numerator), denominator) and denominator > 0
		let gcd = TermType(gcd(numerator, denominator))

		_numerator /= gcd
		_denominator /= gcd
	}
}

extension Rational: Sendable where TermType: Sendable { }

extension Rational: Equatable {
	@inlinable
	public static func ==(lhs: Self, rhs: TermType) -> Bool {
		(lhs._denominator == 1) && (lhs._numerator == rhs)
	}

	@inlinable
	public static func ==(lhs: TermType, rhs: Self) -> Bool {
		(rhs._denominator == 1) && (rhs._numerator == lhs)
	}

	@inlinable
	public static func !=(lhs: Self, rhs: TermType) -> Bool {
		(lhs._denominator != 1) || (lhs._numerator != rhs)
	}

	@inlinable
	public static func !=(lhs: TermType, rhs: Self) -> Bool {
		(rhs._denominator != 1) || (rhs._numerator != lhs)
	}
}


extension Rational: Comparable {
	@inlinable
	public static func <(lhs: Self, rhs: Self) -> Bool {
		assert(!(lhs._numerator is any FixedWidthInteger))

		return (lhs._numerator * rhs._denominator) < (rhs._numerator * lhs._denominator)
	}

	@inlinable
	public static func <(lhs: Self, rhs: Self) -> Bool where TermType: FixedWidthInteger {
		if lhs._denominator == rhs._denominator {
			(lhs._numerator < rhs._numerator)
		} else {
			// The boost library has an interesting algorithm for this, but performance testing shows that a simple full width multiply is more than twice as fast.
			lhs._numerator.multipliedFullWidth(by: rhs._denominator) < rhs._numerator.multipliedFullWidth(by: lhs._denominator)
		}
	}

	@inlinable
	public static func <=(lhs: Self, rhs: Self) -> Bool {
		!(rhs < lhs)
	}


	@inlinable
	public static func <=(lhs: Self, rhs: Self) -> Bool where TermType: FixedWidthInteger {
		!(rhs < lhs)
	}

	@inlinable
	public static func >(lhs: Self, rhs: Self) -> Bool {
		rhs < lhs
	}

	@inlinable
	public static func >(lhs: Self, rhs: Self) -> Bool where TermType: FixedWidthInteger {
		rhs < lhs
	}

	@inlinable
	public static func >=(lhs: Self, rhs: Self) -> Bool {
		!(lhs < rhs)
	}

	@inlinable
	public static func >=(lhs: Self, rhs: Self) -> Bool where TermType: FixedWidthInteger {
		!(lhs < rhs)
	}
}

extension Rational: Hashable where TermType: Hashable {
	@inlinable
	public func hash(into hasher: inout Hasher) {
		hasher.combine(_numerator)
		hasher.combine(_denominator)
	}
}

extension Rational/*: Numeric*/ {
	@inlinable
	public init?<T>(exactly source: T) where T : BinaryInteger {
		guard let value = TermType(exactly: source) else {
			return nil
		}

		self.init(value)
	}

	@inlinable
	public static var zero: Rational<TermType> {
		Rational()
	}

	@inlinable
	public var magnitude: Rational<TermType.Magnitude> {
		Rational<TermType.Magnitude>(numerator: _numerator.magnitude, denominator: _denominator.magnitude)
	}

	@inlinable
	public static func +(lhs: Self, rhs: Self) -> Self {
		assert(!(lhs._numerator is any FixedWidthInteger))

		if lhs.denominator == rhs.denominator {
			return Self(numerator: lhs.numerator + rhs.numerator, denominator: lhs.denominator)
		} else {
			return Self(numerator: (lhs.numerator * rhs.denominator) + (rhs.numerator * lhs.denominator), denominator: lhs.denominator * rhs.denominator)
		}
	}

	@inlinable
	public static func +(lhs: Self, rhs: Self) throws(RationalOverflowError<TermType>) -> Self where TermType: FixedWidthInteger {
		if lhs.denominator == rhs.denominator {
			let (partialValue, overflow) = lhs.numerator.addingReportingOverflow(rhs.numerator)

			guard !overflow else {
				if (lhs.numerator < 0) && (rhs.numerator < 0) {
					throw RationalOverflowError(highBit: true, mid: ~0, low: .init(truncatingIfNeeded: partialValue))
				} else {
					throw RationalOverflowError(highBit: false, mid: partialValue < 0 ? 0 : 1, low: .init(truncatingIfNeeded: partialValue))
				}
			}

			return Self(numerator: partialValue, denominator: lhs.denominator)
		} else {
			return Self(numerator: (lhs.numerator * rhs.denominator) + (rhs.numerator * lhs.denominator), denominator: lhs.denominator * rhs.denominator)
		}
	}

	@inlinable
	public static func +(lhs: TermType, rhs: Self) -> Self {
		assert(!(rhs._numerator is any FixedWidthInteger))

		if rhs.denominator == 1 {
			return Self(lhs + rhs.numerator)
		} else {
			return Self(numerator: (lhs * rhs.denominator) + rhs.numerator, denominator: rhs.denominator)
		}
	}

	@inlinable
	public static func +(lhs: Self, rhs: TermType) -> Self {
		assert(!(lhs._numerator is any FixedWidthInteger))

		return rhs + lhs
	}
}

/// Error thrown by `Rational<FixedWidthInteger>`.
///
/// Thrown when the result of Rational arithmetic isn't representable within its type. You can combine `[highBit | mid | low]` into a double width + 1 bit integer to access the result.
///
/// For example a `Rational<UInt8>` would throw 17 bit overflows as `(highBit ? 0x01 : 0x00) << 16 | (UInt8(mid) << 8) | UInt8(low)`. This allows you to get the result in a UInt32 integer.
public struct RationalOverflowError<TermType: FixedWidthInteger>: Error, Equatable {
	public let highBit: Bool
	public let mid: TermType.Magnitude
	public let low: TermType.Magnitude

	@inlinable
	public init(highBit: Bool, mid: TermType.Magnitude, low: TermType.Magnitude) {
		self.highBit = highBit
		self.mid = mid
		self.low = low
	}
}

extension RationalOverflowError: Sendable where TermType.Magnitude: Sendable { }

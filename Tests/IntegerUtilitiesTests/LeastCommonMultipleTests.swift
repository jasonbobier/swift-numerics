//===--- LeastCommonMultipleTests.swift -----------------------*- swift -*-===//
//
// This source file is part of the Swift Numerics open source project
//
// Copyright (c) 2021 Apple Inc. and the Swift Numerics project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

import IntegerUtilities
import Testing

private func lcm_ForceBinaryInteger<T: BinaryInteger>(_ a: T, _ b: T) -> T {
	IntegerUtilities.lcm(a,b)
}

struct `Least Common Multiple Tests` {
	@Test func `lcm<BinaryInteger>`() async throws {
		#expect(lcm_ForceBinaryInteger(1024, 0) == 0)
		#expect(lcm_ForceBinaryInteger(0, 1024) == 0)
		#expect(lcm_ForceBinaryInteger(0, 0) == 0)
		#expect(lcm_ForceBinaryInteger(1024, 768) == 3072)
		#expect(lcm_ForceBinaryInteger(768, 1024) == 3072)
		#expect(lcm_ForceBinaryInteger(24, 18) == 72)
		#expect(lcm_ForceBinaryInteger(18, 24) == 72)
		#expect(lcm_ForceBinaryInteger(6930, 288) == 110880)
		#expect(lcm_ForceBinaryInteger(288, 6930) == 110880)
		#expect(lcm_ForceBinaryInteger(Int.max, 1) == Int.max)
		#expect(lcm_ForceBinaryInteger(1, Int.max) == Int.max)
	}

	@Test func `lcm<FixedWidthInteger>`() async throws {
		#expect(try lcm(1024, 0) == 0)
		#expect(try lcm(0, 1024) == 0)
		#expect(try lcm(0, 0) == 0)
		#expect(try lcm(1024, 768) == 3072)
		#expect(try lcm(768, 1024) == 3072)
		#expect(try lcm(24, 18) == 72)
		#expect(try lcm(18, 24) == 72)
		#expect(try lcm(6930, 288) == 110880)
		#expect(try lcm(288, 6930) == 110880)
		#expect(try lcm(Int.max, 1) == Int.max)
		#expect(try lcm(1, Int.max) == Int.max)
		#expect(throws: LeastCommonMultipleOverflowError<Int>(high: 0, low: Int.min.magnitude)) {
			try lcm(Int.min, Int.min)
		}
		#expect(throws: LeastCommonMultipleOverflowError<Int>(high: 0, low: Int.min.magnitude)) {
			try lcm(Int.min, 1)
		}
		#expect(throws: LeastCommonMultipleOverflowError<Int>(high: 0, low: Int.min.magnitude)) {
			try lcm(1, Int.min)
		}
		#expect(throws: LeastCommonMultipleOverflowError<Int8>(high: 63, low: 128)) {
			try lcm(Int8.min, Int8.max)
		}
	}
}

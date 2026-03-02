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
	@Test func `lcm()`() async throws {
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
        await #expect(processExitsWith: .failure) {
            _ = lcm_ForceBinaryInteger(Int.min, Int.min)
        }
        await #expect(processExitsWith: .failure) {
            _ = lcm_ForceBinaryInteger(Int.min, 1)
        }
        await #expect(processExitsWith: .failure) {
            _ = lcm_ForceBinaryInteger(1, Int.min)
        }
        await #expect(processExitsWith: .failure) {
            _ = lcm_ForceBinaryInteger(Int8.min, Int8.max)
        }
	}

    @Test func `leastCommonMultiple()`() async throws {
        #expect(try leastCommonMultiple(1024, 0) == 0)
        #expect(try leastCommonMultiple(0, 1024) == 0)
        #expect(try leastCommonMultiple(0, 0) == 0)
        #expect(try leastCommonMultiple(1024, 768) == 3072)
        #expect(try leastCommonMultiple(768, 1024) == 3072)
        #expect(try leastCommonMultiple(24, 18) == 72)
        #expect(try leastCommonMultiple(18, 24) == 72)
        #expect(try leastCommonMultiple(6930, 288) == 110880)
        #expect(try leastCommonMultiple(288, 6930) == 110880)
        #expect(try leastCommonMultiple(Int.max, 1) == Int.max)
        #expect(try leastCommonMultiple(1, Int.max) == Int.max)
        #expect(throws: LeastCommonMultipleOverflowError<Int>(high: 0, low: Int.min.magnitude)) {
            try leastCommonMultiple(Int.min, Int.min)
        }
        #expect(throws: LeastCommonMultipleOverflowError<Int>(high: 0, low: Int.min.magnitude)) {
            try leastCommonMultiple(Int.min, 1)
        }
        #expect(throws: LeastCommonMultipleOverflowError<Int>(high: 0, low: Int.min.magnitude)) {
            try leastCommonMultiple(1, Int.min)
        }
        #expect(throws: LeastCommonMultipleOverflowError<Int8>(high: 63, low: 128)) {
            try leastCommonMultiple(Int8.min, Int8.max)
        }
    }

    @Test func `leastCommonMultipleReportingOverflow()`() async throws {
        #expect(leastCommonMultipleReportingOverflow(1024, 0) == (partialValue: 0, overflow: false))
        #expect(leastCommonMultipleReportingOverflow(0, 1024) == (partialValue: 0, overflow: false))
        #expect(leastCommonMultipleReportingOverflow(0, 0) == (partialValue: 0, overflow: false))
        #expect(leastCommonMultipleReportingOverflow(1024, 768) == (partialValue: 3072, overflow: false))
        #expect(leastCommonMultipleReportingOverflow(768, 1024) == (partialValue: 3072, overflow: false))
        #expect(leastCommonMultipleReportingOverflow(24, 18) == (partialValue: 72, overflow: false))
        #expect(leastCommonMultipleReportingOverflow(18, 24) == (partialValue: 72, overflow: false))
        #expect(leastCommonMultipleReportingOverflow(6930, 288) == (partialValue: 110880, overflow: false))
        #expect(leastCommonMultipleReportingOverflow(288, 6930) == (partialValue: 110880, overflow: false))
        #expect(leastCommonMultipleReportingOverflow(Int.max, 1) == (partialValue: Int.max, overflow: false))
        #expect(leastCommonMultipleReportingOverflow(1, Int.max) == (partialValue: Int.max, overflow: false))
        #expect(leastCommonMultipleReportingOverflow(Int.min, Int.min) == (partialValue: Int(truncatingIfNeeded: Int.min), overflow: true))
        #expect(leastCommonMultipleReportingOverflow(Int.min, 1) == (partialValue: Int(truncatingIfNeeded: Int.min), overflow: true))
        #expect(leastCommonMultipleReportingOverflow(1, Int.min) == (partialValue: Int(truncatingIfNeeded: Int.min), overflow: true))
        #expect(leastCommonMultipleReportingOverflow(Int8.min, Int8.max) == (partialValue: Int8(truncatingIfNeeded: Int16(Int8.min).magnitude * Int16(Int8.max).magnitude), overflow: true))
    }
    
    @Test func `leastCommonMultipleFullWidth()`() async throws {
        #expect(leastCommonMultipleFullWidth(1024, 0) == (high: 0, low: 0))
        #expect(leastCommonMultipleFullWidth(0, 1024) == (high: 0, low: 0))
        #expect(leastCommonMultipleFullWidth(0, 0) == (high: 0, low: 0))
        #expect(leastCommonMultipleFullWidth(1024, 768) == (high: 0, low: 3072))
        #expect(leastCommonMultipleFullWidth(768, 1024) == (high: 0, low: 3072))
        #expect(leastCommonMultipleFullWidth(24, 18) == (high: 0, low: 72))
        #expect(leastCommonMultipleFullWidth(18, 24) == (high: 0, low: 72))
        #expect(leastCommonMultipleFullWidth(6930, 288) == (high: 0, low: 110880))
        #expect(leastCommonMultipleFullWidth(288, 6930) == (high: 0, low: 110880))
        #expect(leastCommonMultipleFullWidth(Int.max, 1) == (high: 0, low: Int.max.magnitude))
        #expect(leastCommonMultipleFullWidth(1, Int.max) == (high: 0, low: Int.max.magnitude))
        #expect(leastCommonMultipleFullWidth(Int.min, Int.min) == (high: 0, low: Int.min.magnitude))
        #expect(leastCommonMultipleFullWidth(Int.min, 1) == (high: 0, low: Int.min.magnitude))
        #expect(leastCommonMultipleFullWidth(1, Int.min) == (high: 0, low: Int.min.magnitude))
        #expect(leastCommonMultipleFullWidth(Int8.min, Int8.max) == (high: 63, low: 128))
    }
}

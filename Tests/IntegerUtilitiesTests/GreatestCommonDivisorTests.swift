//===--- GreatestCommonDivisorTests.swift ---------------------*- swift -*-===//
//
// This source file is part of the Swift Numerics open source project
//
// Copyright (c) 2021-2025 Apple Inc. and the Swift Numerics project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

import IntegerUtilities
import Testing

struct `Greatest Common Divisor Tests` {
    @Test func `gcd()`() async throws {
        #expect(gcd(0, 0) == 0)
        #expect(gcd(0, 1) == 1)
        #expect(gcd(1, 0) == 1)
        #expect(gcd(0, -1) == 1)
        #expect(gcd(-1, 0) == 1)
        #expect(gcd(1, 1) == 1)
        #expect(gcd(1, 2) == 1)
        #expect(gcd(2, 2) == 2)
        #expect(gcd(4, 2) == 2)
        #expect(gcd(6, 8) == 2)
        #expect(gcd(77, 91) == 7)
        #expect(gcd(24, -36) == 12)
        #expect(gcd(-24, -36) == 12)
        #expect(gcd(51, 34) == 17)
        #expect(gcd(64, 96) == 32)
        #expect(gcd(-64, 96) == 32)
        #expect(gcd(4*7*19, 27*25) == 1)
        #expect(gcd(16*315, 11*315) == 315)
        #expect(gcd(97*67*53*27*8, 83*67*53*9*32) == 67*53*9*8)
        #expect(gcd(Int.max, Int.max) == Int.max)
        #expect(gcd(Int.min, -1) == 1)
        await #expect(processExitsWith: .failure) {
            _ = gcd(0, Int.min)
        }
        await #expect(processExitsWith: .failure) {
            _ = gcd(Int.min, 0)
        }
        await #expect(processExitsWith: .failure) {
            _ = gcd(Int.min, Int.min)
        }
    }
    
    @Test func `greatestCommonDivisorReportingOverflow()`() async throws {
        #expect(greatestCommonDivisorReportingOverflow(0, 0) == (partialResult: 0, overflow: false))
        #expect(greatestCommonDivisorReportingOverflow(0, 1) == (partialResult: 1, overflow: false))
        #expect(greatestCommonDivisorReportingOverflow(1, 0) == (partialResult: 1, overflow: false))
        #expect(greatestCommonDivisorReportingOverflow(0, -1) == (partialResult: 1, overflow: false))
        #expect(greatestCommonDivisorReportingOverflow(-1, 0) == (partialResult: 1, overflow: false))
        #expect(greatestCommonDivisorReportingOverflow(1, 1) == (partialResult: 1, overflow: false))
        #expect(greatestCommonDivisorReportingOverflow(1, 2) == (partialResult: 1, overflow: false))
        #expect(greatestCommonDivisorReportingOverflow(2, 2) == (partialResult: 2, overflow: false))
        #expect(greatestCommonDivisorReportingOverflow(4, 2) == (partialResult: 2, overflow: false))
        #expect(greatestCommonDivisorReportingOverflow(6, 8) == (partialResult: 2, overflow: false))
        #expect(greatestCommonDivisorReportingOverflow(77, 91) == (partialResult: 7, overflow: false))
        #expect(greatestCommonDivisorReportingOverflow(24, -36) == (partialResult: 12, overflow: false))
        #expect(greatestCommonDivisorReportingOverflow(-24, -36) == (partialResult: 12, overflow: false))
        #expect(greatestCommonDivisorReportingOverflow(51, 34) == (partialResult: 17, overflow: false))
        #expect(greatestCommonDivisorReportingOverflow(64, 96) == (partialResult: 32, overflow: false))
        #expect(greatestCommonDivisorReportingOverflow(-64, 96) == (partialResult: 32, overflow: false))
        #expect(greatestCommonDivisorReportingOverflow(4*7*19, 27*25) == (partialResult: 1, overflow: false))
        #expect(greatestCommonDivisorReportingOverflow(16*315, 11*315) == (partialResult: 315, overflow: false))
        #expect(greatestCommonDivisorReportingOverflow(97*67*53*27*8, 83*67*53*9*32) == (partialResult: 67*53*9*8, overflow: false))
        #expect(greatestCommonDivisorReportingOverflow(Int.max, Int.max) == (partialResult: Int.max, overflow: false))
        #expect(greatestCommonDivisorReportingOverflow(Int.min, -1) == (partialResult: 1, overflow: false))
        #expect(greatestCommonDivisorReportingOverflow(0, Int.min) == (partialResult: Int(truncatingIfNeeded: Int.min.magnitude), overflow: true))
        #expect(greatestCommonDivisorReportingOverflow(Int.min, 0) == (partialResult: Int(truncatingIfNeeded: Int.min.magnitude), overflow: true))
        #expect(greatestCommonDivisorReportingOverflow(Int.min, Int.min) == (partialResult: Int(truncatingIfNeeded: Int.min.magnitude), overflow: true))
    }
    
    @Test func `greatestCommonDivisorFullWidth()`() async throws {
        #expect(greatestCommonDivisorFullWidth(0, 0) == 0)
        #expect(greatestCommonDivisorFullWidth(0, 1) == 1)
        #expect(greatestCommonDivisorFullWidth(1, 0) == 1)
        #expect(greatestCommonDivisorFullWidth(0, -1) == 1)
        #expect(greatestCommonDivisorFullWidth(-1, 0) == 1)
        #expect(greatestCommonDivisorFullWidth(1, 1) == 1)
        #expect(greatestCommonDivisorFullWidth(1, 2) == 1)
        #expect(greatestCommonDivisorFullWidth(2, 2) == 2)
        #expect(greatestCommonDivisorFullWidth(4, 2) == 2)
        #expect(greatestCommonDivisorFullWidth(6, 8) == 2)
        #expect(greatestCommonDivisorFullWidth(77, 91) == 7)
        #expect(greatestCommonDivisorFullWidth(24, -36) == 12)
        #expect(greatestCommonDivisorFullWidth(-24, -36) == 12)
        #expect(greatestCommonDivisorFullWidth(51, 34) == 17)
        #expect(greatestCommonDivisorFullWidth(64, 96) == 32)
        #expect(greatestCommonDivisorFullWidth(-64, 96) == 32)
        #expect(greatestCommonDivisorFullWidth(4*7*19, 27*25) == 1)
        #expect(greatestCommonDivisorFullWidth(16*315, 11*315) == 315)
        #expect(greatestCommonDivisorFullWidth(97*67*53*27*8, 83*67*53*9*32) == 67*53*9*8)
        #expect(greatestCommonDivisorFullWidth(Int.max, Int.max) == Int.max)
        #expect(greatestCommonDivisorFullWidth(Int.min, -1) == 1)
        #expect(greatestCommonDivisorFullWidth(0, Int.min) == Int.min.magnitude)
        #expect(greatestCommonDivisorFullWidth(Int.min, 0) == Int.min.magnitude)
        #expect(greatestCommonDivisorFullWidth(Int.min, Int.min) == Int.min.magnitude)
    }
}

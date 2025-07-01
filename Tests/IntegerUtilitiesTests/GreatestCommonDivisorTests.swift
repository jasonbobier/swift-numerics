//===--- GreatestCommonDivisorTests.swift ---------------------------------------*- swift -*-===//
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
import BigInt

struct `Greatest Common Divisor Tests` {
	@Test func `gcd<BinaryInteger>`() async throws {
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
		#expect(gcd(Int.min, 2) == 2)
		#expect(gcd(Int.max, Int.max) == Int.max)
		#expect(gcd(0, Int.min) == Int.min.magnitude)
		#expect(gcd(Int.min, 0) == Int.min.magnitude)
		#expect(gcd(Int.min, Int.min) == Int.min.magnitude)

		let bigIntCommonFactor = BigInt("457425209663695646359203630886756382027")
		let bigInt1 = BigInt("340282366920938463463374607431768211507") * bigIntCommonFactor
		let bigInt2 = BigInt("391658961466960540800131805247996205641") * bigIntCommonFactor

		#expect(gcd(bigInt1, bigInt2) == bigIntCommonFactor)
	}
}

// Copyright © 2025 Jason Bobier. All rights reserved.

import Testing
import RationalModule
import Foundation
import BigInt

#if DEBUG
	private func `< ForceBinaryInteger`<T: BinaryInteger>(_ a: Rational<T>, _ b: Rational<T>) {
		_ = a < b
	}

	private func `<= ForceBinaryInteger`<T: BinaryInteger>(_ a: Rational<T>, _ b: Rational<T>) {
		_ = a <= b
	}

	private func `> ForceBinaryInteger`<T: BinaryInteger>(_ a: Rational<T>, _ b: Rational<T>) {
		_ = a > b
	}

	private func `>= ForceBinaryInteger`<T: BinaryInteger>(_ a: Rational<T>, _ b: Rational<T>) {
		_ = a >= b
	}

	private func `+(Self, Self) ForceBinaryInteger`<T: BinaryInteger>(_ a: Rational<T>, _ b: Rational<T>) {
		_ = a + b
	}

	private func `+(TermType, Self) ForceBinaryInteger`<T: BinaryInteger>(_ a: T, _ b: Rational<T>) {
		_ = a + b
	}

	private func `+(Self, TermType) ForceBinaryInteger`<T: BinaryInteger>(_ a: Rational<T>, _ b: T) {
		_ = a + b
	}
#endif

struct RationalTests {

	struct `inits` {
		@Test func `init`() async throws {
			let r1 = Rational<Int>()

			#expect(r1.numerator == 0)
			#expect(r1.denominator == 1)

			let r2 = Rational<BigInt>()

			#expect(r2.numerator == 0)
			#expect(r2.denominator == 1)
		}

		@Test func `init(_:)`() async throws {
			let r1 = Rational(0)

			#expect(r1.numerator == 0)
			#expect(r1.denominator == 1)

			let r2 = Rational(1)

			#expect(r2.numerator == 1)
			#expect(r2.denominator == 1)

			let r3 = Rational(Int.min)

			#expect(r3.numerator == Int.min)
			#expect(r3.denominator == 1)

			let r4 = Rational(BigInt("340282366920938463463374607431768211507"))

			#expect(r4.numerator == BigInt("340282366920938463463374607431768211507"))
			#expect(r4.denominator == 1)
		}

		@Test func `init(numerator:denominator:)`() async throws {
			let r1 = Rational(numerator: 1, denominator: 2)

			#expect(r1.numerator == 1)
			#expect(r1.denominator == 2)

			let r2 = Rational(numerator: 2, denominator: 4)

			#expect(r2.numerator == 1)
			#expect(r2.denominator == 2)

			let r3 = Rational(numerator: 0, denominator: 4)

			#expect(r3.numerator == 0)
			#expect(r3.denominator == 1)

			let r4 = Rational(numerator: 2, denominator: 1)

			#expect(r4.numerator == 2)
			#expect(r4.denominator == 1)

			let r5 = Rational(numerator: Int.min, denominator: 1)

			#expect(r5.numerator == Int.min)
			#expect(r5.denominator == 1)

			let r6 = Rational(numerator: Int.min, denominator: 2)

			#expect(r6.numerator == (Int.min / 2))
			#expect(r6.denominator == 1)

			let r7 = Rational(numerator: BigInt("340282366920938463463374607431768211508"), denominator: 2)

			#expect(r7.numerator == (BigInt("340282366920938463463374607431768211508") / 2))
			#expect(r7.denominator == 1)

			try await #expect(
				#require(
					String(
						bytes:	#require(processExitsWith: .failure, observing: [\.standardErrorContent]) {
							_ = Rational(numerator: 1, denominator: 0)
						}.standardErrorContent,
						encoding: .utf8
					)
				).contains(
					"Rational denominator must be greater than zero."
				)
			)
			try await #expect(
				#require(
					String(
						bytes:	#require(processExitsWith: .failure, observing: [\.standardErrorContent]) {
							_ = Rational(numerator: Int.max, denominator: -1)
						}.standardErrorContent,
						encoding: .utf8
					)
				).contains(
					"Rational denominator must be greater than zero."
				)
			)
			try await #expect(
				#require(
					String(
						bytes:	#require(processExitsWith: .failure, observing: [\.standardErrorContent]) {
							_ = Rational<BigInt>(numerator: 1, denominator: 0)
						}.standardErrorContent,
						encoding: .utf8
					)
				).contains(
					"Rational denominator must be greater than zero."
				)
			)
			try await #expect(
				#require(
					String(
						bytes:	#require(processExitsWith: .failure, observing: [\.standardErrorContent]) {
							_ = Rational<BigInt>(numerator: BigInt(Int.max), denominator: -1)
						}.standardErrorContent,
						encoding: .utf8
					)
				).contains(
					"Rational denominator must be greater than zero."
				)
			)
		}
	}


	@Test func mixedNumber() async throws {
		#expect(Rational(numerator: 5, denominator: 6).mixedNumber() == (integer: 0, fraction: Rational(numerator: 5, denominator: 6)))
		#expect(Rational(numerator: 6, denominator: 5).mixedNumber() == (integer: 1, fraction: Rational(numerator: 1, denominator: 5)))
		#expect(Rational(numerator: -27, denominator: 6).mixedNumber() == (integer: -4, fraction: Rational(numerator: -1, denominator: 2)))

		let denominator = BigInt("457425209663695646359203630886756382027")
		let remainder = BigInt("340282366920938463463374607431768211507")
		let numerator = denominator * 4 + remainder

		#expect(Rational(numerator: numerator, denominator: denominator).mixedNumber() == (integer: 4, fraction: Rational(numerator: remainder, denominator: denominator)))
	}

	struct `Rational: Equatable` {
		@Test func `==(lhs: Self, rhs: Self)`() async throws {
			#expect(Rational(numerator: 1, denominator: 2) == Rational(numerator: 1, denominator: 2))
			#expect(Rational(numerator: 3, denominator: 6) == Rational(numerator: 1, denominator: 2))
			#expect(Rational(numerator: 0, denominator: 6) == Rational(numerator: 0, denominator: 5))
			#expect(Rational(numerator: -10, denominator: 2) == Rational(-5))
			#expect(Rational(numerator: BigInt("340282366920938463463374607431768211507") * 2, denominator: 2) == Rational(BigInt("340282366920938463463374607431768211507")))
		}

		@Test func `==(lhs: Self, rhs: TermType)`() async throws {
			#expect(Rational(numerator: -10, denominator: 2) == -5)
			#expect(Rational(numerator: 0, denominator: 6) == 0)
			#expect(Rational(numerator: BigInt("340282366920938463463374607431768211507") * 2, denominator: 2) == BigInt("340282366920938463463374607431768211507"))
		}

		@Test func `==(lhs: TermType, rhs: Self)`() async throws {
			#expect(-7 == Rational(numerator: -14, denominator: 2))
			#expect(0 == Rational(numerator: 0, denominator: 1))
			#expect(BigInt("340282366920938463463374607431768211507") == Rational(numerator: BigInt("340282366920938463463374607431768211507") * 2, denominator: 2))
		}

		@Test func `!=(lhs: Self, rhs: TermType)`() async throws {
			#expect(Rational(numerator: -3, denominator: 2) != -5)
			#expect(Rational(numerator: 0, denominator: 6) != 10)
			#expect(Rational(numerator: BigInt("340282366920938463463374607431768211507") * 2, denominator: 2) != BigInt("34028236920938463463374607431768211507"))
		}

		@Test func `!=(lhs: TermType, rhs: Self)`() async throws {
			#expect(-7 != Rational(numerator: -15, denominator: 2))
			#expect(1 != Rational(numerator: 0, denominator: 1))
			#expect(BigInt("340282366920938463463374607431768211505") != Rational(numerator: BigInt("340282366920938463463374607431768211507") * 2, denominator: 2))
		}
	}

	struct `Rational: Comparable` {

		@Test func `<(lhs: Self, rhs: Self)`() async throws {
			#expect((Rational<BigInt>(numerator: -5, denominator: 3) < Rational(numerator: -4, denominator: 5))  == true)
			#expect((Rational<BigInt>(numerator: -5, denominator: 3) < Rational(numerator: -4, denominator: 3))  == true)
			#expect((Rational<BigInt>(numerator: -9, denominator: 4) < Rational(numerator: -4, denominator: 3))  == true)
			#expect((Rational<BigInt>(numerator: -9, denominator: 2) < Rational(numerator: -9, denominator: 3))  == true)
			#expect((Rational<BigInt>(numerator: -9, denominator: 2) < Rational(numerator: -9, denominator: 2))  == false)
			#expect((Rational<BigInt>(numerator: -9, denominator: 5) < Rational(numerator: -9, denominator: 2))  == false)
			#expect((Rational<BigInt>(numerator: -3, denominator: 3) < Rational(numerator: -4, denominator: 5))  == true)
			#expect((Rational<BigInt>(numerator: -3, denominator: 3) < Rational(numerator: -4, denominator: 3))  == false)
			#expect((Rational<BigInt>(numerator: -3, denominator: 4) < Rational(numerator: -4, denominator: 3))  == false)

			#expect((Rational<BigInt>(numerator: -5, denominator: 3) < Rational(numerator: 0, denominator: 5))  == true)
			#expect((Rational<BigInt>(numerator: -5, denominator: 3) < Rational(numerator: 0, denominator: 3))  == true)
			#expect((Rational<BigInt>(numerator: -9, denominator: 4) < Rational(numerator: 0, denominator: 3))  == true)

			#expect((Rational<BigInt>(numerator: -5, denominator: 3) < Rational(numerator: 4, denominator: 5))  == true)
			#expect((Rational<BigInt>(numerator: -5, denominator: 3) < Rational(numerator: 4, denominator: 3))  == true)
			#expect((Rational<BigInt>(numerator: -9, denominator: 4) < Rational(numerator: 4, denominator: 3))  == true)

			#expect((Rational<BigInt>(numerator: 0, denominator: 3) < Rational(numerator: -4, denominator: 5))  == false)
			#expect((Rational<BigInt>(numerator: 0, denominator: 3) < Rational(numerator: -4, denominator: 3))  == false)
			#expect((Rational<BigInt>(numerator: 0, denominator: 4) < Rational(numerator: -4, denominator: 3))  == false)

			#expect((Rational<BigInt>(numerator: 0, denominator: 2) < Rational(numerator: 0, denominator: 3))  == false)
			#expect((Rational<BigInt>(numerator: 0, denominator: 2) < Rational(numerator: 0, denominator: 2))  == false)
			#expect((Rational<BigInt>(numerator: 0, denominator: 5) < Rational(numerator: 0, denominator: 2))  == false)

			#expect((Rational<BigInt>(numerator: 0, denominator: 3) < Rational(numerator: 4, denominator: 5))  == true)
			#expect((Rational<BigInt>(numerator: 0, denominator: 3) < Rational(numerator: 4, denominator: 3))  == true)
			#expect((Rational<BigInt>(numerator: 0, denominator: 4) < Rational(numerator: 4, denominator: 3))  == true)

			#expect((Rational<BigInt>(numerator: 3, denominator: 3) < Rational(numerator: -4, denominator: 5))  == false)
			#expect((Rational<BigInt>(numerator: 3, denominator: 3) < Rational(numerator: -4, denominator: 3))  == false)
			#expect((Rational<BigInt>(numerator: 3, denominator: 4) < Rational(numerator: -4, denominator: 3))  == false)

			#expect((Rational<BigInt>(numerator: 3, denominator: 3) < Rational(numerator: 0, denominator: 5))  == false)
			#expect((Rational<BigInt>(numerator: 3, denominator: 3) < Rational(numerator: 0, denominator: 3))  == false)
			#expect((Rational<BigInt>(numerator: 3, denominator: 4) < Rational(numerator: 0, denominator: 3))  == false)

			#expect((Rational<BigInt>(numerator: 5, denominator: 3) < Rational(numerator: 4, denominator: 5))  == false)
			#expect((Rational<BigInt>(numerator: 5, denominator: 3) < Rational(numerator: 4, denominator: 3))  == false)
			#expect((Rational<BigInt>(numerator: 9, denominator: 4) < Rational(numerator: 4, denominator: 3))  == false)
			#expect((Rational<BigInt>(numerator: 9, denominator: 2) < Rational(numerator: 9, denominator: 3))  == false)
			#expect((Rational<BigInt>(numerator: 9, denominator: 2) < Rational(numerator: 9, denominator: 2))  == false)
			#expect((Rational<BigInt>(numerator: 9, denominator: 5) < Rational(numerator: 9, denominator: 2))  == true)
			#expect((Rational<BigInt>(numerator: 3, denominator: 3) < Rational(numerator: 4, denominator: 5))  == false)
			#expect((Rational<BigInt>(numerator: 3, denominator: 3) < Rational(numerator: 4, denominator: 3))  == true)
			#expect((Rational<BigInt>(numerator: 3, denominator: 4) < Rational(numerator: 4, denominator: 3))  == true)

			#if DEBUG
				await #expect(processExitsWith: .failure) {
					`< ForceBinaryInteger`(Rational(numerator: -5, denominator: 3), Rational(numerator: -4, denominator: 5))
				}
			#endif
		}

		@Test func `<(lhs: Self, rhs: Self) where TermType: FixedWidthInteger`() async throws {
			#expect((Rational(numerator: -5, denominator: 3) < Rational(numerator: -4, denominator: 5))  == true)
			#expect((Rational(numerator: -5, denominator: 3) < Rational(numerator: -4, denominator: 3))  == true)
			#expect((Rational(numerator: -9, denominator: 4) < Rational(numerator: -4, denominator: 3))  == true)
			#expect((Rational(numerator: -9, denominator: 2) < Rational(numerator: -9, denominator: 3))  == true)
			#expect((Rational(numerator: -9, denominator: 2) < Rational(numerator: -9, denominator: 2))  == false)
			#expect((Rational(numerator: -9, denominator: 5) < Rational(numerator: -9, denominator: 2))  == false)
			#expect((Rational(numerator: -3, denominator: 3) < Rational(numerator: -4, denominator: 5))  == true)
			#expect((Rational(numerator: -3, denominator: 3) < Rational(numerator: -4, denominator: 3))  == false)
			#expect((Rational(numerator: -3, denominator: 4) < Rational(numerator: -4, denominator: 3))  == false)

			#expect((Rational(numerator: -5, denominator: 3) < Rational(numerator: 0, denominator: 5))  == true)
			#expect((Rational(numerator: -5, denominator: 3) < Rational(numerator: 0, denominator: 3))  == true)
			#expect((Rational(numerator: -9, denominator: 4) < Rational(numerator: 0, denominator: 3))  == true)

			#expect((Rational(numerator: -5, denominator: 3) < Rational(numerator: 4, denominator: 5))  == true)
			#expect((Rational(numerator: -5, denominator: 3) < Rational(numerator: 4, denominator: 3))  == true)
			#expect((Rational(numerator: -9, denominator: 4) < Rational(numerator: 4, denominator: 3))  == true)

			#expect((Rational(numerator: 0, denominator: 3) < Rational(numerator: -4, denominator: 5))  == false)
			#expect((Rational(numerator: 0, denominator: 3) < Rational(numerator: -4, denominator: 3))  == false)
			#expect((Rational(numerator: 0, denominator: 4) < Rational(numerator: -4, denominator: 3))  == false)

			#expect((Rational(numerator: 0, denominator: 2) < Rational(numerator: 0, denominator: 3))  == false)
			#expect((Rational(numerator: 0, denominator: 2) < Rational(numerator: 0, denominator: 2))  == false)
			#expect((Rational(numerator: 0, denominator: 5) < Rational(numerator: 0, denominator: 2))  == false)

			#expect((Rational(numerator: 0, denominator: 3) < Rational(numerator: 4, denominator: 5))  == true)
			#expect((Rational(numerator: 0, denominator: 3) < Rational(numerator: 4, denominator: 3))  == true)
			#expect((Rational(numerator: 0, denominator: 4) < Rational(numerator: 4, denominator: 3))  == true)

			#expect((Rational(numerator: 3, denominator: 3) < Rational(numerator: -4, denominator: 5))  == false)
			#expect((Rational(numerator: 3, denominator: 3) < Rational(numerator: -4, denominator: 3))  == false)
			#expect((Rational(numerator: 3, denominator: 4) < Rational(numerator: -4, denominator: 3))  == false)

			#expect((Rational(numerator: 3, denominator: 3) < Rational(numerator: 0, denominator: 5))  == false)
			#expect((Rational(numerator: 3, denominator: 3) < Rational(numerator: 0, denominator: 3))  == false)
			#expect((Rational(numerator: 3, denominator: 4) < Rational(numerator: 0, denominator: 3))  == false)

			#expect((Rational(numerator: 5, denominator: 3) < Rational(numerator: 4, denominator: 5))  == false)
			#expect((Rational(numerator: 5, denominator: 3) < Rational(numerator: 4, denominator: 3))  == false)
			#expect((Rational(numerator: 9, denominator: 4) < Rational(numerator: 4, denominator: 3))  == false)
			#expect((Rational(numerator: 9, denominator: 2) < Rational(numerator: 9, denominator: 3))  == false)
			#expect((Rational(numerator: 9, denominator: 2) < Rational(numerator: 9, denominator: 2))  == false)
			#expect((Rational(numerator: 9, denominator: 5) < Rational(numerator: 9, denominator: 2))  == true)
			#expect((Rational(numerator: 3, denominator: 3) < Rational(numerator: 4, denominator: 5))  == false)
			#expect((Rational(numerator: 3, denominator: 3) < Rational(numerator: 4, denominator: 3))  == true)
			#expect((Rational(numerator: 3, denominator: 4) < Rational(numerator: 4, denominator: 3))  == true)

			#expect((Rational(numerator: .min, denominator: .max - 1) < Rational(numerator: .min + 1, denominator: .max))  == true)
			#expect((Rational(numerator: .min, denominator: .max) < Rational(numerator: .min + 1, denominator: .max))  == true)
			#expect((Rational(numerator: .min, denominator: .max) < Rational(numerator: .min + 1, denominator: .max - 1))  == false)
			#expect((Rational(numerator: .min, denominator: .max - 1) < Rational(numerator: .min, denominator: .max))  == true)
			#expect((Rational(numerator: Int.min, denominator: .max) < Rational(numerator: .min, denominator: .max))  == false)
			#expect((Rational(numerator: .min, denominator: .max) < Rational(numerator: .min, denominator: .max - 1))  == false)
			#expect((Rational(numerator: .min + 1, denominator: .max - 1) < Rational(numerator: .min, denominator: .max))  == true)
			#expect((Rational(numerator: .min + 1, denominator: .max) < Rational(numerator: .min, denominator: .max))  == false)
			#expect((Rational(numerator: .min + 1, denominator: .max) < Rational(numerator: .min, denominator: .max - 1))  == false)

			#expect((Rational(numerator: .min, denominator: .max - 1) < Rational(numerator: 0, denominator: .max))  == true)
			#expect((Rational(numerator: .min, denominator: .max) < Rational(numerator: 0, denominator: .max))  == true)
			#expect((Rational(numerator: .min, denominator: .max) < Rational(numerator: 0, denominator: .max - 1))  == true)

			#expect((Rational(numerator: .min, denominator: .max - 1) < Rational(numerator: .max, denominator: .max))  == true)
			#expect((Rational(numerator: Int.min, denominator: .max) < Rational(numerator: .max, denominator: .max))  == true)
			#expect((Rational(numerator: .min, denominator: .max) < Rational(numerator: .max, denominator: .max - 1))  == true)

			#expect((Rational(numerator: 0, denominator: .max - 1) < Rational(numerator: .min, denominator: .max))  == false)
			#expect((Rational(numerator: 0, denominator: .max) < Rational(numerator: .min, denominator: .max))  == false)
			#expect((Rational(numerator: 0, denominator: .max) < Rational(numerator: .min, denominator: .max - 1))  == false)

			#expect((Rational(numerator: 0, denominator: .max - 1) < Rational(numerator: 0, denominator: .max))  == false)
			#expect((Rational(numerator: 0, denominator: .max) < Rational(numerator: 0, denominator: .max))  == false)
			#expect((Rational(numerator: 0, denominator: .max) < Rational(numerator: 0, denominator: .max - 1))  == false)

			#expect((Rational(numerator: 0, denominator: .max - 1) < Rational(numerator: .max, denominator: .max))  == true)
			#expect((Rational(numerator: 0, denominator: .max) < Rational(numerator: .max, denominator: .max))  == true)
			#expect((Rational(numerator: 0, denominator: .max) < Rational(numerator: .max, denominator: .max - 1))  == true)

			#expect((Rational(numerator: .max, denominator: .max - 1) < Rational(numerator: .min, denominator: .max))  == false)
			#expect((Rational(numerator: Int.max, denominator: .max) < Rational(numerator: .min, denominator: .max))  == false)
			#expect((Rational(numerator: .max, denominator: .max) < Rational(numerator: .min, denominator: .max - 1))  == false)

			#expect((Rational(numerator: .max, denominator: .max - 1) < Rational(numerator: 0, denominator: .max))  == false)
			#expect((Rational(numerator: .max, denominator: .max) < Rational(numerator: 0, denominator: .max))  == false)
			#expect((Rational(numerator: .max, denominator: .max) < Rational(numerator: 0, denominator: .max - 1))  == false)

			#expect((Rational(numerator: .max, denominator: .max - 1) < Rational(numerator: .max - 1, denominator: .max))  == false)
			#expect((Rational(numerator: .max, denominator: .max) < Rational(numerator: .max - 1, denominator: .max))  == false)
			#expect((Rational(numerator: .max, denominator: .max) < Rational(numerator: .max - 1, denominator: .max - 1))  == false)
			#expect((Rational(numerator: .max, denominator: .max - 1) < Rational(numerator: .max, denominator: .max))  == false)
			#expect((Rational(numerator: Int.max, denominator: .max) < Rational(numerator: .max, denominator: .max))  == false)
			#expect((Rational(numerator: .max, denominator: .max) < Rational(numerator: .max, denominator: .max - 1))  == true)
			#expect((Rational(numerator: .max - 1, denominator: .max - 1) < Rational(numerator: .max, denominator: .max))  == false)
			#expect((Rational(numerator: .max - 1, denominator: .max) < Rational(numerator: .max, denominator: .max))  == true)
			#expect((Rational(numerator: .max - 1, denominator: .max) < Rational(numerator: .max, denominator: .max - 1))  == true)
		}

		@Test func `<=(lhs: Self, rhs: Self)`() async throws {
			#expect((Rational<BigInt>(numerator: -5, denominator: 3) <= Rational(numerator: -4, denominator: 5))  == true)
			#expect((Rational<BigInt>(numerator: -5, denominator: 3) <= Rational(numerator: -4, denominator: 3))  == true)
			#expect((Rational<BigInt>(numerator: -9, denominator: 4) <= Rational(numerator: -4, denominator: 3))  == true)
			#expect((Rational<BigInt>(numerator: -9, denominator: 2) <= Rational(numerator: -9, denominator: 3))  == true)
			#expect((Rational<BigInt>(numerator: -9, denominator: 2) <= Rational(numerator: -9, denominator: 2))  == true)
			#expect((Rational<BigInt>(numerator: -9, denominator: 5) <= Rational(numerator: -9, denominator: 2))  == false)
			#expect((Rational<BigInt>(numerator: -3, denominator: 3) <= Rational(numerator: -4, denominator: 5))  == true)
			#expect((Rational<BigInt>(numerator: -3, denominator: 3) <= Rational(numerator: -4, denominator: 3))  == false)
			#expect((Rational<BigInt>(numerator: -3, denominator: 4) <= Rational(numerator: -4, denominator: 3))  == false)

			#expect((Rational<BigInt>(numerator: -5, denominator: 3) <= Rational(numerator: 0, denominator: 5))  == true)
			#expect((Rational<BigInt>(numerator: -5, denominator: 3) <= Rational(numerator: 0, denominator: 3))  == true)
			#expect((Rational<BigInt>(numerator: -9, denominator: 4) <= Rational(numerator: 0, denominator: 3))  == true)

			#expect((Rational<BigInt>(numerator: -5, denominator: 3) <= Rational(numerator: 4, denominator: 5))  == true)
			#expect((Rational<BigInt>(numerator: -5, denominator: 3) <= Rational(numerator: 4, denominator: 3))  == true)
			#expect((Rational<BigInt>(numerator: -9, denominator: 4) <= Rational(numerator: 4, denominator: 3))  == true)

			#expect((Rational<BigInt>(numerator: 0, denominator: 3) <= Rational(numerator: -4, denominator: 5))  == false)
			#expect((Rational<BigInt>(numerator: 0, denominator: 3) <= Rational(numerator: -4, denominator: 3))  == false)
			#expect((Rational<BigInt>(numerator: 0, denominator: 4) <= Rational(numerator: -4, denominator: 3))  == false)

			#expect((Rational<BigInt>(numerator: 0, denominator: 2) <= Rational(numerator: 0, denominator: 3))  == true)
			#expect((Rational<BigInt>(numerator: 0, denominator: 2) <= Rational(numerator: 0, denominator: 2))  == true)
			#expect((Rational<BigInt>(numerator: 0, denominator: 5) <= Rational(numerator: 0, denominator: 2))  == true)

			#expect((Rational<BigInt>(numerator: 0, denominator: 3) <= Rational(numerator: 4, denominator: 5))  == true)
			#expect((Rational<BigInt>(numerator: 0, denominator: 3) <= Rational(numerator: 4, denominator: 3))  == true)
			#expect((Rational<BigInt>(numerator: 0, denominator: 4) <= Rational(numerator: 4, denominator: 3))  == true)

			#expect((Rational<BigInt>(numerator: 3, denominator: 3) <= Rational(numerator: -4, denominator: 5))  == false)
			#expect((Rational<BigInt>(numerator: 3, denominator: 3) <= Rational(numerator: -4, denominator: 3))  == false)
			#expect((Rational<BigInt>(numerator: 3, denominator: 4) <= Rational(numerator: -4, denominator: 3))  == false)

			#expect((Rational<BigInt>(numerator: 3, denominator: 3) <= Rational(numerator: 0, denominator: 5))  == false)
			#expect((Rational<BigInt>(numerator: 3, denominator: 3) <= Rational(numerator: 0, denominator: 3))  == false)
			#expect((Rational<BigInt>(numerator: 3, denominator: 4) <= Rational(numerator: 0, denominator: 3))  == false)

			#expect((Rational<BigInt>(numerator: 5, denominator: 3) <= Rational(numerator: 4, denominator: 5))  == false)
			#expect((Rational<BigInt>(numerator: 5, denominator: 3) <= Rational(numerator: 4, denominator: 3))  == false)
			#expect((Rational<BigInt>(numerator: 9, denominator: 4) <= Rational(numerator: 4, denominator: 3))  == false)
			#expect((Rational<BigInt>(numerator: 9, denominator: 2) <= Rational(numerator: 9, denominator: 3))  == false)
			#expect((Rational<BigInt>(numerator: 9, denominator: 2) <= Rational(numerator: 9, denominator: 2))  == true)
			#expect((Rational<BigInt>(numerator: 9, denominator: 5) <= Rational(numerator: 9, denominator: 2))  == true)
			#expect((Rational<BigInt>(numerator: 3, denominator: 3) <= Rational(numerator: 4, denominator: 5))  == false)
			#expect((Rational<BigInt>(numerator: 3, denominator: 3) <= Rational(numerator: 4, denominator: 3))  == true)
			#expect((Rational<BigInt>(numerator: 3, denominator: 4) <= Rational(numerator: 4, denominator: 3))  == true)

			#if DEBUG
				await #expect(processExitsWith: .failure) {
					`<= ForceBinaryInteger`(Rational(numerator: -5, denominator: 3), Rational(numerator: -4, denominator: 5))
				}
			#endif
		}

		@Test func `<=(lhs: Self, rhs: Self) where TermType: FixedWidthInteger`() async throws {
			#expect((Rational(numerator: -5, denominator: 3) <= Rational(numerator: -4, denominator: 5))  == true)
			#expect((Rational(numerator: -5, denominator: 3) <= Rational(numerator: -4, denominator: 3))  == true)
			#expect((Rational(numerator: -9, denominator: 4) <= Rational(numerator: -4, denominator: 3))  == true)
			#expect((Rational(numerator: -9, denominator: 2) <= Rational(numerator: -9, denominator: 3))  == true)
			#expect((Rational(numerator: -9, denominator: 2) <= Rational(numerator: -9, denominator: 2))  == true)
			#expect((Rational(numerator: -9, denominator: 5) <= Rational(numerator: -9, denominator: 2))  == false)
			#expect((Rational(numerator: -3, denominator: 3) <= Rational(numerator: -4, denominator: 5))  == true)
			#expect((Rational(numerator: -3, denominator: 3) <= Rational(numerator: -4, denominator: 3))  == false)
			#expect((Rational(numerator: -3, denominator: 4) <= Rational(numerator: -4, denominator: 3))  == false)

			#expect((Rational(numerator: -5, denominator: 3) <= Rational(numerator: 0, denominator: 5))  == true)
			#expect((Rational(numerator: -5, denominator: 3) <= Rational(numerator: 0, denominator: 3))  == true)
			#expect((Rational(numerator: -9, denominator: 4) <= Rational(numerator: 0, denominator: 3))  == true)

			#expect((Rational(numerator: -5, denominator: 3) <= Rational(numerator: 4, denominator: 5))  == true)
			#expect((Rational(numerator: -5, denominator: 3) <= Rational(numerator: 4, denominator: 3))  == true)
			#expect((Rational(numerator: -9, denominator: 4) <= Rational(numerator: 4, denominator: 3))  == true)

			#expect((Rational(numerator: 0, denominator: 3) <= Rational(numerator: -4, denominator: 5))  == false)
			#expect((Rational(numerator: 0, denominator: 3) <= Rational(numerator: -4, denominator: 3))  == false)
			#expect((Rational(numerator: 0, denominator: 4) <= Rational(numerator: -4, denominator: 3))  == false)

			#expect((Rational(numerator: 0, denominator: 2) <= Rational(numerator: 0, denominator: 3))  == true)
			#expect((Rational(numerator: 0, denominator: 2) <= Rational(numerator: 0, denominator: 2))  == true)
			#expect((Rational(numerator: 0, denominator: 5) <= Rational(numerator: 0, denominator: 2))  == true)

			#expect((Rational(numerator: 0, denominator: 3) <= Rational(numerator: 4, denominator: 5))  == true)
			#expect((Rational(numerator: 0, denominator: 3) <= Rational(numerator: 4, denominator: 3))  == true)
			#expect((Rational(numerator: 0, denominator: 4) <= Rational(numerator: 4, denominator: 3))  == true)

			#expect((Rational(numerator: 3, denominator: 3) <= Rational(numerator: -4, denominator: 5))  == false)
			#expect((Rational(numerator: 3, denominator: 3) <= Rational(numerator: -4, denominator: 3))  == false)
			#expect((Rational(numerator: 3, denominator: 4) <= Rational(numerator: -4, denominator: 3))  == false)

			#expect((Rational(numerator: 3, denominator: 3) <= Rational(numerator: 0, denominator: 5))  == false)
			#expect((Rational(numerator: 3, denominator: 3) <= Rational(numerator: 0, denominator: 3))  == false)
			#expect((Rational(numerator: 3, denominator: 4) <= Rational(numerator: 0, denominator: 3))  == false)

			#expect((Rational(numerator: 5, denominator: 3) <= Rational(numerator: 4, denominator: 5))  == false)
			#expect((Rational(numerator: 5, denominator: 3) <= Rational(numerator: 4, denominator: 3))  == false)
			#expect((Rational(numerator: 9, denominator: 4) <= Rational(numerator: 4, denominator: 3))  == false)
			#expect((Rational(numerator: 9, denominator: 2) <= Rational(numerator: 9, denominator: 3))  == false)
			#expect((Rational(numerator: 9, denominator: 2) <= Rational(numerator: 9, denominator: 2))  == true)
			#expect((Rational(numerator: 9, denominator: 5) <= Rational(numerator: 9, denominator: 2))  == true)
			#expect((Rational(numerator: 3, denominator: 3) <= Rational(numerator: 4, denominator: 5))  == false)
			#expect((Rational(numerator: 3, denominator: 3) <= Rational(numerator: 4, denominator: 3))  == true)
			#expect((Rational(numerator: 3, denominator: 4) <= Rational(numerator: 4, denominator: 3))  == true)

			#expect((Rational(numerator: .min, denominator: .max - 1) <= Rational(numerator: .min + 1, denominator: .max))  == true)
			#expect((Rational(numerator: .min, denominator: .max) <= Rational(numerator: .min + 1, denominator: .max))  == true)
			#expect((Rational(numerator: .min, denominator: .max) <= Rational(numerator: .min + 1, denominator: .max - 1))  == false)
			#expect((Rational(numerator: .min, denominator: .max - 1) <= Rational(numerator: .min, denominator: .max))  == true)
			#expect((Rational(numerator: Int.min, denominator: .max) <= Rational(numerator: .min, denominator: .max))  == true)
			#expect((Rational(numerator: .min, denominator: .max) <= Rational(numerator: .min, denominator: .max - 1))  == false)
			#expect((Rational(numerator: .min + 1, denominator: .max - 1) <= Rational(numerator: .min, denominator: .max))  == true)
			#expect((Rational(numerator: .min + 1, denominator: .max) <= Rational(numerator: .min, denominator: .max))  == false)
			#expect((Rational(numerator: .min + 1, denominator: .max) <= Rational(numerator: .min, denominator: .max - 1))  == false)

			#expect((Rational(numerator: .min, denominator: .max - 1) <= Rational(numerator: 0, denominator: .max))  == true)
			#expect((Rational(numerator: .min, denominator: .max) <= Rational(numerator: 0, denominator: .max))  == true)
			#expect((Rational(numerator: .min, denominator: .max) <= Rational(numerator: 0, denominator: .max - 1))  == true)

			#expect((Rational(numerator: .min, denominator: .max - 1) <= Rational(numerator: .max, denominator: .max))  == true)
			#expect((Rational(numerator: Int.min, denominator: .max) <= Rational(numerator: .max, denominator: .max))  == true)
			#expect((Rational(numerator: .min, denominator: .max) <= Rational(numerator: .max, denominator: .max - 1))  == true)

			#expect((Rational(numerator: 0, denominator: .max - 1) <= Rational(numerator: .min, denominator: .max))  == false)
			#expect((Rational(numerator: 0, denominator: .max) <= Rational(numerator: .min, denominator: .max))  == false)
			#expect((Rational(numerator: 0, denominator: .max) <= Rational(numerator: .min, denominator: .max - 1))  == false)

			#expect((Rational(numerator: 0, denominator: .max - 1) <= Rational(numerator: 0, denominator: .max))  == true)
			#expect((Rational(numerator: 0, denominator: .max) <= Rational(numerator: 0, denominator: .max))  == true)
			#expect((Rational(numerator: 0, denominator: .max) <= Rational(numerator: 0, denominator: .max - 1))  == true)

			#expect((Rational(numerator: 0, denominator: .max - 1) <= Rational(numerator: .max, denominator: .max))  == true)
			#expect((Rational(numerator: 0, denominator: .max) <= Rational(numerator: .max, denominator: .max))  == true)
			#expect((Rational(numerator: 0, denominator: .max) <= Rational(numerator: .max, denominator: .max - 1))  == true)

			#expect((Rational(numerator: .max, denominator: .max - 1) <= Rational(numerator: .min, denominator: .max))  == false)
			#expect((Rational(numerator: Int.max, denominator: .max) <= Rational(numerator: .min, denominator: .max))  == false)
			#expect((Rational(numerator: .max, denominator: .max) <= Rational(numerator: .min, denominator: .max - 1))  == false)

			#expect((Rational(numerator: .max, denominator: .max - 1) <= Rational(numerator: 0, denominator: .max))  == false)
			#expect((Rational(numerator: .max, denominator: .max) <= Rational(numerator: 0, denominator: .max))  == false)
			#expect((Rational(numerator: .max, denominator: .max) <= Rational(numerator: 0, denominator: .max - 1))  == false)

			#expect((Rational(numerator: .max, denominator: .max - 1) <= Rational(numerator: .max - 1, denominator: .max))  == false)
			#expect((Rational(numerator: .max, denominator: .max) <= Rational(numerator: .max - 1, denominator: .max))  == false)
			#expect((Rational(numerator: .max, denominator: .max) <= Rational(numerator: .max - 1, denominator: .max - 1))  == true)
			#expect((Rational(numerator: .max, denominator: .max - 1) <= Rational(numerator: .max, denominator: .max))  == false)
			#expect((Rational(numerator: Int.max, denominator: .max) <= Rational(numerator: .max, denominator: .max))  == true)
			#expect((Rational(numerator: .max, denominator: .max) <= Rational(numerator: .max, denominator: .max - 1))  == true)
			#expect((Rational(numerator: .max - 1, denominator: .max - 1) <= Rational(numerator: .max, denominator: .max))  == true)
			#expect((Rational(numerator: .max - 1, denominator: .max) <= Rational(numerator: .max, denominator: .max))  == true)
			#expect((Rational(numerator: .max - 1, denominator: .max) <= Rational(numerator: .max, denominator: .max - 1))  == true)
		}

		@Test func `>(lhs: Self, rhs: Self)`() async throws {
			#expect((Rational<BigInt>(numerator: -5, denominator: 3) > Rational(numerator: -4, denominator: 5))  == false)
			#expect((Rational<BigInt>(numerator: -5, denominator: 3) > Rational(numerator: -4, denominator: 3))  == false)
			#expect((Rational<BigInt>(numerator: -9, denominator: 4) > Rational(numerator: -4, denominator: 3))  == false)
			#expect((Rational<BigInt>(numerator: -9, denominator: 2) > Rational(numerator: -9, denominator: 3))  == false)
			#expect((Rational<BigInt>(numerator: -9, denominator: 2) > Rational(numerator: -9, denominator: 2))  == false)
			#expect((Rational<BigInt>(numerator: -9, denominator: 5) > Rational(numerator: -9, denominator: 2))  == true)
			#expect((Rational<BigInt>(numerator: -3, denominator: 3) > Rational(numerator: -4, denominator: 5))  == false)
			#expect((Rational<BigInt>(numerator: -3, denominator: 3) > Rational(numerator: -4, denominator: 3))  == true)
			#expect((Rational<BigInt>(numerator: -3, denominator: 4) > Rational(numerator: -4, denominator: 3))  == true)

			#expect((Rational<BigInt>(numerator: -5, denominator: 3) > Rational(numerator: 0, denominator: 5))  == false)
			#expect((Rational<BigInt>(numerator: -5, denominator: 3) > Rational(numerator: 0, denominator: 3))  == false)
			#expect((Rational<BigInt>(numerator: -9, denominator: 4) > Rational(numerator: 0, denominator: 3))  == false)

			#expect((Rational<BigInt>(numerator: -5, denominator: 3) > Rational(numerator: 4, denominator: 5))  == false)
			#expect((Rational<BigInt>(numerator: -5, denominator: 3) > Rational(numerator: 4, denominator: 3))  == false)
			#expect((Rational<BigInt>(numerator: -9, denominator: 4) > Rational(numerator: 4, denominator: 3))  == false)

			#expect((Rational<BigInt>(numerator: 0, denominator: 3) > Rational(numerator: -4, denominator: 5))  == true)
			#expect((Rational<BigInt>(numerator: 0, denominator: 3) > Rational(numerator: -4, denominator: 3))  == true)
			#expect((Rational<BigInt>(numerator: 0, denominator: 4) > Rational(numerator: -4, denominator: 3))  == true)

			#expect((Rational<BigInt>(numerator: 0, denominator: 2) > Rational(numerator: 0, denominator: 3))  == false)
			#expect((Rational<BigInt>(numerator: 0, denominator: 2) > Rational(numerator: 0, denominator: 2))  == false)
			#expect((Rational<BigInt>(numerator: 0, denominator: 5) > Rational(numerator: 0, denominator: 2))  == false)

			#expect((Rational<BigInt>(numerator: 0, denominator: 3) > Rational(numerator: 4, denominator: 5))  == false)
			#expect((Rational<BigInt>(numerator: 0, denominator: 3) > Rational(numerator: 4, denominator: 3))  == false)
			#expect((Rational<BigInt>(numerator: 0, denominator: 4) > Rational(numerator: 4, denominator: 3))  == false)

			#expect((Rational<BigInt>(numerator: 3, denominator: 3) > Rational(numerator: -4, denominator: 5))  == true)
			#expect((Rational<BigInt>(numerator: 3, denominator: 3) > Rational(numerator: -4, denominator: 3))  == true)
			#expect((Rational<BigInt>(numerator: 3, denominator: 4) > Rational(numerator: -4, denominator: 3))  == true)

			#expect((Rational<BigInt>(numerator: 3, denominator: 3) > Rational(numerator: 0, denominator: 5))  == true)
			#expect((Rational<BigInt>(numerator: 3, denominator: 3) > Rational(numerator: 0, denominator: 3))  == true)
			#expect((Rational<BigInt>(numerator: 3, denominator: 4) > Rational(numerator: 0, denominator: 3))  == true)

			#expect((Rational<BigInt>(numerator: 5, denominator: 3) > Rational(numerator: 4, denominator: 5))  == true)
			#expect((Rational<BigInt>(numerator: 5, denominator: 3) > Rational(numerator: 4, denominator: 3))  == true)
			#expect((Rational<BigInt>(numerator: 9, denominator: 4) > Rational(numerator: 4, denominator: 3))  == true)
			#expect((Rational<BigInt>(numerator: 9, denominator: 2) > Rational(numerator: 9, denominator: 3))  == true)
			#expect((Rational<BigInt>(numerator: 9, denominator: 2) > Rational(numerator: 9, denominator: 2))  == false)
			#expect((Rational<BigInt>(numerator: 9, denominator: 5) > Rational(numerator: 9, denominator: 2))  == false)
			#expect((Rational<BigInt>(numerator: 3, denominator: 3) > Rational(numerator: 4, denominator: 5))  == true)
			#expect((Rational<BigInt>(numerator: 3, denominator: 3) > Rational(numerator: 4, denominator: 3))  == false)
			#expect((Rational<BigInt>(numerator: 3, denominator: 4) > Rational(numerator: 4, denominator: 3))  == false)

			#if DEBUG
				await #expect(processExitsWith: .failure) {
					`> ForceBinaryInteger`(Rational(numerator: -5, denominator: 3), Rational(numerator: -4, denominator: 5))
				}
			#endif
		}

		@Test func `>(lhs: Self, rhs: Self) where TermType: FixedWidthInteger`() async throws {
			#expect((Rational(numerator: -5, denominator: 3) > Rational(numerator: -4, denominator: 5))  == false)
			#expect((Rational(numerator: -5, denominator: 3) > Rational(numerator: -4, denominator: 3))  == false)
			#expect((Rational(numerator: -9, denominator: 4) > Rational(numerator: -4, denominator: 3))  == false)
			#expect((Rational(numerator: -9, denominator: 2) > Rational(numerator: -9, denominator: 3))  == false)
			#expect((Rational(numerator: -9, denominator: 2) > Rational(numerator: -9, denominator: 2))  == false)
			#expect((Rational(numerator: -9, denominator: 5) > Rational(numerator: -9, denominator: 2))  == true)
			#expect((Rational(numerator: -3, denominator: 3) > Rational(numerator: -4, denominator: 5))  == false)
			#expect((Rational(numerator: -3, denominator: 3) > Rational(numerator: -4, denominator: 3))  == true)
			#expect((Rational(numerator: -3, denominator: 4) > Rational(numerator: -4, denominator: 3))  == true)

			#expect((Rational(numerator: -5, denominator: 3) > Rational(numerator: 0, denominator: 5))  == false)
			#expect((Rational(numerator: -5, denominator: 3) > Rational(numerator: 0, denominator: 3))  == false)
			#expect((Rational(numerator: -9, denominator: 4) > Rational(numerator: 0, denominator: 3))  == false)

			#expect((Rational(numerator: -5, denominator: 3) > Rational(numerator: 4, denominator: 5))  == false)
			#expect((Rational(numerator: -5, denominator: 3) > Rational(numerator: 4, denominator: 3))  == false)
			#expect((Rational(numerator: -9, denominator: 4) > Rational(numerator: 4, denominator: 3))  == false)

			#expect((Rational(numerator: 0, denominator: 3) > Rational(numerator: -4, denominator: 5))  == true)
			#expect((Rational(numerator: 0, denominator: 3) > Rational(numerator: -4, denominator: 3))  == true)
			#expect((Rational(numerator: 0, denominator: 4) > Rational(numerator: -4, denominator: 3))  == true)

			#expect((Rational(numerator: 0, denominator: 2) > Rational(numerator: 0, denominator: 3))  == false)
			#expect((Rational(numerator: 0, denominator: 2) > Rational(numerator: 0, denominator: 2))  == false)
			#expect((Rational(numerator: 0, denominator: 5) > Rational(numerator: 0, denominator: 2))  == false)

			#expect((Rational(numerator: 0, denominator: 3) > Rational(numerator: 4, denominator: 5))  == false)
			#expect((Rational(numerator: 0, denominator: 3) > Rational(numerator: 4, denominator: 3))  == false)
			#expect((Rational(numerator: 0, denominator: 4) > Rational(numerator: 4, denominator: 3))  == false)

			#expect((Rational(numerator: 3, denominator: 3) > Rational(numerator: -4, denominator: 5))  == true)
			#expect((Rational(numerator: 3, denominator: 3) > Rational(numerator: -4, denominator: 3))  == true)
			#expect((Rational(numerator: 3, denominator: 4) > Rational(numerator: -4, denominator: 3))  == true)

			#expect((Rational(numerator: 3, denominator: 3) > Rational(numerator: 0, denominator: 5))  == true)
			#expect((Rational(numerator: 3, denominator: 3) > Rational(numerator: 0, denominator: 3))  == true)
			#expect((Rational(numerator: 3, denominator: 4) > Rational(numerator: 0, denominator: 3))  == true)

			#expect((Rational(numerator: 5, denominator: 3) > Rational(numerator: 4, denominator: 5))  == true)
			#expect((Rational(numerator: 5, denominator: 3) > Rational(numerator: 4, denominator: 3))  == true)
			#expect((Rational(numerator: 9, denominator: 4) > Rational(numerator: 4, denominator: 3))  == true)
			#expect((Rational(numerator: 9, denominator: 2) > Rational(numerator: 9, denominator: 3))  == true)
			#expect((Rational(numerator: 9, denominator: 2) > Rational(numerator: 9, denominator: 2))  == false)
			#expect((Rational(numerator: 9, denominator: 5) > Rational(numerator: 9, denominator: 2))  == false)
			#expect((Rational(numerator: 3, denominator: 3) > Rational(numerator: 4, denominator: 5))  == true)
			#expect((Rational(numerator: 3, denominator: 3) > Rational(numerator: 4, denominator: 3))  == false)
			#expect((Rational(numerator: 3, denominator: 4) > Rational(numerator: 4, denominator: 3))  == false)

			#expect((Rational(numerator: .min, denominator: .max - 1) > Rational(numerator: .min + 1, denominator: .max))  == false)
			#expect((Rational(numerator: .min, denominator: .max) > Rational(numerator: .min + 1, denominator: .max))  == false)
			#expect((Rational(numerator: .min, denominator: .max) > Rational(numerator: .min + 1, denominator: .max - 1))  == true)
			#expect((Rational(numerator: .min, denominator: .max - 1) > Rational(numerator: .min, denominator: .max))  == false)
			#expect((Rational(numerator: Int.min, denominator: .max) > Rational(numerator: .min, denominator: .max))  == false)
			#expect((Rational(numerator: .min, denominator: .max) > Rational(numerator: .min, denominator: .max - 1))  == true)
			#expect((Rational(numerator: .min + 1, denominator: .max - 1) > Rational(numerator: .min, denominator: .max))  == false)
			#expect((Rational(numerator: .min + 1, denominator: .max) > Rational(numerator: .min, denominator: .max))  == true)
			#expect((Rational(numerator: .min + 1, denominator: .max) > Rational(numerator: .min, denominator: .max - 1))  == true)

			#expect((Rational(numerator: .min, denominator: .max - 1) > Rational(numerator: 0, denominator: .max))  == false)
			#expect((Rational(numerator: .min, denominator: .max) > Rational(numerator: 0, denominator: .max))  == false)
			#expect((Rational(numerator: .min, denominator: .max) > Rational(numerator: 0, denominator: .max - 1))  == false)

			#expect((Rational(numerator: .min, denominator: .max - 1) > Rational(numerator: .max, denominator: .max))  == false)
			#expect((Rational(numerator: Int.min, denominator: .max) > Rational(numerator: .max, denominator: .max))  == false)
			#expect((Rational(numerator: .min, denominator: .max) > Rational(numerator: .max, denominator: .max - 1))  == false)

			#expect((Rational(numerator: 0, denominator: .max - 1) > Rational(numerator: .min, denominator: .max))  == true)
			#expect((Rational(numerator: 0, denominator: .max) > Rational(numerator: .min, denominator: .max))  == true)
			#expect((Rational(numerator: 0, denominator: .max) > Rational(numerator: .min, denominator: .max - 1))  == true)

			#expect((Rational(numerator: 0, denominator: .max - 1) > Rational(numerator: 0, denominator: .max))  == false)
			#expect((Rational(numerator: 0, denominator: .max) > Rational(numerator: 0, denominator: .max))  == false)
			#expect((Rational(numerator: 0, denominator: .max) > Rational(numerator: 0, denominator: .max - 1))  == false)

			#expect((Rational(numerator: 0, denominator: .max - 1) > Rational(numerator: .max, denominator: .max))  == false)
			#expect((Rational(numerator: 0, denominator: .max) > Rational(numerator: .max, denominator: .max))  == false)
			#expect((Rational(numerator: 0, denominator: .max) > Rational(numerator: .max, denominator: .max - 1))  == false)

			#expect((Rational(numerator: .max, denominator: .max - 1) > Rational(numerator: .min, denominator: .max))  == true)
			#expect((Rational(numerator: Int.max, denominator: .max) > Rational(numerator: .min, denominator: .max))  == true)
			#expect((Rational(numerator: .max, denominator: .max) > Rational(numerator: .min, denominator: .max - 1))  == true)

			#expect((Rational(numerator: .max, denominator: .max - 1) > Rational(numerator: 0, denominator: .max))  == true)
			#expect((Rational(numerator: .max, denominator: .max) > Rational(numerator: 0, denominator: .max))  == true)
			#expect((Rational(numerator: .max, denominator: .max) > Rational(numerator: 0, denominator: .max - 1))  == true)

			#expect((Rational(numerator: .max, denominator: .max - 1) > Rational(numerator: .max - 1, denominator: .max))  == true)
			#expect((Rational(numerator: .max, denominator: .max) > Rational(numerator: .max - 1, denominator: .max))  == true)
			#expect((Rational(numerator: .max, denominator: .max) > Rational(numerator: .max - 1, denominator: .max - 1))  == false)
			#expect((Rational(numerator: .max, denominator: .max - 1) > Rational(numerator: .max, denominator: .max))  == true)
			#expect((Rational(numerator: Int.max, denominator: .max) > Rational(numerator: .max, denominator: .max))  == false)
			#expect((Rational(numerator: .max, denominator: .max) > Rational(numerator: .max, denominator: .max - 1))  == false)
			#expect((Rational(numerator: .max - 1, denominator: .max - 1) > Rational(numerator: .max, denominator: .max))  == false)
			#expect((Rational(numerator: .max - 1, denominator: .max) > Rational(numerator: .max, denominator: .max))  == false)
			#expect((Rational(numerator: .max - 1, denominator: .max) > Rational(numerator: .max, denominator: .max - 1))  == false)
		}

		@Test func `>=(lhs: Self, rhs: Self)`() async throws {
			#expect((Rational<BigInt>(numerator: -5, denominator: 3) >= Rational(numerator: -4, denominator: 5))  == false)
			#expect((Rational<BigInt>(numerator: -5, denominator: 3) >= Rational(numerator: -4, denominator: 3))  == false)
			#expect((Rational<BigInt>(numerator: -9, denominator: 4) >= Rational(numerator: -4, denominator: 3))  == false)
			#expect((Rational<BigInt>(numerator: -9, denominator: 2) >= Rational(numerator: -9, denominator: 3))  == false)
			#expect((Rational<BigInt>(numerator: -9, denominator: 2) >= Rational(numerator: -9, denominator: 2))  == true)
			#expect((Rational<BigInt>(numerator: -9, denominator: 5) >= Rational(numerator: -9, denominator: 2))  == true)
			#expect((Rational<BigInt>(numerator: -3, denominator: 3) >= Rational(numerator: -4, denominator: 5))  == false)
			#expect((Rational<BigInt>(numerator: -3, denominator: 3) >= Rational(numerator: -4, denominator: 3))  == true)
			#expect((Rational<BigInt>(numerator: -3, denominator: 4) >= Rational(numerator: -4, denominator: 3))  == true)

			#expect((Rational<BigInt>(numerator: -5, denominator: 3) >= Rational(numerator: 0, denominator: 5))  == false)
			#expect((Rational<BigInt>(numerator: -5, denominator: 3) >= Rational(numerator: 0, denominator: 3))  == false)
			#expect((Rational<BigInt>(numerator: -9, denominator: 4) >= Rational(numerator: 0, denominator: 3))  == false)

			#expect((Rational<BigInt>(numerator: -5, denominator: 3) >= Rational(numerator: 4, denominator: 5))  == false)
			#expect((Rational<BigInt>(numerator: -5, denominator: 3) >= Rational(numerator: 4, denominator: 3))  == false)
			#expect((Rational<BigInt>(numerator: -9, denominator: 4) >= Rational(numerator: 4, denominator: 3))  == false)

			#expect((Rational<BigInt>(numerator: 0, denominator: 3) >= Rational(numerator: -4, denominator: 5))  == true)
			#expect((Rational<BigInt>(numerator: 0, denominator: 3) >= Rational(numerator: -4, denominator: 3))  == true)
			#expect((Rational<BigInt>(numerator: 0, denominator: 4) >= Rational(numerator: -4, denominator: 3))  == true)

			#expect((Rational<BigInt>(numerator: 0, denominator: 2) >= Rational(numerator: 0, denominator: 3))  == true)
			#expect((Rational<BigInt>(numerator: 0, denominator: 2) >= Rational(numerator: 0, denominator: 2))  == true)
			#expect((Rational<BigInt>(numerator: 0, denominator: 5) >= Rational(numerator: 0, denominator: 2))  == true)

			#expect((Rational<BigInt>(numerator: 0, denominator: 3) >= Rational(numerator: 4, denominator: 5))  == false)
			#expect((Rational<BigInt>(numerator: 0, denominator: 3) >= Rational(numerator: 4, denominator: 3))  == false)
			#expect((Rational<BigInt>(numerator: 0, denominator: 4) >= Rational(numerator: 4, denominator: 3))  == false)

			#expect((Rational<BigInt>(numerator: 3, denominator: 3) >= Rational(numerator: -4, denominator: 5))  == true)
			#expect((Rational<BigInt>(numerator: 3, denominator: 3) >= Rational(numerator: -4, denominator: 3))  == true)
			#expect((Rational<BigInt>(numerator: 3, denominator: 4) >= Rational(numerator: -4, denominator: 3))  == true)

			#expect((Rational<BigInt>(numerator: 3, denominator: 3) >= Rational(numerator: 0, denominator: 5))  == true)
			#expect((Rational<BigInt>(numerator: 3, denominator: 3) >= Rational(numerator: 0, denominator: 3))  == true)
			#expect((Rational<BigInt>(numerator: 3, denominator: 4) >= Rational(numerator: 0, denominator: 3))  == true)

			#expect((Rational<BigInt>(numerator: 5, denominator: 3) >= Rational(numerator: 4, denominator: 5))  == true)
			#expect((Rational<BigInt>(numerator: 5, denominator: 3) >= Rational(numerator: 4, denominator: 3))  == true)
			#expect((Rational<BigInt>(numerator: 9, denominator: 4) >= Rational(numerator: 4, denominator: 3))  == true)
			#expect((Rational<BigInt>(numerator: 9, denominator: 2) >= Rational(numerator: 9, denominator: 3))  == true)
			#expect((Rational<BigInt>(numerator: 9, denominator: 2) >= Rational(numerator: 9, denominator: 2))  == true)
			#expect((Rational<BigInt>(numerator: 9, denominator: 5) >= Rational(numerator: 9, denominator: 2))  == false)
			#expect((Rational<BigInt>(numerator: 3, denominator: 3) >= Rational(numerator: 4, denominator: 5))  == true)
			#expect((Rational<BigInt>(numerator: 3, denominator: 3) >= Rational(numerator: 4, denominator: 3))  == false)
			#expect((Rational<BigInt>(numerator: 3, denominator: 4) >= Rational(numerator: 4, denominator: 3))  == false)

			#if DEBUG
				await #expect(processExitsWith: .failure) {
					`>= ForceBinaryInteger`(Rational(numerator: -5, denominator: 3), Rational(numerator: -4, denominator: 5))
				}
			#endif
		}

		@Test func `>=(lhs: Self, rhs: Self) where TermType: FixedWidthInteger`() async throws {
			#expect((Rational(numerator: -5, denominator: 3) >= Rational(numerator: -4, denominator: 5))  == false)
			#expect((Rational(numerator: -5, denominator: 3) >= Rational(numerator: -4, denominator: 3))  == false)
			#expect((Rational(numerator: -9, denominator: 4) >= Rational(numerator: -4, denominator: 3))  == false)
			#expect((Rational(numerator: -9, denominator: 2) >= Rational(numerator: -9, denominator: 3))  == false)
			#expect((Rational(numerator: -9, denominator: 2) >= Rational(numerator: -9, denominator: 2))  == true)
			#expect((Rational(numerator: -9, denominator: 5) >= Rational(numerator: -9, denominator: 2))  == true)
			#expect((Rational(numerator: -3, denominator: 3) >= Rational(numerator: -4, denominator: 5))  == false)
			#expect((Rational(numerator: -3, denominator: 3) >= Rational(numerator: -4, denominator: 3))  == true)
			#expect((Rational(numerator: -3, denominator: 4) >= Rational(numerator: -4, denominator: 3))  == true)

			#expect((Rational(numerator: -5, denominator: 3) >= Rational(numerator: 0, denominator: 5))  == false)
			#expect((Rational(numerator: -5, denominator: 3) >= Rational(numerator: 0, denominator: 3))  == false)
			#expect((Rational(numerator: -9, denominator: 4) >= Rational(numerator: 0, denominator: 3))  == false)

			#expect((Rational(numerator: -5, denominator: 3) >= Rational(numerator: 4, denominator: 5))  == false)
			#expect((Rational(numerator: -5, denominator: 3) >= Rational(numerator: 4, denominator: 3))  == false)
			#expect((Rational(numerator: -9, denominator: 4) >= Rational(numerator: 4, denominator: 3))  == false)

			#expect((Rational(numerator: 0, denominator: 3) >= Rational(numerator: -4, denominator: 5))  == true)
			#expect((Rational(numerator: 0, denominator: 3) >= Rational(numerator: -4, denominator: 3))  == true)
			#expect((Rational(numerator: 0, denominator: 4) >= Rational(numerator: -4, denominator: 3))  == true)

			#expect((Rational(numerator: 0, denominator: 2) >= Rational(numerator: 0, denominator: 3))  == true)
			#expect((Rational(numerator: 0, denominator: 2) >= Rational(numerator: 0, denominator: 2))  == true)
			#expect((Rational(numerator: 0, denominator: 5) >= Rational(numerator: 0, denominator: 2))  == true)

			#expect((Rational(numerator: 0, denominator: 3) >= Rational(numerator: 4, denominator: 5))  == false)
			#expect((Rational(numerator: 0, denominator: 3) >= Rational(numerator: 4, denominator: 3))  == false)
			#expect((Rational(numerator: 0, denominator: 4) >= Rational(numerator: 4, denominator: 3))  == false)

			#expect((Rational(numerator: 3, denominator: 3) >= Rational(numerator: -4, denominator: 5))  == true)
			#expect((Rational(numerator: 3, denominator: 3) >= Rational(numerator: -4, denominator: 3))  == true)
			#expect((Rational(numerator: 3, denominator: 4) >= Rational(numerator: -4, denominator: 3))  == true)

			#expect((Rational(numerator: 3, denominator: 3) >= Rational(numerator: 0, denominator: 5))  == true)
			#expect((Rational(numerator: 3, denominator: 3) >= Rational(numerator: 0, denominator: 3))  == true)
			#expect((Rational(numerator: 3, denominator: 4) >= Rational(numerator: 0, denominator: 3))  == true)

			#expect((Rational(numerator: 5, denominator: 3) >= Rational(numerator: 4, denominator: 5))  == true)
			#expect((Rational(numerator: 5, denominator: 3) >= Rational(numerator: 4, denominator: 3))  == true)
			#expect((Rational(numerator: 9, denominator: 4) >= Rational(numerator: 4, denominator: 3))  == true)
			#expect((Rational(numerator: 9, denominator: 2) >= Rational(numerator: 9, denominator: 3))  == true)
			#expect((Rational(numerator: 9, denominator: 2) >= Rational(numerator: 9, denominator: 2))  == true)
			#expect((Rational(numerator: 9, denominator: 5) >= Rational(numerator: 9, denominator: 2))  == false)
			#expect((Rational(numerator: 3, denominator: 3) >= Rational(numerator: 4, denominator: 5))  == true)
			#expect((Rational(numerator: 3, denominator: 3) >= Rational(numerator: 4, denominator: 3))  == false)
			#expect((Rational(numerator: 3, denominator: 4) >= Rational(numerator: 4, denominator: 3))  == false)

			#expect((Rational(numerator: .min, denominator: .max - 1) >= Rational(numerator: .min + 1, denominator: .max))  == false)
			#expect((Rational(numerator: .min, denominator: .max) >= Rational(numerator: .min + 1, denominator: .max))  == false)
			#expect((Rational(numerator: .min, denominator: .max) >= Rational(numerator: .min + 1, denominator: .max - 1))  == true)
			#expect((Rational(numerator: .min, denominator: .max - 1) >= Rational(numerator: .min, denominator: .max))  == false)
			#expect((Rational(numerator: Int.min, denominator: .max) >= Rational(numerator: .min, denominator: .max))  == true)
			#expect((Rational(numerator: .min, denominator: .max) >= Rational(numerator: .min, denominator: .max - 1))  == true)
			#expect((Rational(numerator: .min + 1, denominator: .max - 1) >= Rational(numerator: .min, denominator: .max))  == false)
			#expect((Rational(numerator: .min + 1, denominator: .max) >= Rational(numerator: .min, denominator: .max))  == true)
			#expect((Rational(numerator: .min + 1, denominator: .max) >= Rational(numerator: .min, denominator: .max - 1))  == true)

			#expect((Rational(numerator: .min, denominator: .max - 1) >= Rational(numerator: 0, denominator: .max))  == false)
			#expect((Rational(numerator: .min, denominator: .max) >= Rational(numerator: 0, denominator: .max))  == false)
			#expect((Rational(numerator: .min, denominator: .max) >= Rational(numerator: 0, denominator: .max - 1))  == false)

			#expect((Rational(numerator: .min, denominator: .max - 1) >= Rational(numerator: .max, denominator: .max))  == false)
			#expect((Rational(numerator: Int.min, denominator: .max) >= Rational(numerator: .max, denominator: .max))  == false)
			#expect((Rational(numerator: .min, denominator: .max) >= Rational(numerator: .max, denominator: .max - 1))  == false)

			#expect((Rational(numerator: 0, denominator: .max - 1) >= Rational(numerator: .min, denominator: .max))  == true)
			#expect((Rational(numerator: 0, denominator: .max) >= Rational(numerator: .min, denominator: .max))  == true)
			#expect((Rational(numerator: 0, denominator: .max) >= Rational(numerator: .min, denominator: .max - 1))  == true)

			#expect((Rational(numerator: 0, denominator: .max - 1) >= Rational(numerator: 0, denominator: .max))  == true)
			#expect((Rational(numerator: 0, denominator: .max) >= Rational(numerator: 0, denominator: .max))  == true)
			#expect((Rational(numerator: 0, denominator: .max) >= Rational(numerator: 0, denominator: .max - 1))  == true)

			#expect((Rational(numerator: 0, denominator: .max - 1) >= Rational(numerator: .max, denominator: .max))  == false)
			#expect((Rational(numerator: 0, denominator: .max) >= Rational(numerator: .max, denominator: .max))  == false)
			#expect((Rational(numerator: 0, denominator: .max) >= Rational(numerator: .max, denominator: .max - 1))  == false)

			#expect((Rational(numerator: .max, denominator: .max - 1) >= Rational(numerator: .min, denominator: .max))  == true)
			#expect((Rational(numerator: Int.max, denominator: .max) >= Rational(numerator: .min, denominator: .max))  == true)
			#expect((Rational(numerator: .max, denominator: .max) >= Rational(numerator: .min, denominator: .max - 1))  == true)

			#expect((Rational(numerator: .max, denominator: .max - 1) >= Rational(numerator: 0, denominator: .max))  == true)
			#expect((Rational(numerator: .max, denominator: .max) >= Rational(numerator: 0, denominator: .max))  == true)
			#expect((Rational(numerator: .max, denominator: .max) >= Rational(numerator: 0, denominator: .max - 1))  == true)

			#expect((Rational(numerator: .max, denominator: .max - 1) >= Rational(numerator: .max - 1, denominator: .max))  == true)
			#expect((Rational(numerator: .max, denominator: .max) >= Rational(numerator: .max - 1, denominator: .max))  == true)
			#expect((Rational(numerator: .max, denominator: .max) >= Rational(numerator: .max - 1, denominator: .max - 1))  == true)
			#expect((Rational(numerator: .max, denominator: .max - 1) >= Rational(numerator: .max, denominator: .max))  == true)
			#expect((Rational(numerator: Int.max, denominator: .max) >= Rational(numerator: .max, denominator: .max))  == true)
			#expect((Rational(numerator: .max, denominator: .max) >= Rational(numerator: .max, denominator: .max - 1))  == false)
			#expect((Rational(numerator: .max - 1, denominator: .max - 1) >= Rational(numerator: .max, denominator: .max))  == true)
			#expect((Rational(numerator: .max - 1, denominator: .max) >= Rational(numerator: .max, denominator: .max))  == false)
			#expect((Rational(numerator: .max - 1, denominator: .max) >= Rational(numerator: .max, denominator: .max - 1))  == false)
		}
	}

	struct `Rational: Hashable` {
		@Test func hash() async throws {
			#expect(Rational(numerator: 3, denominator: 7).hashValue == Rational(numerator: 6, denominator: 14).hashValue)
			#expect(Rational(numerator: 21, denominator: 7).hashValue == Rational(3).hashValue)
			#expect(Rational(numerator: 21, denominator: 8).hashValue != Rational(3).hashValue)

			let bigIntCommonFactor = BigInt("457425209663695646359203630886756382027")
			let bigIntPrime1 = BigInt("340282366920938463463374607431768211507")
			let bigInt1 = bigIntPrime1 * bigIntCommonFactor
			let bigIntPrime2 = BigInt("391658961466960540800131805247996205641")
			let bigInt2 = bigIntPrime2 * bigIntCommonFactor

			#expect(Rational(numerator: bigInt1, denominator: bigInt2).hashValue == Rational(numerator: bigIntPrime1, denominator: bigIntPrime2).hashValue)
		}
	}

	struct `Rational: Numeric` {
		@Test func `init(exactly:)`() async throws {
			#expect(Rational(exactly: 64) == Rational(64))
			#expect(Rational(exactly: BigInt(64)) == Rational(64))
			#expect(Rational<Int>(exactly: BigInt("340282366920938463463374607431768211507")) == nil)
		}

		@Test func `var zero`() async throws {
			#expect(Rational<Int>.zero == Rational(0))
			#expect(Rational<BigInt>.zero == Rational(0))
		}

		@Test func `var magnitude`() {
			#expect(Rational(numerator: 6, denominator: 5).magnitude == Rational(numerator: -6, denominator: 5).magnitude)
			#expect(Rational(numerator: BigInt("340282366920938463463374607431768211507"), denominator: 5).magnitude == Rational(numerator: BigInt("-340282366920938463463374607431768211507"), denominator: 5).magnitude)
		}

		@Test func `func +(lhs: Self, rhs: Self)`() async throws {
			#expect((Rational<BigInt>(numerator: 1, denominator: 8) + Rational(numerator: 1, denominator: 8)) == Rational(numerator: 1, denominator: 4))
			#expect((Rational<BigInt>(numerator: 1, denominator: 8) + Rational(numerator: 1, denominator: 6)) == Rational(numerator: 7, denominator: 24))
			#expect((Rational<BigInt>(numerator: 1, denominator: 2) + Rational(numerator: -2, denominator: 3)) == Rational(numerator: -1, denominator: 6))
			#expect((Rational<BigInt>(numerator: -2, denominator: 7) + Rational(numerator: -1, denominator: 3)) == Rational(numerator: -13, denominator: 21))
			#expect((Rational<BigInt>(numerator: -3, denominator: 5) + Rational(numerator: 5, denominator: 7)) == Rational(numerator: 4, denominator: 35))
			#expect((Rational<BigInt>(numerator: BigInt(Int.max) / 4, denominator: 8) + Rational(numerator: BigInt(Int.max) / 4, denominator: 4)) == Rational(numerator: 6917529027641081853, denominator: 8))

			#if DEBUG
				await #expect(processExitsWith: .failure) {
					`+(Self, Self) ForceBinaryInteger`(Rational(numerator: -5, denominator: 3), Rational(numerator: -4, denominator: 5))
				}
			#endif
		}

		@Test func `func +(lhs: Self, rhs: Self) throws(RationalOverflowError<TermType>)`() async throws {
			let error1 = try #require(throws: RationalOverflowError<Int8>.self) {
				try Rational<Int8>(.min) + Rational(-1)
			}
			#expect((Int(error1.highBit ? -1 : 0) << 16 | Int(error1.mid) << 8 | Int(error1.low)) == (Int(Int8.min) + -1))
			let error2 = try #require(throws: RationalOverflowError<Int8>.self) {
				try Rational<Int8>(.max) + Rational(1)
			}
			#expect((Int(error2.highBit ? -1 : 0) << 16 | Int(error2.mid) << 8 | Int(error2.low)) == (Int(Int8.max) + 1))
			let error3 = try #require(throws: RationalOverflowError<UInt8>.self) {
				try Rational<UInt8>(.max) + Rational(1)
			}
			#expect((Int(error3.highBit ? -1 : 0) << 16 | Int(error3.mid) << 8 | Int(error3.low)) == (Int(UInt8.max) + 1))


		}

		@Test func `func +(lhs: TermType, rhs: Self)`() async throws {
			#expect((0 + Rational<BigInt>(numerator: 3, denominator: 4)) == Rational(numerator: 3, denominator: 4))
			#expect((5 + Rational<BigInt>(numerator: 3, denominator: 4)) == Rational(numerator: 23, denominator: 4))

			#if DEBUG
				await #expect(processExitsWith: .failure) {
					`+(TermType, Self) ForceBinaryInteger`(5, Rational(numerator: -4, denominator: 5))
				}
			#endif
		}

		@Test func `func +(lhs: Self, rhs: TermType)`() async throws {
			#expect((Rational<BigInt>(numerator: 3, denominator: 4) + 0) == Rational(numerator: 3, denominator: 4))
			#expect((Rational<BigInt>(numerator: 3, denominator: 4) + 5) == Rational(numerator: 23, denominator: 4))

			#if DEBUG
				await #expect(processExitsWith: .failure) {
					`+(Self, TermType) ForceBinaryInteger`(Rational(numerator: -5, denominator: 3), 5)
				}
			#endif
		}
	}
}

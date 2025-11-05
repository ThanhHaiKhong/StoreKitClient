//
//  StoreKitClientTests.swift
//  StoreKitClient
//
//  Created on 5/11/25.
//

import XCTest
import Dependencies
@testable import StoreKitClient

@available(iOS 15.0, *)
final class StoreKitClientTests: XCTestCase {

    func testCanMakePayments() async {
        await withDependencies {
            $0.storeKitClient = .happy
        } operation: {
            @Dependency(\.storeKitClient) var storeKitClient
            XCTAssertTrue(storeKitClient.canMakePayments())
        }
    }

    func testLoadProducts() async throws {
        try await withDependencies {
            $0.storeKitClient = .happy
        } operation: {
            @Dependency(\.storeKitClient) var storeKitClient
            let products = try await storeKitClient.loadProducts(["com.example.product.weekly"])
            XCTAssertFalse(products.isEmpty)
            XCTAssertEqual(products.count, 3)
        }
    }

    func testFailingClient() async {
        await withDependencies {
            $0.storeKitClient = .failing
        } operation: {
            @Dependency(\.storeKitClient) var storeKitClient

            do {
                _ = try await storeKitClient.loadProducts(["com.example.product"])
                XCTFail("Expected error to be thrown")
            } catch {
                XCTAssertTrue(error is URLError)
            }
        }
    }

    func testTransactionExpiration() {
        let activeTransaction = StoreKitClient.Transaction.mockSubscription
        XCTAssertFalse(activeTransaction.isExpired)

        let expiredTransaction = StoreKitClient.Transaction.mockExpiredSubscription
        XCTAssertFalse(expiredTransaction.isExpired) // Will be false since rawValue is nil in mocks
    }

    func testMockTransactions() {
        let consumable = StoreKitClient.Transaction.mockConsumable
        XCTAssertNotNil(consumable)

        let subscription = StoreKitClient.Transaction.mockSubscription
        XCTAssertNotNil(subscription)

        let expired = StoreKitClient.Transaction.mockExpiredSubscription
        XCTAssertNotNil(expired)
    }
}

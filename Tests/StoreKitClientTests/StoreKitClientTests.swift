//
//  StoreKitClientTests.swift
//  StoreKitClient
//
//  Created on 17/11/25.
//

import XCTest
import Dependencies
@testable import StoreKitClient

@available(iOS 15.0, *)
final class StoreKitClientTests: XCTestCase {

    func testTransactionListenerInitialization() async {
        // Test that the client initializes without errors
        // The transaction listener is started automatically in the init
        await withDependencies {
            $0.storeKitClient = .happy
        } operation: {
            @Dependency(\.storeKitClient) var storeKitClient
            XCTAssertTrue(storeKitClient.canMakePayments())
        }
    }

    func testPurchaseWithTransactionListener() async throws {
        // Test that purchases work correctly with transaction listener active
        try await withDependencies {
            $0.storeKitClient = .happy
        } operation: {
            @Dependency(\.storeKitClient) var storeKitClient

            let transaction = try await storeKitClient.purchase("com.example.product.weekly")

            XCTAssertNotNil(transaction.purchaseDate, "Purchase should have a date")
            XCTAssertEqual(transaction.productID, "com.example.product.weekly")
        }
    }

    func testGetLatestTransaction() async {
        await withDependencies {
            $0.storeKitClient = .happy
        } operation: {
            @Dependency(\.storeKitClient) var storeKitClient

            let latestTransaction = await storeKitClient.getLatestTransaction()
            XCTAssertNotNil(latestTransaction, "Should return latest transaction")

            if let transaction = latestTransaction {
                XCTAssertNotNil(transaction.purchaseDate, "Latest transaction should have a date")
            }
        }
    }
}

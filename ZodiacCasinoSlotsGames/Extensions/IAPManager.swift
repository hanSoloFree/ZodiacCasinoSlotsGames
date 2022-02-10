//
//  IAPManager.swift
//  SlotDemo
//
//  Created by Vsevolod Shelaiev on 23.08.2021.
//

import UIKit
import StoreKit

class IAPManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    static let shared = IAPManager()
    
    private var products = [SKProduct]()
    
    private var completion: ((Int) -> Void)?
    
    private var productBeingPurchased: SKProduct?
    
    enum Product: String, CaseIterable {
        case buy100Coins = "com.vladimir.svarovski.zodiac.slots.buy300000000"
        case buy500Coins = "com.vladimir.svarovski.zodiac.slots.buy90000000"
        case buy1000Coins = "com.vladimir.svarovski.zodiac.slots.buy330000000"
        case buy10000Coins = "com.vladimir.svarovski.zodiac.slots.buy960000000"
        case buy100000Coins =
                "com.vladimir.svarovski.zodiac.slots.buy2700000000"
        var count: Int {
            switch self {
            case .buy100Coins:
                return 30_000_000
            case .buy500Coins:
                return 90_000_000
            case .buy1000Coins:
                return 330_000_000
            case .buy10000Coins:
                return 960_000_000
            case .buy100000Coins:
                return 2_700_000_000
            }
        }
}
    
    
    public func fetchProducts() {
        let request = SKProductsRequest(productIdentifiers: Set(Product.allCases.compactMap({ $0.rawValue })))
        request.delegate = self
        request.start()
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach { (transaction) in
            switch transaction.transactionState {
            case .purchasing:
                break
            case .purchased:
                if let product = Product(rawValue: transaction.payment.productIdentifier) {
                    completion?(product.count)
                }
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
            case .failed:
                break
            case .restored:
                break
            case .deferred:
                break
            @unknown default:
                break
            }
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
    }
    
    func requestDidFinish(_ request: SKRequest) {
        guard request is SKProductsRequest else {
            request.start()
            return
        }
        print("Product fetch request failed")
    }
    
    func purchase(product: Product,completion: @escaping((Int) -> Void)) {
        guard SKPaymentQueue.canMakePayments() else {
            return
        }
        productBeingPurchased = products.first(where: { $0.productIdentifier == product.rawValue})
        if let productpurchased = productBeingPurchased {
            self.completion = completion
            let payment = SKPayment(product: productpurchased)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
        }
        
      
    }
    
}

//
//  ShopViewController.swift
//  JackotCity
//
//  Created by Vsevolod Shelaiev on 21.12.2021.
//

import UIKit

class ShopViewController: BaseVC {

    enum Product: String, CaseIterable {
        case buy100Coins = "com.vladimir.svarovski.zodiac.slots.buy300000000"
        case buy500Coins = "com.vladimir.svarovski.zodiac.slots.buy90000000"
        case buy1000Coins = "com.vladimir.svarovski.zodiac.slots.buy330000000"
        case buy10000Coins = "com.vladimir.svarovski.zodiac.slots.buy960000000"
        case buy100000Coins = "com.vladimir.svarovski.zodiac.slots.buy2700000000"
    }
    
//    @IBOutlet weak var centralView: UIView!
    
    @IBAction func buy100Coins(_ sender: Any) {
        IAPManager.shared.purchase(product: .buy100Coins, completion: { [weak self] count in
            DispatchQueue.main.async {
                self?.addCoins(count: count)
            }
        })
    }
    
    @IBAction func buy500Coins(_ sender: Any) {
        IAPManager.shared.purchase(product: .buy500Coins, completion: { [weak self] count in
            DispatchQueue.main.async {
                self?.addCoins(count: count)
            }
        })
    }
    
    
    @IBAction func buy1000Coins(_ sender: Any) {
        IAPManager.shared.purchase(product: .buy1000Coins, completion: { [weak self] count in
            DispatchQueue.main.async {
                self?.addCoins(count: count)
            }
        })
    }
    
    
    @IBAction func buy10000Coins(_ sender: Any) {
        IAPManager.shared.purchase(product: .buy10000Coins, completion: { [weak self] count in
            DispatchQueue.main.async {
                self?.addCoins(count: count)
            }
        })
    }
    
    @IBAction func buy100000Coins(_ sender: Any) {
        IAPManager.shared.purchase(product: .buy10000Coins, completion: { [weak self] count in
            DispatchQueue.main.async {
                self?.addCoins(count: count)
            }
        })
    }
    
    
    @IBAction func backToMenu(_ sender: Any) {
        self.navigationController!.popViewController(animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        centralView.layer.cornerRadius = 12
    }
    
    private func addCoins(count: Int) {
        let currentCount = Level.shared.coinsPool
        let newCount = currentCount + count
        Level.shared.coinsPool = newCount
    }

}

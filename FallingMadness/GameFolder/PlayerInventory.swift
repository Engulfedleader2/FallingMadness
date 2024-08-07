//
//  PlayerInventory.swift
//  FallingMadness
//
//  Created by Israel on 8/6/24.
//

import Foundation
import Combine

class PlayerInventory: ObservableObject{
    static let shared = PlayerInventory()
    
    @Published var currency: Int = 1000
    @Published var purchasedItems: [StoreItem] = []
    @Published var equippedItem: StoreItem?
    
    private init(){}
    
    func purchase(item: StoreItem) {
        if currency >= item.price && !purchasedItems.contains(where: { $0.id == item.id }) {
            currency -= item.price
            purchasedItems.append(item)
        }
    }
    
    func equip(item: StoreItem) {
        if purchasedItems.contains(where: { $0.id == item.id }) {
            equippedItem = item
        }
    }
}

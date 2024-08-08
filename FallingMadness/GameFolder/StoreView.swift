//
//  StoreView.swift
//  FallingMadness
//
//  Created by Israel on 8/6/24.
//

import SwiftUI

struct StoreItem: Identifiable{
    let id = UUID()
    let name: String
    let price: Int
    let imageName: String
}

struct StoreView: View {
    
    @ObservedObject var inventory = PlayerInventory.shared
    @Environment(\.presentationMode) var presentationMode
   // @State private var playerCurrency = 1000  // Example in-game currency amount
    let storeItems = [
        StoreItem(name: "Gerome Boy", price: 100, imageName: "Gerome_Sprite"),
        StoreItem(name: "Jasper", price: 200, imageName: "Jasper_Bird"),
        StoreItem(name: "Character 3", price: 300, imageName: "character3"),
        StoreItem(name: "Character 4", price: 400, imageName: "character4")
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Store")
                    .font(.largeTitle)
                    .padding()
                
                Text("Currency: \(inventory.currency)")
                    .font(.title)
                    .padding(.bottom, 20)
                
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 20) {
                        ForEach(storeItems) { item in
                            VStack {
                                Image(item.imageName)
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .padding(.bottom, 10)
                                Text(item.name)
                                Text("\(item.price) coins")
                                
                                Button(action: {
                                    handleAction(for: item)
                                }) {
                                    Text(buttonTitle(for: item))
                                        .padding()
                                        .background(buttonColor(for: item))
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                                .disabled(!buttonEnabled(for: item))
                            }
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(15)
                        }
                    }
                    .padding()
                }
                .navigationBarItems(leading: Button("Close") {
                    closeView()
                })
            }
        }
    }
    
    
    private func handleAction(for item: StoreItem){
        if inventory.purchasedItems.contains(where: {$0.id == item.id}){
            inventory.equip(item: item)
        } else {
            inventory.purchase(item: item)
        }
    }

    private func buttonTitle(for item: StoreItem) -> String {
        if inventory.equippedItem?.id == item.id {
            return "Equipped"
        } else if inventory.purchasedItems.contains(where: { $0.id == item.id }) {
            return "Equip"
        } else {
            return "Buy"
        }
    }
    
    private func buttonColor(for item: StoreItem) -> Color {
        if inventory.equippedItem?.id == item.id {
            return Color.green
        } else if inventory.purchasedItems.contains(where: { $0.id == item.id }) {
            return Color.blue
        } else {
            return Color.blue
        }
    }
    
    private func buttonEnabled(for item: StoreItem) -> Bool {
        return inventory.currency >= item.price && !(inventory.equippedItem?.id == item.id)
    }
    
    
    private func closeView() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct StoreView_Previews: PreviewProvider {
    static var previews: some View {
        StoreView()
    }
}

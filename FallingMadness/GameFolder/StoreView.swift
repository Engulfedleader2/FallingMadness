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
    @State private var playerCurrency = 1000  // Example in-game currency amount
    let storeItems = [
        StoreItem(name: "Gerome Boy", price: 100, imageName: "Gerome_Sprite"),
        StoreItem(name: "Character 2", price: 200, imageName: "character2"),
        StoreItem(name: "Character 3", price: 300, imageName: "character3"),
        StoreItem(name: "Character 4", price: 400, imageName: "character4")
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Store")
                    .font(.largeTitle)
                    .padding()
                
                Text("Currency: \(playerCurrency)")
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
                                    purchase(item: item)
                                }) {
                                    Text("Buy")
                                        .padding()
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                                .disabled(playerCurrency < item.price)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(15)
                        }
                    }
                    .padding()
                }
                .navigationBarItems(leading: Button("Close") {
                    // Dismiss action
                    closeView()
                })
            }
        }
    }
    
    private func purchase(item: StoreItem) {
        // Handle purchase logic
        if playerCurrency >= item.price {
            playerCurrency -= item.price
            print("Purchased: \(item.name)")
        } else {
            print("Not enough currency")
        }
    }
    
    private func closeView() {
        // Add logic to dismiss the view
    }
}

struct StoreView_Previews: PreviewProvider {
    static var previews: some View {
        StoreView()
    }
}

//
//  ContentView.swift
//  FormValidationStarter
//
//  Created by 羅壽之 on 2024/12/16.
//

import SwiftUI


struct PurchasedItem: Identifiable {
    let id = UUID()
    let imageName: String
    let quantity: Int
    let price: Double
}

let storeImage = ["shoe1", "shoe2","shoe3","shoe4","shoe5","shoe6"]
let gridLayout = [GridItem(.flexible()), GridItem(.flexible())]

struct ContentView: View {
    @State private var purchasedItems: [PurchasedItem] = []
    var body: some View {
        TabView() {
            HomePage(purchasedItems: $purchasedItems)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            ShopPage(purchasedItems: purchasedItems)
                .tabItem {
                    Image(systemName: "cart.fill")
                    Text("Store")
                }
            CustomPage()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Custom")
                }
        }
    }
}

struct HomePage: View {
    @Binding var purchasedItems: [PurchasedItem]
    @State private var selectedImage: String = ""
    @State private var showShopSheet: Bool = false
    var body: some View {
        VStack(spacing:180){
            Banner()
              .frame(height:50)
            ScrollView(.horizontal) {
                LazyVGrid(columns:gridLayout){
                    ForEach(storeImage, id:\.self){ image in
                        Image(image)
                            .resizable()
                            .frame(minWidth:0,maxWidth:.infinity,maxHeight:150)
                            .clipped()
                            .onTapGesture {
                                selectedImage = image
                                showShopSheet = true
                            }
                    }
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            .sheet(isPresented: $showShopSheet){
                PurchaseDetailSheet(imageName: $selectedImage, showShopSheet: $showShopSheet, purchasedItems: $purchasedItems)
            }
          }
        }
     }

struct PurchaseDetailSheet: View {
    @Binding var imageName: String
    @Binding var showShopSheet: Bool
    @State private var quantity: Int = 1
    @Binding var purchasedItems: [PurchasedItem]
    private let pricePerItem: Double = 50.0
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Debug: \(imageName)")
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 200)

            Text("Product: \(imageName)")
                .font(.headline)
            HStack {
                Text("Quantity:")
                    .font(.subheadline)

                Stepper(value: $quantity, in: 1...99) {
                    Text("\(quantity)")
                        .font(.headline)
                }
                .frame(width: 150)
            }
            .padding()
            Button(action: {
                let newItem = PurchasedItem(imageName: imageName, quantity: quantity, price: Double(quantity) * pricePerItem)
                showShopSheet = false
                purchasedItems.append(newItem)
            }) {
                Text("Buy Now")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()

            Spacer()
        }
        .padding()
    }
}

struct Banner: View {
  let bannerImages = ["ad1", "ad2", "ad3","ad4"]
  @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(bannerImages.indices, id: \.self) { index in
                Image(bannerImages[index])
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: 400)
                    .clipped()
                    .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .onAppear {
            AutoPlay()
        }
    }

    private func AutoPlay() {
        guard !bannerImages.isEmpty else { return }
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            withAnimation {
                selectedTab = (selectedTab + 1) % bannerImages.count
            }
        }
    }
}




struct ShopPage: View {
    var purchasedItems: [PurchasedItem]
    
    var body: some View {
        if purchasedItems.isEmpty {
            Text("No items purchased yet")
                .font(.headline)
                .foregroundColor(.gray)
                .padding()
        } else {
            List(purchasedItems) { item in
                HStack {
                    Image(item.imageName)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipped()
                    VStack(alignment: .leading) {
                        Text("Product: \(item.imageName)")
                            .font(.headline)
                        Text("Quantity: \(item.quantity)")
                            .font(.subheadline)
                        Text("Price: $\(String(format: "%.2f", item.price))")
                            .font(.subheadline)
                    }
                }
            }
            .navigationTitle("Shop")
        }
    }
}



struct CustomPage: View {
    @State var showSignIn = false
    @State var showSignUp = false
    
    var body: some View {
        VStack {
            Text("Welcome")
                .font(.title)
            Button {
                showSignIn.toggle()
            } label: {
                HStack {
                    Image(systemName: "person.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("Sign In")
                        .font(.headline)
                }
            }
            .buttonStyle(MyButtonStyle(bgColor: Color.blue))
            .frame(width:150)
            // Sign Up Button
            Button {
                showSignUp.toggle()
            } label: {
                HStack {
                    Image(systemName: "person.badge.plus.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("Sign Up")
                        .font(.headline)
                }
            }
            .buttonStyle(MyButtonStyle(bgColor: Color.green))
            .frame(width:150)
            .sheet(isPresented: $showSignUp) {
                SignUpView()
            }
            
            // Logout Button
            Button {
                // process logout
            } label: {
                HStack {
                    Image(systemName: "arrow.backward.circle.fill") // Icon
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("Logout") // Text
                        .font(.headline)
                }
            }
            .buttonStyle(MyButtonStyle(bgColor: Color.red))
            .frame(width:150)
            
            
        }
    }
}

struct MyButtonStyle: ButtonStyle {
    var bgColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(bgColor)
            .cornerRadius(10)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


//
//  ContentView.swift
//  FormValidationStarter
//
//

import SwiftUI

let storeImage = ["shoe1", "shoe2","shoe3","shoe4","shoe5","shoe6"]
let gridLayout = [GridItem(.flexible()), GridItem(.flexible())]
let PersonImage = ["skirt1", "skirt2","skirt3","skirt4","skirt5","skirt6"]


struct ContentView: View {
    @Environment(\.managedObjectContext) var viewContext
    
    @FetchRequest(sortDescriptors: [
        NSSortDescriptor(keyPath: \Shoe.name, ascending: true)
    ], animation: .default)
    private var shoes: FetchedResults<Shoe>

    var body: some View {
        TabView {
            HomePage(shoes: shoes)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            ShopPage(shoes: shoes)
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
    let shoes: FetchedResults<Shoe>
    @Environment(\.managedObjectContext) var viewContext
    @State private var selectedImage: String = ""
    @State private var showShopSheet: Bool = false

    var body: some View {
        VStack(spacing: 180) {
            Banner()
                .frame(height: 50)

            //中間UI
            FunctionButtonsView()
                .padding(.horizontal)

            ScrollView(.horizontal) {
                LazyVGrid(columns: gridLayout) {
                    ForEach(storeImage, id: \.self) { image in
                        Image(image)
                            .resizable()
                            .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 150)
                            .clipped()
                            .onTapGesture {
                                selectedImage = image
                                showShopSheet = true
                            }
                    }
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            .sheet(isPresented: $showShopSheet) {
                PurchaseDetailSheet(imageName: $selectedImage, showShopSheet: $showShopSheet)
            }
        }
    }
}


//中間UI
struct FunctionButtonsView: View {
    let buttons: [(icon: String, title: String)] = [
        ("sparkles", "好東西"),
        ("magnifyingglass", "搜索"),
        ("leaf.fill", "草"),
        ("calendar", "簽到")
    ]

    var body: some View {
        HStack(spacing: 20) {
            ForEach(buttons, id: \.title) { button in
                VStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.orange, Color.yellow]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60, height: 60)
                        .overlay(
                            Image(systemName: button.icon)
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 30, height: 30)
                        )

                    Text(button.title)
                        .font(.caption)
                        .foregroundColor(.black)
                }
            }
        }
    }
}

struct PurchaseDetailSheet: View {
    @Binding var imageName: String
    @Binding var showShopSheet: Bool
    @Environment(\.managedObjectContext) var viewContext
    @State private var quantity: Int = 1
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
                let totalPrice = Double(quantity) * pricePerItem
                let newShoe = Shoe(context: viewContext)
                newShoe.name = imageName
                newShoe.imageName = imageName
                newShoe.number = Int64(quantity)
                newShoe.price = Int64(totalPrice)
                PersistenceController.saveContext(viewContext: viewContext)
                showShopSheet = false
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
    @FetchRequest(sortDescriptors: [
        NSSortDescriptor(keyPath: \Shoe.name, ascending: true)
    ], animation: .default)
    private var shoes: FetchedResults<Shoe>
    @Environment(\.managedObjectContext) var viewContext

    var body: some View {
        if shoes.isEmpty {
            Text("No items purchased yet")
                .font(.headline)
                .foregroundColor(.gray)
                .padding()
        } else {
            List {
                ForEach(shoes) { shoe in
                    HStack {
                        Image(shoe.imageName ?? "placeholder")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipped()
                        VStack(alignment: .leading) {
                            Text("Product: \(shoe.name ?? "Unknown")")
                                .font(.headline)
                            Text("Quantity: \(shoe.number)")
                                .font(.subheadline)
                            Text("Price: $\(shoe.price)")
                                .font(.subheadline)
                        }
                    }
                }
                .onDelete { offsets in
                    offsets.map { shoes[$0] }.forEach { shoe in
                        viewContext.delete(shoe)
                    }
                    PersistenceController.saveContext(viewContext: viewContext)
                }
            }
        }
    }
}


struct ProfilePage: View {
    @State private var showCustomPage = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                HeaderView()

                MiddleButton()
            
                BottomTabView()
            }
            .padding()
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showCustomPage.toggle()
                    }) {
                        Image(systemName: "gearshape.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                    .sheet(isPresented: $showCustomPage) {
                        CustomPage()
                    }
                }
            }
        }
    }
}


struct HeaderView: View {
    var body: some View {
        ZStack {
            // 背景
            Image("cat_background")
                .resizable()
                .scaledToFill()
                .frame(height: 200)
                .clipped()

            VStack {
                // 頭像
                Image("user_avatar")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .shadow(radius: 5)

                //名稱
                Text("Wilber")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)

                // 簡介
                Text("衡量智力的標準是適應改變的能力")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))

                // 成就
                HStack(spacing: 30) {
                    AchievementView(title: "9999", subtitle: "成就")
                    AchievementView(title: "99899", subtitle: "精選")
                    AchievementView(title: "199899", subtitle: "打賞")
                }
                .padding(.top, 10)
            }
        }
    }
}

struct AchievementView: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            Text(subtitle)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
        }
    }
}


struct MiddleButton: View {
    let buttons: [(icon: String, title: String)] = [
        ("list.bullet.rectangle", "訂單"),
        ("person.2.fill", "好友"),
        ("creditcard.fill", "積分"),
        ("message.fill", "訊息")
    ]

    var body: some View {
        HStack(spacing: 20) {
            ForEach(buttons, id: \.title) { button in
                VStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.orange, Color.yellow]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60, height: 60)
                        .overlay(
                            Image(systemName: button.icon)
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 30, height: 30)
                        )
                    Text(button.title)
                        .font(.caption)
                        .foregroundColor(.black)
                }
            }
        }
    }
}

struct BottomTabView: View {
    @State private var selectedTab = 0
    @State private var selectedImage: String = ""
    @State private var showShopSheet: Bool = false
    let tabs = ["單品", "清單", "互動", "發布"]

    var body: some View {
        VStack {
            // Tab 選項卡
            HStack {
                ForEach(tabs.indices, id: \.self) { index in
                    Button(action: {
                        selectedTab = index
                    }) {
                        VStack {
                            Text(tabs[index])
                                .font(.headline)
                                .foregroundColor(selectedTab == index ? .red : .gray)
                            if selectedTab == index {
                                Rectangle()
                                    .fill(Color.red)
                                    .frame(height: 2)
                                    .padding(.horizontal)
                            } else {
                                Spacer().frame(height: 2)
                            }
                        }
                    }
                }
            }

            ScrollView(.horizontal) {
                LazyVGrid(columns: gridLayout) {
                    ForEach(PersonImage, id: \.self) { image in
                        Image(image)
                            .resizable()
                            .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 150)
                            .clipped()
                            .onTapGesture {
                                selectedImage = image
                                showShopSheet = true
                            }
                    }
                }
            }
            .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct CustomPage: View {
    @State var showSignIn = false
    @State var showSignUp = false

    var body: some View {
        ZStack {
            // 背景漸變
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.white]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                // 標題
                Text("Welcome")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.blue)
                    .padding(.top, 50)

                // 功能按鈕區域
                VStack(spacing: 20) {
                    ActionButton(
                        iconName: "person.fill",
                        title: "Sign In",
                        bgColor: Color.blue,
                        action: { showSignIn.toggle() }
                    )
                    .sheet(isPresented: $showSignIn) {
                        SignInView()
                    }

                    ActionButton(
                        iconName: "person.badge.plus.fill",
                        title: "Sign Up",
                        bgColor: Color.green,
                        action: { showSignUp.toggle() }
                    )
                    .sheet(isPresented: $showSignUp) {
                        SignUpView()
                    }

                    ActionButton(
                        iconName: "arrow.backward.circle.fill",
                        title: "Logout",
                        bgColor: Color.red,
                        action: {
                            print("Logged out")
                            // 處理登出邏輯
                        }
                    )
                }
                Spacer()
            }
        }
    }
}


struct ActionButton: View {
    let iconName: String
    let title: String
    let bgColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: iconName)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(bgColor)
            .cornerRadius(10)
            .shadow(color: bgColor.opacity(0.5), radius: 5, x: 0, y: 5)
        }
        .frame(width: 200)
    }
}

struct SignInView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    TextField("Enter email", text: $email)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                    RequiredText(text: "Legal email format", isStrikeThrough: emailValidate)

                    SecureField("Enter password", text: $password)
                    RequiredText(text: "At least 6 characters", isStrikeThrough: passwordLengthValidate)
                }
                

                Button {
                    if validateInputs() {
                        print("Login successful!")
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        showError = true
                    }
                } label: {
                    Text("Sign In")
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(30)
                .padding(.top, 10)
            }
            .navigationTitle("Sign In")
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $showError) {
                Alert(title: Text("Error"), message: Text("Invalid email or password"), dismissButton: .default(Text("OK")))
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    

    private var emailValidate: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }


    private var passwordLengthValidate: Bool {
        password.count >= 6
    }


    private func validateInputs() -> Bool {
        return emailValidate && passwordLengthValidate
    }
}

struct RequiredText: View {
    var text: String
    var isStrikeThrough: Bool
    
    var body: some View {
        HStack {
            Image(systemName: isStrikeThrough ? "checkmark.square" : "xmark.square")
                .foregroundColor(isStrikeThrough ? .green : .red)
            Text(text)
                .foregroundColor(.secondary)
                .strikethrough(isStrikeThrough)
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
            .environment(\.managedObjectContext, PersistenceController.preview.viewContext)
    }
}


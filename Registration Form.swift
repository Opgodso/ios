import SwiftUI

struct ContentView: View {
    @State private var title: String = "Mr."
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var Initial: String = ""
    @State private var MiddleName: String = ""
    @State private var gender: String = "Male"
    @State private var dateOfBirth: Date = Date()
    @State private var streetAddress: String = ""
    @State private var streetAddress2: String = ""
    @State private var city: String = ""
    @State private var region: String = ""
    @State private var postal: String = ""
    @State private var country: String = "Taiwan"
    @State private var homePhone: String = ""
    @State private var mobilePhone: String = ""
    @State private var email: String = ""
    @State private var emailValidate: Bool = true
    @State private var homePhoneIsValid: Bool = true
    @State private var mobilePhoneIsValid: Bool = true
    @State private var showSheet: Bool = false

    let titles = ["Mr.", "Ms.", "Dr.", "Prof."]
    let countries = ["Taiwan", "Japan", "Korea"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name")) {
                    VStack(spacing: 5) {
                        HStack(spacing: 25) {
                            Picker("Title", selection: $title) {
                                ForEach(titles, id: \.self) {
                                    Text($0)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())

                            TextField("FirstName", text: $firstName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(maxWidth: 120)

                            TextField("Initial", text: $Initial)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(maxWidth: 120)
                        }
                        HStack(spacing: 5) {
                            TextField("MiddleName", text: $MiddleName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(maxWidth: 170)

                            TextField("LastName", text: $lastName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 170)
                        }
                    }
                }
                    .frame(maxHeight:70)

                Section(header: Text("Gender")) {
                    HStack(spacing: 10) {
                        Button(action: { gender = "Female" }) {
                            HStack {
                                Circle()
                                    .stroke(gender == "Female" ? Color.blue : Color.gray, lineWidth: 2)
                                    .frame(width: 20, height: 20)
                                Text("Female")
                            }
                        }
                        .buttonStyle(PlainButtonStyle())

                        Button(action: { gender = "Male" }) {
                            HStack {
                                Circle()
                                    .stroke(gender == "Male" ? Color.blue : Color.gray, lineWidth: 2)
                                    .frame(width: 20, height: 20)
                                Text("Male")
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .frame(maxHeight:10)

                Section(header: Text("Date of Birth")) {
                    DatePicker("Select Date", selection: $dateOfBirth, displayedComponents: .date)
                }
                .frame(maxHeight:10)

                Section(header: Text("Address")) {
                    HStack {
                        TextField("Street Address", text: $streetAddress)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        TextField("Street Address 2", text: $streetAddress2)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    HStack {
                        TextField("City", text: $city)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        TextField("Region", text: $region)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    HStack {
                        TextField("Postal Code", text: $postal)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 120)

                        Picker("Country", selection: $country) {
                            ForEach(countries, id: \.self) {
                                Text($0)
                            }
                        }
                    }
                }
                .frame(maxHeight:10)

                Section(header: Text("Contact Information")) {
                    HStack {
                        VStack {
                            TextField("Home Phone", text: $homePhone, onEditingChanged: { _ in
                                validatePhoneInput(for: &homePhone)
                            })
                            .onChange(of: homePhone) { _ in
                                validatePhoneInput(for: &homePhone)
                            }
                            .keyboardType(.phonePad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .foregroundColor(homePhoneIsValid ? .primary : .red)
                            if !homePhoneIsValid {
                                Text("Invalid phone format.")
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        }

                        VStack {
                            TextField("Mobile Phone", text: $mobilePhone, onEditingChanged: { _ in
                                validatePhoneInput(for: &mobilePhone)
                            })
                            .onChange(of: mobilePhone) { _ in
                                validatePhoneInput(for: &mobilePhone)
                            }
                            .keyboardType(.phonePad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .foregroundColor(mobilePhoneIsValid ? .primary : .red)
                            if !mobilePhoneIsValid {
                                Text("Invalid phone format.")
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        }
                    }

                    TextField("Email", text: $email, onEditingChanged: { _ in
                        _ = validateEmail()
                    })
                    .onChange(of: email) { _ in
                        if !validateEmail() {
                            print("Invalid email format.")
                        }
                    }
                    .keyboardType(.emailAddress)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .foregroundColor(emailValidate ? .primary : .red)
                    if !emailValidate {
                        Text("Invalid email format")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                .frame(maxHeight:100)

                HStack {
                    Spacer()
                    Button(action: {
                        if validateEmail() {
                            showSheet = true
                        }
                    }) {
                        Text("Send")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    Spacer()
                }
                .frame(maxHeight:10)
            }
            .navigationTitle("Registration Form")
            .sheet(isPresented: $showSheet) {
                RegistrationDetailsView(
                    title: title,
                    firstName: firstName,
                    initial: Initial,
                    middleName: MiddleName,
                    lastName: lastName,
                    gender: gender,
                    dateOfBirth: dateOfBirth,
                    streetAddress: streetAddress,
                    streetAddress2: streetAddress2,
                    city: city,
                    region: region,
                    postal: postal,
                    country: country,
                    homePhone: homePhone,
                    mobilePhone: mobilePhone,
                    email: email
                )
            }
        }
    }

    private func validateEmail() -> Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let result = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
        emailValidate = result
        return result
    }
    private func validatePhoneInput(for phone: inout String) {
        let phoneRegex = "^[0-9]*$"
        let isValid = NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: phone)
        if phone == homePhone {
            homePhoneIsValid = isValid
        } else if phone == mobilePhone {
            mobilePhoneIsValid = isValid
        }
    }
}

struct RegistrationDetailsView: View {
    var title: String
    var firstName: String
    var initial: String
    var middleName: String
    var lastName: String
    var gender: String
    var dateOfBirth: Date
    var streetAddress: String
    var streetAddress2: String?
    var city: String
    var region: String
    var postal: String
    var country: String
    var homePhone: String
    var mobilePhone: String
    var email: String

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            List {
                    Section(header: Text("Personal Information")) {
                    Text("Title: \(title)")
                    Text("First Name: \(firstName)")
                    Text("Initial: \(initial)")
                    Text("Middle Name: \(middleName)")
                    Text("Last Name: \(lastName)")
                    Text("Gender: \(gender)")
                    Text("Date of Birth: \(formattedDate(dateOfBirth))")
                }

                Section(header: Text("Address")) {
                    Text("Street Address: \(streetAddress)")
                    Text("Street Address 2: \(streetAddress2 ?? "N/A")")
                    Text("City: \(city)")
                }

                Section(header: Text("Contact")) {
                    Text("Region: \(region)")
                    Text("Postal Code: \(postal)")
                    Text("Country: \(country)")
                    Text("Home Phone: \(homePhone)")
                    Text("Mobile Phone: \(mobilePhone)")
                    Text("Email: \(email)")
                }
            }
            .navigationTitle("Registered Information")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }


}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

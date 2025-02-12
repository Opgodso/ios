import Foundation
import Combine

class AccountForm: ObservableObject {
    
    @Published var email = ""
    @Published var emailValidate = false
    
    @Published var password = ""
    @Published var passwordLengthValidate = false
    @Published var passwordUppercaseValidate = false
    
    @Published var passwordConfirm = ""
    @Published var passwordConfirmValidate = false
    
    private var cancellableSet = Set<AnyCancellable>()
    
    init() {
        // check the email format
        // emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        // format: "SELF MATCHES %@"
        $email
            .receive(on: RunLoop.main)
            .map{ email in
                let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
                return NSPredicate(format: "SELF MATCHES %@",emailRegex).evaluate(with: email)
            }
            .assign(to:\.emailValidate, on:self)
            .store(in: &cancellableSet)
        
        // check the password length
       $password
        .receive(on: RunLoop.main)
        .map{ password in
            return password.count >= 6
        }
        .assign(to: \.passwordLengthValidate, on:self)
        .store(in: &cancellableSet)
        
        // check the password letters
        $password
         .receive(on: RunLoop.main)
         .map{ password in
            let pattern = "[A-Z]"
            if let _ = password.range(of: pattern,options: .regularExpression){
                return true
            }else{
                return false
            }
         }
         .assign(to: \.passwordUppercaseValidate, on:self)
         .store(in: &cancellableSet)
        
        // check the consistency of re-typing the password
        Publishers.CombineLatest($password, $passwordConfirm)
            .receive(on: RunLoop.main)
            .map{ password ,confirm in
                return !confirm.isEmpty && (confirm == password)
            }
            .assign(to: \.passwordConfirmValidate, on:self)
            .store(in: &cancellableSet)
        }
}


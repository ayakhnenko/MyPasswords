//
//  ContentView.swift
//  MyPasswords
//
//  Created by Alisa Yakhnenko on 11.06.2023.
//

import SwiftUI
import LocalAuthentication
import UniformTypeIdentifiers

struct UDValue {
    static let keyTitle: String = "title"
    static let keyPassword: String = "password"
    static let keyArray: String = "array"
}


struct ContentView: View {
    
    @State private var title: String = ""
    @State private var password: String = ""
    @State private var total: String = ""
    
    
    let defaults = UserDefaults.standard
    
    func saveAction() {
        let title = title
        let password = password
        
        if !title.isEmpty && !password.isEmpty {
            Base.shared.saveData(title: title, password: password)
            
        }
        
    }
    
    func delete(offsets: IndexSet) {
        offsets.forEach { index in
            Base.shared.deleteData(at: offsets)
        }
    }
    
    
    var body: some View {
        VStack {
            VStack {
                TextField("Enter title", text: $title)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.black)
                
                TextField("Enter password", text: $password)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.black)
                
                HStack {
                    Spacer()
                    Button("Save") {
                        saveAction()
                        title = ""
                        password = ""
                    }
                    .padding()
                    .frame(width: 150)
                    .background(Color.gray.gradient)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    
                    Spacer()
                }
            }
            .padding()
            
            
            
            List {
                ForEach(Base.shared.array, id: \.self.id) { pass in
                    Row(pass: pass)
                    
                }.onDelete(perform: delete)
            }
            
        }
        
    }
    
}


struct Row: View {
    
    @State private var isUnlocked = false
    @State private var isCopied: Bool = false
    var pass: Base.UserData
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "We need to unlock your data"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                if success {
                    isUnlocked = true
                } else {
                    print(error! as NSError)
                }
            }
        }
    }
    func copyOnTapGesture(string: String) {
        let clipboard = UIPasteboard.general
        clipboard.setValue(string, forPasteboardType: UTType.plainText.identifier)
        isCopied = true
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 3) {
            isCopied = false
        }
    }
    var body: some View {
        ZStack {
            
            HStack {
                Text(pass.title)
                    .frame(maxWidth: .infinity / 2 - 20 )
                    .cornerRadius(8)
                    .onLongPressGesture {
                        copyOnTapGesture(string: pass.title)
                    }
                Text("-")
                if isUnlocked {
                    Text(pass.password)
                        .frame(maxWidth: .infinity / 2 - 20 )
                        .cornerRadius(8)
                        .onLongPressGesture {
                            copyOnTapGesture(string: pass.password)
                        }
                } else {
                    Text(pass.password)
                        .frame(maxWidth: .infinity / 2 - 20 )
                        .blur(radius: 10)
                        .onTapGesture {
                            authenticate()
                        }
                }
                if isCopied {
                    
                    Text("Copied successfully!")
                        .foregroundColor(.black)
                        .bold()
                        .font(.footnote)
                        .frame(width: 140, height: 50)
                        .background(Color.gray.cornerRadius(8))
                }
            }
            
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

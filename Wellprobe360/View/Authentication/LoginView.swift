//
//  LoginView.swift
//  Wellprobe360
//
//  Created by Victor Edu on 17/09/2023.
//

import SwiftUI


struct LoginView: View {
    @State var email = "johndaavoo@gmail.com"
    @State var password = "Undefined12"
    @EnvironmentObject var viewModel:  AuthViewModel
    var body: some View {
     
        let someColor = #colorLiteral(red: 0.1215780899, green: 0.4257294536, blue: 0.884799242, alpha: 1)
        NavigationStack {
            ZStack {
                VStack{
                    Image("Logo")
                        .scaledToFit()
                        .frame(width: 220, height: 100)
                        .padding(.top, 88)
                        .colorInvert()
                    
                    VStack(spacing: 20){
                        CustomTextField(text: $email, placeholder: Text("Email"), imageName: "envelope")
                            .padding()
                            .background(Color(.init(white: 1, alpha: 0.15)))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                        
                        
                        CustomSecuredField(text: $password, placeholder: Text("Password"))
                            .padding()
                            .background(Color(.init(white: 1, alpha: 0.15)))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                        
                    }
                    .padding(.horizontal, 32)
                    
                    
                    HStack{
                        Spacer()
                        
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                            Text("Forgot Password?")
                                .font(.footnote)
                                .bold()
                                .foregroundColor(.white)
                                .padding(.top, 16)
                                .padding(.trailing, 28)
                        })
                    }
                    
                  
                        Button(action: {
                           viewModel.authenticate(username: email, password: password)
                        
                        }, label: {
                            Text("Sign In")
                                .font(.headline)
                                .foregroundColor(.blue)
                                .frame(width: 360, height: 50)
                                .background(Color.white)
                                .clipShape(Capsule())
                                .padding()
                        })
                    
                    Group {
                        if viewModel.errorMessage != nil {
                            Text(viewModel.errorMessage!)
                                .foregroundColor(Color(hex: 0xFF80AB))
                                .opacity(0.8)
                                .padding(.bottom, 8)  // Add some padding at the
                        }
                    }
                   
      
                    Spacer()
                   
                    
                  NavigationLink(destination: Text("Registration View")//RegistrationView()
                    .navigationBarBackButtonHidden(true),
                                 label: {
                      HStack{
                          Text("Don't have an account?")
                              .font(.system(size: 14))
                          
                          
                              Text("Sign Up")
                                  .font(.system(size: 14, weight: .semibold))
                              
                    
                      }
                      .foregroundColor(.white)
                      .padding(.bottom, 32)
                  })
                    
                
                    
            
                   
                    
                }
            }
            .background(Color(someColor))
        .ignoresSafeArea()
        }
    
    }
}
extension Color {
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double((hex & 0xff) >> 0) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}
#Preview {
    LoginView().environmentObject(AuthViewModel.shared)
}

//
//struct AuthView: View {
//    @ObservedObject var viewModel = AuthViewModel()
//
//    var body: some View {
//        VStack {
//            // ... other UI elements like username and password fields ...
//
//            if let error = viewModel.errorMessage {
//                Text(error)
//                    .foregroundColor(.red)
//            }
//
//            Button("Login") {
//                viewModel.authenticate(username: "exampleUsername", password: "examplePassword")
//            }
//        }
//    }
//}

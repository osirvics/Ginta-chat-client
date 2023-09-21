//
//  CustomSecuredField.swift
//  Wellprobe360
//
//  Created by Victor Edu on 17/09/2023.
//

import SwiftUI


struct CustomSecuredField: View {
    @Binding var text: String
    let placeholder: Text
    
    var body: some View {
        ZStack(alignment: .leading){
            if text.isEmpty {
                placeholder
                    .foregroundColor(Color(.init(white: 1, alpha: 0.87)))
                    .padding(.leading, 40)
                
                 
            }
            
            HStack(spacing: 16){
                
                Image(systemName: "lock")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color(.init(white: 1, alpha: 0.87)))
                
                
                
                SecureField("", text: $text)
                
            }
            
            

        }
    }
}

#Preview {
    CustomSecuredField(text: .constant(""), placeholder: Text("Password"))
}

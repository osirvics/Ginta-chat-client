//
//  UserItem.swift
//  Wellprobe360
//
//  Created by Victor Edu on 18/09/2023.
//
import SwiftUI
import Kingfisher


struct UserItem: View {
    let user: User
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8 ){
            HStack{
                KFImage(URL(string: user.profileImage ?? ""))
                    .placeholder({
                        Image(systemName: "person.fill")
                            .font(.system(size: 32))
                            .padding(8)
                            .overlay(RoundedRectangle(cornerRadius: 44)
                                .stroke(Color(.systemGray), lineWidth: 1)
                            )
                    })
                    .resizable()
                    .frame(width: 56, height: 56)
                    .clipShape(Circle())
                    
                
                VStack(alignment: .leading, spacing: 4 ){
                   
                        
                    Text(user.firstName + " " + user.lastName)
                            .font(.system(size: 14, weight: .semibold))
                    
                    Text(user.userType.rawValue)
                        .font(.system(size: 14))
                }
                .padding(.trailing)
                Spacer()
            }
            Divider()
        }
     
    }
    
}

//#Preview {
//    UserItem()
//}


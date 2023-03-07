//
//  ProfileImageView.swift
//  ShowUp
//
//  Created by Zhuowei Z on 5/6/22.
//

import SwiftUI

struct ProfileImageRow: View {
    @EnvironmentObject var user_session: UserVM
    @Binding var isSet: Bool
    
    var body: some View {
        HStack {
            Spacer()
            if isSet {
                Image(uiImage: user_session.profileImg ?? UIImage(imageLiteralResourceName: "profile"))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100, alignment: .center)
                    .clipShape(Circle())
                    .padding(.vertical)
            } else {
                if let imageData = user_session.profileImg {
                    Image(uiImage: imageData)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100, alignment: .center)
                        .clipShape(Circle())
                        .padding(.vertical)
                } else {
                    Image("profile")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100, alignment: .center)
                        .clipShape(Circle())
                        .padding(.vertical)
                }
            }
            Spacer()
        }
    }
}

struct ProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}

//
//  AboutView.swift
//  Game In-Depth
//
//  Created by Indra Permana on 22/07/20.
//  Copyright © 2020 IndraPP. All rights reserved.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack {
            Text("About Me")
                .fontWeight(.bold)
                .padding(.all, 50)
                .font(.largeTitle)
                .foregroundColor(.white)
            Image("profile")
                .resizable()
                .frame(width: 250.0, height: 250.0)
                .clipShape(Circle())
                .padding(.bottom, 20)
            Text(/*@START_MENU_TOKEN@*/"Muhamad Yusuf Indra"/*@END_MENU_TOKEN@*/)
                .foregroundColor(.white)
            Text("iOS Developer")
                .fontWeight(.light)
                .padding(.bottom, 20)
                .foregroundColor(.white)
            Text("Email dicoding: muhamadyusufindra@gmail.com")
                .foregroundColor(.gray)
            Spacer()
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}

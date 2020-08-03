//
//  ProfileView.swift
//  Game In-Depth
//
//  Created by Indra Permana on 03/08/20.
//  Copyright © 2020 IndraPP. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var profile = Profile()
    @State var presentAlert = false
    var favouriteGamesProvider: FavouriteGameProvider = FavouriteGameProvider()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Nickname")) {
                    TextField("nickname", text: $profile.nickname)
                }
                Section(header: Text("Email")) {
                    TextField("email", text: $profile.email)
                }
                Section(footer: Text("This action will delete your Profile and Favourite Games")) {
                    Button(action: {
                        self.presentAlert = true
                    }) {
                        Text("Delete All Data")
                    }
                    .foregroundColor(.red)
                    .alert(isPresented: $presentAlert) {
                        Alert(title: Text("Warning"), message: Text("Are you sure to delete all data ?"), primaryButton: .destructive(Text("Yes")) {
                            self.deleteAllData()
                            }, secondaryButton: .cancel())
                    }
                }
            }
            .navigationBarTitle("Profile")
        }
        .statusBar(hidden: false)
        .preferredColorScheme(.dark)
    }
    func deleteAllData() {
        DispatchQueue.main.async {
            self.favouriteGamesProvider.deleteAllFavouriteGame {
                
            }
            if let domain = Bundle.main.bundleIdentifier {
                UserDefaults.standard.removePersistentDomain(forName: domain)
                UserDefaults.standard.synchronize()
                self.profile.sync()
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

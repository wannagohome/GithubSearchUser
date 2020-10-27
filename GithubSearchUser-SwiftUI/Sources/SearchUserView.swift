//
//  ContentView.swift
//  GithubSearchUser-SwiftUI
//
//  Created by Jinho Jang on 2020/10/27.
//

import SwiftUI

class SearchUserViewModel: ObservableObject {
    
}

struct SearchUserView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 0, content: {
                    ForEach(1...20, id: \.self) { index in
                        UserView()
                    }
                    .scaledToFill()
                    .foregroundColor(.blue)
                })
                .scaledToFill()
                .foregroundColor(.white)
            }
        }
        .navigationTitle("Github Search")

        
//        Text("Hello, world!")
//            .padding()
    }
}

struct UserView: View {
    var body: some View {
        ZStack() {
            Rectangle().fill(Color.white)
            Text("Placeholder")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SearchUserView()
            .preferredColorScheme(.dark)
    }
}

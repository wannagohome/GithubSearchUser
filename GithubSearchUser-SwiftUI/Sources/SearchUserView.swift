//
//  ContentView.swift
//  GithubSearchUser-SwiftUI
//
//  Created by Jinho Jang on 2020/10/27.
//

import SwiftUI
import struct Kingfisher.KFImage

struct SearchUserView: View {
    @ObservedObject private var viewModel: SearchUserViewModel
    
    init(viewModel: SearchUserViewModel = SearchUserViewModel()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                searchField
                    .padding(.bottom, 10)
                
                List(viewModel.userList, id: \.id) { user in
                    UserView(user: user).onAppear {
                        self.viewModel.appearedID.send(user.id)
                    }
                }
                .listStyle(PlainListStyle())
            }
            
            .navigationTitle("Github Search")
        }
        .alert(isPresented: $viewModel.showingAlert) {
            Alert(title: Text(viewModel.errorMessage))
        }
    }
    
    private var searchField: some View {
        HStack {
            TextField("User Name", text: $viewModel.searchText)
                .padding(.leading, 27)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(6)
        .overlay(
            HStack {
                Image(systemName: "magnifyingglass")
                Spacer()
            }
            .padding(.horizontal, 18)
            .foregroundColor(.gray)
        )
        .padding(.horizontal)
    }
}

struct UserView: View {
    private let userInfo: User
    init(user: User) {
        self.userInfo = user
    }
    var body: some View {
        HStack {
            VStack {
                KFImage(URL(string: userInfo.avatarURL!)!)
                    .resizable()
                    .frame(width: 60, height: 60)
            }
            
            VStack(alignment: .leading) {
                Text("\(userInfo.login!)")
                Text("Number of repos : \(userInfo.numberOfRepos)")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            .padding(.leading, 15)
            
            Spacer()
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = SearchUserViewModel()
        let sampleData = SampleData.userList.data(using: .utf8)!
        let result = try! JSONDecoder().decode(UserList.self, from: sampleData)
        viewModel.userList = result.users!
        return SearchUserView(viewModel: viewModel)
    }
}

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
            List {
                searchField
                
                Section {
                    ForEach(viewModel.userList) { user in
                        UserView(user: user)
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("Github Search")
        }
    }
    
    private var searchField: some View {
      HStack(alignment: .center) {
        TextField("User Name", text: $viewModel.searchText)
      }
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

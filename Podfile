source 'https://github.com/CocoaPods/Specs.git'
workspace 'GithubSearchUser.xcworkspace'
platform :ios, '14.0'
use_frameworks!

abstract_target 'GithubSearchUser' do
  pod 'Kingfisher'

target 'GithubSearchUser' do
  project 'GithubSearchUser/GithubSearchUser.xcodeproj'
  pod 'ReactorKit'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'Alamofire'


  target 'GithubSearchUserTests' do
    pod 'RxTest'
  end

end


target 'GithubSearchUser-SwiftUI' do
  project 'GithubSearchUser-SwiftUI/GithubSearchUser-SwiftUI.xcodeproj'
  pod 'Kingfisher/SwiftUI'
end

end
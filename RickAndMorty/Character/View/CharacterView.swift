//
//  CharacterView.swift
//  RickAndMorty
//
//  Created by erick on 21/06/24.
//

import Foundation
import SwiftUI

struct CharacterView: View {
    @State var data: CharacterResult?
    @StateObject var viewModel = CharacterViewModel()
    @StateObject private var viewModels = ContentViewModel()

    var body: some View {
        NavigationStack {
            List {
                if let characters =  viewModels.characters?.results {
                    ForEach(characters) { character in
                        LazyHStack(spacing: 0){
                            AsyncImage(url: URL(string: character.image ?? "")) { phase in
                                switch phase {
                                    case .empty:
                                        ProgressView()
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color.black, lineWidth: 2))
                                    case .failure:
                                        Image(systemName: "person")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color.black, lineWidth: 2))
                                    @unknown default:
                                        EmptyView()
                                }
                            }

                            Text(character.name ?? "")
                                .padding(.leading, 10)
                        }

                    }
                    .listRowSeparator(.hidden)
                }
            }.listStyle(.plain)
                .toolbar {
                    ToolbarItemGroup(placement: .primaryAction) {
                        Button {
                            print("Search Characters")
                        } label: {
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(.black)
                        }
                    }
                    ToolbarItem(placement: .principal) {
                        Text("Characters")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                }
                .task {
                    await viewModel.fetchCharacters()
                }.refreshable {
                    await viewModels.loadCharacters()
                }
        }
    }
}

#Preview {
    CharacterView()
}

class WebService {
    func downloadData<T: Codable>(fromURL: String) async -> T? {
        do {
            guard let url = URL(string: fromURL) else { throw NetworkError.badUrl }
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let response = response as? HTTPURLResponse else { throw NetworkError.badResponse }
            guard response.statusCode >= 200 && response.statusCode < 300 else { throw NetworkError.badStatus }
            guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else { throw NetworkError.failedToDecodeResponse }
            print(response.statusCode)
            return decodedResponse
        } catch NetworkError.badUrl {
            print("There was an error creating the URL")
        } catch NetworkError.badResponse {
            print("Did not get a valid response")
        } catch NetworkError.badStatus {
            print("Did not get a 2xx status code from the response")
        } catch NetworkError.failedToDecodeResponse {
            print("Failed to decode response into the given type")
        } catch {
            print("An error occured downloading the data")
        }

        return nil
    }
}

@MainActor class PostViewModel: ObservableObject {
    @Published var postData: CharacterModel?

    func fetchData() async {
        guard let downloadedPosts: CharacterModel = await WebService().downloadData(fromURL: "https://rickandmortyapi.com/api/character") else {return}
        postData = downloadedPosts
    }
}

struct ContentViews: View {
    @StateObject var vm = PostViewModel()

    var body: some View {
        if let results = vm.postData?.results {
            List(results) { post in
                VStack(alignment: .leading) {
                    Text(post.name ?? "")
                        .bold()
                        .lineLimit(1)

                    Text(post.status?.rawValue ?? "")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }.task {
                await vm.fetchData()

            }

        }

    }
}

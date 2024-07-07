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
    @EnvironmentObject var networkMonitor: NetworkMonitor
    var body: some View {
        ZStack {
            NavigationStack {
                if !networkMonitor.isConnected {
                    Popup(isPresented: $networkMonitor.isConnected,  {
                        VStack {
                            Image(systemName: "wifi.slash")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.red)
                            Text("No Internet Connection")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                        }
                    })
                }
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
                        viewModels.loadCharacters()
                    }

            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    CharacterView()
}

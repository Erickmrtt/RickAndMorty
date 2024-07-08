//
//  CharacterView.swift
//  RickAndMorty
//
//  Created by erick on 21/06/24.
//

import Foundation
import SwiftUI

struct CharacterView: View {
    @State private var searchText = ""
    @StateObject private var viewModel = CharacterViewModel()
    @FocusState private var isSearch: Bool
    @StateObject private var viewModels = ContentViewModel()
    @EnvironmentObject var networkMonitor: NetworkMonitor
    var body: some View {
        ZStack {
            NavigationStack {

                if !networkMonitor.isConnected {
                    Popup(isPresented: $networkMonitor.isConnected,  {
                        VStack {
                            Image(systemName: "noWifiImg".localized())
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.red)
                            Text("noInternetConnection".localized())
                                .modifier(GenericTextConfig(accessibilityText: "noInternetConnection".localized(),fontSize: 14,color: .red, fontWeight: .black))
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
                    .safeAreaInset(edge: .top, spacing: 0){
                        ExpandableNavigationBar()
                    }  .animation(.snappy(duration: 0.3, extraBounce: 0), value: isSearch)

                    .task {
                        await viewModel.fetchCharacters()
                    }.refreshable {
                        viewModels.loadCharacters()
                    }

            }
            .animation(.snappy(duration: 0.3, extraBounce: 0))
            .contentMargins(.top, 190,  for: .scrollIndicators)
            .navigationBarBackButtonHidden(true)
        }
    }
    @ViewBuilder
    func ExpandableNavigationBar() -> some View {
        GeometryReader { geo in
            let minY = geo.frame(in: .scrollView(axis: .vertical)).minY
            let progress = isSearch ? 1 :  max(min(-minY, 70 / 1), 0)
            VStack(spacing: 10) {
                Text("Characters")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                HStack(spacing: 12) {
                    if isSearch {
                        Button {
                            searchText = ""
                            isSearch = false
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title3)
                        }.transition(.asymmetric(insertion: .push(from: .bottom), removal: .push(from: .top)))
                    }
                    Spacer()
                    TextField("Search Characters", text: $searchText)
                        .focused($isSearch)

                    Image(systemName: "magnifyingglass")
                        .font(.title3)
                }
                .foregroundStyle(Color.primary)
                .padding(.horizontal, 15 - (progress * 15))
                .padding(.vertical, 10)
                .frame(height: 45)
                .clipShape(.capsule)
                .background {
                    RoundedRectangle(cornerRadius: 25 - (progress * 25))
                        .fill(.background)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
                        .padding(.top, -progress * 190)
                        .padding(.bottom, -progress * 65)
                        .padding(.horizontal, -progress * 15)
                }

                ScrollView(.horizontal) {
                    HStack(spacing: 12){
                        if let characters =  viewModels.characters?.results {
                            ForEach(characters) { tab in
                                Text(tab.name ?? "")
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 8)
                                    .background(.teal)
                                    .foregroundColor(.white)
                                    .cornerRadius(25)
                            }
                        }
                    }
                }.frame(height: 50)
            }
            .safeAreaPadding(.horizontal, 15)
            .offset(y: minY > 0 || isSearch ? -minY : 0)
            .offset(y: -progress * 65)
            .padding(.top, 25)

        }
        .frame(height: 150)
        .padding(.bottom, 10)
        .padding(.bottom, isSearch ? -65 : 0)
    }
}

#Preview {
    CharacterView()
}

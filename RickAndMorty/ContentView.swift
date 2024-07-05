//
//  ContentView.swift
//  RickAndMorty
//
//  Created by erick on 19/06/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                    } label: {
                        Text(item.timestamp!, formatter: itemFormatter)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}




















struct BankView: View {
    @State var isVisible = true

    var body: some View {
        ZStack {
            BackgroundShape()
                .ignoresSafeArea(.all, edges: .top)
                .background(Color("background"))
                .foregroundColor(Color("yellow"))

            ScrollView(.vertical, showsIndicators: false, content: {
                VStack(spacing: 20) {
                    HeaderView(isVisible: $isVisible)
                        .padding(.horizontal)

                    AccountView(isVisible: $isVisible)
                        .frame(height: 150)
                        .padding(.horizontal)

                    CardView(isVisible: $isVisible)
                        .padding(20)
                        .background(Color("cardBackground"))
                        .cornerRadius(8)
                        .padding(.horizontal)

                    CardStatusView()
                        .padding(20)
                        .background(Color("cardBackground"))
                        .cornerRadius(8)
                        .padding(.horizontal)

                    InviteView()
                        .padding(20)
                        .background(Color("cardBackground"))
                        .cornerRadius(8)
                        .padding(.horizontal)

                    PollView()
                        .background(Color("cardBackground"))
                        .cornerRadius(8)
                        .padding(.horizontal)

                    Spacer()
                }
            })
        }
    }
}

struct PollView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("Are you enjoying the app?")
                    .font(.system(size: 21, weight: .bold))

                Text("Click here to tell me about your experience. Your opinion is essential!")
                    .font(.system(size: 19))
            }
            .foregroundColor(Color.black.opacity(0.7))
            .padding(20)

            Spacer()

            VStack {
                Spacer()

                Image("image2")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 140)
            }
        }
    }
}

struct InviteView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Invite Friends")
                    .font(.system(size: 21, weight: .bold))

                Text("Call everyone to be Digital too. Invite your friends and earn rewards!")
                    .font(.system(size: 19))
                    .padding(.top, 40)
            }
            .foregroundColor(Color.black.opacity(0.7))

            Spacer()

            Image("image1")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
}

struct CardStatusView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Manage Cards")
                    .fontWeight(.bold)
                    .foregroundColor(.gray)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.gray)
            }

            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)

                    Text("Virtual")

                    Text("Released for purchases")
                        .fontWeight(.bold)

                    Spacer()
                }

                HStack(spacing: 12) {
                    Image(systemName: "envelope.fill")

                    Text("Physical")

                    Text("Track delivery")
                        .fontWeight(.bold)

                    Spacer()
                }
            }
            .foregroundColor(.black)
            .padding(.top, 40)
        }
    }
}

struct CardView: View {
    @Binding var isVisible: Bool

    var body: some View {
        HStack {
            Text("Limit available on the credit card")
                .foregroundColor(.gray)
                .fontWeight(.bold)

            Spacer()

            Text(isVisible ? "R$ 4.893,25" : "R$ •••••••••")
                .font(.system(size: 19))
                .fontWeight(.bold)

            Image(systemName: "chevron.right")
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(.gray)
        }
    }
}

struct AccountView: View {
    @Binding var isVisible: Bool

    var body: some View {
        HStack(spacing: 15) {
            Button(action: {}, label: {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(.white)
                    .overlay(
                        VStack {
                            HStack {
                                Text("Digital Account")

                                Spacer()

                                Image(systemName: "chevron.right")
                            }
                            .foregroundColor(.gray)

                            Spacer()

                            Text("A full account for you soon.")
                                .foregroundColor(.black)
                        }
                        .padding(12)

                    )
            })

            Button(action: {}, label: {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(.white)
                    .overlay(
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Credit card")

                                Spacer()

                                Image(systemName: "chevron.right")
                            }
                            .foregroundColor(.black)

                            Spacer()

                            Text("Open invoice")
                                .foregroundColor(.black)

                            Text(isVisible ? "R$ 1585,93" : "R$ ••••••")
                                .foregroundColor(.black)
                                .font(.title2)
                                .fontWeight(.bold)

                            Text("Cose on 04/06")
                                .foregroundColor(.green)
                        }
                        .padding(12)
                    )
            })
        }
    }
}

struct HeaderView: View {
    @Binding var isVisible: Bool

    var body: some View {
        HStack {
            Circle()
                .frame(width: 70, height: 70)
                .foregroundColor(.white)

            VStack(alignment: .leading) {
                Text("Hey, Erick!")
                    .font(.title)
                    .fontWeight(.bold)

                Button(action: {}, label: {
                    Text("See profile")
                        .font(.system(size: 23))
                        .foregroundColor(.black)
                })
            }
            .padding(.leading)

            Spacer()

            Button(action: {
                isVisible.toggle()
            }, label: {
                Image(systemName: isVisible ? "eye.fill" : "eye.slash.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30)
                    .foregroundColor(.black)
            })
        }
    }
}

struct BackgroundShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.midY), control: CGPoint(x: rect.midX, y: rect.maxY * 0.6))
        return path
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BankView()
    }
}

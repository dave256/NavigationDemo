//
//  ContentView.swift
//  NavigationDemo
//
//  Created by David M Reed on 1/30/21.
//

import SwiftUI

struct Item: Identifiable, Hashable {
    var value: String
    let id = UUID()

    init(_ x: Int) {
        self.value = String(format: "Item %02i", x)
    }
}

extension Item: Comparable {
    static func < (lhs: Item, rhs: Item) -> Bool {
        lhs.value < rhs.value
    }
}

struct DetailView: View {
    let item: Item

    var body: some View {
        Text(item.value)
    }
}

struct ContentView: View {
    @State private var items = (1...10).map { Item($0) }

    var body: some View {
        NavigationView {
            List {
                ForEach(items, id: \.self) { item in
                    NavigationLink(
                        destination: DetailView(item: item),
                        label: {
                            Text(item.value)
                        })
                }
                .onMove(perform: move)
                .onDelete(perform: delete)
            }
            .navigationBarItems(leading: EditButton(), trailing: Button {
                withAnimation() {
                    items.append(Item(Int.random(in: 0...20)))
                    items.sort()
                }
            } label: {
                Image(systemName: "plus")
            })
            .navigationBarTitle("Navigation Demo", displayMode: .inline)
            .listStyle(InsetGroupedListStyle())
        }
    }

    func move(from source: IndexSet, to destination: Int) {
        items.move(fromOffsets: source, toOffset: destination)
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
      }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

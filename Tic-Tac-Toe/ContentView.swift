//
//  ContentView.swift
//  Tic-Tac-Toe
//
//  Created by bogdanov on 10.05.21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                LazyVGrid(columns: columns) {
                    ForEach(0 ..< 9) { _ in
                        ZStack {
                            Rectangle()
                                .foregroundColor(.blue)
                                .opacity(0.5)
                                .frame(width: geometry.size.width/3-5,
                                       height: geometry.size.width/3-5)
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: geometry.size.width/3-50, height: geometry.size.width/3-50)
                        }
                    }
                }
                Spacer()
            }
        }.padding()
    }
}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

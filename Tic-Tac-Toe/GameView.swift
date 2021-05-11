//
//  GameView.swift
//  Tic-Tac-Toe
//
//  Created by bogdanov on 10.05.21.
//

import SwiftUI

struct GameView: View {
    @StateObject private var viewModel = GameViewModel()

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                LazyVGrid(columns: viewModel.columns) {
                    ForEach(0 ..< 9) { i in
                        ZStack {
                            GameSquareView(proxy: geometry)
                            PlayerIndicator(systemImageName: viewModel.moves[i]?.indicator ?? "", proxy: geometry)
                        }.onTapGesture {
                            viewModel.processPlayerMove(for: i)
                        }
                    }
                }
                Spacer()
            }
        }
        .padding()
        .disabled(viewModel.isGameBoardDisabled)
        .alert(item: $viewModel.alertItem) { alertItem in
            Alert(title: alertItem.title,
                  message: alertItem.message,
                  dismissButton: .default(alertItem.buttonTitle,
                                          action: { viewModel.resetGame() }))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}

struct GameSquareView: View {
    var proxy: GeometryProxy

    var body: some View {
        Rectangle()
            .foregroundColor(.blue)
            .opacity(0.5)
            .frame(width: proxy.size.width/3-5,
                   height: proxy.size.width/3-5)
    }
}

struct PlayerIndicator: View {
    var systemImageName: String
    var proxy: GeometryProxy

    var body: some View {
        Image(systemName: systemImageName)
            .resizable()
            .frame(width: proxy.size.width/3-50, height: proxy.size.width/3-50)
    }
}

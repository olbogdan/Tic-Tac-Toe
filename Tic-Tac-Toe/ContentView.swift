//
//  ContentView.swift
//  Tic-Tac-Toe
//
//  Created by bogdanov on 10.05.21.
//

import SwiftUI

struct ContentView: View {
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]

    @State private var moves: [Move?] = Array(repeating: nil, count: 9)

    @State private var isGameBoardDisabled: Bool = false

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                LazyVGrid(columns: columns) {
                    ForEach(0 ..< 9) { i in
                        ZStack {
                            Rectangle()
                                .foregroundColor(.blue)
                                .opacity(0.5)
                                .frame(width: geometry.size.width/3-5,
                                       height: geometry.size.width/3-5)
                            Image(systemName: moves[i]?.indicator ?? "")
                                .resizable()
                                .frame(width: geometry.size.width/3-50, height: geometry.size.width/3-50)
                        }.onTapGesture {
                            if !isSquareOccupied(in: moves, forIndex: i) {
                                moves[i] = Move(player: .human, boardIndex: i)
                                isGameBoardDisabled = true
                                // check for win condition or draw
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    let computerPosition = determineComputerMovePosition(in: moves)
                                    moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
                                    isGameBoardDisabled = false
                                }
                            }
                        }
                    }
                }
                Spacer()
            }
        }
        .padding()
        .disabled(isGameBoardDisabled)
    }

    private func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index })
    }

    private func determineComputerMovePosition(in moves: [Move?]) -> Int {
        var movePosition: Int
        repeat {
            movePosition = Int.random(in: 0 ..< 9)
        } while isSquareOccupied(in: moves, forIndex: movePosition)
        return movePosition
    }


}

private enum Player {
    case human, computer
}

private struct Move {
    let player: Player
    let boardIndex: Int

    var indicator: String {
        return player == .human ? "xmark" : "circle"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

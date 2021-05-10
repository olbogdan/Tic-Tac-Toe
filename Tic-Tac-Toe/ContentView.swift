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

    @State private var alertItem: AlertItem?

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

                                if checkWinCondition(for: .human, in: moves) {
                                    alertItem = AlertContext.humanWin
                                    return
                                }
                                if checkForDraw(in: moves) {
                                    alertItem = AlertContext.draw
                                    return
                                }
                                isGameBoardDisabled = true

                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    let computerPosition = determineComputerMovePosition(in: moves)
                                    moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
                                    isGameBoardDisabled = false

                                    if checkWinCondition(for: .computer, in: moves) {
                                        alertItem = AlertContext.computerWin
                                        return
                                    }
                                    if checkForDraw(in: moves) {
                                        alertItem = AlertContext.draw
                                        return
                                    }
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
        .alert(item: $alertItem) { alertItem in
            Alert(title: alertItem.title,
                  message: alertItem.message,
                  dismissButton: .default(alertItem.buttonTitle,
                                          action: { resetGame() }))
        }
    }

    private func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index })
    }

    private let winPatterns: Set<Set<Int>> = [
        [0, 1, 2], [3, 4, 5], [6, 7, 8],
        [0, 3, 6], [1, 4, 7], [2, 5, 8],
        [0, 4, 8], [2, 4, 6]
    ]

    // If AI can't win then block
    // If AI can't block then take middle square

    private func determineComputerMovePosition(in moves: [Move?]) -> Int {
        // If AI can win, then win
        let computerPositions = moves
            .compactMap { $0 }
            .filter { $0.player == .computer }
            .map { $0.boardIndex }

        var winPosition = winPatterns
            .map { $0.subtracting(computerPositions) }
            .filter { $0.count == 1 }
            .compactMap { $0.first }
            .first { !isSquareOccupied(in: moves, forIndex: $0) }

        if winPosition != nil {
            return winPosition!
        }
        
        // If AI can't win then block
        let humanPositions = moves
            .compactMap { $0 }
            .filter { $0.player == .human }
            .map { $0.boardIndex }

        winPosition = winPatterns
            .map { $0.subtracting(humanPositions) }
            .filter { $0.count == 1 }
            .compactMap { $0.first }
            .first { !isSquareOccupied(in: moves, forIndex: $0) }

        if winPosition != nil {
            return winPosition!
        }

        // if AI can't take middle square, take random available square
        var movePosition: Int
        repeat {
            movePosition = Int.random(in: 0 ..< 9)
        } while isSquareOccupied(in: moves, forIndex: movePosition)
        return movePosition
    }

    private func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool {
        let playerPositions = moves.compactMap { $0 }
            .filter { $0.player == player }
            .map { $0.boardIndex }

        for pattern in winPatterns where pattern.isSubset(of: playerPositions) {
            return true
        }
        return false
    }

    private func checkForDraw(in moves: [Move?]) -> Bool {
        return moves.compactMap { $0 }.count == 9
    }

    private func resetGame() {
        moves = Array(repeating: nil, count: 9)
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

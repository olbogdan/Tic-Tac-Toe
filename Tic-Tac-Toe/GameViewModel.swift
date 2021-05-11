//
//  GameViewModel.swift
//  Tic-Tac-Toe
//
//  Created by bogdanov on 11.05.21.
//

import SwiftUI

final class GameViewModel: ObservableObject {
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isGameBoardDisabled: Bool = false
    @Published var alertItem: AlertItem?

    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]

    func processPlayerMove(for i: Int) {
        // human move processing
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

            // computer move processing
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
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

    func resetGame() {
        moves = Array(repeating: nil, count: 9)
    }

    private func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index })
    }

    private let winPatterns: Set<Set<Int>> = [
        [0, 1, 2], [3, 4, 5], [6, 7, 8],
        [0, 3, 6], [1, 4, 7], [2, 5, 8],
        [0, 4, 8], [2, 4, 6]
    ]

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

        // If AI can't block then take middle square
        let centerSquare = 4
        if !isSquareOccupied(in: moves, forIndex: centerSquare) {
            return centerSquare
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
}

enum Player {
    case human, computer
}

struct Move {
    let player: Player
    let boardIndex: Int

    var indicator: String {
        return player == .human ? "xmark" : "circle"
    }
}

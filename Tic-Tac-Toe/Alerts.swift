//
//  Alerts.swift
//  Tic-Tac-Toe
//
//  Created by bogdanov on 10.05.21.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

enum AlertContext {
    static let humanWin = AlertItem(title: Text("You Win!"),
                                    message: Text("You are so smart. You beat your own AI."),
                                    buttonTitle: Text("Well done!"))

    static let computerWin = AlertItem(title: Text("You Lost"),
                                       message: Text("Try one more time."),
                                       buttonTitle: Text("Rematch"))

    static let draw = AlertItem(title: Text("Draw"),
                                message: Text("What a good battle!"),
                                buttonTitle: Text("Try Again"))
}

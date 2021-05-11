//
//  GameViewModel.swift
//  Tic-Tac-Toe
//
//  Created by bogdanov on 11.05.21.
//

import SwiftUI

final class GameViewModel: ObservableObject {
    
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
}

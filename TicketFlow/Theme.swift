//
//  Theme.swift
//  TicketFlow
//
//  Created by Laurence Alves Ribeiro on 05/09/26.
//

import SwiftUI
import UIKit

enum AppearanceMode: String, CaseIterable {
    case automatic = "Automático"
    case light = "Claro"
    case dark = "Escuro"

    var colorScheme: ColorScheme? {
        switch self {
        case .automatic:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}

extension Color {
    static let ticketFlowBlue = Color(
        UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor(
                    red: 0.31,
                    green: 0.56,
                    blue: 0.94,
                    alpha: 1
                )
            } else {
                return UIColor(
                    red: 0.10,
                    green: 0.24,
                    blue: 0.40,
                    alpha: 1
                )
            }
        }
    )

    static let ticketFlowCard = Color(
        UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor(
                    red: 0.11,
                    green: 0.11,
                    blue: 0.12,
                    alpha: 1
                )
            } else {
                return UIColor.white
            }
        }
    )

    static let ticketFlowBackground = Color(
        UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor.black
            } else {
                return UIColor(
                    red: 0.95,
                    green: 0.95,
                    blue: 0.97,
                    alpha: 1
                )
            }
        }
    )
}

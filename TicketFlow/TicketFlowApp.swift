//
//  TicketFlowApp.swift
//  TicketFlow
//
//  Created by Laurence Alves Ribeiro on 05/09/26.
//

import SwiftUI

@main
struct TicketFlowApp: App {
    @AppStorage("modoAparencia") private var modoAparencia = AppearanceMode.automatic.rawValue

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(
                    AppearanceMode(rawValue: modoAparencia)?.colorScheme
                )
        }
    }
}

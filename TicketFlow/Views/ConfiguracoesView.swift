//
//  ConfiguracoesView.swift
//  TicketFlow
//
//  Created by Laurence Alves Ribeiro on 05/09/26.
//

import SwiftUI

struct ConfiguracoesView: View {
    @AppStorage("modoAparencia")
    private var modoAparencia = AppearanceMode.automatic.rawValue

    var body: some View {
        Form {
            Section("Aparência") {
                Picker("Tema do aplicativo", selection: $modoAparencia) {
                    ForEach(AppearanceMode.allCases, id: \.rawValue) { modo in
                        Text(modo.rawValue)
                            .tag(modo.rawValue)
                    }
                }
            }
        }
        .navigationTitle("Configurações")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ConfiguracoesView()
}

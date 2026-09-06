//
//  HistoricoView.swift
//  TicketFlow
//
//  Created by Laurence Alves Ribeiro on 05/09/26.
//

import SwiftUI

struct HistoricoView: View {
    @State private var chamados: [Chamado] = []
    @State private var carregando = true
    @State private var erro: String?

    private let api = APIService()

    var body: some View {
        ZStack {
            Color.ticketFlowBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                if carregando {
                    Spacer()

                    ProgressView("Carregando histórico...")

                    Spacer()

                } else if let erro = erro {
                    Spacer()

                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)

                        Text("Não foi possível carregar o histórico")
                            .font(.headline)

                        Text(erro)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)

                        Button("Tentar novamente") {
                            Task {
                                await carregarHistorico()
                            }
                        }
                    }

                    Spacer()

                } else if chamados.isEmpty {
                    Spacer()

                    VStack(spacing: 12) {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.largeTitle)

                        Text("Nenhum chamado no histórico")
                            .font(.headline)

                        Text("Não existem chamados finalizados.")
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(chamados) { chamado in
                                NavigationLink {
                                    ChamadoDetalhesView(
                                        chamadoId: chamado.id
                                    )
                                } label: {
                                    HistoricoCard(chamado: chamado)
                                }
                            }
                        }
                        .padding(20)
                    }
                }
            }
        }
        .navigationTitle("Histórico")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await carregarHistorico()
        }
    }

    private func carregarHistorico() async {
        carregando = true
        erro = nil

        do {
            chamados = try await api.listarHistorico()
        } catch {
            erro = error.localizedDescription
        }

        carregando = false
    }
}

struct HistoricoCard: View {
    let chamado: Chamado

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("#\(chamado.id)")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color.ticketFlowBlue)

                Spacer()

                if let data = chamado.dataCriacao {
                    Text(data.prefix(10))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Text(chamado.titulo)
                .font(.headline)
                .foregroundStyle(.primary)

            HStack(spacing: 8) {
                StatusBadge(
                    text: chamado.status,
                    tipo: .status
                )

                if let prioridade = chamado.prioridade {
                    StatusBadge(
                        text: prioridade,
                        tipo: .prioridade
                    )
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.ticketFlowCard)
        .clipShape(
            RoundedRectangle(cornerRadius: 18)
        )
        .shadow(
            color: .black.opacity(0.06),
            radius: 8,
            y: 3
        )
    }
}

#Preview {
    HistoricoView()
}

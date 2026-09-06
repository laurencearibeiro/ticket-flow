//
//  ChamadoDetalhesView.swift
//  TicketFlow
//
//  Created by Laurence Alves Ribeiro on 05/09/26.
//

import SwiftUI

struct ChamadoDetalhesView: View {
    let chamadoId: Int

    @State private var chamado: Chamado?
    @State private var carregando = true
    @State private var erro: String?

    private let api = APIService()

    var body: some View {
        ZStack {
            Color.ticketFlowBackground
                .ignoresSafeArea()

            if carregando {
                ProgressView("Carregando chamado...")
                    .tint(Color.ticketFlowBlue)

            } else if let erro = erro {
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundStyle(.orange)

                    Text("Não foi possível carregar o chamado")
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Text(erro)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)

                    Button("Tentar novamente") {
                        Task {
                            await carregarChamado()
                        }
                    }
                    .foregroundStyle(Color.ticketFlowBlue)
                }
                .padding()

            } else if let chamado = chamado {
                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {

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
                            .font(.title2.weight(.bold))
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

                        if let categoria = chamado.categoria {
                            detalhe(
                                titulo: "Categoria",
                                valor: categoria
                            )
                        }

                        if let descricao = chamado.descricao {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Descrição")
                                    .font(.headline)
                                    .foregroundStyle(.primary)

                                Text(descricao)
                                    .foregroundStyle(.secondary)
                            }
                        }

                        VStack(alignment: .leading, spacing: 12) {
                            Text("Histórico de Atendimento")
                                .font(.headline)
                                .foregroundStyle(.primary)

                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: "circle.fill")
                                    .font(.caption)
                                    .foregroundStyle(Color.ticketFlowBlue)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Chamado criado")
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundStyle(.primary)

                                    Text("Aberto em \(chamado.dataCriacaoFormatada)")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .padding(16)
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )
                        .background(Color.ticketFlowCard)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 18)
                        )

                        NavigationLink {
                            EditarChamadoView(chamado: chamado)
                        } label: {
                            Text("Editar chamado")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(Color.ticketFlowBlue)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 14)
                                )
                        }
                    }
                    .padding(20)
                }
            }
        }
        .navigationTitle("Chamado #\(chamadoId)")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await carregarChamado()
        }
    }

    private func carregarChamado() async {
        carregando = true
        erro = nil

        do {
            chamado = try await api.buscarChamado(id: chamadoId)
        } catch {
            erro = error.localizedDescription
        }

        carregando = false
    }

    private func detalhe(titulo: String, valor: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(titulo)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(valor)
                .font(.body.weight(.medium))
                .foregroundStyle(.primary)
        }
    }
}

#Preview {
    ChamadoDetalhesView(chamadoId: 16)
}

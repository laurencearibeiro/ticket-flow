import SwiftUI

struct ChamadosView: View {
    @State private var chamados: [Chamado] = []
    @State private var carregando = true
    @State private var erro: String?

    @State private var chamadoParaExcluir: Chamado?
    @State private var mostrarConfirmacao = false

    private let api = APIService()

    var body: some View {
        ZStack {
            Color.ticketFlowBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                if carregando {
                    Spacer()

                    ProgressView("Carregando chamados...")
                        .tint(Color.ticketFlowBlue)
                        .foregroundStyle(.primary)

                    Spacer()

                } else if let erro = erro {
                    Spacer()

                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundStyle(.orange)

                        Text("Não foi possível carregar os chamados")
                            .font(.headline)
                            .foregroundStyle(.primary)

                        Text(erro)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)

                        Button("Tentar novamente") {
                            Task {
                                await carregarChamados()
                            }
                        }
                        .foregroundStyle(Color.ticketFlowBlue)
                    }

                    Spacer()

                } else if chamados.isEmpty {
                    Spacer()

                    VStack(spacing: 12) {
                        Image(systemName: "tray")
                            .font(.largeTitle)
                            .foregroundStyle(Color.ticketFlowBlue)

                        Text("Nenhum chamado encontrado")
                            .font(.headline)
                            .foregroundStyle(.primary)

                        Text("Você ainda não possui chamados ativos.")
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(chamados) { chamado in
                                HStack(spacing: 10) {

                                    NavigationLink {
                                        ChamadoDetalhesView(chamadoId: chamado.id)
                                    } label: {
                                        ChamadoCard(chamado: chamado)
                                    }

                                    Button {
                                        chamadoParaExcluir = chamado
                                        mostrarConfirmacao = true
                                    } label: {
                                        Image(systemName: "trash")
                                            .font(.headline)
                                            .foregroundStyle(.red)
                                            .frame(width: 44, height: 44)
                                            .background(Color.ticketFlowCard)
                                            .clipShape(
                                                RoundedRectangle(cornerRadius: 12)
                                            )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                        .padding(20)
                    }
                }
            }
        }
        .navigationTitle("Meus Chamados")
        .navigationBarTitleDisplayMode(.inline)

        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    NovoChamadoView()
                } label: {
                    Image(systemName: "plus")
                        .foregroundStyle(Color.ticketFlowBlue)
                }
            }
        }

        .task {
            await carregarChamados()
        }

        .confirmationDialog(
            "Excluir chamado?",
            isPresented: $mostrarConfirmacao,
            titleVisibility: .visible
        ) {
            Button("Excluir", role: .destructive) {
                guard let chamado = chamadoParaExcluir else {
                    return
                }

                Task {
                    do {
                        try await api.excluirChamado(id: chamado.id)
                        chamados.removeAll { $0.id == chamado.id }
                    } catch {
                        erro = error.localizedDescription
                    }
                }
            }

            Button("Cancelar", role: .cancel) {
                chamadoParaExcluir = nil
            }
        }
    }

    private func carregarChamados() async {
        carregando = true
        erro = nil

        do {
            chamados = try await api.listarChamados()
        } catch {
            erro = error.localizedDescription
        }

        carregando = false
    }
}


struct ChamadoCard: View {
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
                .multilineTextAlignment(.leading)

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

struct StatusBadge: View {
    enum Tipo {
        case status
        case prioridade
    }

    let text: String
    let tipo: Tipo

    var body: some View {
        Text(text)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(corFundo)
            .foregroundStyle(corTexto)
            .clipShape(Capsule())
    }

    private var corFundo: Color {
        switch tipo {
        case .status:
            return .blue.opacity(0.15)

        case .prioridade:
            switch text {
            case "Alta":
                return .red.opacity(0.15)

            case "Média":
                return .orange.opacity(0.15)

            case "Baixa":
                return .green.opacity(0.15)

            default:
                return .gray.opacity(0.15)
            }
        }
    }

    private var corTexto: Color {
        switch tipo {
        case .status:
            return .blue

        case .prioridade:
            switch text {
            case "Alta":
                return .red

            case "Média":
                return .orange

            case "Baixa":
                return .green

            default:
                return .gray
            }
        }
    }
}

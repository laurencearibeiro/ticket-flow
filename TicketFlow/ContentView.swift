import SwiftUI

struct ContentView: View {
    private let azulTicketFlow = Color.ticketFlowBlue

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 20) {

                    // Título
                    VStack(alignment: .leading, spacing: 6) {
                        Text("TicketFlow")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundStyle(azulTicketFlow)

                        Text("Sistema de chamados para empresas")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, 20)

                    // Cards principais
                    VStack(spacing: 14) {

                        NavigationLink {
                            NovoChamadoView()
                        } label: {
                            MenuCard(
                                icon: "ticket",
                                title: "Abertura de chamados",
                                description: "Registre solicitações de forma rápida."
                            )
                        }

                        NavigationLink {
                            ChamadosView()
                        } label: {
                            MenuCard(
                                icon: "checkmark.shield",
                                title: "Acompanhamento",
                                description: "Acompanhe o status dos seus chamados."
                            )
                        }

                        NavigationLink {
                            HistoricoView()
                        } label: {
                            MenuCard(
                                icon: "clock.arrow.circlepath",
                                title: "Histórico",
                                description: "Consulte atendimentos anteriores."
                            )
                        }
                    }
                    .padding(.horizontal, 20)

                    Spacer()

                    // Botão Meus Chamados
                    NavigationLink {
                        ChamadosView()
                    } label: {
                        Text("Ver meus chamados")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(azulTicketFlow)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 14)
                            )
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.top, 20)
                .padding(.bottom, 10)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        ConfiguracoesView()
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundStyle(azulTicketFlow)
                    }
                }
            }
        }
    }
}

struct MenuCard: View {
    let icon: String
    let title: String
    let description: String

    private let azulTicketFlow = Color.ticketFlowBlue

    var body: some View {
        HStack(spacing: 14) {

            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(azulTicketFlow)
                .frame(width: 46, height: 46)
                .background(
                    Color(.systemGray6)
                )
                .clipShape(
                    RoundedRectangle(cornerRadius: 12)
                )

            VStack(alignment: .leading, spacing: 4) {

                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
            }

            Spacer()
        }
        .padding(16)
        .background(
            Color.ticketFlowCard
        )
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
    ContentView()
}

//
//  EditarChamadoView.swift
//  TicketFlow
//
//  Created by Laurence Alves Ribeiro on 05/09/26.
//

import SwiftUI

struct EditarChamadoView: View {
    let chamado: Chamado

    @State private var titulo: String
    @State private var descricao: String
    @State private var categoria: String
    @State private var prioridade: String
    @State private var status: String
    @State private var salvando = false
    @State private var mensagem: String?

    private let api = APIService()

    let categorias = [
        "Análise",
        "Hardware",
        "Software",
        "Rede",
        "Acesso"
    ]

    let prioridades = [
        "Baixa",
        "Média",
        "Alta"
    ]

    let statusOptions = [
        "Aberto",
        "Em andamento",
        "Resolvido"
    ]

    init(chamado: Chamado) {
        self.chamado = chamado
        _titulo = State(initialValue: chamado.titulo)
        _descricao = State(initialValue: chamado.descricao ?? "")
        _categoria = State(initialValue: chamado.categoria ?? "Análise")
        _prioridade = State(initialValue: chamado.prioridade ?? "Média")
        _status = State(initialValue: chamado.status)
    }

    var body: some View {
        ZStack {
            Color.ticketFlowBackground
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    campoTexto(
                        titulo: "Título",
                        texto: $titulo
                    )

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Descrição")
                            .font(.headline)
                            .foregroundStyle(.primary)

                        TextEditor(text: $descricao)
                            .frame(minHeight: 140)
                            .padding(8)
                            .scrollContentBackground(.hidden)
                            .background(Color.ticketFlowCard)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 14)
                            )
                    }

                    campoSelecao(
                        titulo: "Categoria",
                        selecao: $categoria,
                        opcoes: categorias
                    )

                    campoSelecao(
                        titulo: "Prioridade",
                        selecao: $prioridade,
                        opcoes: prioridades
                    )

                    campoSelecao(
                        titulo: "Status",
                        selecao: $status,
                        opcoes: statusOptions
                    )

                    if let mensagem = mensagem {
                        Text(mensagem)
                            .font(.subheadline)
                            .foregroundStyle(.green)
                    }

                    Button {
                        Task {
                            await salvar()
                        }
                    } label: {
                        HStack {
                            if salvando {
                                ProgressView()
                                    .tint(.white)
                            }

                            Text(
                                salvando
                                ? "Salvando..."
                                : "Salvar alterações"
                            )
                            .font(.headline)
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color.ticketFlowBlue)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 14)
                        )
                    }
                    .disabled(salvando)
                }
                .padding(20)
            }
        }
        .navigationTitle("Editar Chamado")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func campoTexto(
        titulo: String,
        texto: Binding<String>
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(titulo)
                .font(.headline)
                .foregroundStyle(.primary)

            TextField(
                "Digite o título do chamado",
                text: texto
            )
            .padding()
            .background(Color.ticketFlowCard)
            .clipShape(
                RoundedRectangle(cornerRadius: 14)
            )
        }
    }

    private func campoSelecao(
        titulo: String,
        selecao: Binding<String>,
        opcoes: [String]
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(titulo)
                .font(.headline)
                .foregroundStyle(.primary)

            Picker(titulo, selection: selecao) {
                ForEach(opcoes, id: \.self) { opcao in
                    Text(opcao)
                        .tag(opcao)
                }
            }
            .pickerStyle(.menu)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color.ticketFlowCard)
            .clipShape(
                RoundedRectangle(cornerRadius: 14)
            )
        }
    }

    private func salvar() async {
        salvando = true
        mensagem = nil

        do {
            try await api.atualizarChamado(
                id: chamado.id,
                titulo: titulo,
                descricao: descricao,
                categoria: categoria,
                prioridade: prioridade,
                status: status
            )

            mensagem = "Chamado atualizado com sucesso."
        } catch {
            mensagem = "Erro ao atualizar: \(error.localizedDescription)"
        }

        salvando = false
    }
}

#Preview {
    EditarChamadoView(
        chamado: Chamado(
            id: 17,
            titulo: "Teste pelo aplicativo",
            cliente: "Usuário Mobile",
            descricao: "Chamado criado pelo aplicativo TicketFlow.",
            categoria: "Hardware",
            prioridade: "Alta",
            status: "Aberto",
            ativo: 1,
            dataCriacao: "2026-09-05T15:10:35"
        )
    )
}

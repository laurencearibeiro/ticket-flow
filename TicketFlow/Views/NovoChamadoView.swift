//
//  NovoChamadoView.swift
//  TicketFlow
//
//  Created by Laurence Alves Ribeiro on 05/09/26.
//

import SwiftUI

struct NovoChamadoView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var titulo = ""
    @State private var descricao = ""
    @State private var categoria = "Análise"
    @State private var prioridade = "Média"
    @State private var enviando = false
    @State private var erro: String?

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

    var body: some View {
        ZStack {
            Color.ticketFlowBackground
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    campoTexto(
                        titulo: "Título",
                        placeholder: "Digite o título do chamado",
                        texto: $titulo
                    )

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Descrição")
                            .font(.headline)
                            .foregroundStyle(.primary)

                        TextEditor(text: $descricao)
                            .frame(height: 130)
                            .padding(8)
                            .scrollContentBackground(.hidden)
                            .background(Color.ticketFlowCard)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 14)
                            )
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Categoria")
                            .font(.headline)
                            .foregroundStyle(.primary)

                        Picker("Categoria", selection: $categoria) {
                            ForEach(categorias, id: \.self) { categoria in
                                Text(categoria)
                                    .tag(categoria)
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

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Prioridade")
                            .font(.headline)
                            .foregroundStyle(.primary)

                        Picker("Prioridade", selection: $prioridade) {
                            ForEach(prioridades, id: \.self) { prioridade in
                                Text(prioridade)
                                    .tag(prioridade)
                            }
                        }
                        .pickerStyle(.segmented)
                    }

                    if let erro = erro {
                        Text(erro)
                            .font(.subheadline)
                            .foregroundStyle(.red)
                    }

                    Button {
                        Task {
                            await abrirChamado()
                        }
                    } label: {
                        if enviando {
                            ProgressView()
                                .tint(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                        } else {
                            Text("Abrir chamado")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                        }
                    }
                    .background(Color.ticketFlowBlue)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 14)
                    )
                    .disabled(
                        titulo.trimmingCharacters(
                            in: .whitespacesAndNewlines
                        ).isEmpty ||
                        descricao.trimmingCharacters(
                            in: .whitespacesAndNewlines
                        ).isEmpty ||
                        enviando
                    )
                    .padding(.top, 10)
                }
                .padding(20)
            }
        }
        .navigationTitle("Novo Chamado")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func abrirChamado() async {
        enviando = true
        erro = nil

        do {
            try await api.criarChamado(
                titulo: titulo,
                descricao: descricao,
                categoria: categoria,
                prioridade: prioridade
            )

            dismiss()
        } catch {
            erro = "Não foi possível abrir o chamado."
        }

        enviando = false
    }

    private func campoTexto(
        titulo: String,
        placeholder: String,
        texto: Binding<String>
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(titulo)
                .font(.headline)
                .foregroundStyle(.primary)

            TextField(placeholder, text: texto)
                .padding()
                .background(Color.ticketFlowCard)
                .clipShape(
                    RoundedRectangle(cornerRadius: 14)
                )
        }
    }
}

#Preview {
    NovoChamadoView()
}

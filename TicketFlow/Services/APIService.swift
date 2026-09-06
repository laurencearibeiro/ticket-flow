//
//  APIService.swift
//  TicketFlow
//
//  Created by Laurence Alves Ribeiro on 05/09/26.
//

import Foundation

class APIService {

    // Endereço da nossa API Flask
    private let baseURL = "http://127.0.0.1:5001/api"

    // MARK: - Listar chamados

    func listarChamados() async throws -> [Chamado] {

        guard let url = URL(string: "\(baseURL)/chamados") else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode([Chamado].self, from: data)
    }


    // MARK: - Buscar chamado por ID

    func buscarChamado(id: Int) async throws -> Chamado {

        guard let url = URL(string: "\(baseURL)/chamados/\(id)") else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(Chamado.self, from: data)
    }
    
    // MARK: - Criar chamado

    func criarChamado(
        titulo: String,
        descricao: String,
        categoria: String,
        prioridade: String
    ) async throws {

        guard let url = URL(string: "\(baseURL)/chamados") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )

        let dados: [String: String] = [
            "titulo": titulo,
            "cliente": "Usuário Mobile",
            "descricao": descricao,
            "categoria": categoria,
            "prioridade": prioridade,
            "status": "Aberto"
        ]

        request.httpBody = try JSONSerialization.data(
            withJSONObject: dados
        )

        let (_, response) = try await URLSession.shared.data(
            for: request
        )

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }
    // MARK: - Atualizar chamado

    func atualizarChamado(
        id: Int,
        titulo: String,
        descricao: String,
        categoria: String,
        prioridade: String,
        status: String
    ) async throws {

        guard let url = URL(string: "\(baseURL)/chamados/\(id)") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"

        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )

        let dados: [String: String] = [
            "titulo": titulo,
            "descricao": descricao,
            "categoria": categoria,
            "prioridade": prioridade,
            "status": status
        ]

        request.httpBody = try JSONSerialization.data(
            withJSONObject: dados
        )

        let (_, response) = try await URLSession.shared.data(
            for: request
        )

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }
    // MARK: - Histórico

    func listarHistorico() async throws -> [Chamado] {
        guard let url = URL(string: "\(baseURL)/chamados/historico") else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode([Chamado].self, from: data)
    }
    func excluirChamado(id: Int) async throws {
        guard let url = URL(string: "\(baseURL)/chamados/\(id)") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
    }
}

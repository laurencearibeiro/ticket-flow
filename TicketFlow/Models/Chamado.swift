//
//  Chamado.swift
//  TicketFlow
//
//  Created by Laurence Alves Ribeiro on 05/09/26.
//

import Foundation

struct Chamado: Identifiable, Codable {
    let id: Int
    let titulo: String
    let cliente: String
    let descricao: String?
    let categoria: String?
    let prioridade: String?
    let status: String
    let ativo: Int
    let dataCriacao: String?
    
    var dataCriacaoFormatada: String {
        guard let dataCriacao = dataCriacao else {
            return "-"
        }

        let entrada = DateFormatter()
        entrada.locale = Locale(identifier: "en_US_POSIX")
        entrada.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        let saida = DateFormatter()
        saida.locale = Locale(identifier: "pt_BR")
        saida.dateFormat = "dd/MM/yyyy 'às' HH:mm"

        guard let data = entrada.date(from: dataCriacao) else {
            return dataCriacao
        }

        return saida.string(from: data)
    }

    enum CodingKeys: String, CodingKey {
        case id
        case titulo
        case cliente
        case descricao
        case categoria
        case prioridade
        case status
        case ativo
        case dataCriacao = "data_criacao"
    }
}

from flask import Flask, render_template, request, redirect, jsonify
import mysql.connector

app = Flask(__name__)


# ==========================================
# CONEXÃO COM O BANCO DE DADOS
# ==========================================

conexao = mysql.connector.connect(
    host="localhost",
    user="root",
    password="",
    database="ticketflow"
)


# ==========================================
# ROTAS DO SITE WEB
# ==========================================

@app.route("/")
def landing():
    return render_template("index.html")


@app.route("/crud", methods=["GET", "POST"])
def crud():

    if request.method == "POST":

        titulo = request.form["titulo"]
        cliente = request.form["cliente"]
        status = request.form["status"]

        cursor = conexao.cursor()

        sql = """
        INSERT INTO chamados
        (titulo, cliente, status)
        VALUES
        (%s, %s, %s)
        """

        valores = (
            titulo,
            cliente,
            status
        )

        cursor.execute(sql, valores)

        conexao.commit()

    cursor = conexao.cursor(dictionary=True)

    cursor.execute("""
        SELECT *
        FROM chamados
        WHERE ativo = 1
        ORDER BY id DESC
    """)

    chamados = cursor.fetchall()

    return render_template(
        "editar.html",
        chamados=chamados
    )


@app.route("/excluir/<int:id>")
def excluir(id):

    cursor = conexao.cursor()

    sql = """
    UPDATE chamados
    SET ativo = 0
    WHERE id = %s
    """

    cursor.execute(sql, (id,))

    conexao.commit()

    return redirect("/crud")


@app.route("/historico")
def historico():

    cursor = conexao.cursor(dictionary=True)

    cursor.execute("""
        SELECT *
        FROM chamados
        WHERE ativo = 0
        ORDER BY id DESC
    """)

    chamados = cursor.fetchall()

    return render_template(
        "historico.html",
        chamados=chamados
    )


@app.route("/editar/<int:id>", methods=["GET", "POST"])
def editar(id):

    cursor = conexao.cursor(dictionary=True)

    if request.method == "POST":

        titulo = request.form["titulo"]
        cliente = request.form["cliente"]
        status = request.form["status"]

        cursor.execute(
            """
            UPDATE chamados
            SET
                titulo = %s,
                cliente = %s,
                status = %s
            WHERE id = %s
            """,
            (
                titulo,
                cliente,
                status,
                id
            )
        )

        conexao.commit()

        return redirect("/crud")

    cursor.execute(
        """
        SELECT *
        FROM chamados
        WHERE id = %s
        """,
        (id,)
    )

    chamado = cursor.fetchone()

    return render_template(
        "editar_chamado.html",
        chamado=chamado
    )


# ==========================================
# API REST - TICKETFLOW MOBILE
# ==========================================


# ------------------------------------------
# GET - LISTAR CHAMADOS ATIVOS
# ------------------------------------------

@app.route("/api/chamados", methods=["GET"])
def api_listar_chamados():

    cursor = conexao.cursor(dictionary=True)

    cursor.execute("""
        SELECT
            id,
            titulo,
            cliente,
            descricao,
            categoria,
            prioridade,
            status,
            ativo,
            data_criacao
        FROM chamados
        WHERE ativo = 1
        ORDER BY id DESC
    """)

    chamados = cursor.fetchall()

    for chamado in chamados:
        if chamado["data_criacao"]:
            chamado["data_criacao"] = chamado["data_criacao"].isoformat()

    return jsonify(chamados)


# ------------------------------------------
# GET - BUSCAR UM CHAMADO
# ------------------------------------------

@app.route("/api/chamados/<int:id>", methods=["GET"])
def api_buscar_chamado(id):

    cursor = conexao.cursor(dictionary=True)

    cursor.execute(
        """
        SELECT
            id,
            titulo,
            cliente,
            descricao,
            categoria,
            prioridade,
            status,
            ativo,
            data_criacao
        FROM chamados
        WHERE id = %s
        """,
        (id,)
    )

    chamado = cursor.fetchone()

    if not chamado:
        return jsonify({
            "erro": "Chamado não encontrado"
        }), 404

    if chamado["data_criacao"]:
        chamado["data_criacao"] = chamado["data_criacao"].isoformat()

    return jsonify(chamado)


# ------------------------------------------
# POST - CRIAR NOVO CHAMADO
# ------------------------------------------

@app.route("/api/chamados", methods=["POST"])
def api_criar_chamado():

    dados = request.get_json()

    if not dados:
        return jsonify({
            "erro": "Nenhum dado foi enviado"
        }), 400

    titulo = dados.get("titulo")
    descricao = dados.get("descricao")
    categoria = dados.get("categoria")
    prioridade = dados.get("prioridade")

    cliente = dados.get(
        "cliente",
        "Usuário Mobile"
    )

    status = "Aberto"

    if not titulo:
        return jsonify({
            "erro": "O título é obrigatório"
        }), 400

    cursor = conexao.cursor()

    sql = """
    INSERT INTO chamados
    (
        titulo,
        cliente,
        descricao,
        categoria,
        prioridade,
        status,
        ativo
    )
    VALUES
    (%s, %s, %s, %s, %s, %s, 1)
    """

    valores = (
        titulo,
        cliente,
        descricao,
        categoria,
        prioridade,
        status
    )

    cursor.execute(sql, valores)

    conexao.commit()

    novo_id = cursor.lastrowid

    return jsonify({
        "mensagem": "Chamado criado com sucesso",
        "id": novo_id
    }), 201


# ------------------------------------------
# PUT - EDITAR CHAMADO
# ------------------------------------------

@app.route("/api/chamados/<int:id>", methods=["PUT"])
def api_editar_chamado(id):

    dados = request.get_json()

    if not dados:
        return jsonify({
            "erro": "Nenhum dado foi enviado"
        }), 400

    cursor = conexao.cursor(dictionary=True)

    cursor.execute(
        """
        SELECT id
        FROM chamados
        WHERE id = %s
        """,
        (id,)
    )

    chamado = cursor.fetchone()

    if not chamado:
        return jsonify({
            "erro": "Chamado não encontrado"
        }), 404

    titulo = dados.get("titulo")
    descricao = dados.get("descricao")
    categoria = dados.get("categoria")
    prioridade = dados.get("prioridade")
    status = dados.get("status")

    cursor.execute(
        """
        UPDATE chamados
        SET
            titulo = %s,
            descricao = %s,
            categoria = %s,
            prioridade = %s,
            status = %s
        WHERE id = %s
        """,
        (
            titulo,
            descricao,
            categoria,
            prioridade,
            status,
            id
        )
    )

    conexao.commit()

    return jsonify({
        "mensagem": "Chamado atualizado com sucesso"
    })

# ------------------------------------------
# DELETE - EXCLUIR CHAMADO
# ------------------------------------------

@app.route("/api/chamados/<int:id>", methods=["DELETE"])
def api_excluir_chamado(id):
    cursor = conexao.cursor(dictionary=True)
    cursor.execute(
        """
        SELECT id
        FROM chamados
        WHERE id = %s
          AND ativo = 1
        """,
        (id,)
    )
    chamado = cursor.fetchone()
    if not chamado:
        return jsonify({
            "erro": "Chamado não encontrado"
        }), 404
    cursor.execute(
        """
        UPDATE chamados
        SET ativo = 0
        WHERE id = %s
        """,
        (id,)
    )
    conexao.commit()
    return jsonify({
        "mensagem": "Chamado excluído com sucesso"
    })


# ------------------------------------------
# GET - HISTÓRICO
# ------------------------------------------

@app.route("/api/chamados/historico", methods=["GET"])
def api_historico():

    cursor = conexao.cursor(dictionary=True)

    cursor.execute("""
        SELECT
            id,
            titulo,
            cliente,
            descricao,
            categoria,
            prioridade,
            status,
            ativo,
            data_criacao
        FROM chamados
        WHERE ativo = 0
        ORDER BY id DESC
    """)

    chamados = cursor.fetchall()

    for chamado in chamados:
        if chamado["data_criacao"]:
            chamado["data_criacao"] = chamado["data_criacao"].isoformat()

    return jsonify(chamados)


# ==========================================
# EXECUÇÃO
# ==========================================

if __name__ == "__main__":
    app.run(
        host="0.0.0.0",
        port=5001,
        debug=True
    )
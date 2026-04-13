*** Settings ***
Resource    base.robot

*** Variables ***
${URL}    https://compassuol.serverest.dev

*** Keywords ***

Criar Body Produto
    [Arguments]    ${nome}    ${preco}    ${descricao}    ${quantidade}
    [Return]    &{body}
    &{body}    Create Dictionary
    ...    nome=${nome}
    ...    preco=${preco}
    ...    descricao=${descricao}
    ...    quantidade=${quantidade}

#---POST---
Cadastrar Novo Produto
    [Arguments]    ${preco}    ${descricao}    ${quantidade}

    &{headers}    Create Dictionary    Authorization=Bearer ${TOKEN}    Content-Type=application/json

    ${nome}    FakerLibrary.Word
    &{body}    Criar Body Produto    ${nome}    ${preco}    ${descricao}    ${quantidade}

    ${response}    POST    url=${URL}/produtos    json=&{body}    expected_status=201    headers=&{headers}

    VAR    ${ID_PRODUTO}           ${response.json()["_id"]}    scope=TEST
    VAR    ${QUANTIDADE_PRODUTO}    ${quantidade}               scope=TEST
    VAR    ${RESPONSE_PRODUTO}      ${response}                 scope=TEST
    VAR    ${NOME_PRODUTO}          ${nome}                     scope=TEST
    VAR    ${PRECO_PRODUTO}         ${preco}                    scope=TEST
    VAR    ${DESCRICAO_PRODUTO}     ${descricao}                scope=TEST

Cadastrar Novo Produto Inválido
    [Arguments]    ${preco}    ${descricao}    ${quantidade}    ${status_esperado}

    &{headers}    Create Dictionary    Authorization=Bearer ${TOKEN}    Content-Type=application/json

    ${nome}    Generate Random String    length=10    chars=[LETTERS]
    &{body}    Criar Body Produto    ${nome}    ${preco}    ${descricao}    ${quantidade}

    ${response}    POST    url=${URL}/produtos    json=&{body}    expected_status=${status_esperado}    headers=&{headers}
    VAR    ${RESPONSE_PRODUTO}    ${response}    scope=TEST

Cadastrar Novo Produto Com Nome Já Utilizado
    [Arguments]    ${nome}    ${preco}    ${descricao}    ${quantidade}

    &{headers}    Create Dictionary    Authorization=Bearer ${TOKEN}    Content-Type=application/json
    &{body}    Criar Body Produto    ${nome}    ${preco}    ${descricao}    ${quantidade}

    ${response}    POST    url=${URL}/produtos    json=&{body}    expected_status=400    headers=&{headers}

Cadastrar Novo Produto Sem Permissão
    [Arguments]    ${preco}    ${descricao}    ${quantidade}

    &{headers}    Create Dictionary    Authorization=Bearer token_invalido    Content-Type=application/json
    ${nome}    Generate Random String    length=10    chars=[LETTERS]
    &{body}    Criar Body Produto    ${nome}    ${preco}    ${descricao}    ${quantidade}

    ${response}    POST    url=${URL}/produtos    json=&{body}    expected_status=401    headers=&{headers}

#---GET---
Buscar Produto Pelo ID
    ${response}    GET    url=${URL}/produtos/${ID_PRODUTO}
    VAR    ${RESPONSE_GET_PRODUTO}    ${response}    scope=TEST

Buscar Produto Pelo ID Inválido
    ${response}    GET    url=${URL}/produtos/id_invalido    expected_status=any
    VAR    ${RESPONSE_GET_PRODUTO}    ${response}    scope=TEST

Buscar Produtos Sem ID
    ${response}    GET    url=${URL}/produtos    expected_status=200
    VAR    ${RESPONSE_GET_PRODUTO}    ${response}    scope=TEST

Buscar Produto Por ID Inexistente
    ${response}    GET    url=${URL}/produtos/000000000000000000000000    expected_status=400
    VAR    ${RESPONSE_GET_PRODUTO}    ${response}    scope=TEST

#---PUT---
Alterar Produto
    [Arguments]    ${preco}    ${descricao}    ${quantidade}    ${status_esperado}

    &{headers}    Create Dictionary    Authorization=Bearer ${TOKEN}    Content-Type=application/json
    ${nome}    FakerLibrary.Word
    &{body}    Criar Body Produto    ${nome}    ${preco}    ${descricao}    ${quantidade}

    ${response}    PUT    url=${URL}/produtos/${ID_PRODUTO}    json=&{body}    expected_status=${status_esperado}    headers=&{headers}
    VAR    ${RESPONSE_PRODUTO}      ${response}     scope=TEST
    VAR    ${NOME_PRODUTO}          ${nome}         scope=TEST
    VAR    ${PRECO_PRODUTO}         ${preco}        scope=TEST
    VAR    ${DESCRICAO_PRODUTO}     ${descricao}    scope=TEST
    VAR    ${QUANTIDADE_PRODUTO}    ${quantidade}   scope=TEST

Alterar Produto Para Nome Já Utilizado
    [Arguments]    ${nome}    ${preco}    ${descricao}    ${quantidade}    ${status_esperado}

    &{headers}    Create Dictionary    Authorization=Bearer ${TOKEN}    Content-Type=application/json
    &{body}    Criar Body Produto    ${nome}    ${preco}    ${descricao}    ${quantidade}

    PUT    url=${URL}/produtos/${ID_PRODUTO}    json=&{body}    expected_status=${status_esperado}    headers=&{headers}

Alterar Produto Invalido
    [Arguments]    ${preco}    ${descricao}    ${quantidade}    ${status_esperado}

    &{headers}    Create Dictionary    Authorization=Bearer ${TOKEN}    Content-Type=application/json
    ${nome}    Generate Random String    length=10    chars=[LETTERS]
    &{body}    Criar Body Produto    ${nome}    ${preco}    ${descricao}    ${quantidade}

    PUT    url=${URL}/produtos/id_invalido    json=&{body}    expected_status=${status_esperado}    headers=&{headers}

#---DELETE---
Excluir Produto
    [Arguments]    ${status_esperado}
    &{headers}    Create Dictionary    Authorization=Bearer ${TOKEN}
    DELETE    url=${URL}/produtos/${ID_PRODUTO}    headers=&{headers}    expected_status=${status_esperado}

#---VERIFICAÇÃO---
Verificar JSON Da Response Do Produto
    ${produto}    GET    url=${URL}/produtos/${ID_PRODUTO}    expected_status=200
    Should Be Equal As Strings     ${produto.json()["nome"]}        ${NOME_PRODUTO}
    Should Be Equal As Integers    ${produto.json()["preco"]}       ${PRECO_PRODUTO}
    Should Be Equal As Strings     ${produto.json()["descricao"]}   ${DESCRICAO_PRODUTO}
    Should Be Equal As Integers    ${produto.json()["quantidade"]}  ${QUANTIDADE_PRODUTO}

Verificar o Status Code
    [Arguments]    ${status_esperado}
    Should Be Equal As Integers    ${RESPONSE_GET_PRODUTO.status_code}    ${status_esperado}

Verificar a quantidade de produtos no estoque
    [Arguments]    ${id}    ${id_2}

    ${produto_response}    GET    url=${URL}/produtos/${id}    expected_status=200
    ${produto_response2}    GET    url=${URL}/produtos/${id_2}    expected_status=200

Verificar a quantidade de produtos no estoque após criação do carrinho
    [Arguments]    ${id}

    ${produto_response}    GET    url=${URL}/produtos/${id}    expected_status=200

    ${quantidade_nova}    Evaluate    int(${QUANTIDADE_PRODUTO}) - int(${QUANTIDADE_PRODUTO2_CARRINHO})
    Should Be Equal    ${quantidade_nova}        ${produto_response.json()["quantidade"]}

Verificar se os produtos retornaram ao estoque
    [Arguments]    ${id}

    ${produto_response}    GET    url=${URL}/produtos/${id}    expected_status=200
    Should Be Equal    ${produto_response.json()["quantidade"]}    ${QUANTIDADE_PRODUTO}

Verificar Se Os Produtos Não Retornaram Ao Estoque
    [Arguments]    ${id}

    ${produto_response}    GET    url=${URL}/produtos/${id}    expected_status=200
    Should Not Be Equal    ${produto_response.json()["quantidade"]}    ${QUANTIDADE_PRODUTO}

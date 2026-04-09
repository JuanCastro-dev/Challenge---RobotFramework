*** Settings ***
Resource    base.robot

*** Variables ***
${URL}              https://compassuol.serverest.dev
${CANCELAR}         carrinhos/cancelar-compra
${CONCLUIR}         carrinhos/concluir-compra
${EMAIL_ADMIN}      fulano@qa.com
${SENHA_ADMIN}      teste

*** Keywords ***

#------------------------------------------- KeyWords para Login -------------------------------------------
Fazer login com o email "${EMAIL}" e a senha "${PASSWORD}"
    ${body}    Create Dictionary
    ...    email=${EMAIL}
    ...    password=${PASSWORD}

    ${login_response}    POST    url=${URL}/login    json=${body}    expected_status=200

    ${login_response_json}    Set Variable    ${login_response.json()}

    Set Test Variable   ${TOKEN}     ${login_response_json["authorization"]}
    VAR    ${TOKEN}    ${TOKEN.replace("Bearer","").replace(" ","")}    scope=TEST

Fazer login inválido com o email "${EMAIL}" e a senha "${PASSWORD}"
    [Arguments]    ${status_esperado}

    ${body}    Create Dictionary
    ...    email=${EMAIL}
    ...    password=${PASSWORD}

    ${login_response}    POST    url=${URL}/login    json=${body}    expected_status=${status_esperado}

Fazer login com payload incompleto com o email "${EMAIL}"
    ${body}    Create Dictionary
    ...    email=${EMAIL}

    ${login_response}    POST    url=${URL}/login    json=${body}    expected_status=400

#------------------------------------------- KeyWords para Produtos -------------------------------------------
#---POST---
Cadastrar Novo Produto
    [Arguments]    ${preco}    ${descricao}    ${quantidade}

    &{headers}    Create Dictionary    Authorization=Bearer ${TOKEN}    Content-Type=application/json

    ${nome}    FakerLibrary.Word

    ${body}    Create Dictionary
    ...    nome=${nome}
    ...    preco=${preco}
    ...    descricao=${descricao}
    ...    quantidade=${quantidade}

    ${response}    POST    url=${URL}/produtos    json=${body}    expected_status=201    headers=&{headers}

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

    ${body}    Create Dictionary
    ...    nome=${nome}
    ...    preco=${preco}
    ...    descricao=${descricao}
    ...    quantidade=${quantidade}

    ${response}    POST    url=${URL}/produtos    json=${body}    expected_status=${status_esperado}    headers=&{headers}
    VAR    ${RESPONSE_PRODUTO}    ${response}    scope=TEST

Cadastrar Novo Produto Com Nome Já Utilizado
    [Arguments]    ${nome}    ${preco}    ${descricao}    ${quantidade}

    &{headers}    Create Dictionary    Authorization=Bearer ${TOKEN}    Content-Type=application/json

    ${body}    Create Dictionary
    ...    nome=${nome}
    ...    preco=${preco}
    ...    descricao=${descricao}
    ...    quantidade=${quantidade}

    ${response}    POST    url=${URL}/produtos    json=${body}    expected_status=400    headers=&{headers}

Cadastrar Novo Produto Sem Permissão
    [Arguments]    ${preco}    ${descricao}    ${quantidade}

    &{headers}    Create Dictionary    Authorization=Bearer token_invalido    Content-Type=application/json

    ${nome}    Generate Random String    length=10    chars=[LETTERS]

    ${body}    Create Dictionary
    ...    nome=${nome}
    ...    preco=${preco}
    ...    descricao=${descricao}
    ...    quantidade=${quantidade}

    ${response}    POST    url=${URL}/produtos    json=${body}    expected_status=401    headers=&{headers}

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

    ${body}    Create Dictionary
    ...    nome=${nome}
    ...    preco=${preco}
    ...    descricao=${descricao}
    ...    quantidade=${quantidade}

    ${response}    PUT    url=${URL}/produtos/${ID_PRODUTO}    json=${body}    expected_status=${status_esperado}    headers=&{headers}
    VAR    ${RESPONSE_PRODUTO}      ${response}     scope=TEST
    VAR    ${NOME_PRODUTO}          ${nome}         scope=TEST
    VAR    ${PRECO_PRODUTO}         ${preco}        scope=TEST
    VAR    ${DESCRICAO_PRODUTO}     ${descricao}    scope=TEST
    VAR    ${QUANTIDADE_PRODUTO}    ${quantidade}   scope=TEST

Alterar Produto Para Nome Já Utilizado
    [Arguments]    ${nome}    ${preco}    ${descricao}    ${quantidade}    ${status_esperado}

    &{headers}    Create Dictionary    Authorization=Bearer ${TOKEN}    Content-Type=application/json

    ${body}    Create Dictionary
    ...    nome=${nome}
    ...    preco=${preco}
    ...    descricao=${descricao}
    ...    quantidade=${quantidade}

    PUT    url=${URL}/produtos/${ID_PRODUTO}    json=${body}    expected_status=${status_esperado}    headers=&{headers}

Alterar Produto Invalido
    [Arguments]    ${preco}    ${descricao}    ${quantidade}    ${status_esperado}

    &{headers}    Create Dictionary    Authorization=Bearer ${TOKEN}    Content-Type=application/json

    ${nome}    Generate Random String    length=10    chars=[LETTERS]

    ${body}    Create Dictionary
    ...    nome=${nome}
    ...    preco=${preco}
    ...    descricao=${descricao}
    ...    quantidade=${quantidade}

    PUT    url=${URL}/produtos/id_invalido    json=${body}    expected_status=${status_esperado}    headers=&{headers}

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

#------------------------------------------- KeyWords para POST em Carrinhos -------------------------------------------
Cadastrar Novo Carrinho
    [Arguments]    ${idProduto1}    ${quantidade1}    ${idProduto2}    ${quantidade2}

    &{headers}     Create Dictionary    Authorization=Bearer ${TOKEN}    Content-Type=application/json

    &{produto1}    Create Dictionary    idProduto=${idProduto1}    quantidade=${quantidade1}
    &{produto2}    Create Dictionary    idProduto=${idProduto2}    quantidade=${quantidade2}
    @{produtos}    Create List          ${produto1}    ${produto2}
    &{body}        Create Dictionary    produtos=${produtos}

    ${response}    POST    url=${URL}/carrinhos    json=&{body}    expected_status=201    headers=&{headers}

    VAR    ${ID_CARRINHO}                  ${response.json()["_id"]}    scope=TEST
    VAR    ${QUANTIDADE_PRODUTO2_CARRINHO}    ${quantidade2}              scope=TEST

Cadastrar Novo Carrinho Sem Token Válido
    [Arguments]    ${idProduto1}    ${quantidade1}    ${idProduto2}    ${quantidade2}

    &{headers}     Create Dictionary    Authorization=Bearer token_invalido    Content-Type=application/json

    &{produto1}    Create Dictionary    idProduto=${idProduto1}    quantidade=${quantidade1}
    &{produto2}    Create Dictionary    idProduto=${idProduto2}    quantidade=${quantidade2}
    @{produtos}    Create List          ${produto1}    ${produto2}
    &{body}        Create Dictionary    produtos=${produtos}

    ${response}    POST    url=${URL}/carrinhos    json=&{body}    expected_status=401    headers=&{headers}

Cadastrar Novo Carrinho Inválido
    [Arguments]    ${idProduto1}    ${quantidade1}    ${idProduto2}    ${quantidade2}

    &{headers}     Create Dictionary    Authorization=Bearer ${TOKEN}    Content-Type=application/json

    &{produto1}    Create Dictionary    idProduto=${idProduto1}    quantidade=${quantidade1}
    &{produto2}    Create Dictionary    idProduto=${idProduto2}    quantidade=${quantidade2}
    @{produtos}    Create List          ${produto1}    ${produto2}
    &{body}        Create Dictionary    produtos=${produtos}

    ${response}    POST    url=${URL}/carrinhos    json=&{body}    expected_status=400    headers=&{headers}

Cadastrar Carrinho Novamente
    [Arguments]    ${idProduto1}    ${quantidade1}    ${idProduto2}    ${quantidade2}

    &{headers}     Create Dictionary    Authorization=Bearer ${TOKEN}    Content-Type=application/json

    &{produto1}    Create Dictionary    idProduto=${idProduto1}    quantidade=${quantidade1}
    &{produto2}    Create Dictionary    idProduto=${idProduto2}    quantidade=${quantidade2}
    @{produtos}    Create List          ${produto1}    ${produto2}
    &{body}        Create Dictionary    produtos=${produtos}

    ${response}    POST    url=${URL}/carrinhos    json=&{body}    expected_status=400    headers=&{headers}

#------------------------------------------- KeyWords para GET em Carrinhos -------------------------------------------

Listar Todos Os Carrinhos
    ${response}    GET    url=${URL}/carrinhos    expected_status=200
    VAR    ${RESPONSE_GET_CARRINHO}    ${response}    scope=TEST

Buscar Carrinho Pelo ID
    ${response}    GET    url=${URL}/carrinhos/${ID_CARRINHO}    expected_status=200
    VAR    ${RESPONSE_GET_CARRINHO}    ${response}    scope=TEST

#------------------------------------------- KeyWords para DELETE em Carrinhos -------------------------------------------

Cancelar uma compra
    &{headers}     Create Dictionary    Authorization=Bearer ${TOKEN}

    DELETE    url=${URL}/${CANCELAR}    headers=&{headers}

Cancelar Uma Compra Token Inválido
    &{headers}     Create Dictionary    Authorization=Bearer token_invalido

    DELETE    url=${URL}/${CANCELAR}    headers=&{headers}    expected_status=401

Cancelar Uma Compra Sem Carrinho Vinculado
    &{headers}     Create Dictionary    Authorization=Bearer ${TOKEN}

    DELETE    url=${URL}/${CANCELAR}    headers=&{headers}    expected_status=400

Concluir Uma Compra
    &{headers}     Create Dictionary    Authorization=Bearer ${TOKEN}

    DELETE    url=${URL}/${CONCLUIR}    headers=&{headers}    expected_status=200

Concluir Uma Compra Sem Carrinho Vinculado
    &{headers}     Create Dictionary    Authorization=Bearer ${TOKEN}

    DELETE    url=${URL}/${CONCLUIR}    headers=&{headers}    expected_status=400

Verificar Se Os Produtos Não Retornaram Ao Estoque
    [Arguments]    ${id}

    ${produto_response}    GET    url=${URL}/produtos/${id}    expected_status=200
    Should Not Be Equal    ${produto_response.json()["quantidade"]}    ${QUANTIDADE_PRODUTO}

#------------------------------------------- KeyWords para Usuários -------------------------------------------

Criar novo usuário como admin
    [Arguments]    ${nome}    ${email}    ${password}    ${administrador}

    ${body}    Create Dictionary
    ...    nome=${nome}
    ...    email=${email}
    ...    password=${password}
    ...    administrador=${administrador}

    POST    url=${URL}/usuarios    json=${body}    expected_status=201

Fazer login como admin e garantir que não tenha carrinho já criado
    ${EMAIL_GERADO}    FakerLibrary.Email
    Criar novo usuário como admin    Tester    ${EMAIL_GERADO}    123456    true
    Fazer login com o email "${EMAIL_GERADO}" e a senha "123456"
    Cancelar uma compra

Fazer login como admin
    ${EMAIL_GERADO}    FakerLibrary.Email
    Criar novo usuário como admin    Tester    ${EMAIL_GERADO}    123456    true
    Fazer login com o email "${EMAIL_GERADO}" e a senha "123456"
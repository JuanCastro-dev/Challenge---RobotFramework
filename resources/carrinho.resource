*** Settings ***
Resource    base.robot

*** Variables ***
${URL}          https://compassuol.serverest.dev
${CANCELAR}     carrinhos/cancelar-compra
${CONCLUIR}     carrinhos/concluir-compra

*** Keywords ***

Criar Body Carrinho
    [Arguments]    ${idProduto1}    ${quantidade1}    ${idProduto2}    ${quantidade2}
    [Return]    &{body}
    &{produto1}    Create Dictionary    idProduto=${idProduto1}    quantidade=${quantidade1}
    &{produto2}    Create Dictionary    idProduto=${idProduto2}    quantidade=${quantidade2}
    @{produtos}    Create List          ${produto1}    ${produto2}
    &{body}        Create Dictionary    produtos=${produtos}

#---POST---
Cadastrar Novo Carrinho
    [Arguments]    ${idProduto1}    ${quantidade1}    ${idProduto2}    ${quantidade2}

    &{headers}     Create Dictionary    Authorization=Bearer ${TOKEN}    Content-Type=application/json
    &{body}    Criar Body Carrinho    ${idProduto1}    ${quantidade1}    ${idProduto2}    ${quantidade2}

    ${response}    POST    url=${URL}/carrinhos    json=&{body}    expected_status=201    headers=&{headers}

    VAR    ${ID_CARRINHO}                    ${response.json()["_id"]}    scope=TEST
    VAR    ${QUANTIDADE_PRODUTO2_CARRINHO}    ${quantidade2}              scope=TEST

Cadastrar Novo Carrinho Sem Token Válido
    [Arguments]    ${idProduto1}    ${quantidade1}    ${idProduto2}    ${quantidade2}

    &{headers}     Create Dictionary    Authorization=Bearer token_invalido    Content-Type=application/json
    &{body}    Criar Body Carrinho    ${idProduto1}    ${quantidade1}    ${idProduto2}    ${quantidade2}

    ${response}    POST    url=${URL}/carrinhos    json=&{body}    expected_status=401    headers=&{headers}

Cadastrar Novo Carrinho Inválido
    [Arguments]    ${idProduto1}    ${quantidade1}    ${idProduto2}    ${quantidade2}

    &{headers}     Create Dictionary    Authorization=Bearer ${TOKEN}    Content-Type=application/json
    &{body}    Criar Body Carrinho    ${idProduto1}    ${quantidade1}    ${idProduto2}    ${quantidade2}

    ${response}    POST    url=${URL}/carrinhos    json=&{body}    expected_status=400    headers=&{headers}

Cadastrar Carrinho Novamente
    [Arguments]    ${idProduto1}    ${quantidade1}    ${idProduto2}    ${quantidade2}

    &{headers}     Create Dictionary    Authorization=Bearer ${TOKEN}    Content-Type=application/json
    &{body}    Criar Body Carrinho    ${idProduto1}    ${quantidade1}    ${idProduto2}    ${quantidade2}

    ${response}    POST    url=${URL}/carrinhos    json=&{body}    expected_status=400    headers=&{headers}

#---GET---
Listar Todos Os Carrinhos
    ${response}    GET    url=${URL}/carrinhos    expected_status=200
    VAR    ${RESPONSE_GET_CARRINHO}    ${response}    scope=TEST

Buscar Carrinho Pelo ID
    ${response}    GET    url=${URL}/carrinhos/${ID_CARRINHO}    expected_status=200
    VAR    ${RESPONSE_GET_CARRINHO}    ${response}    scope=TEST

#---DELETE---
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

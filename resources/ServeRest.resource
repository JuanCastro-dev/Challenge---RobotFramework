*** Settings ***
Library    SeleniumLibrary
Library    RequestsLibrary
Library    Collections
Library    String

*** Variables ***
${URL}           https://compassuol.serverest.dev
${CANCELAR}      carrinhos/cancelar-compra

*** Keywords ***

#------------------------------------------- KeyWords para Login -------------------------------------------
Fazer login com o email "${EMAIL}" e a senha "${PASSWORD}"
    ${body}    Create Dictionary
    ...    email=${EMAIL}
    ...    password=${PASSWORD}
    Log    ${body}

    ${login_response}    POST    url=${URL}/login    json=${body}    expected_status=200

    ${login_response_json}    Set Variable    ${login_response.json()}

    Log To Console  ${login_response_json}

    Set Test Variable   ${TOKEN}     ${login_response_json["authorization"]}
    VAR    ${TOKEN}    ${TOKEN.replace("Bearer","").replace(" ","")}    scope=TEST
        
    Log    ${TOKEN}

Fazer login inválido com o email "${EMAIL}" e a senha "${PASSWORD}"
    [Arguments]    ${status_esperado}
    
    ${body}    Create Dictionary
    ...    email=${EMAIL}
    ...    password=${PASSWORD}
    Log    ${body}

    ${login_response}    POST    url=${URL}/login    json=${body}    expected_status=${status_esperado}

#------------------------------------------- KeyWords para Produtos -------------------------------------------
Cadastrar Novo Produto
    [Arguments]    ${preco}    ${descricao}    ${quantidade}
    
    &{headers}    Create Dictionary    Authorization=Bearer ${TOKEN}    Content-Type=application/json

    ${palavra_aleatoria}  Generate Random String    length=10  chars=[LETTERS]
    
    ${body}    Create Dictionary    
    ...    nome=${palavra_aleatoria}
    ...    preco=${preco}
    ...    descricao=${descricao}
    ...    quantidade=${quantidade}
    Log    ${body}

    ${response}    POST    url=${URL}/produtos    json=${body}    expected_status=201  headers=&{headers}

    ${response_json}  Set Variable    ${response.json()}

    VAR    ${ID_PRODUTO}            ${response_json["_id"]}           scope=TEST
    VAR    ${QUANTIDADE_PRODUTO}    ${quantidade}    scope=TEST

Cadastrar Novo Produto Inválido
    [Arguments]    ${preco}    ${descricao}    ${quantidade}    ${status_esperado}

    &{headers}    Create Dictionary    Authorization=Bearer ${TOKEN}    Content-Type=application/json

    ${palavra_aleatoria}  Generate Random String    length=10  chars=[LETTERS]

    ${body}    Create Dictionary
    ...    nome=${palavra_aleatoria}
    ...    preco=${preco}
    ...    descricao=${descricao}
    ...    quantidade=${quantidade}
    Log    ${body}

    ${response}    POST    url=${URL}/produtos    json=${body}    expected_status=${status_esperado}  headers=&{headers}

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


#------------------------------------------- KeyWords para Carrinhos -------------------------------------------
Cadastrar Novo Carrinho
    [Arguments]    ${idProduto1}    ${quantidade1}    ${idProduto2}    ${quantidade2}
    
    &{headers}     Create Dictionary        Authorization=Bearer ${TOKEN}    Content-Type=application/json

    &{produto1}    Create Dictionary        idProduto=${idProduto1}    quantidade=${quantidade1}
    &{produto2}    Create Dictionary        idProduto=${idProduto2}    quantidade=${quantidade2}
    @{produtos}    Create List              ${produto1}    ${produto2}
    &{body}        Create Dictionary        produtos=${produtos}
    
    ${response}    POST   url=${URL}/carrinhos   json=&{body}   expected_status=201   headers=&{headers}

     VAR    ${QUANTIDADE_PRODUTO2_CARRINHO}            ${quantidade2}           scope=TEST


Cancelar uma compra
    &{headers}     Create Dictionary        Authorization=Bearer ${TOKEN}
        
    DELETE    url=${URL}/${CANCELAR}    headers=&{headers}

Fazer login com "fulano@qa.com" e garantir que não tenha carrinho já criado
        Fazer login com o email "fulano@qa.com" e a senha "teste"
        Cancelar uma compra
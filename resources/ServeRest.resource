*** Settings ***
Library    SeleniumLibrary
Library    RequestsLibrary
Library    Collections
Library    String

*** Variables ***
${URL}    https://compassuol.serverest.dev
${CANCELAR}    carrinhos/cancelar-compra

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

    ${response}    POST    url=${URL}/produtos    json=${body}    expected_status=any  headers=&{headers}
    
    IF    ${response.status_code} == 201
        ${response_json}  Set Variable    ${response.json()}
        VAR    ${ID_PRODUTO}    ${response_json["_id"]}    scope=TEST
        
        Log    ${ID_PRODUTO}

    ELSE
        Log To Console    O produto com dados inválidos não foi cadastrado
    END


#------------------------------------------- KeyWords para Carrinhos -------------------------------------------
Cadastrar Novo Carrinho
    [Arguments]    ${idProduto1}    ${quantidade1}    ${idProduto2}    ${quantidade2}
    
    &{headers}     Create Dictionary        Authorization=Bearer ${TOKEN}    Content-Type=application/json

    &{produto1}    Create Dictionary        idProduto=${idProduto1}    quantidade=${quantidade1}
    &{produto2}    Create Dictionary        idProduto=${idProduto2}    quantidade=${quantidade2}
    @{produtos}    Create List              ${produto1}    ${produto2}
    &{body}        Create Dictionary        produtos=${produtos}
    
    ${response}    POST   url=${URL}/carrinhos   json=&{body}   expected_status=201   headers=&{headers}


Cancelar uma compra
    &{headers}     Create Dictionary        Authorization=Bearer ${TOKEN}
        
    DELETE    url=${URL}/${CANCELAR}    headers=&{headers}
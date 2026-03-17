*** Settings ***
Library    SeleniumLibrary
Library    RequestsLibrary

*** Variables ***
${URL}    https://compassuol.serverest.dev

*** Keywords ***

#Keywords para login
Fazer login com o email "${EMAIL}" e a senha "${PASSWORD}"
    ${body}    Create Dictionary
    ...    email=${EMAIL}
    ...    password=${PASSWORD}
    Log    ${body}

    ${login_response}    POST    url=${URL}/login    json=${body}    expected_status=any
    
    IF    ${login_response.status_code} == 200
        ${login_response_json}    Set Variable    ${login_response.json()}

        Log To Console  ${login_response_json}

        Set Test Variable   ${TOKEN}     ${login_response_json["authorization"]}
        VAR    ${TOKEN}    ${TOKEN.replace("Bearer","").replace(" ","")}    scope=TEST
        
        Log    ${TOKEN}
    ELSE
        Log To Console        Não foi possivel realizar o login
    END

#Keywords para produtos
Cadastrar Novo Produto
    [Arguments]    ${nome}    ${preco}    ${descricao}    ${quantidade}
    
    &{headers}    Create Dictionary    Authorization=Bearer ${TOKEN}    Content-Type=application/json
    
    ${body}    Create Dictionary    
    ...    nome=${nome}
    ...    preco=${preco}
    ...    descricao=${descricao}
    ...    quantidade=${quantidade}
    Log    ${body}

    POST    url=${URL}/produtos    json=${body}    expected_status=201  headers=&{headers}
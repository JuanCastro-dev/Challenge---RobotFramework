*** Settings ***
Resource    base.robot
Resource    ../resources/carrinho.resource

*** Variables ***
${URL}              https://compassuol.serverest.dev
${EMAIL_ADMIN}      fulano@qa.com
${SENHA_ADMIN}      teste

*** Keywords ***

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

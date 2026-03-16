*** Settings ***
Library    SeleniumLibrary
Library    RequestsLibrary

*** Variables ***
${URL}    https://compassuol.serverest.dev

*** Keywords ***

Criar Sessão na ServeRest
    ${headers}  Create Dictionary    accept=application/json    Content-Type=application/json
    Create Session    alias=ServeRest

Fazer login com o email "${EMAIL}" e a senha "${PASSWORD}"
    ${body}    Create Dictionary   
    ...    email=${EMAIL}
    ...    password=${PASSWORD}
    Log    ${body}

    POST    url=${URL}/login    json=${body}    expected_status=200
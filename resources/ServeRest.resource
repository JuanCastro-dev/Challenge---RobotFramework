*** Settings ***
Library    SeleniumLibrary
Library    RequestsLibrary

*** Variables ***
${URL}    https://compassuol.serverest.dev

*** Keywords ***

Fazer login com o email "${EMAIL}" e a senha "${PASSWORD}"
    ${body}    Create Dictionary   
    ...    email=${EMAIL}
    ...    password=${PASSWORD}
    Log    ${body}

    ${login_response}    POST    url=${URL}/login    json=${body}    expected_status=200
    ${login_response_json}    Set Variable    ${login_response.json()}

    Log To Console  ${login_response_json}
    
    ${TOKEN}    Set Variable    ${login_response_json["authorization"]}
    ${TOKEN}    Set Variable    ${TOKEN.replace("Bearer","").replace(" ","")}
    
    Log    ${TOKEN}
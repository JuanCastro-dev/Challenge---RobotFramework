*** Settings ***
Documentation    Essa suíte testa o endpoint /login da aplicação ServeRest
Resource    ../resources/ServeRest.resource

*** Test Cases ***
Tl01 - Login válido
    [Documentation]    Realizar login com dados válidos e usuário cadastrado
    [Tags]    login    valid
    Fazer login com o email "fulano@qa.com" e a senha "teste"
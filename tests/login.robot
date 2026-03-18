*** Settings ***
Documentation    Essa suíte testa o endpoint /login da aplicação ServeRest
Resource    ../resources/ServeRest.resource

*** Test Cases ***
Tl-01 - Login válido
    [Documentation]    Realizar login com dados válidos e usuário cadastrado
    [Tags]    login    valid
    Fazer login com o email "fulano@qa.com" e a senha "teste"

Tl-02 - Login com dados inválidos
    [Documentation]    Realizar login com dados inválidos
    [Tags]    login    invalid
    Fazer login inválido com o email "teste." e a senha ""    400
    
Tl-03 - Login com usuário não cadastrado
    [Documentation]    Realizar login com dados inválidos
    [Tags]    login    invalid
    Fazer login inválido com o email "testesemuser@email.com" e a senha "123456"    401

Tl-04 - Login com senha incorreta
    [Documentation]    Realizar login com dados inválidos
    [Tags]    login    invalid
    Fazer login inválido com o email "fulano@qa.com" e a senha "123456"    401
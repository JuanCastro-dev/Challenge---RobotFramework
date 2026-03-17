*** Settings ***
Documentation    Essa suíte testa o endpoint /produtos da aplicação ServeRest
Resource    ../resources/ServeRest.resource

*** Test Cases ***

TP02 - Cadastrar um produto com dados válidos
    [Documentation]    Cadastrar um produto com dados válidos e com admin autenticado
    [Tags]    products    valid
    Fazer login com o email "fulano@qa.com" e a senha "teste"
    Cadastrar Novo Produto   tablet   2500   eletrônicos   201

TP03 - Cadastrar um produto com dados inválidos
    [Documentation]    Cadastrar um produto com dados inválidos e com admin autenticado
    [Tags]    products    invalid
    Fazer login com o email "fulano@qa.com" e a senha "teste"
    Cadastrar Novo Produto   tablet%¨78   doismil   eletrônicos   trezentos

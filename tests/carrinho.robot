*** Settings ***
Documentation    Essa suíte testa o endpoint /carrinhos da aplicação ServeRest
Resource    ../resources/ServeRest.resource

*** Test Cases ***

TC02 - Cadastrar um carrinho com sucesso
    [Documentation]    Cadastrar um carrinho com dados válidos e com um token válido
    [Tags]    cart    valid
    Fazer login com o email "fulano@qa.com" e a senha "teste"
    Cadastrar Novo Carrinho    BeeJh5lz3k6kSIzA    2    YaeJ455lz3k6kSIzA    3
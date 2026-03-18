*** Settings ***
Documentation    Essa suíte testa o endpoint /carrinhos da aplicação ServeRest
Resource    ../resources/ServeRest.resource
Test Setup    Fazer login com "fulano@qa.com" e garantir que não tenha carrinho já criado

*** Test Cases ***

TC01 - Cadastrar um carrinho com sucesso
    [Documentation]    Cadastrar um carrinho com dados válidos e com um token válido
    [Tags]    cart    valid    post

    Cadastrar Novo Produto   500   eletrodomésticos   100
    Verificar a quantidade de produtos no estoque    BeeJh5lz3k6kSIzA    ${ID_PRODUTO}
    Cadastrar Novo Carrinho    BeeJh5lz3k6kSIzA    2    ${ID_PRODUTO}    3
    Verificar a quantidade de produtos no estoque após criação do carrinho    ${ID_PRODUTO}
    
TC03 - Cancelar uma compra com sucesso
    [Documentation]    Cancelar uma compra, excluindo o carrinho e retornando os produtos ao estoque
    [Tags]    cart    valid    delete

    Cadastrar Novo Produto   500   eletrodomesticos   105
    Cadastrar Novo Carrinho                           BeeJh5lz3k6kSIzA    5    ${ID_PRODUTO}    10
    Verificar a quantidade de produtos no estoque após criação do carrinho    ${ID_PRODUTO}
    Cancelar uma compra
    #Bug encontrado, a quantidade de produtos não corresponde
    Verificar se os produtos retornaram ao estoque    ${ID_PRODUTO}
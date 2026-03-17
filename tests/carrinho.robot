*** Settings ***
Documentation    Essa suíte testa o endpoint /carrinhos da aplicação ServeRest
Resource    ../resources/ServeRest.resource

*** Test Cases ***

TC02 - Cadastrar um carrinho com sucesso
    [Documentation]    Cadastrar um carrinho com dados válidos e com um token válido
    [Tags]    cart    valid    post
    Fazer login com o email "fulano@qa.com" e a senha "teste"
    Cadastrar Novo Produto   500   eletrodomésticos   105
    Cadastrar Novo Carrinho    BeeJh5lz3k6kSIzA    2    ${ID_PRODUTO}    3
    
TC11 - Cancelar uma compra com sucesso    
    [Documentation]    Cancelar uma compra, excluindo o carrinho e retornando os produtos ao estoque
    [Tags]    cart    valid    delete
    Fazer login com o email "fulano@qa.com" e a senha "teste"
    Cancelar uma compra
    #Verificar se os produtos retornaram ao estoque
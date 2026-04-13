*** Settings ***
Documentation    Essa suíte testa o endpoint /carrinhos da aplicação ServeRest
Resource    ../resources/login.resource
Resource    ../resources/produtos.resource
Resource    ../resources/carrinho.resource
Test Setup    Fazer login como admin e garantir que não tenha carrinho já criado

*** Test Cases ***

TC-01 - Cadastrar um carrinho com sucesso
    [Documentation]    Cadastrar um carrinho com dados válidos e com um token válido
    [Tags]    cart    valid    post

    Cadastrar Novo Produto   500   eletrodomésticos   100
    Verificar a quantidade de produtos no estoque    BeeJh5lz3k6kSIzA    ${ID_PRODUTO}
    Cadastrar Novo Carrinho    BeeJh5lz3k6kSIzA    2    ${ID_PRODUTO}    3
    Verificar a quantidade de produtos no estoque após criação do carrinho    ${ID_PRODUTO}

TC-02 - Cadastrar um carrinho sem um token válido
    [Documentation]    Cadastrar um carrinho com dados válidos e com um token inválido
    [Tags]    cart    invalid    post

    Cadastrar Novo Produto   500   eletrodomésticos   100
    Verificar a quantidade de produtos no estoque    BeeJh5lz3k6kSIzA    ${ID_PRODUTO}
    Cadastrar Novo Carrinho Sem Token Válido    BeeJh5lz3k6kSIzA    2    ${ID_PRODUTO}    3

TC-03 - Cadastrar um carrinho com quantidade excedente de produtos
    [Documentation]    Cadastrar um carrinho com mais produtos que o estoque e token válido
    [Tags]    cart    invalid    post

    Cadastrar Novo Produto   500   eletrodomésticos   100
    Verificar a quantidade de produtos no estoque    BeeJh5lz3k6kSIzA    ${ID_PRODUTO}
    Cadastrar Novo Carrinho Inválido    BeeJh5lz3k6kSIzA    2    ${ID_PRODUTO}    200
    
TC-04 - Cadastrar um carrinho com um token já vinculado
    [Documentation]    Cadastrar um carrinho com dados válidos e com um token já vinculado a outro carrinho
    [Tags]    cart    invalid    post

    Cadastrar Novo Produto   500   eletrodomésticos   100
    Verificar a quantidade de produtos no estoque    BeeJh5lz3k6kSIzA    ${ID_PRODUTO}
    Cadastrar Novo Carrinho    BeeJh5lz3k6kSIzA    2    ${ID_PRODUTO}    3
    Cadastrar Carrinho Novamente    BeeJh5lz3k6kSIzA    8    ${ID_PRODUTO}    4

TC-05 - Cadastrar Carrinho Com O Mesmo Produto Duplicado No Array De Itens
    [Documentation]    Cadastrar um carrinho com o mesmo produto duplicado no array de itens e verificar status 400
    [Tags]    cart    invalid    post    genAI

    Cadastrar Novo Produto    500    eletrônicos    100
    Cadastrar Novo Carrinho Inválido    ${ID_PRODUTO}    2    ${ID_PRODUTO}    6

TC-06 - Cadastrar Carrinho Com Produto De Quantidade Negativa
    [Documentation]    Cadastrar um carrinho com um produto de quantidade negativa e verificar status 400
    [Tags]    cart    invalid    post    genAI

    Cadastrar Novo Produto    500    eletrônicos    100
    Cadastrar Novo Carrinho Inválido    BeeJh5lz3k6kSIzA    -2    ${ID_PRODUTO}    6
        
TC-07 - Cadastrar Novo Carrinho Com Um Produto Inexistente
    [Documentation]    Cadastrar um carrinho com um produto de ID inexistente e verificar status 400
    [Tags]    cart    invalid    post    genAI

    Cadastrar Novo Carrinho Inválido    id_produto_inexistente    2    BeeJh5lz3k6kSIzA    3

TC-08 - Cancelar uma compra com sucesso
    [Documentation]    Cancelar uma compra, excluindo o carrinho e retornando os produtos ao estoque
    [Tags]    cart    valid    delete

    Cadastrar Novo Produto   500   eletrodomesticos   105
    Cadastrar Novo Carrinho  BeeJh5lz3k6kSIzA    5    ${ID_PRODUTO}    10
    Verificar a quantidade de produtos no estoque após criação do carrinho    ${ID_PRODUTO}
    Cancelar uma compra
    Verificar se os produtos retornaram ao estoque    ${ID_PRODUTO}

TC-09 - Cancelar uma compra sem um token válido
    [Documentation]    Cancelar uma compra, excluindo o carrinho utilizando um token inválido
    [Tags]    cart    invalid    delete

    Cadastrar Novo Produto   500   eletrodomesticos   105
    Cadastrar Novo Carrinho                          BeeJh5lz3k6kSIzA    5    ${ID_PRODUTO}    10
    Verificar a quantidade de produtos no estoque após criação do carrinho    ${ID_PRODUTO}
    Cancelar Uma Compra Token Inválido

TC-10 - Cancelar uma compra sem um carrinho existente
    [Documentation]    Cancelar uma compra com um token sem carrinho vinculado
    [Tags]    cart    invalid    delete

    Cancelar Uma Compra Sem Carrinho Vinculado

TC-11 - Concluir uma compra com sucesso
    [Documentation]    Concluir uma compra, excluindo o carrinho sem retornar os produtos ao estoque
    [Tags]    cart    valid    delete

    Cadastrar Novo Produto                                   500    eletrodomesticos    105
    Cadastrar Novo Carrinho                                  BeeJh5lz3k6kSIzA    5    ${ID_PRODUTO}    10
    Verificar a quantidade de produtos no estoque após criação do carrinho    ${ID_PRODUTO}
    Concluir Uma Compra
    Verificar Se Os Produtos Não Retornaram Ao Estoque       ${ID_PRODUTO}

TC-12 - Concluir Uma Compra Sem Carrinho Existente
    [Documentation]    Concluir uma compra com um token sem carrinho vinculado e verificar status 400
    [Tags]    cart    invalid    delete    genAI

    Concluir Uma Compra Sem Carrinho Vinculado

TC-13 - Listar Todos Os Carrinhos
    [Documentation]    Listar todos os carrinhos cadastrados e verificar status 200
    [Tags]    cart    valid    get    genAI
    [Setup]    No Operation

    Listar Todos Os Carrinhos

TC-14 - Buscar Carrinho Pelo Id
    [Documentation]    Buscar um carrinho pelo ID após cadastro e verificar status 200
    [Tags]    cart    valid    get    genAI

    Cadastrar Novo Produto    500    eletrodomesticos    100
    Cadastrar Novo Carrinho    BeeJh5lz3k6kSIzA    2    ${ID_PRODUTO}    3
    Buscar Carrinho Pelo ID
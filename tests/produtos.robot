*** Settings ***
Documentation    Essa suíte testa o endpoint /produtos da aplicação ServeRest
Resource         ../resources/ServeRest.resource
Test Setup       Fazer login com o email "${EMAIL_ADMIN}" e a senha "${SENHA_ADMIN}"

*** Test Cases ***

TP-01 - Cadastrar um produto com dados válidos
    [Documentation]    Cadastrar um produto com dados válidos e com admin autenticado
    [Tags]    products    valid

    Cadastrar Novo Produto    2500    eletrônicos    201

TP-02 - Cadastrar um produto com dados inválidos
    [Documentation]    Cadastrar um produto com dados inválidos e com admin autenticado
    [Tags]    products    invalid

    Cadastrar Novo Produto Inválido    doismil    eletrônicos    trezentos    400

TP-03 - Cadastrar um produto com nome já utilizado
    [Documentation]    Cadastrar um produto com nome já utilizado e com admin autenticado
    [Tags]    products    invalid

    Cadastrar Novo Produto Com Nome Já Utilizado    Logitech MX Vertical    2500    eletrônicos    201

TP-04 - Cadastrar um produto sem permissão
    [Documentation]    Cadastrar um produto com dados válidos e sem admin autenticado
    [Tags]    products    invalid
    [Setup]    No Operation

    Cadastrar Novo Produto Sem Permissão    2500    eletrônicos    401

TP-05 - Buscar Produto Com ID Válido
    [Documentation]    Buscar um produto pelo ID após cadastro
    [Tags]    products    valid

    Cadastrar Novo Produto    2500    eletrônicos    201
    Buscar Produto Pelo ID
    Verificar o Status Code    200

TP-06 - Buscar Produto Com ID Inválido
    [Documentation]    Buscar um produto com ID inválido e verificar status 400
    [Tags]    products    invalid
    [Setup]    No Operation

    Buscar Produto Pelo ID Inválido
    Verificar o Status Code    400

TP-07 - Buscar Todos os Produtos
    [Documentation]    Buscar a lista de produtos sem informar ID e verificar status 200
    [Tags]    products    valid
    [Setup]    No Operation

    Buscar Produtos Sem ID
    Verificar o Status Code    200

TP-08 - Buscar Produto Com ID Inexistente
    [Documentation]    Buscar um produto com ID válido no formato mas inexistente na base e verificar status 400
    [Tags]    products    invalid
    [Setup]    No Operation

    Buscar Produto Por ID Inexistente
    Verificar o Status Code    400

TP-09 - Alterar Produto Válido
    [Documentation]    Alterar um produto existente com dados válidos e admin autenticado
    [Tags]    products    valid    genAI

    Cadastrar Novo Produto    2500    eletrônicos    201
    Alterar Produto    1800    eletrônicos    150    200

TP-10 - Alterar Um Produto Para Um Nome Já Utilizado
    [Documentation]    Alterar um produto usando um nome já cadastrado e verificar status 400
    [Tags]    products    invalid    genAI

    Cadastrar Novo Produto    2500    eletrônicos    201
    Alterar Produto Para Nome Já Utilizado    Logitech MX Vertical    1800    eletrônicos    150    400

TP-11 - Alterar Produto Com ID Invalido
    [Documentation]    Alterar um produto com ID inválido e verificar status 400
    [Tags]    products    invalid    genAI

    Alterar Produto Invalido    1800    eletrônicos    150    400

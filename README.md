# Challenge---RobotFramework
## Objetivo do projeto
O projeto tem como objetivo criar uma suíte de testes automatizados para a API: https://compassuol.serverest.dev/.

Os endpoints prioritários da aplicação são os que garantem a compra e cancelamento seguro, sendo eles: 
- /login
- /carrinhos
- /carrinhos/cancelar-compra

Por necessidade da criação de uma massa de dados, o endpoint /produtos com o verbo POST, que cria protutos, também foi testado.

## Instalação de dependências e recursos necessários

O projeto foi criado na linguagem python utilizando o RobotFramework, seguem a lista de dependências e demais recursos que serão necessários para a execução com seus respectivos comeandos para a instalação:
- Ao utilizar uma IDE como PyCharm ou VSCode é RECOMENDADO a instalação de uma extensão para facilitar edições no código
- Python (3.14 Recomendado)
- RobotFramework: *pip install robotframework*
- SeleniumLibrary: *pip install --upgrade robotframework-seleniumlibrary*
- Requests: *pip install --upgrade robotframework-requests*

## Como executar os testes

Os testes já estão todos automatizados, para a execução e salvamento dos resultados nos repositórios corretos, utilize os seguintes códigos no terminal dentro da pasta do projeto:
- Testes do endpoint /produtos: *python -m robot -d ./results/log_produtos ./tests/produtos.robot*
- Testes do endpoint /login: *python -m robot -d ./results/log_login ./tests/login.robot*
- Testes do endpoint /carrinhos: *python -m robot -d ./results/log_carrinho ./tests/carrinho.robot*

## Como visualizar evidências

Os logs/reports serão salvos na pasta *results* em seu respectivo diretório após a execução pelos códigos mencionados acima.

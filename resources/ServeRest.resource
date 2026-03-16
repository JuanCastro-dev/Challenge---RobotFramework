*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}    https://compassuol.serverest.dev

*** Keywords ***

Fazer login com o email "${EMAIL}" e a senha "${PASSWORD}"
    ${body}    Create Dictionary   
    ...    email=${EMAIL}
    ...    password=${PASSWORD}
    Log    ${body}
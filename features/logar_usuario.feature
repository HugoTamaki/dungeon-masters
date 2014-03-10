#language: pt

Funcionalidade: Logar no sistema

    Contexto: Devo estar na página de sign in
              Dado que eu esteja na página de sign in

    @javascript
    Cenário: Devo poder me logar com um usuário válido
        Dado que exista um usuário de email "abc@gmail.com" e password "11111111"
        Quando eu preencho os campos de email com "abc@gmail.com" e password "11111111"
        E eu clico no botão "Sign in"
        Então eu devo estar na página de histórias
        E eu devo ver a mensagem "Signed in successfully."

    @javascript
    Cenário: Não devo poder me logar com um usuário inválido
        Dado que não exista um usuário de email "nao_existo@gmail.com" e password 11111111
        Quando eu preencho os campos de email com "nao_existo@gmail.com" e password "11111111"
        E eu clico no botão "Sign in"
        Então eu devo estar na página de Sign in
        E eu devo ver a mensagem "Invalid email or password."

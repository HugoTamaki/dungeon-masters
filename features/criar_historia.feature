#language: pt

Funcionalidade: Criar uma história corretamente

    Contexto: Devo estar na página inicial
              Dado que eu esteja logado como usuário "abc@exemplo.com" e password "11111111"

    @javascript
    Cenário: Criar uma história corretamente
        Dado que eu esteja na página inicial
        E eu clique no link "New Story"
        Quando eu preencho os campos da história com "titulo", "resumo" e "preludio"
        E eu clico no botão "Next"
        Então eu devo estar na página de edição de capítulos
        E eu devo ver a mensagem "Story was successfully created."

    @javascript
    Cenário: Criar uma história com erros
        Dado que eu esteja na página inicial
        E eu clique no link "New Story"
        Quando eu preencho os campos da história com "", "" e ""
        E eu clico no botão "Next"
        Então eu devo estar na página de criação de história
        E eu devo ver a mensagem "some parameters are missing"


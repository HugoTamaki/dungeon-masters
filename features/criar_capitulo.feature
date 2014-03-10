#language: pt

Funcionalidade: Criar um capitulo corretamente

    Contexto: Devo estar na página de edição de capítulos
              Dado que eu esteja logado como usuário "abc@exemplo.com" e password "11111111"

    @javascript
    Cenário: Criar um capítulo corretamente
        Dado que eu tenha criado uma nova história corretamente com "titulo", "resumo" e "preludio"
        E eu esteja na página de edição de capítulos
        Quando eu preencho a referência e o conteúdo com "1" e "conteúdo"
        E eu clico no botão "Save"
        Então eu devo estar na página de edição de capítulos
        E eu devo ver a mensagem "Story was successfully saved."

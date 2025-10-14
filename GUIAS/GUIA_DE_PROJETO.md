# 📖 Guia de Gerenciamento de Projetos com GitHub

Este guia apresenta uma **SUGESTÃO** fluxo de trabalho passo a passo para organizar os projetos da disciplina usando as ferramentas do GitHub. O objetivo é criar um ambiente padronizado onde cada grupo possa gerenciar suas tarefas, prazos e entregas de forma clara e eficiente.

## Estratégia Geral

Utilizaremos uma metodologia baseada em "Épicos" e "Sub-tarefas" para organizar o trabalho:

- **Issue Principal (Épico):** Uma issue central para cada grupo, que contém o plano geral e um checklist das grandes entregas.
- **Sub-issues (Tarefas):** Cada item do checklist do épico é convertido em uma issue menor e mais detalhada, com responsáveis e prazos específicos.
- **Branches de Grupo:** Cada grupo trabalha em sua própria branch de desenvolvimento para não interferir no trabalho dos outros.
- **Branches de Tarefa:** Cada sub-issue é desenvolvida em uma branch própria, garantindo o isolamento do trabalho.

---

## Passo 1: Criando a Issue Principal (Épico) do seu Grupo

A primeira etapa é criar um "painel de controle" para o seu grupo.

1.  Na aba **Issues** do repositório, clique em **New Issue**.
2.  Selecione o template **"📝 Novo Projeto de Grupo"**.
3.  **Preencha as informações:**
    - **Título:** Altere o `[Grupo X]` para o número do seu grupo e `[Título do Projeto]` para o tema escolhido. (Ex: `[Grupo 6] Estudo de Viabilidade: Data Center Modular`).
    - **Equipe:** `@mencione` os nomes de usuário do GitHub de todos os integrantes do seu grupo.
    - **Descrição do Escopo:** Copie e cole a descrição do tema do seu trabalho.
4.  Clique em **Submit new issue**.

## Passo 2: Configurando Labels e Milestones

Para organizar e rastrear o progresso, vamos usar etiquetas (Labels) e marcos de entrega (Milestones).

1.  **Criando as Labels:**

    - Vá para **Issues > Labels** e crie as seguintes etiquetas:
      - `grupo-X` (substitua o X pelo número do seu grupo): Para identificar suas tarefas.
      - `todo`: Para tarefas que ainda não foram iniciadas.
      - `doing`: Para tarefas em andamento.
      - `done`: Para tarefas concluídas.

2.  **Criando os Milestones (Prazos):**
    - Vá para **Issues > Milestones** e clique em **New milestone**.
    - Crie um milestone para cada grande entrega da disciplina, incluindo o prazo final.
      - **Exemplo 1:** `Grupo X - Proposta` (Due date: 29/10)
      - **Exemplo 2:** `Grupo X - Etapa 1` (Due date: 14/11)

## Passo 3: Criando a Branch do Grupo

Para isolar o trabalho do seu grupo, crie uma branch de desenvolvimento a partir da sua issue principal.

1.  Abra a sua **Issue Principal (Épico)**.
2.  Na barra lateral direita, em **Development**, clique em **Create a branch**.
3.  Nomeie a branch com o padrão `gX-<nome-do-projeto>` (Ex: `g6-data-center-modular`).
4.  Confirme a criação.

## Passo 4: Quebrando o Trabalho em Sub-issues

Agora, vamos transformar as grandes entregas do seu checklist em tarefas menores e gerenciáveis.

1.  Dentro da sua **Issue Principal**, encontre o checklist de entregas.
2.  Ao lado de cada item (ex: `- [ ] Proposta (Entrega em 29/10)`), clique no ícone de três pontos e selecione **"Convert to issue"**.
3.  O GitHub criará uma nova issue ("sub-issue") e a vinculará automaticamente ao seu épico.
4.  **Para cada sub-issue criada:**
    - Abra-a e adicione um **descritivo detalhado** com o objetivo e um checklist de ações.
    - Na barra lateral, configure os **Assignees** (responsáveis), as **Labels** (`grupo-X`, `todo`) e o **Milestone** correspondente.

## Passo 5: Fluxo de Trabalho Diário (Branches e Pull Requests)

Este é o fluxo para o dia a dia de trabalho.

1.  **Sempre comece pela branch do seu grupo** e garanta que ela esteja atualizada:

    ```bash
    git checkout gX-<nome-do-projeto>
    git pull origin gX-<nome-do-projeto>
    ```

2.  **Crie uma nova branch para a tarefa específica** que você irá executar:

    ```bash
    # Exemplo: git checkout -b feat/analise-demanda
    git checkout -b <tipo>/<nome-da-tarefa>
    ```

3.  **Trabalhe na sua tarefa**, faça seus commits e envie sua branch para o repositório:

    ```bash
    git push origin <tipo>/<nome-da-tarefa>
    ```

4.  **Abra um Pull Request (PR)** no GitHub.
    - **Importante:** O PR deve ser da sua `branch de tarefa` para a `branch do grupo`, **NUNCA** para a `main`.
    - No PR, descreva o que você fez e peça a revisão dos seus colegas de equipe.

---

## Recursos Adicionais de Git e GitHub

Para auxiliar na compreensão e aplicação deste guia, recomendamos os seguintes materiais:

- **Playlist de Git/GitHub (Geofisicando - Ensinando Geofísica):** Uma série de tutoriais sobre como instalar o Git e realizar as operações básicas e avançadas no GitHub.
  - [Curso Git/GitHub #1 - Como instalar o git e como fazer o primeiro commit - Olá mundo, git!](https://www.youtube.com/watch?v=ZZLnlAbSDrI&list=PLLCFxfe9wkl_URgxXbZzRnhBH6neoBFjG)
- **Git Cheat Sheets:** Resumos práticos de comandos Git para consulta rápida, disponíveis na pasta `GUIAS/`.

---

Seguindo este guia, todos os grupos terão um projeto organizado, rastreável e colaborativo.

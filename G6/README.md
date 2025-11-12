# ⚡ Suprimento de Energia: Data Center Modular (Grupo 6)

![Status: Em Andamento](https://img.shields.io/badge/Status-Em%20Andamento-blueviolet?style=for-the-badge)
![Próxima Entrega: Etapa 1](<https://img.shields.io/badge/Pr%C3%B3xima%20Entrega-Etapa%201%20(12/11)-yellow?style=for-the-badge>)
![Issue Principal: #3](https://img.shields.io/badge/Issue%20Principal-%233-informational?style=for-the-badge)

Este documento centraliza as informações e o andamento do projeto do **Grupo 6** para a disciplina de Geração de Energia, focado no **Tema 6: Suprimento de Energia de Alta Confiabilidade para um Data Center Modular**.

### 👥 Equipe

- **Aleksander Da Silva Toth:** [@akstoth](https://github.com/akstoth)
- **Emanuel Dantas de Carvalho:** [@EmanuelDCarvalho](https://github.com/EmanuelDCarvalho)
- **Gabriel Eidi Lopes Yamashita:** [@Eidi-yamashita](https://github.com/Eidi-yamashita)

---

### 🚀 Painel de Controle e Status

- **Issue Principal (nossa main):** [[Grupo 6] Suprimento de Energia: Data Center Modular](https://github.com/baconclass/geraenerg/issues/3)
- **Milestone Atual:** [Grupo 6 - Etapa 1](https://github.com/baconclass/geraenerg/milestone/1)
- **Branch de Desenvolvimento:** `g6-data-center-modular`

**Status Atual:** O foco do grupo está na finalização da **Etapa 1**, começando pelas sub-issues de **Análise de Demanda** e **Definição da Metodologia**.

---

### 📂 Links Rápidos para Documentos

- **[PROPOSTA](./docs/Proposta_Grupo6.pdf):** Documento de proposta (Issue #4).
- **[RESUMO DE REFERÊNCIAS (ETAPA 1)](./docs/Resumo_de_Referências_Etapa_1.pdf):** Guia de estudo e plano de ação para a Etapa 1 (Issues #8 a #11).

---

### 🛠️ Como Contribuir (Workflow do Grupo)

Para garantir a organização, todo o trabalho do grupo deve seguir este fluxo:

1.  **Sincronize sua branch principal do grupo:**

    ```bash
    git checkout g6-data-center-modular
    git pull origin g6-data-center-modular
    ```

2.  **Crie uma nova branch para sua tarefa específica** (a partir da branch do grupo):

    ```bash
    # Exemplo: git checkout -b feat/analise-demanda
    git checkout -b <tipo>/<nome-da-tarefa>
    ```

3.  **Trabalhe na sua tarefa** e faça os commits.

4.  **Abra um Pull Request** da sua branch de tarefa para a `g6-data-center-modular` para que a equipe possa revisar.

### 📝 Padrão de Commits (Conventional Commits)

Para manter nosso histórico de alterações limpo e legível, todos os commits na branch do grupo devem seguir o padrão **Conventional Commits**.

**Estrutura do Commit:** `<tipo>(<escopo>): <descrição>`

- **`<escopo>`** (opcional): O contexto da alteração (ex: `relatorio`, `analise-demanda`, `readme`).

| Tipo         | Descrição                                                    |
| :----------- | :----------------------------------------------------------- |
| **feat**     | Adiciona uma nova funcionalidade, cálculo ou análise.        |
| **fix**      | Corrige um erro em um cálculo, texto ou simulação.           |
| **docs**     | Altera apenas a documentação (como este README, relatórios). |
| **style**    | Altera a formatação do código/texto, sem mudar a lógica.     |
| **refactor** | Melhora a estrutura de um arquivo sem alterar seu resultado. |
| **chore**    | Tarefas de manutenção (ex: ajustes em configurações).        |

**Exemplos:**

- `feat(analise-demanda): calcula o fator de carga`
- `docs(readme): adiciona seção de padrão de commits`
- `fix(relatorio): corrige erro de digitação na introdução`

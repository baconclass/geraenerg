import datetime

# --- CONFIGURAÇÃO DA RUBRICA (Conforme sua solicitação) ---
# Estrutura: "Nome do Critério": Peso
RUBRICA = {
    "1. Análise da Demanda": 1.5,
    "2. Dimensionamento Técnico": 2.0,
    "3. Análise de Produção": 2.0,
    "4. Análise Econômica": 2.0,
    "5. Análise Qualitativa": 1.5,
    "6. Conclusão": 1.0
}

DESCRICAO_RUBRICA = {
    1:"\n - Caracterização da curva de carga \n - Cálculo da demanda máxima \n - Fator de carga \n - Consumo anual de energia",
    2:"\n- Estimativa da potência instalada necessária para cada solução \n- Consideração do fator de capacidade de cada tecnologia \n- Dimensionamento preliminar dos principais equipamentos",
    3:"\n- Estimativa da geração anual de energia para cada solução \n- Uso de dados de recursos energéticos (hidrológicos, solares, eólicos) da região de implantação fictícia",
    4:"\n- Estimativa dos custos de implantação (**CAPEX**) \n- Estimativa dos custos de operação e manutenção (**OPEX**) \n- Cálculo do **Custo Nivelado de Energia (LCOE - Levelized Cost of Energy)** para cada solução, permitindo uma comparação econômica objetiva",
    5:"\n- Impactos socioambientais \n- Confiabilidade \n- Flexibilidade operacional",
    6:"\n- Recomendação justificada da melhor solução com base na **análise multicritério**"
}

# Função principal para gerar o feedback

def gerar_feedback():
    print(f"--- AVALIAÇÃO DE PROJETO FINAL (TF) ---")
    print(f"Disciplina: Geração de Energia Elétrica")
    print("Digite a nota de 0 a 10 para cada item. Pressione Enter sem digitar para comentário vazio.\n")
    
    aluno_grupo = input("Nome do Aluno/Grupo: ")
    link_pr = input("Link do PR/Repositório (opcional): ")
    
    resultados = []
    nota_final_total = 0
    i = 0
    
    for criterio, peso in RUBRICA.items():
        while True:
            try:
                i = i+1
                entrada = input(f"\n '{criterio}'\n{DESCRICAO_RUBRICA.get(i)} \n\n>> Nota para '{criterio}' (Peso {peso}):")
                nota_0_10 = float(entrada.replace(',', '.'))
                if 0 <= nota_0_10 <= 10:
                    break
                print("Por favor, insira um valor entre 0 e 10.")
            except ValueError:
                print("Entrada inválida. Digite um número.")
        
        comentario = input(f"   Comentário para '{criterio}' (Enter para pular): ")
        
        # Cálculo: (Nota Atribuída / 10) * Peso do Item
        pontos_obtidos = (nota_0_10 / 10) * peso
        nota_final_total += pontos_obtidos
        
        resultados.append({
            "criterio": criterio,
            "peso": peso,
            "nota_original": nota_0_10,
            "pontos": pontos_obtidos,
            "comentario": comentario
        })

    # --- GERAÇÃO DO MARKDOWN ---
    md = []
    md.append(f"# ⚡ Feedback de Avaliação: Projeto Final (TF)")
    md.append(f"**Grupo/Aluno:** {aluno_grupo}")
    if link_pr: md.append(f"**Contexto:** {link_pr}")
    md.append(f"**Data:** {datetime.date.today().strftime('%d/%m/%Y')}\n")
    
    md.append("| Critério | Peso | Nota (0-10) | Pontos Obtidos | Comentários |")
    md.append("| :--- | :---: | :---: | :---: | :--- |")
    
    for item in resultados:
        coment_str = item['comentario'] if item['comentario'] else "-"
        # Formata a linha da tabela
        linha = f"| **{item['criterio']}** | {item['peso']} | {item['nota_original']} | **{item['pontos']:.2f}** | {coment_str} |"
        md.append(linha)
        
    md.append(f"| | | | | |")
    md.append(f"| **TOTAL FINAL** | **10.0** | | **{nota_final_total:.2f}** | |")
    
    md.append("\n### 📝 Resumo e Próximos Passos")
    if nota_final_total >= 6.0:
        md.append(f"> ✅ **Aprovado.** O projeto atende aos requisitos técnicos e econômicos estipulados.")
    else:
        md.append(f"> ⚠️ **Revisão Necessária.** O projeto precisa de ajustes significativos nos pontos destacados acima.")
    
    print("\n" + "="*40)
    print(" COPIE O CÓDIGO ABAIXO PARA O GITHUB")
    print("="*40 + "\n")
    print("\n".join(md))

if __name__ == "__main__":
    gerar_feedback()
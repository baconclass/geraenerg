% ============= ANÁLISE DE DEMANDA - DATA CENTER (ETAPA 1) =============
% =========================================================================
%   UNIVERSIDADE TECNOLÓGICA FEDERAL DO PARANÁ
%   Engenharia Elétrica - 2025/2
%   Versão: v1.4 - Ajustes de menu, pasta de figuras e decomposição PUE.
%
%   Disciplina: Geração de Energia Elétrica (GE68A)
%   Projeto: Tema 6 - Suprimento de Energia para Data Center Modular
%   Grupo 6:
%     - Aleksander Da Silva Toth
%     - Emanuel Dantas de Carvalho
%     - Gabriel Eidi Lopes Yamashita
%
%   Arquivo: analise_demanda_g6.m
% =========================================================================
%  DESCRIÇÃO:
%   Este script é um entregável da Issue #8 (Análise da Demanda).
%   Ele define as premissas de carga, calcula métricas (D_media, Consumo),
%   gera os gráficos (Curva de Carga, CDC) e decompõe a carga (TI vs. Infra).
%
%  GLOSSÁRIO (símbolos e termos do projeto)
%   P:              Struct contendo todas as premissas do projeto.
%   D_max_MW [MW]:  Demanda Máxima (Pico) de potência do data center.
%   FC [-]:         Fator de Carga (adimensional, 0 a 1).
%   D_media_MW [MW]:Demanda Média de potência (Total da Instalação).
%   PUE [-]:        Power Usage Effectiveness (PUE = D_Total / D_TI).
%   D_TI [MW]:      Demanda da Carga de TI (Servidores, Rede).
%   D_Infra [MW]:   Demanda da Infraestrutura (Refrigeração + UPS/Aux).
%
%  EXPORTAÇÃO (Salva em ./Figuras/etapa_1_graficos relativo ao script)
%
%  REFERÊNCIAS-CHAVE (ver "Resumo_de_Referências_Etapa_1.tex"):
%   - [novec2024forecast], [ethree2024load] (Justificam FC ≈ 0,86–0,95)
%   - [epa2007ldc] (Metodologia da CDC)
%   - [fracalossi2015] (Conceitos de PUE, Tiers, Decomposição)
%   - [schneider2024modular], [economisers2019] (PUE moderno < 1,6)
% =========================================================================

function analise_demanda_g6
    % --- Inicialização ---
    close all; clc;
    set(0, 'DefaultFigureWindowStyle', 'normal');
    fprintf('Script de Análise de Demanda (G6) v1.4 iniciado.\n');

    % --- Definição das Premissas do Projeto ---
    P = struct();
    P.D_max_MW   = 10;      % Premissa: Demanda Máxima de 10 MW
    P.FC         = 0.90;    % Premissa: Fator de Carga de 90%
    P.horas_ano  = 8760;    % Horas em um ano
    P.PUE_alvo   = 1.5;     % PUE alvo do nosso Data Center Modular moderno
    
    setappdata(0, 'PROJETO_PREMISSAS', P);

    % --- Menu Interativo ---
    executando = true;
    while executando
        opcoes = {
            '1. Calcular Métricas Fundamentais (D_media, Consumo Anual)', ...
            '2. Gerar Gráfico: Curva de Carga Diária (24h)', ...
            '3. Gerar Gráfico: Curva de Duração de Carga (CDC)', ...
            '4. Calcular Decomposição da Carga (Análise de PUE)', ...
            '5. Gerar Gráfico: Decomposição PUE (Stack-bar)', ...
            '6. Executar Análise Completa (Passos 1, 2, 3, 4 e 5)', ...
            '----------', ...
            'Limpar Terminal', ...
            'Sair'
            };
        
        [escolha, ok] = listdlg('PromptString', 'Selecione a ação da Etapa 1.1:', ...
            'SelectionMode', 'single', ...
            'ListString', opcoes, ...
            'ListSize', [450, 240], ...
            'Name', 'Análise de Demanda (G6)');

        % Se usuário cancelar ou escolher "Sair"
        if ~ok || escolha == numel(opcoes)
            executando = false;
            fprintf('Análise de Demanda encerrada.\n');
            continue;
        end

        try
            switch escolha
                case 1
                    calcular_metricas();
                case 2
                    dados_dia = gerar_dados_curva_diaria();
                    plotar_curva_diaria(dados_dia);
                case 3
                    dados_cdc = gerar_dados_cdc();
                    plotar_cdc(dados_cdc);
                case 4
                    calcular_decomposicao_carga();
                case 5
                    % Garante que os dados existem antes de plotar
                    P = calcular_decomposicao_carga(); 
                    plotar_decomposicao_pue(P);
                case 6
                    fprintf('\n--- EXECUTANDO ANÁLISE COMPLETA ---\n');
                    calcular_metricas();
                    dados_dia = gerar_dados_curva_diaria();
                    plotar_curva_diaria(dados_dia);
                    dados_cdc = gerar_dados_cdc();
                    plotar_cdc(dados_cdc);
                    P_calc = calcular_decomposicao_carga();
                    plotar_decomposicao_pue(P_calc);
                    fprintf('--- ANÁLISE COMPLETA FINALIZADA ---\n');
                case 7
                    % Separador visual ("----------") – não faz nada
                    continue;
                case 8
                    clc;
            end
        catch ME
            errordlg(sprintf('Erro na execução:\n%s', ME.message), 'Erro');
            fprintf('%s\n', getReport(ME, 'extended', 'hyperlinks', 'off'));
        end
    end
end

% ========================================================================
% FUNÇÕES DE CÁLCULO E PLOTAGEM (MODULARIZADO)
% ========================================================================

%% 1. CÁLCULO DAS MÉTRICAS
function P = calcular_metricas()
    P = getappdata(0, 'PROJETO_PREMISSAS');
    P = calcular_metricas_base(P); 
    
    fprintf('------------------------------------------------------\n');
    fprintf('RESULTADOS DA ANÁLISE DE DEMANDA (Etapa 1.1)\n');
    fprintf('------------------------------------------------------\n');
    fprintf('Demanda Máxima (Pico) Definida:   %.2f MW\n', P.D_max_MW);
    fprintf('Fator de Carga (FC) Adotado:      %.2f (ou %d%%)\n', P.FC, P.FC*100);
    fprintf('Demanda Média Calculada (TOTAL):  %.2f MW\n', P.D_media_MW);
    fprintf('Consumo Anual de Energia (TOTAL): %.0f MWh/ano\n', P.Consumo_Anual_MWh);
    fprintf('Consumo Anual de Energia (TOTAL): %.2f GWh/ano\n', P.Consumo_Anual_GWh);
    fprintf('------------------------------------------------------\n');
end

%% 2. GERAÇÃO DE DADOS DA CURVA DIÁRIA
function dados_dia = gerar_dados_curva_diaria()
    P = getappdata(0, 'PROJETO_PREMISSAS');
    P = calcular_metricas_base(P); 
    
    horas_dia = 1:24;
    carga_diaria = ones(1, 24) * P.D_media_MW;
    
    % Ruído +/- 2%
    ruido = (rand(1, 24) - 0.5) * (P.D_media_MW * 0.04);
    carga_diaria = carga_diaria + ruido;
    
    % Força o pico
    carga_diaria(14) = P.D_max_MW * 0.98;
    carga_diaria(15) = P.D_max_MW; % Atinge o pico
    
    % Recentraliza para manter D_media
    carga_diaria = carga_diaria - (mean(carga_diaria) - P.D_media_MW);
    carga_diaria(15) = P.D_max_MW; 
    
    dados_dia.horas = horas_dia;
    dados_dia.carga = carga_diaria;
    
    setappdata(0, 'DADOS_DIA', dados_dia);
end

%% 3. PLOTAGEM DA CURVA DIÁRIA
function plotar_curva_diaria(dados_dia)
    P = getappdata(0, 'PROJETO_PREMISSAS');
    
    fig1 = figure('Name', 'Curva de Carga Diária', 'NumberTitle', 'off');
    set(fig1, 'WindowState', 'maximized'); 
    
    bar(dados_dia.horas, dados_dia.carga, 'FaceColor', [0.2 0.6 1.0]);
    hold on;
    
    yline(P.D_max_MW, 'k--', 'LineWidth', 1.5);
    text(2, P.D_max_MW * 1.03, sprintf('Demanda Máxima (Pico): %.1f MW', P.D_max_MW), ...
        'Color', 'k', 'FontWeight', 'bold', 'FontSize', 12);
    
    yline(P.D_media_MW, 'k--', 'LineWidth', 1.5);
    text(2, P.D_media_MW * 1.03, ...
        sprintf('Demanda Média (Total): %.1f MW (FC = %.2f)', P.D_media_MW, P.FC), ...
        'Color', 'k', 'FontWeight', 'bold', 'FontSize', 12);
    
    xlabel('Hora do Dia', 'FontSize', 12);
    ylabel('Demanda (MW)', 'FontSize', 12);
    xticks(0:2:24);
    grid on;
    ylim([0 P.D_max_MW * 1.15]);
    ax = gca;
    ax.FontSize = 12;
    hold off;
    
    pause(1); 
    salvar_figuras_resultados(fig1, 'curva_carga_diaria');
end

%% 4. GERAÇÃO DE DADOS DA CDC
function dados_cdc = gerar_dados_cdc()
    P = getappdata(0, 'PROJETO_PREMISSAS');
    P = calcular_metricas_base(P);
    
    horas_pico = round(P.horas_ano * (1 - P.FC));
    horas_base = P.horas_ano - horas_pico;
    
    carga_anual_base = ones(1, horas_base) * P.D_media_MW;
    carga_anual_pico = linspace(P.D_media_MW, P.D_max_MW, horas_pico); 
    carga_anual_ordenada = sort([carga_anual_base, carga_anual_pico], 'descend');
    
    dados_cdc.horas      = 1:P.horas_ano;
    dados_cdc.carga      = carga_anual_ordenada;
    dados_cdc.horas_pico = horas_pico;
    
    setappdata(0, 'DADOS_CDC', dados_cdc);
end

%% 5. PLOTAGEM DA CDC
function plotar_cdc(dados_cdc)
    P = getappdata(0, 'PROJETO_PREMISSAS');
    
    fig2 = figure('Name', 'Curva de Duração de Carga (CDC)', 'NumberTitle', 'off');
    set(fig2, 'WindowState', 'maximized'); 
    
    plot(dados_cdc.horas, dados_cdc.carga, 'b-', 'LineWidth', 3);
    hold on;
    
    x_base = dados_cdc.horas_pico;
    y_base = P.D_media_MW;
    plot([x_base, x_base], [0, y_base], 'k--'); 
    plot([0, x_base], [y_base, y_base], 'k--'); 
    
    text(P.horas_ano / 2, y_base - 0.5, ...
         sprintf('Carga de Base (%.1f MW)', P.D_media_MW), ...
         'Color', 'k', 'FontSize', 12, 'FontWeight', 'bold');
         
    text(500, P.D_media_MW + 0.5, ...
         sprintf('Carga de Ponta (%.1f MW)', P.D_max_MW - P.D_media_MW), ...
         'Color', 'k', 'FontSize', 12, 'FontWeight', 'bold');
         
    xlabel('Duração (Horas no Ano)', 'FontSize', 12);
    ylabel('Demanda (MW)', 'FontSize', 12);
    grid on;
    xlim([0 P.horas_ano]);
    ylim([0 P.D_max_MW * 1.15]);
    ax = gca;
    ax.FontSize = 12;
    hold off;
    
    pause(1); 
    salvar_figuras_resultados(fig2, 'curva_duracao_carga');
end

%% 6. DECOMPOSIÇÃO DA CARGA E ANÁLISE DE PUE
function P = calcular_decomposicao_carga()
    P = getappdata(0, 'PROJETO_PREMISSAS');
    P = calcular_metricas_base(P);
    
    fprintf('\n------------------------------------------------------\n');
    fprintf('DECOMPOSIÇÃO DA CARGA (ANÁLISE DE PUE)\n');
    fprintf('------------------------------------------------------\n');
    fprintf('Demanda Média Total (D_media): %.2f MW\n\n', P.D_media_MW);

    % --- Cenário 1: Baseline (Fracalossi, 2015) ---
    fprintf('Cenário 1: Baseline (TCC Fracalossi, 2015)\n');
    P_IT_perc_2015   = 0.36;  % 36%
    P_HVAC_perc_2015 = 0.50; % 50%
    P_UPS_perc_2015  = 0.14;  % 14%
    
    P.D_TI_2015_MW   = P.D_media_MW * P_IT_perc_2015;
    P.D_HVAC_2015_MW = P.D_media_MW * P_HVAC_perc_2015;
    P.D_UPS_2015_MW  = P.D_media_MW * P_UPS_perc_2015;
    P.PUE_2015       = P.D_media_MW / P.D_TI_2015_MW;
    
    fprintf('  Carga de TI (36%%):        %.2f MW\n', P.D_TI_2015_MW);
    fprintf('  Carga de HVAC (50%%):      %.2f MW\n', P.D_HVAC_2015_MW);
    fprintf('  Carga de UPS/Aux (14%%):   %.2f MW\n', P.D_UPS_2015_MW);
    fprintf('  PUE Calculado (Total/TI): %.2f (Muito alto)\n\n', P.PUE_2015);
    
    % --- Cenário 2: Projeto G6 (Data Center Modular Moderno) ---
    fprintf('Cenário 2: Nosso Projeto (PUE Alvo = %.2f)\n', P.PUE_alvo);
    
    P.D_TI_G6_MW    = P.D_media_MW / P.PUE_alvo;
    P.D_Infra_G6_MW = P.D_media_MW - P.D_TI_G6_MW;
    
    fprintf('  Carga de TI (Crítica):     %.2f MW\n', P.D_TI_G6_MW);
    fprintf('  Carga de Infra (HVAC+UPS): %.2f MW\n', P.D_Infra_G6_MW);
    fprintf('  Total (D_TI + D_Infra):    %.2f MW (Confere com D_media)\n', ...
        P.D_TI_G6_MW + P.D_Infra_G6_MW);
    fprintf('------------------------------------------------------\n');
    
    % Salva os cálculos de volta nas premissas
    setappdata(0, 'PROJETO_PREMISSAS', P);
end

%% 7. PLOTAGEM DA DECOMPOSIÇÃO PUE
function plotar_decomposicao_pue(P)
    % Agrupa HVAC e UPS do Cenário 1 em "Infra" para comparação TI vs Não-TI
    D_TI_2015    = P.D_TI_2015_MW;
    D_Infra_2015 = P.D_HVAC_2015_MW + P.D_UPS_2015_MW;
    
    D_TI_G6      = P.D_TI_G6_MW;
    D_Infra_G6   = P.D_Infra_G6_MW;
    
    dados_plot = [D_TI_2015,   D_TI_G6;    % Linha 1: TI
                  D_Infra_2015, D_Infra_G6]; % Linha 2: Infra (HVAC + UPS + perdas)
              
    fig3 = figure('Name', 'Decomposição da Carga (PUE)', 'NumberTitle', 'off');
    set(fig3, 'WindowState', 'maximized');
    
    b = bar(dados_plot, 'stacked'); %#ok<NASGU>
    
    ax = gca;
    ax.FontSize = 12;
    grid on;
    
    ylabel('Demanda Média (MW)', 'FontSize', 12);
    
    xticklabels({'Cenário 1: PUE 2.78 (Baseline 2015)', ...
                 'Cenário 2: PUE 1.50 (Alvo Projeto G6)'});
    xtickangle(10);  % Leve inclinação p/ evitar sobreposição
    
    legend('Carga de TI (Servidores, Rede)', ...
           'Carga de Infraestrutura (HVAC, UPS, Perdas)', ...
           'Location', 'northeastoutside', 'FontSize', 12);
    
    % Adicionar rótulos dentro das barras
    y_total = sum(dados_plot, 1);
    y_offset = zeros(1, size(dados_plot, 2));
    
    for i = 1:size(dados_plot, 1) % Componentes (TI, Infra)
        y_offset_new = y_offset + dados_plot(i, :);
        for j = 1:size(dados_plot, 2) % Cenários
            text(j, (y_offset(j) + y_offset_new(j)) / 2, ...
                 sprintf('%.2f MW', dados_plot(i, j)), ...
                 'HorizontalAlignment', 'center', ...
                 'VerticalAlignment', 'middle', ...
                 'Color', 'w', 'FontWeight', 'bold', 'FontSize', 11);
        end
        y_offset = y_offset_new;
    end
    
    % Adicionar o PUE em cima das barras totais
    text(1, y_total(1) + 0.3, sprintf('PUE: %.2f', P.PUE_2015), ...
        'HorizontalAlignment', 'center', 'Color', 'r', ...
        'FontWeight', 'bold', 'FontSize', 12);
    text(2, y_total(2) + 0.3, sprintf('PUE: %.2f', P.PUE_alvo), ...
        'HorizontalAlignment', 'center', 'Color', 'b', ...
        'FontWeight', 'bold', 'FontSize', 12);
    
    ylim([0 P.D_max_MW * 1.15]);
    hold off;
    
    pause(1);
    salvar_figuras_resultados(fig3, 'decomposicao_carga_pue');
end

% ========================================================================
% FUNÇÕES AUXILIARES (INTERNAS)
% ========================================================================

%% Cálculo base (sempre recalcula métricas a partir de D_max e FC)
function P_out = calcular_metricas_base(P_in)
    P_in.D_media_MW        = P_in.D_max_MW * P_in.FC;
    P_in.Consumo_Anual_MWh = P_in.D_media_MW * P_in.horas_ano;
    P_in.Consumo_Anual_GWh = P_in.Consumo_Anual_MWh / 1000;
    setappdata(0, 'PROJETO_PREMISSAS', P_in);
    P_out = P_in;
end

%% Função de salvar (agora em ./Figuras/etapa_1_graficos)
function salvar_figuras_resultados(figHandle, nomeBase)
    script_folder = fileparts(mfilename('fullpath'));
    dirFig = fullfile(script_folder, 'Figuras', 'etapa_1_graficos');
    
    if ~exist(dirFig, 'dir')
        try
            mkdir(dirFig);
            fprintf('Pasta de gráficos criada: %s\n', dirFig);
        catch ME_mkdir
            warning(['Não foi possível criar a pasta de gráficos em %s. ', ...
                     'Salvando na pasta atual. Erro: %s'], ...
                     dirFig, ME_mkdir.message);
            dirFig = pwd; % Salva na pasta atual como fallback
        end
    end
    
    nomeArquivo = fullfile(dirFig, [nomeBase, '.png']);
    
    try
        exportgraphics(figHandle, nomeArquivo, 'Resolution', 300);
        fprintf('Gráfico salvo em: %s\n', nomeArquivo);
    catch ME_export
        warning('Falha ao salvar figura %s: %s', nomeBase, ME_export.message);
    end
end

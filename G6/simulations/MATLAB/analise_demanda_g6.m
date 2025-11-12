% ============= ANÁLISE DE DEMANDA - DATA CENTER (ETAPA 1) =============
% =========================================================================
%   UNIVERSIDADE TECNOLÓGICA FEDERAL DO PARANÁ
%   Câmpus Apucarana - PR
%   Engenharia Elétrica - 2025/2
%   Versão: v1.0
%
%   Disciplina: Geração de Energia Elétrica (GE68A)
%   Projeto: Tema 6 - Suprimento de Energia para Data Center Modular
%   Grupo 6:
%     - Aleksander Da Silva Toth
%     - Emanuel Dantas de Carvalhosi
%     - Gabriel Eidi Lopes Yamashita
%
%   Arquivo: analise_demanda_g6.m
% =========================================================================
%  DESCRIÇÃO:
%   Este script é o entregável da Issue #8 (Análise da Demanda).
%   Ele define as premissas de carga do Data Center Modular, calcula as
%   métricas fundamentais (Demanda Média, Consumo Anual) e gera os
%   gráficos da Curva de Carga Diária e da Curva de Duração de Carga (CDC).
%
%  GLOSSÁRIO (símbolos e termos do projeto)
%   P:           Struct contendo todas as premissas do projeto.
%   D_max [MW]:  Demanda Máxima (Pico) de potência do data center.
%   FC [-]:      Fator de Carga (adimensional, 0 a 1). Relação D_media / D_max.
%   D_media [MW]:Demanda Média de potência.
%   E_ano [MWh]: Consumo Anual de Energia (E = D_media * 8760).
%   CDC:         Curva de Duração de Carga (Load Duration Curve - LDC).
%
%  EXPORTAÇÃO (etapa_1_graficos/)
%   - Os gráficos gerados são salvos automaticamente nesta pasta.
%
%  REFERÊNCIAS-CHAVE (Ver "reference_resume_task_1.tex"):
%   - [NOVEC, 2024] (Justifica o perfil "flat" da curva de carga)
%   - [E3, 2024] e [CLPT, 2016] (Justificam o Fator de Carga de 86-90%)
%   - [EPA, 2007] (Metodologia da Curva de Duração de Carga - CDC)
%   - [Fracalossi, 2015] (Conceitos de PUE e Tiers)
% =========================================================================

function analise_demanda_g6
    % --- Inicialização ---
    close all; clc;
    set(0, 'DefaultFigureWindowStyle', 'docked');
    fprintf('Script de Análise de Demanda (G6) iniciado.\n');

    % --- Definição das Premissas do Projeto ---
    % Estas são as premissas que definimos na nossa pesquisa
    P = struct();
    P.D_max_MW = 10;      % Premissa: Demanda Máxima de 10 MW
    P.FC = 0.90;          % Premissa: Fator de Carga de 90% (justificado por)
    P.horas_ano = 8760;   % Horas em um ano
    
    % Salva as premissas globalmente (inspirado no seu script)
    setappdata(0, 'PROJETO_PREMISSAS', P);

    % --- Menu Interativo (Inspirado no seu script de PCOM) ---
    executando = true;
    while executando
        opcoes = {
            '1. Calcular Métricas Fundamentais (D_media, Consumo Anual)', ...
            '2. Gerar Gráfico: Curva de Carga Diária (24h)', ...
            '3. Gerar Gráfico: Curva de Duração de Carga (CDC)', ...
            '4. Executar Análise Completa (Passos 1, 2 e 3)', ...
            '----------', ...
            'Limpar Terminal', ...
            'Sair'
            };
        
        [escolha, ok] = listdlg('PromptString', 'Selecione a ação da Etapa 1.1:', ...
            'SelectionMode', 'single', ...
            'ListString', opcoes, ...
            'ListSize', [450, 200], ...
            'Name', 'Análise de Demanda (G6)');

        if ~ok || escolha == numel(opcoes)  % 'Sair'
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
                    fprintf('\n--- EXECUTANDO ANÁLISE COMPLETA ---\n');
                    calcular_metricas();
                    dados_dia = gerar_dados_curva_diaria();
                    plotar_curva_diaria(dados_dia);
                    dados_cdc = gerar_dados_cdc();
                    plotar_cdc(dados_cdc);
                    fprintf('--- ANÁLISE COMPLETA FINALIZADA ---\n');
                case 6
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
    P = getappdata(0, 'PROJETO_PREMISSAS'); % Carrega premissas

    % 1.1. Cálculo da Demanda Média
    P.D_media_MW = P.D_max_MW * P.FC;

    % 1.2. Cálculo do Consumo Anual de Energia
    P.Consumo_Anual_MWh = P.D_media_MW * P.horas_ano;
    P.Consumo_Anual_GWh = P.Consumo_Anual_MWh / 1000;

    % Exibe os resultados no console
    fprintf('------------------------------------------------------\n');
    fprintf('RESULTADOS DA ANÁLISE DE DEMANDA (Etapa 1.1)\n');
    fprintf('------------------------------------------------------\n');
    fprintf('Demanda Máxima (Pico) Definida:   %.2f MW\n', P.D_max_MW);
    fprintf('Fator de Carga (FC) Adotado:      %.2f (ou %d%%)\n', P.FC, P.FC*100);
    fprintf('Demanda Média Calculada:          %.2f MW\n', P.D_media_MW);
    fprintf('Consumo Anual de Energia:         %.0f MWh/ano\n', P.Consumo_Anual_MWh);
    fprintf('Consumo Anual de Energia:         %.2f GWh/ano\n', P.Consumo_Anual_GWh);
    fprintf('------------------------------------------------------\n');
    
    % Salva os cálculos de volta nas premissas
    setappdata(0, 'PROJETO_PREMISSAS', P);
end

%% 2. GERAÇÃO DE DADOS DA CURVA DIÁRIA
function dados_dia = gerar_dados_curva_diaria()
    P = getappdata(0, 'PROJETO_PREMISSAS');
    P = calcular_metricas_base(P); % Garante que D_media está calculada
    
    horas_dia = 1:24;
    carga_diaria = ones(1, 24) * P.D_media_MW;
    
    % Simula uma variação "flat" (ruído)
    ruido = (rand(1, 24) - 0.5) * (P.D_media_MW * 0.04); % +/- 2%
    carga_diaria = carga_diaria + ruido;
    
    % Força picos para atingir D_max (ex: picos de refrigeração/processamento)
    carga_diaria(14) = P.D_max_MW * 0.98;
    carga_diaria(15) = P.D_max_MW; % Atinge o pico
    
    % Ajusta a média para bater exatamente com o FC
    carga_diaria = carga_diaria - (mean(carga_diaria) - P.D_media_MW);
    carga_diaria(15) = P.D_max_MW; % Garante que o pico é D_max
    
    dados_dia.horas = horas_dia;
    dados_dia.carga = carga_diaria;
    
    setappdata(0, 'DADOS_DIA', dados_dia);
end

%% 3. PLOTAGEM DA CURVA DIÁRIA
function plotar_curva_diaria(dados_dia)
    P = getappdata(0, 'PROJETO_PREMISSAS');
    
    fig1 = figure('Name', 'Curva de Carga Diária', 'NumberTitle', 'off');
    bar(dados_dia.horas, dados_dia.carga, 'FaceColor', [0.2 0.6 1.0]);
    hold on;
    
    % Linhas de referência
    yline(P.D_max_MW, 'k--', 'LineWidth', 1);
    text(2, P.D_max_MW * 1.03, sprintf('Demanda Máxima (Pico): %.1f MW', P.D_max_MW), 'Color', 'k', 'FontWeight', 'bold');

    yline(P.D_media_MW, 'k--', 'LineWidth', 1);
    text(2, P.D_media_MW * 1.03, sprintf('Demanda Média: %.1f MW (FC = %.2f)', P.D_media_MW, P.FC), 'Color', 'k', 'FontWeight', 'bold');

    title('Figura 1: Curva de Carga Diária Típica (Data Center Modular)');
    xlabel('Hora do Dia');
    ylabel('Demanda (MW)');
    xticks(0:2:24);
    grid on;
    ylim([0 P.D_max_MW * 1.15]);
    hold off;
    
    salvar_figuras_resultados(fig1, 'curva_carga_diaria');
end

%% 4. GERAÇÃO DE DADOS DA CDC
function dados_cdc = gerar_dados_cdc()
    P = getappdata(0, 'PROJETO_PREMISSAS');
    P = calcular_metricas_base(P);
    
    % Simula as 8760 horas do ano
    horas_pico = round(P.horas_ano * (1 - P.FC));
    horas_base = P.horas_ano - horas_pico;
    
    carga_anual_base = ones(1, horas_base) * P.D_media_MW;
    % Simula os picos como uma rampa de D_media até D_max
    carga_anual_pico = linspace(P.D_media_MW, P.D_max_MW, horas_pico); 

    % Junta e ordena do maior para o menor
    carga_anual_ordenada = sort([carga_anual_base, carga_anual_pico], 'descend');
    
    dados_cdc.horas = 1:P.horas_ano;
    dados_cdc.carga = carga_anual_ordenada;
    dados_cdc.horas_pico = horas_pico;
    
    setappdata(0, 'DADOS_CDC', dados_cdc);
end

%% 5. PLOTAGEM DA CDC
function plotar_cdc(dados_cdc)
    P = getappdata(0, 'PROJETO_PREMISSAS');
    
    fig2 = figure('Name', 'Curva de Duração de Carga (CDC)', 'NumberTitle', 'off');
    plot(dados_cdc.horas, dados_cdc.carga, 'b-', 'LineWidth', 3);
    hold on;

    % Identifica Carga de Base e Ponta
    x_base = dados_cdc.horas_pico;
    y_base = P.D_media_MW;
    plot([x_base, x_base], [0, y_base], 'k--'); % Linha vertical
    plot([0, x_base], [y_base, y_base], 'k--'); % Linha horizontal

    text(P.horas_ano / 2, y_base - 0.5, ...
         sprintf('Carga de Base (%.1f MW)', P.D_media_MW), ...
         'Color', 'k', 'FontSize', 10, 'FontWeight', 'bold');
         
    text(500, P.D_media_MW + 0.5, ...
         sprintf('Carga de Ponta (%.1f MW)', P.D_max_MW - P.D_media_MW), ...
         'Color', 'k', 'FontSize', 10, 'FontWeight', 'bold');

    title('Figura 2: Curva de Duração de Carga (CDC) Anual');
    xlabel('Duração (Horas no Ano)');
    ylabel('Demanda (MW)');
    grid on;
    xlim([0 P.horas_ano]);
    ylim([0 P.D_max_MW * 1.15]);
    hold off;
    
    salvar_figuras_resultados(fig2, 'curva_duracao_carga');
end

% ========================================================================
% FUNÇÕES AUXILIARES (INTERNAS)
% ========================================================================

%% Cálculo base (sem printar no console)
function P_out = calcular_metricas_base(P_in)
    if ~isfield(P_in, 'D_media_MW')
        P_in.D_media_MW = P_in.D_max_MW * P_in.FC;
        P_in.Consumo_Anual_MWh = P_in.D_media_MW * P_in.horas_ano;
        P_in.Consumo_Anual_GWh = P_in.Consumo_Anual_MWh / 1000;
        setappdata(0, 'PROJETO_PREMISSAS', P_in);
    end
    P_out = P_in;
end

%% Função de salvar (inspirada no seu script de PCOM)
function salvar_figuras_resultados(figHandle, nomeBase)
    % Define a pasta de saída
    dirFig = fullfile(pwd, 'etapa_1_graficos');
    if ~exist(dirFig, 'dir')
        mkdir(dirFig);
        fprintf('Pasta criada: %s\n', dirFig);
    end
    
    % Monta o nome do arquivo
    nomeArquivo = fullfile(dirFig, [nomeBase, '.png']);
    
    try
        % Salva o gráfico
        exportgraphics(figHandle, nomeArquivo, 'Resolution', 300);
        fprintf('Gráfico salvo em: %s\n', nomeArquivo);
    catch ME
        warning('Falha ao salvar figura %s: %s', nomeBase, ME.message);
    end
end
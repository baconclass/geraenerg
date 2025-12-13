% =========================================================================
% GERADOR DE PERFIL DE CARGA - DATA CENTER 10 MW (CLEAN)
% Versão: v5.1 (Sem setas/anotações manuais)
% =========================================================================

function gerar_perfil_carga_clean
    close all; clc;
    
    % --- 1. CONFIGURAÇÃO ---
    t = linspace(0, 24*60, 1440); 
    horas = t / 60;
    
    % --- 2. COMPONENTES ---
    
    % A. Carga Base (7.0 MW)
    P_base_TI = 7.8 * ones(size(t)); 
    
    % B. Clima (0.8 a 1.2 MW)
    P_clima = 1.0 + 0.2 * sin(2*pi*(horas - 10)/24); 
    
    % C. Picos de IA (9.5 MW máx)
    P_IA = zeros(size(t));
    
    % Pico 1
    idx1 = (horas >= 9.5) & (horas <= 11);
    P_IA(idx1) = 0.8; 
    
    % Pico 2
    idx2 = (horas >= 14.5) & (horas <= 16.5);
    P_IA(idx2) = 1.01; 
    
    % Ruído
    ruido = 0.02 * randn(size(t)); 
    
    % --- 3. TOTAL ---
    P_total = P_base_TI + P_clima + P_IA + ruido;
    P_media = mean(P_total);
    FC_calc = P_media / 10;
    
    fprintf('Pico Máximo: %.2f MW\n', max(P_total));
    fprintf('Fator de Carga: %.2f\n', FC_calc);
    
    % --- 4. PLOTAGEM CLEAN ---
    fig = figure('Name', 'Perfil Clean', 'Color', 'w');
    set(fig, 'Position', [100, 100, 1000, 600]);
    
    % Área Principal
    area(horas, P_total, 'FaceColor', [0.85 0.92 1.0], 'EdgeColor', [0.2 0.4 0.8], 'LineWidth', 2);
    hold on;
    
    % Linhas de Referência
    yline(10, 'r--', 'Capacidade Instalada (10 MW)', 'LineWidth', 2, 'FontSize', 12);
    yline(P_media, 'k--', sprintf('Média Operacional (%.1f MW)', P_media), 'LineWidth', 2, 'FontSize', 12);
    
    % Layout
    grid on;
    xlabel('Hora do Dia', 'FontSize', 14, 'FontWeight', 'bold');
    ylabel('Potência (MW)', 'FontSize', 14, 'FontWeight', 'bold');
    % title('Perfil de Carga Diária', 'FontSize', 16);
    
    ylim([0 11]); xlim([0 24]); xticks(0:4:24);
    
    legend('Demanda Estimada', 'Limite Físico', 'Média', ...
           'Location', 'southoutside', 'Orientation', 'horizontal', 'FontSize', 12);
    
    hold off;
    
    saveas(fig, 'perfil_carga_clean.png');
end
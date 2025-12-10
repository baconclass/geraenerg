%% PAYBACK MENSAL - GD x GC NO MESMO GRÁFICO
clc; clear; close all;

%% PARÂMETROS ECONÔMICOS
TE   = 0.36305;          % Tarifa Energia (COPEL)
TUSD = 0.36562;          % Tarifa Uso (COPEL)

% Lei 14.300 – compensação parcial
valor_kWh = TE + 0.30 * TUSD;   

inflacao_anual = 0.07;
inflacao_mensal = (1 + inflacao_anual)^(1/12) - 1;

%% GERAÇÃO
geracao_GD = 5128.8;   
geracao_GC = 5128.8;   

%% ECONOMIA INICIAL
econ_GD = geracao_GD * valor_kWh;
econ_GC = geracao_GC * valor_kWh;

%% CAPEX E OPEX
CAPEX_GD = 157300;
CAPEX_GC = 120200;

OPEX_GD = 924.10 / 12;
OPEX_GC = 825 / 12;

%% TEMPO
meses = 66;

fluxo_GD = zeros(1, meses); 
fluxo_GC = zeros(1, meses);

acum_GD = zeros(1, meses);
acum_GC = zeros(1, meses);

%% SIMULAÇÃO
valorGD = econ_GD;
valorGC = econ_GC;

acum_GD(1) = -CAPEX_GD;
acum_GC(1) = -CAPEX_GC;

for m = 1:meses
    
    if m > 1
        valorGD = valorGD * (1 + inflacao_mensal);
        valorGC = valorGC * (1 + inflacao_mensal);
    end

    fluxo_GD(m) = valorGD - OPEX_GD;
    fluxo_GC(m) = valorGC - OPEX_GC;

    if m == 1
        acum_GD(m) = -CAPEX_GD + fluxo_GD(m);
        acum_GC(m) = -CAPEX_GC + fluxo_GC(m);
    else
        acum_GD(m) = acum_GD(m-1) + fluxo_GD(m);
        acum_GC(m) = acum_GC(m-1) + fluxo_GC(m);
    end
end

%% PAYBACKS
pb_GD = find(acum_GD > 0, 1);
pb_GC = find(acum_GC > 0, 1);

disp("Payback GD: " + pb_GD + " meses");
disp("Payback GC: " + pb_GC + " meses");

%% GRÁFICO COMPARATIVO ÚNICO
figure(1);
hold on;

% --- Barras dos fluxos mensais ---
bar(1:meses, [fluxo_GD' fluxo_GC'], 'BarWidth', 1);
colormap([0.2 0.6 1; 1 0.5 0.2]); % cores diferentes

% --- Linhas do acumulado ---
plot(acum_GD, 'LineWidth', 2.5, 'Color', [0 0.2 0.8]);
plot(acum_GC, 'LineWidth', 2.5, 'Color', [0.8 0.2 0]);

% --- Marcadores de payback ---
if ~isempty(pb_GD)
    plot(pb_GD, acum_GD(pb_GD), 'o', 'MarkerSize', 9, ...
        'MarkerFaceColor', [0 0.2 0.8], 'MarkerEdgeColor','k');
end

if ~isempty(pb_GC)
    plot(pb_GC, acum_GC(pb_GC), 'o', 'MarkerSize', 9, ...
        'MarkerFaceColor', [0.8 0.2 0], 'MarkerEdgeColor','k');
end

% --- Configuração final ---
title('Comparação de Payback - GD vs GC (Fluxo + Acumulado)');
xlabel('Meses');
ylabel('R$');
grid on;

legend('Fluxo GD', 'Fluxo GC', ...
       'Acumulado GD', 'Acumulado GC', ...
       'Payback GD', 'Payback GC', ...
       'Location', 'northwest');

hold off;
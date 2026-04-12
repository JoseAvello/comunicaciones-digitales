%% LAB 2 - Interferencia Intersimbolo (ISI)
%% Jose Avello - Joaquin Moya - Alvaro Valdebenito

clc; clear; close all;

% ---------------- PARÁMETROS DEL SISTEMA ----------------------------

Nbits = 1e4;          % Número de bits
Rb = 1e3;             % Tasa de bits
Fs = 20*Rb;           % Frecuencia de muestreo
Ns = Fs/Rb;           % Muestras por símbolo

span = 6;             
alphas = [0 0.25 0.75 1]; % Roll-off (según enunciado)
SNR_dB = 20;


% ---------------- GENERACIÓN DE DATOS (NRZ-L) -----------------------

bits = randi([0 1], Nbits, 1);
symbols = 2*bits - 1;             % NRZ-L
symbols_up = upsample(symbols, Ns);


% 1) ------------ RESPUESTA AL IMPULSO (t >= 0) -----------------

figure;
hold on;

for k = 1:length(alphas)
    
    alpha = alphas(k);
    
    % =======Evitar problema en alpha = 0 ===========
    if alpha == 0
        alpha_use = 1e-8;
    else
        alpha_use = alpha;
    end
    
    h = rcosdesign(alpha_use, span, Ns, 'normal');
    
    t = (0:length(h)-1)/Ns; % tiempo >= 0
    plot(t, h, 'LineWidth', 1.5);
end

title('Respuesta al impulso del pulso coseno alzado');
xlabel('Tiempo');
ylabel('Amplitud');
legend('\alpha=0','\alpha=0.25','\alpha=0.75','\alpha=1');
grid on;


% ============= 2) RESPUESTA EN FRECUENCIA (-2B ≤ f ≤ 2B) ============

figure;
hold on;

Ts = 1/Rb;

for k = 1:length(alphas)
    
    alpha = alphas(k);
    
    if alpha == 0
        alpha_use = 1e-8;
    else
        alpha_use = alpha;
    end
    
    h = rcosdesign(alpha_use, span, Ns, 'normal');
    
    % ============= FFT ================
    H = fftshift(abs(fft(h, 4096)));
    f = linspace(-Fs/2, Fs/2, length(H));
    
    % ========== Ancho de banda =============
    B = (1 + alpha)/(2*Ts);
    
    % ========== Selección del rango -2B a 2B ============
    idx = (f >= -2*B) & (f <= 2*B);
    
    plot(f(idx), H(idx), 'LineWidth', 1.5);
end

title('Respuesta en frecuencia (-2B ≤ f ≤ 2B)');
xlabel('Frecuencia (Hz)');
ylabel('|H(f)|');
legend('\alpha=0','\alpha=0.25','\alpha=0.75','\alpha=1');
grid on;


%  --------------------- 3) DIAGRAMAS DE OJO (TODOS LOS α) ------------------------

for k = 1:length(alphas)
    
    alpha = alphas(k);
    
    if alpha == 0
        alpha_use = 1e-8;
    else
        alpha_use = alpha;
    end
    
    h = rcosdesign(alpha_use, span, Ns, 'normal');
    
    % ========= Señal transmitida ===========
    tx = conv(symbols_up, h, 'same');
    
    % ========== Canal AWGN =================
    rx = awgn(tx, SNR_dB, 'measured');
    
    % ============ Filtro receptor (matched filter) ==============
    rx_filt = conv(rx, h, 'same');
    
    % ============ Diagrama de ojo =======================
    figure;
    eyediagram(rx_filt, 2*Ns);
    
    title(['Diagrama de ojo (NRZ-L, 10^4 bits, AWGN, \alpha = ', num2str(alpha), ')']);
end


% --------------------------- 4) EFECTO DE FRECUENCIA DE MUESTREO BAJA ------------------------

Fs_low = 5*Rb;
Ns_low = Fs_low/Rb;

symbols_up_low = upsample(symbols, Ns_low);

alpha = 0.25;

h_low = rcosdesign(alpha, span, Ns_low, 'normal');

tx_low = conv(symbols_up_low, h_low, 'same');
rx_low = awgn(tx_low, SNR_dB, 'measured');
rx_low_filt = conv(rx_low, h_low, 'same');

figure;
eyediagram(rx_low_filt, 2*Ns_low);

title('Diagrama de ojo con baja frecuencia de muestreo');

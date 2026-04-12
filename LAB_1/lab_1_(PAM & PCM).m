%% LAB 1 - PAM & PCM
%% Jose Avello - Joaquin Moya - Alvaro Valdebenito


clc; clear; close all;
reset(groot)

%% --- parametros ---
Amp = 1;
f_signal = 1000;
fs_high = 100000;
dt = 1/fs_high;
t_final = 0.005;

t = 0:dt:t_final;
signal = Amp * sin(2*pi*f_signal*t);

%% --- muestreo ---
fs_sample = 8000;
Ts = 1/fs_sample;
duty = 0.3;
pulse_width = duty * Ts;

%% --- indices de muestreo ---
step_idx = round(Ts/dt);
idx_samples = 1:step_idx:length(t);
idx_samples = idx_samples(idx_samples <= length(t));

t_samples = t(idx_samples);
samples = signal(idx_samples);

%% --- PAM Natural ---
pulse_train = (mod(t, Ts) < pulse_width);
pam_nat = signal .* double(pulse_train);

%% --- PAM instantaneo (flat-top) ---
pam_flat = zeros(size(t));
for k = 1:length(idx_samples)
    t0 = t(idx_samples(k));
    region = (t >= t0) & (t < t0 + pulse_width);
    pam_flat(region) = samples(k);
end

%% --- FFT ---
nfft = 2^nextpow2(length(t));
freq = (0:nfft-1)*(fs_high/nfft);
half = 1:floor(nfft/2);

S = abs(fft(signal, nfft))/nfft;
P_nat = abs(fft(pam_nat, nfft))/nfft;
P_flat = abs(fft(pam_flat, nfft))/nfft;

%% --- PCM---

vmin = -Amp; 
vmax = Amp;
N_bits = 4;

[q_samples, err] = cuantizador(samples, vmin, vmax, N_bits);

%% reconstruccion tipo PAM cuantificado (flat-top)
pcm_signal = zeros(size(t));
for k = 1:length(idx_samples)
    t0 = t(idx_samples(k));
    region = (t >= t0) & (t < t0 + pulse_width);
    pcm_signal(region) = q_samples(k);
end

%% --- MSE ---
bits_vec = 2:8;
MSE = zeros(size(bits_vec));

for i = 1:length(bits_vec)
    [~, e] = cuantizador(samples, vmin, vmax, bits_vec(i));
    MSE(i) = mean(e.^2);
end


%% GRAFICOS


%% señales
figure;
plot(t, signal,'--','Color',[0.2 0.2 0.2],'LineWidth',1.2); hold on;
plot(t, pam_nat,'Color',[0 0.6 0.3],'LineWidth',1.5);
plot(t, pam_flat,'Color',[0.9 0.4 0],'LineWidth',1.5);
grid on;
title('Señal original vs PAM');
legend('Original','PAM Natural','PAM Instantáneo');

%% FFT
figure;
plot(freq(half), S(half),'--','Color',[0.2 0.2 0.2],'LineWidth',1.2); hold on;
plot(freq(half), P_nat(half),'Color',[0 0.6 0.3],'LineWidth',1.5);
plot(freq(half), P_flat(half),'Color',[0.9 0.4 0],'LineWidth',1.5);
grid on;
xlabel('Frecuencia (Hz)');
title('Espectros');
legend('Original','PAM Natural','PAM Instantáneo');

%% PCM
figure;
plot(t, signal,'--','Color',[0.2 0.2 0.2],'LineWidth',1.2); hold on;
plot(t, pam_flat,'Color',[0.9 0.4 0],'LineWidth',1.5);
plot(t, pcm_signal,'Color',[0 0.3 0.8],'LineWidth',1.8);
grid on;
title(['PCM con ', num2str(N_bits),' bits']);
legend('Original','PAM Instantáneo','Cuantizada');

%%error de cuantización
figure;
stem(t_samples, err,'filled','Color',[0.85 0.2 0.2]);
grid on;
title('Error de cuantización');


%% FUNCION CUANTIZADOR

function [q_samples, err] = cuantizador(samples, vmin, vmax, N)

    L = 2^N;
    delta = (vmax - vmin)/L;

    niveles = vmin + (0.5:1:(L-0.5))*delta;

    samples_clip = min(max(samples, vmin), vmax - eps);
    idx = floor((samples_clip - vmin)/delta) + 1;
    idx = min(max(idx,1),L);

    q_samples = niveles(idx);
    err = samples - q_samples;
end

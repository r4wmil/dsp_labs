
% --- DATA (v. 9) ---

U1 = 4; U2 = 7; U3 = 10; U4 = 0;
T1 = 4; T2 = 7;
Fa = 4;
Ta = 1 / Fa;

k1 = (U2 - U1) / (T1 - 0);
b1 = U1 - k1 * 0;
k2 = (U4 - U3) / (T2 - T1);
b2 = U3 - k2 * T1;

ti1 = 0 : Ta : T1 - Ta;
ti2 = T1 : Ta : T2;
fi1 = k1 * ti1 + b1;
fi2 = k2 * ti2 + b2;

t1 = 0 : Ta : T1 - Ta;
t2 = T1 : Ta : T2;
t = [t1 t2];
f1 = k1 * t1 + b1;
f2 = k2 * t2 + b2;
U = [f1 f2];

figure;
hold on;
grid on;
plot(t1, fi1, 'r--');
plot(ti2, fi2, 'r--');
stem(t, U, 'b--');
title('Initial');
xlabel('t, sample');
ylabel('U, V');

% --- 2. FFT (Fast Fourier Transform) ---

S = fft(U);

figure
subplot(2, 1, 1);
stem(abs(S));
title('Module');
xlabel('k');
ylabel('|S(k)|');
grid on;
subplot(2, 1, 2);
stem(angle(S));
title('Phase');
xlabel('k');
ylabel('arg[S(k)]');
grid on;

% --- 3. Spectre width ---

E0 = sum(U.^2)

function [Ur, Nmax] = signal_reconstruct(S, E0, threshold)
    Nmax = 0;
    while true
        Sf = S; % Spectere filtered
        Sf(Nmax+2 : end-Nmax) = 0;
        Ur = ifft(Sf, 'symmetric'); % Signal recovered
        Er = sum(Ur.^2);
        if Er / E0 >= threshold
           Er
           break
        end
        Nmax = Nmax + 1;
    end
end

[Ur90, Nmax90] = signal_reconstruct(S, E0, 0.9);
[Ur99, Nmax99] = signal_reconstruct(S, E0, 0.99);

figure;
grid on;
subplot(2, 1, 1);
stem(U, 'b');
legend('Initial');
subplot(2, 1, 2);
hold on;
stem(Ur90, 'r', 'Marker', 'x');
stem(Ur99, 'r', 'LineStyle', 'none', 'Marker', 'o');
hold off;
legend('Er / E0 >= 90%', 'Er / E0 >= 99%');
legend show;
xlabel('t, sample');
ylabel('U, V');

% --- 4. Padding with zeroes ---

Up = [U, zeros(1, length(U))];
Sp = fft(Up);

figure
subplot(2, 1, 1);
stem(abs(Sp));
title('Module (zero padded)');
xlabel('k');
ylabel('|Sp(k)|');
grid on;

subplot(2, 1, 2);
stem(angle(Sp));
title('Phase (zero padded)');
xlabel('k');
ylabel('arg[Sp(k)]');
grid on;

% --- 5-6. Direct DFT vs FFT

Nv = [64, 128, 256, 512, 1024, 2048, 4096, 8192];

K_dft = 60;
t_dft = zeros(size(Nv));
for idx = 1:length(Nv)
    N = Nv(idx);
    x_padded = [U, zeros(1, N - length(U))];
    D = dftmtx(N);
    tic
    for k = 1:K_dft
        y = x_padded * D;
    end
    t_dft(idx) = toc;
    fprintf('DFT N = %d, %.4f %.3f с\n', N, t_dft(idx), t_dft(idx)/K_dft*10^6);
end
T_dft_us = (t_dft / K_dft) * 1e6;

K_fft = 100000;
t_fft = zeros(size(Nv));
for idx = 1:length(Nv)
    N = Nv(idx);
    tic
    for k = 1:K_fft
        y = fft(U, N);
    end
    t_fft(idx) = toc;
    fprintf('FFT N = %d, %.4f %.3f с\n', N, t_fft(idx), t_fft(idx)/K_fft*10^6);
end
T_fft_us = (t_fft / K_fft) * 1e6;

% Approximated
k1 = T_dft_us(end) / (Nv(end)^2);
k2 = T_fft_us(end) / (Nv(end)*log2(Nv(end)));

N_fit = Nv;
t_fit_dft = k1 * N_fit.^2;
t_fit_fft = k2 * N_fit .* log2(N_fit);

fprintf('k1 = %.3e с\n', k1);
fprintf('k2 = %.3e с\n', k2);

figure;
loglog(Nv, T_dft_us, 'b-o', 'LineWidth', 1.5);
hold on;
loglog(Nv, t_fit_dft, 'b--', 'LineWidth', 1);
grid on;
xlabel('N');
ylabel('Время, мкс');

figure;
loglog(Nv, T_fft_us, 'r-s', 'LineWidth', 1.5);
hold on;
loglog(Nv, t_fit_fft, 'r--', 'LineWidth', 1);
grid on;
xlabel('N');
ylabel('Время, мкс');

figure;
loglog(Nv, T_dft_us, 'b-o', 'LineWidth', 1.5);
hold on;
loglog(Nv, t_fit_dft, 'b--', 'LineWidth', 1);
loglog(Nv, T_fft_us, 'r-s', 'LineWidth', 1.5);
loglog(Nv, t_fit_fft, 'r--', 'LineWidth', 1);
grid on;
xlabel('N');
ylabel('Время, мкс');
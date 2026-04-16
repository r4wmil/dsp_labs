
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

N = length(Ur99)
delta_f = (Nmax99 - 1) * (4000 / N)

return;

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

% DFT
K_dft = 1200;
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
end

% FFT
K_fft = 190000;
t_fft = zeros(size(Nv));
for idx = 1:length(Nv)
    N = Nv(idx);
    tic
    for k = 1:K_fft
        y = fft(U, N);
    end
    t_fft(idx) = toc;
end

T_dft = t_dft / K_dft;
T_fft = t_fft / K_fft;

k1 = sum(T_dft .* (Nv.^2)) / sum((Nv.^2).^2)
k2 = sum(T_fft .* (Nv .* log2(Nv))) / sum((Nv .* log2(Nv)).^2)

to1 = log2(T_dft);
to2 = log2(T_fft);
N1 = log2(Nv);
tt1 = log2(k1 * (Nv.^2));
tt2 = log2(k2 * Nv .* log2(Nv));

figure
hold on
grid on
plot(N1, to1, 'r-');
plot(N1, tt1, 'b--');
title('Затраты времени на однократное вычисление (прямое ДПФ)');
xlabel('log2(N)');
ylabel('log2(t), с');

figure
hold on
grid on
plot(N1, to2, 'r-');
plot(N1, tt2, 'b--');
title('Затраты времени на однократное вычисление (БПФ)');
xlabel('log2(N)');
ylabel('log2(t), с');

figure
hold on
grid on
plot(N1, to1, 'r-');
plot(N1, tt1, 'r--');
plot(N1, to2, 'b-');
plot(N1, tt2, 'b--');
title('Затраты времени на однократное вычисление');
xlabel('log2(N)');
ylabel('log2(t), с');

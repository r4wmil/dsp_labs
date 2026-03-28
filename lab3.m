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
xlabel('t, ms');
ylabel('U, V');

% --- FFT (Fast Fourier Transform) ---

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
Fpass = 0.5;
Fd = 4;
w0 = 2 * pi * (Fpass / Fd);

k = -20:20;

h = sin(w0 * k) ./ (pi * k);
h(k == 0) = w0 / pi;

stem(n, h, 'filled', 'LineWidth', 1.5);
xlabel('k (samples)');
ylabel('h_k');
title('F_{pass} = 0.5 kHz, F_д = 4 kHz');
grid on;
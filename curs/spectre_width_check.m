function U = spectre(T1, w)
    a1 = 2 / T1;
    a2 = 6 / (5 - T1);

    U = ( (a1 + (a2 - a1)*exp(-1j*w*T1) - a2*exp(-1j*w*5)) ./ (1j*w).^2 ) + ...
        ( (3 - 2*exp(-1j*w*T1) - 9*exp(-1j*w*5)) ./ (1j*w) );

    ReU = (a1 + (a2 - a1)*cos(w*T1) - a2*cos(5*w))./(w.^2) + ...
          (-2*sin(w*T1) - 9*sin(5*w))./w;
    
    ImU = ((a2 - a1)*sin(w*T1) - a2*sin(5*w))./(w.^2) + ...
          (-3 + 2*cos(w*T1) + 9*cos(5*w))./w;

    Uc = ReU + 1j*ImU;


    absUc = abs(Uc);
    absU = abs(U);
    [maxU, ~] = max(absU);
    threshold = 0.1 * maxU;

    w_pos = w(w > 0);
    absU_pos = absU(w > 0);
    idx = find(absU_pos >= threshold, 1, 'last');
    w_width = w_pos(idx);

    figure;
    plot(w, absU, 'LineWidth', 1.5); hold on;
    plot(w, absUc, 'LineWidth', 1.5, 'LineStyle', '--'); hold on;
    line([-w_width, w_width], [threshold, threshold], 'Color', 'r', 'LineStyle', '--');
    plot(w_width, threshold, 'ro', 'MarkerFaceColor', 'r', 'HandleVisibility', 'off');
    plot(-w_width, threshold, 'ro', 'MarkerFaceColor', 'r', 'HandleVisibility', 'off');
    
    xlabel('\omega (rad/s)'); ylabel('|U(\omega)|');
    title(['Magnitude Spectrum for T_1 = ', num2str(T1), ' (Width \approx ', num2str(w_width, '%.2f'), ')']);
    grid on;
    legend('|U(\omega)|', '10% Width', 'Location', 'northeast');

    % --- FFT Part ---
    fs = 180;                 % Частота дискретизации
    dt = 1/fs;                % Шаг по времени
    t = 0:dt:5;               % Временной вектор до 5с
    
    % Определение сигнала: наклон от 3 до 5, затем от 3 до 9
    x = (3 + (2/T1)*t) .* (t < T1) + ...
        (3 + (6/(5-T1))*(t-T1)) .* (t >= T1);

    N_fft = 2^12;             % Zero-padding для точности
    X_fft = fft(x, N_fft) * dt; % Нормировка FFT для соответствия аналитике
    
    % Вектор частот в рад/с
    freqs = (0:N_fft-1) * (fs/N_fft) * 2 * pi;
    
    % Ограничение для визуализации (только положительные частоты)
    idx_plot = freqs <= max(w);
    
    % Наложение на существующий график
    hold on;
    stem(freqs(idx_plot), abs(X_fft(idx_plot)), 'Marker', 'none');
    legend('|U(\omega)| Analytical', 'Re+Im check', '10% Width', 'FFT Spectrum');
end

w = linspace(-20, 20, 10000);
w = w(w ~= 0);
spectre(1, w);
spectre(2, w);
spectre(4, w);
function U = spectre(T1, w)
    a1 = 2 / T1;
    a2 = 6 / (5 - T1);

    % --- Analytical ---
    U = ( (a1 + (a2 - a1)*exp(-1j*w*T1) - a2*exp(-1j*w*5)) ./ (1j*w).^2 ) + ...
        ( (3 - 2*exp(-1j*w*T1) - 9*exp(-1j*w*5)) ./ (1j*w) );
    absU = abs(U);

    % --- Reconstructed from real & imaginary ---
    ReU = -(a1 + (a2 - a1)*cos(w*T1) - a2*cos(5*w))./(w.^2) - ...
          (-2*sin(w*T1) - 9*sin(5*w))./w;
    ImU = ((a2 - a1)*sin(w*T1) - a2*sin(5*w))./(w.^2) + ...
          (-3 + 2*cos(w*T1) + 9*cos(5*w))./w;
    Uc = ReU + 1j*ImU;
    absUc = abs(Uc);

    % --- Width (10% criteria) ---
    [maxU, ~] = max(absU);
    threshold = 0.1 * maxU;
    w_pos = w(w > 0);
    absU_pos = absU(w > 0);
    idx = find(absU_pos >= threshold, 1, 'last');
    w_width = w_pos(idx);

    % --- FFT error check ---
    fs = 180; % sampling rate
    dt = 1/fs; % time step
    t = 0:dt:5;
    
    x = (3 + (2/T1)*t) .* (t < T1) + ...
        (3 + (6/(5-T1))*(t-T1)) .* (t >= T1);

    N_fft = 2^12; % zero-padding
    X_fft = fft(x, N_fft) * dt;
    
    freqs = (0:N_fft-1) * (fs/N_fft) * 2 * pi;
    
    idx_plot = freqs <= max(w);
    
    % --- Figures ---
    figure;
    subplot(2,1,1);
    plot(w, absU, 'LineWidth', 1.5); hold on;
    plot(w, absUc, 'LineWidth', 1.5, 'LineStyle', '--'); hold on;
    line([-w_width, w_width], [threshold, threshold], 'Color', '#f55', 'LineStyle', '--');
    plot(w_width, threshold, 'ro', 'MarkerFaceColor', '#f55', 'HandleVisibility', 'off');
    plot(-w_width, threshold, 'ro', 'MarkerFaceColor', '#f55', 'HandleVisibility', 'off');
    xlabel('\omega (rad/us)'); ylabel('|U(\omega)|');
    grid on;
    hold on;
    stem(freqs(idx_plot), abs(X_fft(idx_plot)), 'Marker', 'none', 'Color', '#aaa');
    title(['Magnitude Spectrum for T_1 = ', num2str(T1), ' (Width \approx ', num2str(w_width, '%.2f'), ')']);
    legend('Analytical', 'Reconstructed (Re + i*Im)', '10% criteria', 'FFT check');
    
    subplot(2,1,2);
    plot(w, angle(U), 'LineWidth', 1.5); hold on;
    plot(w, angle(Uc), 'LineWidth', 1.5, 'LineStyle', '--'); hold on;
    xlabel('\omega (rad/us)'); ylabel('Arg[U(\omega)]');
    stem(freqs(idx_plot), angle(X_fft(idx_plot)), 'Marker', 'none', 'Color', '#aaa');
    grid on;
    legend('Analytical', 'Reconstructed (Re + i*Im)', 'FFT check');
end

w = linspace(-20, 20, 10000);
w = w(w ~= 0);
spectre(1, w);
spectre(2, w);
spectre(4, w);
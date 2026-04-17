function U = spectre(T1, w)
    a1 = 2 / T1;
    a2 = 6 / (5 - T1);

    U = ( (a1 + (a2 - a1)*exp(-1j*w*T1) - a2*exp(-1j*w*5)) ./ (1j*w).^2 ) + ...
        ( (3 - 2*exp(-1j*w*T1) - 9*exp(-1j*w*5)) ./ (1j*w) );

    absU = abs(U);
    [maxU, ~] = max(absU);
    threshold = 0.1 * maxU;

    w_pos = w(w > 0);
    absU_pos = absU(w > 0);
    idx = find(absU_pos >= threshold, 1, 'last');
    w_width = w_pos(idx);

    figure;
    plot(w, absU, 'LineWidth', 1.5); hold on;
    line([-w_width, w_width], [threshold, threshold], 'Color', 'r', 'LineStyle', '--');
    plot(w_width, threshold, 'ro', 'MarkerFaceColor', 'r');
    plot(-w_width, threshold, 'ro', 'MarkerFaceColor', 'r');
    
    xlabel('\omega (rad/s)'); ylabel('|U(\omega)|');
    title(['Magnitude Spectrum for T_1 = ', num2str(T1), ' (Width \approx ', num2str(w_width, '%.2f'), ')']);
    grid on;
    legend('|U(\omega)|', '10% Width', 'Location', 'northeast');
end

w = linspace(-20, 20, 10000);
w = w(w ~= 0);
spectre(1, w);
spectre(2, w);
spectre(4, w);
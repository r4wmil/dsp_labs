function U = spectre(T1, w)
    a1 = 2 / T1;
    a2 = 6 / (5 - T1);

    U = ( (a1 + (a2 - a1)*exp(-1j*w*T1) - a2*exp(-1j*w*5)) ./ (1j*w).^2 ) + ...
        ( (3 - 2*exp(-1j*w*T1) - 9*exp(-1j*w*5)) ./ (1j*w) );

    figure;
    plot(w, abs(U), 'LineWidth', 1.5);
    xlabel('\omega (rad/s)');
    ylabel('|U(\omega)|');
    title(['Magnitude Spectrum |U(\omega)| for T_1 = ', num2str(T1)]);
    grid on;
end

w = linspace(-20, 20, 5000);
w = w(w ~= 0);
spectre(1, w);
spectre(2, w);
spectre(4, w);
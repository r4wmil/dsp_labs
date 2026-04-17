function U = spectre(T1, w)
    a = 2/T1;
    b = 6/(5 - T1);
    
    w(w==0) = 1e-10;
    U = (-a - (b - a)*exp(-1j*w*T1) + b*exp(-1j*w*5) ...
         - 1j*w.*(3 - 2*exp(-1j*w*T1) - 9*exp(-1j*w*5))) ./ (w.^2);

    figure;
    plot(w, abs(U), 'LineWidth', 1.5);
    xlabel('\omega (rad/s)');
    ylabel('|U(\omega)|');
    title('Magnitude Spectrum |U(\omega)|');
    grid on;
end

w = linspace(-20, 20, 5000);
spectre(1, w);
spectre(2, w);
spectre(4, w);
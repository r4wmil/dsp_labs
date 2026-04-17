U1 = 3; U2 = 5; U3 = 3; U4 = 9;
T11 = 1; T12 = 2; T13 = 4;
T21 = 5;
W0 = 1.55e-5; F = 89.2572e6;

U = [0, 0, U1, U2, U3, U4, 0, 0];
T1 = [-1, 0, 0, T11, T11, T21, T21, T21+1];
T2 = [-1, 0, 0, T12, T12, T21, T21, T21+1];
T3 = [-1, 0, 0, T13, T13, T21, T21, T21+1];

figure
hold on
plot(T1, U, '-', 'LineWidth', 2)
plot(T2, U, '--', 'LineWidth', 2)
plot(T3, U, ':', 'LineWidth', 2)
hold off
legend('T1=1', 'T1=2', 'T1=4')
xlabel('Time')
ylabel('Signal')
grid on
xlim([-1, T21+1])
ylim([-1, max(U)+1])

figure
hold on
w = linspace(-1.5*F, 1.5*F, 1000);
W = W0 * (abs(w) < F);
plot(w, W, 'LineWidth', 2)
xlabel('\omega')
ylabel('W(\omega)')
title('PSD')
grid on
xlim([-1.5*F, 1.5*F])
ylim([0, W0*1.2])
hold off
run('var.m');

% --- STEP 2 ---

N = T2 * Fa + 1;
k = (0:N-1).';
w = -pi : (2 * pi) / 777 : pi;
S = U * exp(-1i * k * w);

figure
hold on;
grid on;
subplot(2, 1, 1);
plot(w, abs(S));
title('Amplitude spectre');
xlabel('w, rad/smpl');
ylabel('||U(f)||');
subplot(2, 1, 2);
plot(w, angle(S));
title('Phase spectre');
xlabel('w, rad/smpl');
ylabel('arg(U(f))');



% --- STEP 3 ---

Td = Ta;
t1 = -2 : 0.05 : (T2 + 2);
Fr = zeros(1, length(t1));
for i = 1:N
    Fr = Fr + U(i) .* sinc((t1 - (i - 1) .* Td) ./ Td);
end

figure;
hold on;
grid on;
plot(t1, Fr, 'r--');
stem(t, U, 'b--');
title('Source/Restored');
xlabel('t, ms');
ylabel('U, V');

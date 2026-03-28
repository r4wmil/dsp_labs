s% --- DATA (v. 9) ---

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

b = [ +0.0008 +0.0032 +0.0048 +0.0032 +0.0008 ];
a = [ +1.0000 -3.2396 +4.1442 -2.4599 +0.5696 ];
% --- STEP 2 ---

U0 = [U, zeros(1, 2 * length(U1))];
Uf1 = filter(b, a, U0);
maxf1 = max(Uf1)
figure;
hold on;
grid on;
stem(Uf1, 'b--');
title('Filtered (v1)');
xlabel('t, samples');
ylabel('U, V');

% --- STEP 3 ---

Uf2 = filter(1, a, U0);
maxf2 = max(Uf2)

figure;
hold on;
grid on;
stem(Uf2, 'b--');
title('Filtered (v2)');
xlabel('t, samples');
ylabel('U, V');

maxf0 = max(abs(U0));
maxf2 = max(abs(Uf2));
maxp = max(maxf0, maxf2);

% --- STEP 4 ---

states = [];
s = [];
for k = 1 : length(U0)
	[Uf3(k),s] = filter(b,a,U0(k),s);
	states = [states s];
end

figure
plot(states');
grid on;
title('Internal signals');
xlabel('t, samples');
ylabel('U, V');
maxtr = max(max(abs(states)))

fvtool(b, a);

% --- STEP 5 ---

[r, p, k] = residuez(b, a);
mr = abs(r)
mp = abs(p)
pr = angle(r)
pp = angle(p)
k


close all;
t=64:0.001:256;
y=sqrt(t);
figure(1)
hold on;
n = 3;
plot(t,y, 'linewidth',2.5)
p = polyfit(t,y,n)
z = p(end);
for i = 1:n
    z = z + p(i).*t.^(n-i+1);
end

% b = p(1) .* t.^2 + p(2) .* t.^1;
plot(t, z, 'r', 'linewidth', 1.5)
% plot(t, b, 'y', 'linewidth', 1.5)
% axis([.9, 1.04, 1.1, 1.7])

axis_size = 10;
set(legend('Actual', 'Formula'), 'fontsize',...
    axis_size, 'location', 'SouthEast');

figure(2)
plot(t, y-z)
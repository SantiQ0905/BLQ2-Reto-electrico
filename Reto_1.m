% Parameters
q = 1e-9; % Charge magnitude (Coulombs)
d = 1; % Distance between charges (meters)
epsilon0 = 8.854e-12; % Vacuum permittivity (F/m)

% Grid setup
[x, y] = meshgrid(linspace(-2, 2, 30), linspace(-2, 2, 30));

% Dipole position
x_pos = d/2; x_neg = -d/2;

% Calculate electric field components
Ex = 0; Ey = 0;
for charge = [-1, 1]
    r_x = x - charge * x_pos;
    r_y = y;
    r = sqrt(r_x.^2 + r_y.^2);
    r(r==0) = NaN; % Avoid division by zero
    Ex = Ex + charge*q./(4*pi*epsilon0*r.^3).*r_x;
    Ey = Ey + charge*q./(4*pi*epsilon0*r.^3).*r_y;
end

% Normalize the field vectors (for visualization purposes)
E = sqrt(Ex.^2 + Ey.^2);
Ex_unit = Ex./E;
Ey_unit = Ey./E;

% Plotting
figure;
hold on;
quiver(x, y, Ex_unit, Ey_unit, 'r');

% Draw charges
viscircles([x_pos, 0; x_neg, 0], [0.05; 0.05], 'Color', 'r', 'LineWidth', 1);
scatter(x_pos, 0, 'r', 'filled', 'MarkerEdgeColor', 'k');
scatter(x_neg, 0, 'b', 'filled', 'MarkerEdgeColor', 'k');
hold off;

xlabel('x (m)');
ylabel('y (m)');
title('Electric Field of a Dipole');
axis equal;

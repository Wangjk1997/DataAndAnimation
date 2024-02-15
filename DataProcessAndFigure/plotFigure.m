Data = load('./20230519142556.mat');
roll = Data.logger.Theta(1, : );
pitch = Data.logger.Theta(2, :);
yaw = Data.logger.Theta(3, :);
energy = Data.logger.Energy;
vx = Data.logger.v_bn_b(1, :);
vy = Data.logger.v_bn_b(2, :);
altitude = Data.logger.p_bn_n(3, :);

frequency = 120;
figure
Xaxis = (1:size(Data.logger.Theta, 2))/frequency;
plot(Xaxis, roll)
hold on
plot(Xaxis, pitch)
plot(Xaxis, yaw)
legend('roll','pitch','yaw', 'Location','southeast')
grid on
grid minor
xlabel("Time/s")
ylabel("Euler Angle/rad")
x0=100; y0=100;
width=400; height=220;
set(gcf,'units','points','position',[x0,y0,width,height])

figure 
plot(Xaxis, energy)
xlabel("Time/s")
ylabel("System Energy/J")
grid on
grid minor
x0=100; y0=100;
width=400; height=220;
set(gcf,'units','points','position',[x0,y0,width,height])

figure
subplot(2,1,1)
roll = roll + (roll<-7/8*pi) * 2*pi;
plot(Xaxis, roll_plot)
hold on
plot(Xaxis, pitch)
plot(Xaxis, yaw)
ylim([-2.5, -2.5 + 2*pi])

legend('Roll','Pitch','Yaw', 'Location','southeast')
grid on
grid minor
ylabel("Euler Angle(rad)")



subplot(2,1,2)
p_current_energy = plot(Xaxis, energy);
hold on
% Init energy
% Desired energy
init_energy = -0.0375;
desired_energy = 0.0375;

p_init_energy = plot(Xaxis, init_energy * ones(size(Xaxis)), '--');
p_desired_energy = plot(Xaxis, desired_energy * ones(size(Xaxis)), '--');

xlabel("Time(s)")
ylabel("Energy(J)")
grid on
grid minor
legend([p_current_energy, p_init_energy, p_desired_energy], {'System Energy','Initial Energy','Desired Energy'}, 'Location','east')
x0=100; y0=100;
width=400; height=220;
set(gcf,'units','points','position',[x0,y0,width,height])
print('-dpng','-r300','IMG_angleAndEnergy.png')

% Height and Velocity
figure
subplot(3,1,1)
vx(1:10) = zeros(1, 10);
plot(Xaxis, vx)
grid on
grid minor
hold on
plot(Xaxis, zeros(size(vx)), '--')
legend('Surge Velocity', 'Desired Surge Velocity')
ylim([-0.35, 0.35])
ylabel("Surge Velocity(m/s)")

subplot(3,1,2)
vy(1:10) = zeros(1, 10);
plot(Xaxis, vy)
grid on
grid minor
hold on
plot(Xaxis, zeros(size(vy)), '--')
legend('Sway Velocity', 'Desired Sway Velocity')
ylim([-0.35, 0.35])
ylabel("Sway Velocity(m/s)")

subplot(3,1,3)
altitude(1:10) = -1.4 * ones(1,10);
plot(Xaxis,altitude - 0.03)
grid on
grid minor
hold on
plot(Xaxis, -1.3 * ones(size(altitude)), '--')
legend('Altitude', 'Desired Altitude')
ylim([-1.5, -1.1])
ylabel("Altitude(m)")
xlabel("Time(s)")

x0=100; y0=100;
width=400; height=330;
set(gcf,'units','points','position',[x0,y0,width,height])
print('-dpng','-r300','IMG_velocityAndHeight.png')

Data = load('../data/20230329145516');
roll = Data.logger.Theta(1, : );
pitch = Data.logger.Tueta(2, :);
yaw = Data.logger.Theta(3, :);
frequency = 120;
figure
Xaxis = 1:size(Data.logger.Theta, 2)/frequency;
plot(Xaxis, roll)
hold on
plot(Xaxis, pitch)
plot(Xaxis, yaw)
legend('roll','pitch','yaw')


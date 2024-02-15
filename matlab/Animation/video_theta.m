% Input
input = 10:length(logger.Theta(1,:));
output = logger.Theta(1,10:length(logger.Theta(1,:)));
time = length(logger.Theta(1,:)) - 9;
fileName = 'myVideo_theta.avi';
frameRate = 120;
showTime = 5;

% Initialize the video writer and animation
myVideo = VideoWriter(fileName);
myVideo.FrameRate = frameRate;
myVideo.Quality = 100;
open(myVideo);

% Initialize the figure
figure
h = animatedline('Color','b');
xlabel('Time/s');
ylabel('Roll Angle/rad');
grid on
title('Roll Angle')

% Main loop

for i = 1:time
    if i < myVideo.FrameRate * showTime
        xlim([0,showTime]);
    else
        xlim([input(i)/myVideo.FrameRate - showTime, input(i)/myVideo.FrameRate]);
    end
    ylim([-3.5, 3.5]);
    addpoints(h, input(i)/myVideo.FrameRate, output(i));
    drawnow limitrate
    frame = getframe(gcf);
    writeVideo(myVideo, frame);
end

close(myVideo);

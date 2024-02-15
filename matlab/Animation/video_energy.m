% Input
input = 10:length(logger.Energy);
output = logger.Energy(10:length(logger.Energy));
time = length(logger.Energy) - 9;
fileName = 'myVideo.avi';
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
ylabel('Energy/J');
grid on
title('System Energy')

% Main loop

for i = 1:time
    if i < myVideo.FrameRate * showTime
        xlim([0,showTime]);
    else
        xlim([input(i)/myVideo.FrameRate - showTime, input(i)/myVideo.FrameRate]);
    end
    ylim([-0.05, 0.05]);
    addpoints(h, input(i)/myVideo.FrameRate, output(i));
    drawnow limitrate
    frame = getframe(gcf);
    writeVideo(myVideo, frame);
end

close(myVideo);

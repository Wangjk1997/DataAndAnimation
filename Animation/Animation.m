clc; close all;
Data=load('../data/20230329145516');
x=Data.logger.p_gn_n(1,:);
y=Data.logger.p_gn_n(2,:);
z=Data.logger.p_gn_n(3,:);
xr=Data.logger.reference(1,:);
yr=Data.logger.reference(2,:);
zr=Data.logger.reference(3,:);
total_it=length(x);
bound=[-2.5 1.3 -1.5 1.5];
agentscolor_blimp=[0 0 1];
agentscolor_ref=[1 0 0];
blimp=[x(1) y(1)];
target=[xr(1) yr(1)];

%% Initiate Video Recording if required
video_flag = true;
if video_flag
    figure;
    %pause;
    myVideo = VideoWriter( '../video/circle', 'MPEG-4');
    myVideo.FrameRate = 20;
    myVideo.Quality = 100;
    open(myVideo);
end
fighandle = figure(1);
clear drawing_handles
trail_blimp.x = blimp(1);
trail_blimp.y = blimp(2);
trail_target.x = target(1);
trail_target.y = target(2);
trail_idx = 1;
for it=1:5:total_it-1
    
    zz=-z(it);
    if ~exist('drawing_handles')
        drawing_handles =show_animation(trail_idx,fighandle,blimp,bound,1, struct(),trail_blimp,agentscolor_blimp,agentscolor_ref,zz,target,trail_target);
    else
        drawing_handles =show_animation(trail_idx,fighandle,blimp,bound,1,drawing_handles,trail_blimp,agentscolor_blimp,agentscolor_ref,zz,target,trail_target);
    end
    %r=[x(it) y(it)];
    blimp=[x(it+1) y(it+1)];
    target=[xr(it+1) yr(it+1)];
    trail_idx = trail_idx + 1;
    trail_blimp.x(trail_idx,:) = blimp(1);
    trail_blimp.y(trail_idx,:) = blimp(2);
    trail_target.x(trail_idx,:) = target(1);
    trail_target.y(trail_idx,:) = target(2);
    %% Video recording
    if video_flag
        frame = getframe(gcf);
        writeVideo(myVideo, frame);
    end
end
if video_flag; close(myVideo); end



function handles = show_animation(step,fighandle,r,bound,N,handles,trail_blimp,agentscolor_blimp,agentscolor_ref,zz,target,trail_target)
trail_on = true;
custom_colormap = [
    1  0 0 ; ... %// red
    1 .5 0 ; ... %// orange
    1  1 0 ; ... %// yellow
    0  1 0 ; ... %// green
    0  0 1 ; ... %// blue
    ] ;
if zz>=0.8 iclr=1;end
if zz>=0.7&&zz<0.8 iclr=2;end
if zz>=0.6&&zz<0.7 iclr=3;end
if zz>=0.5&&zz<0.6 iclr=4;end
if zz<0.5 iclr=5;end
trail_blimp_color = [0, 0, 1, 0.8]; % [Red, Green, Blue, Opacity]
trail_target_color = [1, 0, 0, 0.8]; % [Red, Green, Blue, Opacity]
%trail_r_color =custom_colormap(iclr,:);
ghost_interval = 0;
ghost_line_width_r = 5;
set(0, 'CurrentFigure', fighandle)

if isempty(fieldnames(handles))
      grid on
      hold on
      h_trail_blimp = line(trail_blimp.x(:,1:N),trail_blimp.y(:,1:N));
      h_trail_blimp.Color=trail_blimp_color;
      h_trail_blimp.LineWidth=ghost_line_width_r;
      
      h_trail_target = line(trail_target.x(:,1:N),trail_target.y(:,1:N));
      h_trail_target.Color=trail_target_color;
      h_trail_target.LineWidth=ghost_line_width_r;
      
      %colormap custom_colormap
%       h=colorbar;
%       h.Limits = [0.45 0.9];
      h_mar = scatter(r(1:N,1),r(1:N,2),700*ones(N,1),agentscolor_blimp,'filled');
      set ( gca, 'xdir', 'reverse' )
      h_mar_ref = scatter(target(1),target(2),700*ones(N,1),agentscolor_ref,'filled');
      set ( gca, 'xdir', 'reverse' )
      %set(gca,'color',[0 0 0 0.6])
      hold off
      axis(bound);
      title(['The Blimp Height is ',num2str(zz),' C'])
      axis equal
      %axis square
    
    handles = struct('mar',h_mar,'trail_blimp',h_trail_blimp,'trail_target',h_trail_target,'mar_ref',h_mar_ref);%,'ghosts',ghosts
else
    set(handles.mar,'XData',r(1:N,1),'YData',r(1:N,2),'Cdata',agentscolor_blimp);
    set(handles.mar_ref,'XData',target(1),'YData',target(2),'Cdata',agentscolor_ref);
    %set(handles.trail_r,'XData',trail_r.x(:,1:N),'YData',trail_r.y(:,1:N),'Color',trail_r_color);
          title(['The Blimp Height is ',num2str(zz),' C'])

    if trail_on
        newX_r = num2cell(trail_blimp.x',2)';
        newY_r = num2cell(trail_blimp.y',2)';
        [handles.trail_blimp.XData] = newX_r{:};
        [handles.trail_blimp.YData] = newY_r{:}; 
        
         newX_target = num2cell(trail_target.x',2)';
        newY_target = num2cell(trail_target.y',2)';
        [handles.trail_target.XData] = newX_target{:};
        [handles.trail_target.YData] = newY_target{:};
    end
    
    if mod(step,ghost_interval) == 0
        handles.ghosts.loc.x = [handles.ghosts.loc.x; r(1:N,1)];
        handles.ghosts.loc.y = [handles.ghosts.loc.y; r(1:N,2)];
        set(handles.ghosts.markers_handle,'XData',handles.ghosts.loc.x,'YData',handles.ghosts.loc.y);
        
    end
end
drawnow;

%pause(1)
grid off
end

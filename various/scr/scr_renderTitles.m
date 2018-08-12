% This script is to render title videos
save2avi = 1;

fhandle = figure;
set( fhandle, 'doublebuffer', 'on' );
set( fhandle, 'Color', [0, 39, 118 ]/256 );
axis([-5 5 -5 5])
text(-5,3,'WP2.1 Distributed registration/fusion:','Fontsize',16,'Color',[255, 255, 255]/256,'FontName','Papyrus')
text(-5,2,'Separable pseudo-likelihoods for','Fontsize',16,'Color',[255, 255, 255]/256,'FontName','Papyrus','Fontangle','Italic')
text(-5,1,'efficient inference in dynamical models','Fontsize',16,'Color',[255, 255, 255]/256,'FontName','Papyrus','Fontangle','Italic')
text(-5,0,'E.g. Sensor calibration based on noisy ','Fontsize',16,'Color',[255, 255, 0]/256,'FontName','Papyrus')
text(-5,-1,'target measurements with false alarms','Fontsize',16,'Color',[255, 255, 0]/256,'FontName','Papyrus')
axis off
if save2avi == 1
    avifileName = [['title_seperable_likelihood'],'.avi'];
    aviobj = VideoWriter(avifileName, 'Uncompressed AVI');
    aviobj.FrameRate = 1 ; % This is the frame rate
    open(aviobj);
    aviFrame = getframe(gcf);
    writeVideo(aviobj,aviFrame);
    writeVideo(aviobj,aviFrame);
    writeVideo(aviobj,aviFrame);
    writeVideo(aviobj,aviFrame);
    writeVideo(aviobj,aviFrame);
    writeVideo(aviobj,aviFrame);
    close(aviobj);   
end
 

fhandle = figure;
set( fhandle, 'doublebuffer', 'on' );
set( fhandle, 'Color', [0, 39, 118 ]/256 );
axis([-5 5 -5 5])
text(-5,2,'... Self-localisation iterations','Fontsize',16,'Color',[255, 255, 0]/256,'FontName','Papyrus','Fontangle','Italic')
axis off
if save2avi == 1
    avifileName = [['title_iterations'],'.avi'];
    aviobj = VideoWriter(avifileName, 'Uncompressed AVI');
    aviobj.FrameRate = 1 ; % This is the frame rate
    open(aviobj);
    aviFrame = getframe(gcf);
    writeVideo(aviobj,aviFrame);
    writeVideo(aviobj,aviFrame);
    writeVideo(aviobj,aviFrame);
    writeVideo(aviobj,aviFrame);
    writeVideo(aviobj,aviFrame);
    writeVideo(aviobj,aviFrame);
    close(aviobj);   
 end



fhandle = figure;
set( fhandle, 'doublebuffer', 'on' );
set( fhandle, 'Color', [0, 39, 118 ]/256 );
axis([-5 5 -5 5])
text(-5,3,'WP2.1 Distributed registration/fusion:','Fontsize',16,'Color',[255, 255, 255]/256,'FontName','Papyrus')
text(-5,2,'Demonstration with real data','Fontsize',16,'Color',[255, 255, 255]/256,'FontName','Papyrus','Fontangle','Italic')
axis off
if save2avi == 1
    avifileName = [['title_self_localisation'],'.avi'];
    aviobj = VideoWriter(avifileName, 'Uncompressed AVI');
    aviobj.FrameRate = 1 ; % This is the frame rate
    open(aviobj);
    aviFrame = getframe(gcf);
    writeVideo(aviobj,aviFrame);
    writeVideo(aviobj,aviFrame);
    writeVideo(aviobj,aviFrame);
    writeVideo(aviobj,aviFrame);
    writeVideo(aviobj,aviFrame);
    writeVideo(aviobj,aviFrame);
    close(aviobj);   
 end



fhandle = figure;
set( fhandle, 'doublebuffer', 'on' );
set( fhandle, 'Color',[0, 39, 118 ]/256 );
axis([-5 5 -5 5])
text(-5,3,'WP2.2 Distributed/decentralised detection:','Fontsize',16,'Color',[255, 255, 255]/256,'FontName','Papyrus')
text(-5,2,'Simultaneous long time integration','Fontsize',16,'Color',[255, 255, 255]/256,'FontName','Papyrus','Fontangle','Italic')
text(-5,1,'and trajectory estimation','Fontsize',16,'Color',[255, 255, 255]/256,'FontName','Papyrus' ,'Fontangle','Italic')
text(-5,0,'with distributed tx/rx elements','Fontsize',16,'Color',[255, 255, 255]/256,'FontName','Papyrus' ,'Fontangle','Italic')
text(-5,-1,'E.g. Facilitates detection of low SNR','Fontsize',16,'Color',[255, 255, 0]/256,'FontName','Papyrus')
text(-5,-2,'and manoeuvring targets','Fontsize',16,'Color',[255, 255, 0]/256,'FontName','Papyrus')
axis off
if save2avi == 1
    avifileName = [['title_simult_integration_tracking'],'.avi'];
    aviobj = VideoWriter(avifileName, 'Uncompressed AVI');
    aviobj.FrameRate = 1 ; % This is the frame rate
    open(aviobj);
    aviFrame = getframe(gcf);
    writeVideo(aviobj,aviFrame);
    writeVideo(aviobj,aviFrame);
    writeVideo(aviobj,aviFrame);
    writeVideo(aviobj,aviFrame);
    writeVideo(aviobj,aviFrame);
    writeVideo(aviobj,aviFrame);
    close(aviobj);   
end
 


fhandle = figure;
set( fhandle, 'doublebuffer', 'on' );
set( fhandle, 'Color', [0, 39, 118 ]/256 );
axis([-5 5 -5 5])
axis off
if save2avi == 1
    avifileName = [['blank'],'.avi'];
    aviobj = VideoWriter(avifileName, 'Uncompressed AVI');
    aviobj.FrameRate = 1 ; % This is the frame rate
    open(aviobj);
    aviFrame = getframe(gcf);
    writeVideo(aviobj,aviFrame);
    writeVideo(aviobj,aviFrame);
    writeVideo(aviobj,aviFrame);
    writeVideo(aviobj,aviFrame);
    writeVideo(aviobj,aviFrame);
    writeVideo(aviobj,aviFrame);
    close(aviobj);   
 end
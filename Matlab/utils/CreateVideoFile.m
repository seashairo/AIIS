function CreateVideoFile(name, video, frameRate)
% CREATEVIDEOFILE creates a video file of a given name.

vidObj = VideoWriter(name)
vidObj.FrameRate = frameRate;
open(vidObj)
writeVideo(vidObj, video);
close(vidObj)
end


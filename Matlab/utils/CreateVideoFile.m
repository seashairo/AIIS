function CreateVideoFile(name, video)
% CREATEVIDEOFILE creates a video file of a given name.

vidObj = VideoWriter(name)
open(vidObj)
writeVideo(vidObj, video);
close(vidObj)
end


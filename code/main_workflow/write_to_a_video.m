function write_to_a_video(output_video,binary_frame)

% Write a binary frame to a video, making 1 to become 255 and 0 to remain 0.
%
% Yixuan Li, 2024-04-15.
%

binary_frame_uint8 = uint8(binary_frame) * 255;
writeVideo(output_video, binary_frame_uint8);

end
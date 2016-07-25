%function [ frame1, frame2 ] = daten_2frames( input , werte_pro_block, frame_index1, frame_index2 )
function [ frame1 ] = daten_2frames( input , werte_pro_block, frame_index1, frame_index2 )
%Frame Daten selektieren, Frame Index für den ersten Frame ist Nill!!!

frame1 = input(frame_index1*werte_pro_block+1:(frame_index1+1)*werte_pro_block, :)
%frame2 = input((frame_index2+1)*werte_pro_block+1:(frame_index2+2)*werte_pro_block, :)

%check = input(1:20,:)-frame1

%{
size_block1 = size(frame1)
size_block2 = size(frame2)
        
i1 = frame_index1*werte_pro_block+1
i2 = (frame_index1+1)*werte_pro_block
i3 = (frame_index2+1)*werte_pro_block+1
i4 = (frame_index2+2)*werte_pro_block
%}

end


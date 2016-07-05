function [ frame1, frame2 ] = frame_select( projektion_daten, frame_start1, frame_start2, frames_gesamt)
%...
%frame_select( projektion_A, 1, 2, 2);

input = projektion_daten;
input_size = size(input);
rows = input_size(1)

werte_pro_block = rows/frames_gesamt

%Daten der Frames holen
frame1 = input(frame_start1*werte_pro_block+1:(frame_start1+1)*werte_pro_block,:);
frame2 = input(frame_start2*werte_pro_block+1:(frame_start2+1)*werte_pro_block,:);

%frame1_size = size(frame1)
%frame2_size = size(frame1)

end

        %i1 = f*werte_pro_block+1
        %i2 = (f+1)*werte_pro_block
        %i3 = (f+1)*werte_pro_block+1
        %i4 = (f+2)*werte_pro_block
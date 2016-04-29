function [ xTrans, yTrans, zTrans ] = translate3D( x ,y, z, translateX, translateY, translateZ, figure_handle)
%Funktion zur Translation

    %linkdata on;
    
    xTrans = x+translateX;
    yTrans = y+translateY;
    zTrans = z+translateZ;
    
    refreshdata(gcf);

end


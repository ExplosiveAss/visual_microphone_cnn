function y = crj_xcorrshift(x, refsig)
    % this shifts (and pads with zeros if necessary) the signal x such that
    % it will align with the reference signal refsig as much as possible,
    % and return it in y.
    
    flip = false;
    if size(x, 1) > 1 && size(x, 2) == 1
        x = x';
        flip = true;
    end
    if size(refsig, 1) > 1 && size(refsig, 2) == 1
        refsig = refsig';
    end
    
    refsiglength = length(refsig);
    
    
    [c,shift] = xcorr(x,refsig);
    [blah,argshift] = max(c);
    shiftamt = shift(argshift);
        
    if shiftamt > 0
        xlength = length(x);
        if  xlength < 1 + shiftamt + refsiglength
            lengthdiff = shiftamt + refsiglength - xlength;
            pad = zeros(1, abs(lengthdiff));
            x = [x pad];
            
        end
        
        y = x(1+shiftamt: shiftamt+refsiglength);
        if flip
            y = y';
        end
    elseif shiftamt < 0
        pad = zeros(1, abs(shiftamt));
        x = [pad x];
        
        xlength = length(x);
        if xlength < refsiglength
            lengthdiff = refsiglength - xlength;
            pad = zeros(1, abs(lengthdiff));
            x = [x pad];
        end
        
        y = x(1:refsiglength);
        if flip
            y = y';
        end
    else %shiftamt == 0
        xlength = length(x);
        if xlength < refsiglength
            lengthdiff = refsiglength - xlength;
            pad = zeros(1, abs(lengthdiff));
            x = [x pad];
        end
        
        y = x(1:refsiglength);
        if flip
            y = y';
        end
    end
    
    
end
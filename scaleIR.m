function H = scaleIR(scale, H)
    %% Rescales the impulse response with a scaling factor
    %
    % Input:
    %       scale   Scaling factor
    %       H       Stereo impulse iesponse
    %
    % Output:
    %       H       Scaled impulse response
    
    
    fs = 192000;                % Sample rate
    H = resample(H,scale,1);    % Resamples the implulse response

    % High frequency measurement noise filtering
    fstop = 96000/scale - 100;  % Stop band frequency (Hz)
    fpass = fstop - 500;        % Pass band frequency (Hz)
    f_c_stop = fstop*2/fs;      % Stop band freq (rad)
    f_c_pass = fpass*2/fs;      % Pass band freq (rad)

    lpFilt = designfilt('lowpassfir','PassbandFrequency',f_c_pass, ...
            'StopbandFrequency',f_c_stop,'PassbandRipple',0.05, ...
            'StopbandAttenuation',80,'DesignMethod','kaiserwin');

    H = fftfilt(lpFilt, H);


end

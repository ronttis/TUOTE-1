function H = measureStereoIR(duration)
    %% Measures a stereo impulse response
    %
    % Input:
    %       duration    Duration of the sweep
    %
    % Output:
    %       H           Stereo impulse response          
    
    fs = 192000;    % Sample rate
    f_start = 40;	% Sweep start frequency
    f_stop = 96000;	% Sweep stop frequemcy

    % Obtain rec and play devices
    [recDev, playDev] = getDevIDs;

    %% Automatic volume control for SNR optimization

    % Generate a test signal
    t_iter = 0:1/fs:1;                                          % Time vector
    y_iter = chirp(t_iter, f_start, 1, f_stop,'logarithmic')/4; % Sweep from f_start to f_stop
    y_iter = [zeros(fs/4,1)' y_iter, zeros(fs/4,1)']';          % Add zeros to start and end 

    scale = 1;              % Volume scaling coefficient
    volumeIteration = 1;    % Iteration mode set to 1

    while volumeIteration == 1
        y_iter = scale.*y_iter;                         % Scale the test sigal
        y_iter2 = playRec(y_iter,fs, recDev, playDev);	% Play and record the scaled signal
        y_max = max(max(abs(y_iter2)));                 % Signal maximum value
        
        % Finds the scaling coefficient so that 0.6 > y_max > 0.85
        if y_max < 0.85 && y_max > 0.6
            volumeIteration = 0;
        else
            scale = (1/y_max)*0.80;
        end
               
    end

    %% Full duration impulse response measurement

    % Generate the signal
    t = 0:1/fs:duration;                                            % Time vector for excitation signal
    x = chirp(t, f_start, duration, f_stop,'logarithmic')/4;        % Excitation signal
    x = [zeros(fs/4,1)' x, zeros(fs,1)']';                          % Add zeros
    x = scale.*x;                                                   % Scale the signal level

    y = playRec(x,fs, recDev, playDev);                             % Play and record the excitation signal

    %% Impulse response extraction
    
    X = fft(x);
    Y = fft(y);

    Hma(:,1) = Y(:,1)./X;
    Hma(:,2) = Y(:,2)./X;     

    H = real(ifft(Hma));

    %% Sound interface high frequency compensation
    % The frequency response of Steinberg UR22 is attenuated above 50kHz
    % These compensation filters equalize the response
    
    ur22InvFIR = load('invFIR.mat'); % Load correction filters

    H1 = fconv(H(:,1),ur22InvFIR.L); % Uses fconv to filter the impulse response
    H2 = fconv(H(:,2),ur22InvFIR.R);
    H = [H1, H2];

    %% Impulse responses trimming

    % Locate the direct sound peak
    [a1,i1] = max(abs(H(:,1)));
    [a2,i2] = max(abs(H(:,2)));

    if (i1>=i2)
        i = i2; % Right channel closer to speaker
    else
        i = i1; % Left channel closer to speaker
    end

    H = H(i-20:end,:);  % Trim the start point slightly before the direct sound
    H = H(1:0.6*fs,:);  % Use only the first 0.6 sec (maximum chamber T60)
end
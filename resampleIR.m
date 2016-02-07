function H = resampleIR(H, fs1, fs2)
    %% Resamples impulse response from fs1 to fs2
    %
    % Input:
    %       H       Impulse response to be resampled
    %       fs1     Original sample rate
    %       fs2     New sample rate
    %
    % Output:
    %       H       Resampled impulse response
    
    factor = fs1/fs2;   % Resampling factor
    H = H(1:floor(length(H)/factor)*factor,:); % New signal length
    
    SRC = dsp.SampleRateConverter('Bandwidth',40e3,'InputSampleRate',fs1,'OutputSampleRate',fs2); % Initiate sample rate converter
    H = step(SRC, H);               % Execute sample rate conversion
    H = H./(max(max(abs(H)))+0.05); % Normalization with a headroom
end
%% TUOTE-1 Impulse response measurement
% Measures, scales and resamples a stereo impulse response
%
%
% Reads measurement instructions from 'parameters.txt'
% Writes impulse responses into two wav files inside folder 'IR'
% Writes also a metafile for the TUOTE-1 Ableton plug-in

fs1 = 192000;   % Measurement sample rate
fs2 = 48000;    % Usage sample rate

% Read measurement parameters
fn = 'parameters.txt';  % Parameters file
[scale, duration, name] = textread(fn, '%d %d %s'); % scale: Scaling factor
                                                    % duration: Sweep duration
                                                    % name: output IR filename        
    if isempty(scale) == 0
        
        % Measurement and processing
        H = measureStereoIR(duration);  % Impulse response measurement
        H = scaleIR(scale, H);          % Impulse response scaling
        H = resampleIR(H, fs1, fs2);    % Impulse response sample rate conversion

        
        % File operations
        % Audio files
        folder = './IR/';   % Output folder
        fileOutName_L = [char(name) '_L.wav'];  % Left channel IR file
        fileOutName_R = [char(name) '_R.wav'];  % Right channel IR file
        audiowrite([folder fileOutName_L], H(:,1), fs2);
        audiowrite([folder fileOutName_R], H(:,2), fs2);
        
        % Metafile for the Ableton plug-in
        if strcmp(name, 'Preview') ~= 1
            switch duration         
                case 2
                    quality = 'L';  % Low quality (2 sec sweep)
                case 5
                    quality = 'M';  % Medium quality (5 sec)
                case 10
                    quality = 'H';  % High quality (10 sec)
                case 20
                    quality = 'U';  % Ultra quality (20 sec)
            end
            fileIRName = ['./IR/' char(name) '_' int2str(scale) 'x_' quality '.IR'];
        else
            fileIRName = ['./IR/' char(name) '.IR'];    % Meta file for the Preview mode IR
        end        
        fileID = fopen(fileIRName, 'w');
        msg = [char(name) '_L.wav' ' ' char(name) '_R.wav'];
        fprintf(fileID, '%s %s', fileOutName_L, fileOutName_R);
        fclose(fileID);   
    end
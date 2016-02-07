function y = playRec(signal, fs, recDev, playDev)
    %% Plays and records simultaneously the excitation signal
    %
    % Input:
    %       signal      The signal to be played
    %       fs          Sample rate
    %       recDev      Recording device ID
    %       playDev     Playback device ID
    %
    % Output:
    %       y           Recorded signal
    
    % Initiate the player and recorder
    player = audioplayer(signal,fs,24,playDev);
    recorder = audiorecorder(fs,24,2,recDev);
    
    recorder.record;        % Start record
    player.playblocking;    % Start playing and wait to finish
    stop(recorder);         % Stop recording
    
    y = getaudiodata(recorder); % Obtain the signal
    y = y(1:length(signal),:);  % Trim the signal to original length
    
end

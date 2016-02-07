function [devIDrec, devIDplay] = getDevIDs
    %% Obtains the Steinberg UR22 playback and recording device number
    %
    % Input:
    %       -
    % Output:
    %       devIDrec        Recording device ID
    %       devIDplay       Playback device ID
    
    A = audiodevinfo;       % Retrieves available audio devices

    audioInput = A.input;   % Available input devices
    audioOutput = A.output; % Available output devices

    for n = 1:length(audioInput)
        if ( strcmp(audioInput(1,n).Name, 'Steinberg UR22 (Core Audio)') == 1 || ...
        strcmp(audioInput(1,n).Name,'Line (3- Steinberg UR22) (Windows DirectSound)') == 1 )
            break;
        end
    end

    devIDrec = audioInput(1,n).ID;
    
    for n = 1:length(audioOutput)
        if ( strcmp(audioOutput(1,n).Name, 'Steinberg UR22 (Core Audio)') == 1 || ...
        strcmp(audioOutput(1,n).Name,'Line (3- Steinberg UR22) (Windows DirectSound)') == 1 )        
            break;
        end
    end

    devIDplay = audioOutput(1,n).ID;
end

function code = decode(audioContents,Fs)

% Use a windowsize of 125ms
windowSize = 100;

% Use an overlap of 50%
overLap = 50;

% Convert the windowsize and overlap parameters to sample counts
windowsPerSec = 1000 / 125;
samplesPerWindow = floor(Fs / windowsPerSec);
overLapInSamples = samplesPerWindow * overLap / 100;

% Calculate the spectrogram of the signal for visual comparison
[s,w,t] = spectrogram(audioContents,kaiser(samplesPerWindow),overLapInSamples,2^nextpow2(samplesPerWindow),Fs,'yaxis');
clf
hold on;

max(t)
return

% Plot the spectrogram
spectrogram(audioContents,kaiser(samplesPerWindow),overLapInSamples,2^nextpow2(samplesPerWindow),Fs,'yaxis');

% Get the energy of each frequency
a = abs(s);

[~,windows] = size(a);


energies = a(:,1);


for j=2:windows
    
    tmp = a(:,j);
    
    % Maintain an estimate of background noise for those frequencies that
    % have little or no content
    l = logical(tmp > energies) & logical(tmp > 0.2); 
    energies(~l) = energies(~l) - 1 /(j +1 ) * (energies(~l) - tmp(~l));
    
    % Get the frequencies that are above the threshold
    tmpSignal = tmp(l);
    indices = find(l);
    
    % Sort the frequencies in descending order
    [vals, indxs] = sort(tmpSignal,'descend');
    
    if nnz(l) == 0
        continue
    end
        
    maxVal = vals(1);    
    frequencies = zeros(length(w),1);
    
    for i=1:length(vals)
        
        itmp = indices(indxs(i));
        
        curVal = vals(i);
       
        if curVal < 0.2 
            energies(itmp) = energies(itmp) - 1 /(j + 1) * (energies(itmp) - vals(i));
            continue
        else
            
            %minRange = max(itmp-1,1);
            %maxRange = min(itmp+1,4097);                        
                        
            %if nnz(frequencies(minRange:maxRange))> 1
             %   frequencies(minRange:maxRange,1) = 1;
            %elseif itmp~=1                
                frequencies(itmp,1) = 2;
            %end
            %plot([t(j-1),t(j)],[w(itmp)/1000,w(itmp)/1000],'r-');
                    
        end
        
        if curVal < 0.025 * maxVal || curVal < 0.2
            break
        end
        
    end
    
    f = find(frequencies == 2);
%    length(f)
    for q = 1:length(f)
        plot([t(j-1),t(j)],[w(f(q))/1000,w(f(q))/1000],'r-');
    end
        
    
end

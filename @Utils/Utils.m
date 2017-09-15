classdef Utils
    
    methods(Static)
        
        % Method for padding a data window to a given length
        function dataWindow = addPadding(signal, lengthToPad)
            
            % Get the current length of the signal
            m = length(signal);
            
            % If length exceeds or is equal to target length, return signal
            if m >= lengthToPad
                dataWindow = signal;
            % Otherwise add zeroes to the signal
            else
                dataWindow = [signal, zeros(1,lengthToPad-m)];
            end
            
        end
        % reference signal
        function envelope = getEnvelope(signal, referenceSignal)
        
        % Method for extracting envelope of a signal with respect to a
            
            % Determine length of fft to use
            M = max([length(signal),length(referenceSignal)]);
            
            % Determine fft length
            nfft = 2^nextpow2(M);
            
            % Extract fft for both signals
            fftSignal = fft(signal,nfft);
            fftReference = fft(referenceSignal,nfft);
            
            % Multiply the FFTs
            fftEnvelope = fftSignal .* fftReference;
            
            % Set negative frequencies to zero
            fftEnvelope(nfft/2+1:end) = 0;
            fftEnvelope(1:nfft/2) = 2*abs(fftEnvelope(1:nfft/2));
            
            % Return inversed signal
            envelope = abs(ifft(fftEnvelope));
            
        end

        % Perform bandpass filtering on the signal
        function filteredSignal = bandPassFilter(signal, samplingRate, lowerPassFrequency, upperPassFrequency)
            
            % Get the current length of the signal
            M = length(signal);
           
            % Determine fft length
            nfft = 2^nextpow2(M);
            
            % Determine range of frequencies for fft
            dF = samplingRate/ nfft;
            frequencies = (-samplingRate/2:dF:samplingRate/2-dF)';

            % Construct bandpass filter
            BPF = ((lowerPassFrequency < abs(frequencies)) & (abs(frequencies) < upperPassFrequency));
            
            % Remove mean from signal and perform fft on it
            signal = signal - mean(signal);
            spectrum = fftshift(fft(signal,nfft)) / nfft;
            
            
            % Apply bandpass filter on data
            spectrum = BPF' .* spectrum;
            
            % Reconstruct the data after filtering and return results
            filteredSignal = ifft(ifftshift(spectrum) .* nfft);
            

        end
        
        % Get the energy of a signal
        function energy = getEnergy(signal)
            
            % Get the current length of the signal
            M = length(signal);
           
            % Determine fft length
            nfft = 2^nextpow2(M);
            
            % Perform fft
            f = fft(signal,nfft);
            
            % Return results
            energy = sum(f .* conj(f));
            
            
        end
                
        
    end
    
end
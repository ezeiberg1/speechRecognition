function [spec,recorded_sound] = recordAndSpec(timeLimit, fs, audioFrameRate, dt)
    dataPrecision = '16-bit integer'; 
    adr = audioDeviceReader('SampleRate', fs, 'SamplesPerFrame', floor(fs/audioFrameRate), 'BitDepth', dataPrecision, 'Device', 'Sound Blaster Play! 3');

    %spectrogram parameters
    num_samples = dt*fs;
    overlap = 0.75*num_samples;
    freq_axis = .001*fs*(0:(num_samples/2))/num_samples;

    %Create triangular pulse to use for the window 
    rect = ones(1, (num_samples+overlap)/2);
    tri = conv(rect, rect)*1/(num_samples/2);
    tri(end+1) = tri(end);
    tri = tri';

    n = 1;
    i = 1;
    audioBuffer = dsp.AsyncBuffer(fs);
    recorded_sound = [];
    update_spec_old = [];
    update_spec = [];
    spec = [];
    dt2 = (num_samples-overlap)/fs;
    t_spec = [];
    
    tic;
    while  audioBuffer.NumUnreadSamples ~= 0 || toc < timeLimit
        if toc < timeLimit
            % Extract audio samples from the audio device and add to the buffer.
            [audioIn overrun(i)] = adr();
            write(audioBuffer,audioIn);
            recorded_sound = [recorded_sound; audioIn];
        end
        
        if toc > n*dt
            update_spec_old(:,n) = read(audioBuffer,dt*fs+overlap, overlap); %Get M samples, and half the samples are overlapping between this read and last read
            update_spec(:,n) = update_spec_old(:,n).*tri;
            newColumn = abs(fft(update_spec(:,n))); %Take the fft of samples
            newColumn = 20*log10(newColumn(1:length(newColumn)/2));
            newColumn_flipped = flip(newColumn); %flip order of vector (for imagesc), so high frequencies are at the top
            spec(:, n) = newColumn_flipped; %add this column to the spectrogram
            
            figure(2);
            imagesc([dt n*dt], [freq_axis(end) 0], spec);
            set(gca,'YDir','normal'); %switch direction of freq. axis
            xlabel('Time (s)');
            ylabel('Frequency (kHz)');
            title('Spectrogram');
            colorbar;
            drawnow;
            n = n+1;
        end
        i = i+1; 
    end
    disp(n);
    % Release audio object
    release(adr)
    release(audioBuffer)
 
end


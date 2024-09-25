function spec = createSpec(word, timeLimit, fs, dt)
    %spectrogram parameters
    num_samples = dt*fs;
    overlap = 3/4*num_samples;
    freq_axis = .001*fs*(0:(num_samples/2))/num_samples;

    %Create triangular pulse to use for the window 
    rect = ones(1, (num_samples+overlap)/2);
    tri = conv(rect, rect)*1/(num_samples/2);
    tri(end+1) = tri(end);
    tri = tri';
    n = 1;
    update_spec_old = [];
    update_spec = [];
    spec = [];
    audioBuffer = dsp.AsyncBuffer(length(word));
    write(audioBuffer,word);
    t_spec = [];
    dt2 = (num_samples-overlap)/fs;
    
    while audioBuffer.NumUnreadSamples ~= 0 
        update_spec_old(:,n) = read(audioBuffer,dt*fs+overlap, overlap); %Get M samples, and half the samples are overlapping between this read and last read
        update_spec(:,n) = update_spec_old(:,n) .*tri;
        newColumn = abs(fft(update_spec(:,n))); %Take the fft of samples
        newColumn = 20*log10(newColumn(1:length(newColumn)/2));
        newColumn_flipped = flip(newColumn); %flip order of vector (for imagesc), so high frequencies are at the top
        spec(:, n) = newColumn_flipped; %add this column to the spectrogram
        n = n+1;
    end
    disp(n)
    disp(size(spec))
    %t_spec = dt2:dt2:(n-50)*dt2;
    figure(3);
    imagesc([dt n*dt], [freq_axis(end) 0], spec);
    set(gca,'YDir','normal'); %switch direction of freq. axis
    xlabel('Time (s)');
    ylabel('Frequency (kHz)');
    title('Spectrogram');
    colorbar;
    drawnow;
    disp(n);
    
end


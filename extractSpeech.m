function speech = extractSpeech(recorded_sound)
noise = load('noise.mat').noise;
Pnoise = (rms(noise))^2;
snrs = [];
for i=1:length(recorded_sound)-300
    sample = recorded_sound(i:i+300);
    Ps = (rms(sample))^2;
    snrs(i) = 10*log10(Ps/Pnoise);
    if snrs(i)>25
        speech = recorded_sound(i:i+30000);
        break;
    end
end
end


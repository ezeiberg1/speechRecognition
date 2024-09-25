dictionary = cat(1,load('dictionary_E.mat').D_E, load('dictionary_C.mat').D_C);
%dictionary = load('dictionary_E.mat').D_E;
fs = 48000;
dt = 0.2;
num_samples = dt*fs;
overlap = 3/4*num_samples;
freq_axis = .001*fs*(0:(num_samples/2))/num_samples;
timeLimit = 5;
dt2 = (num_samples - overlap)/fs;
audioFrameRate = 20;

[~,audio] = recordAndSpec(timeLimit, fs, audioFrameRate, dt);
rec_word = extractSpeech(audio);
spec = createSpec(rec_word, length(rec_word)/fs, fs, dt);

words = {'Tiger said by Emily', 'Monkey said by Emily', 'Panda said by Emily', 'Giraffe said by Emily', 'Lion said by Emily',...
    'Tiger said by Chiby', 'Monkey said by Chiby', 'Panda said by Chiby', 'Giraffe said by Chiby', 'Lion said by Chiby'};
if ~isempty(rec_word)
   [chosenWord, correlations] = compareWords(spec, 0.65, dictionary);
   if chosenWord == -1 
       disp("Word is not in the dictionary")
   else 
       words(chosenWord)
   end 
end



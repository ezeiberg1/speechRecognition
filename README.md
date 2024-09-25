# speechRecognition

The goal of this project was to design a speech recognition system that operates in real-time. To do this, my lab partner and I created a dictionary of words and used signal processing to compare new words to this dictionary for identification. This included sampling audio to convert an analog signal to a digital one, calculating the signal to noise ratio to identify when a word was being said, using windowing to process one segment of audio at a time, analyzing audio in the frequency domain by taking the Fourier transform, and using cross-correlation to compare words. Our end product was able to identify words in the dictionary with 84% accuracy.

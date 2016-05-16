% noisyFilter.m (Matlab funciton file)
% Brent Hyman
% DSP project -> the filter
% December 17 2015
%===================================================================
function [] = noisyFilter()

	clear all;

	%read in the audio file data
	[noisyAudio, Fs] = wavread('noisy.wav');
	nyqFreq = Fs/2;
	
	%define the band-stop filter specs for IIR filter design
	psBndRng = [1400 1900]/nyqFreq;
	stpBndRng = [1600 1700]/nyqFreq;
	psBndTol = 0.5;
	stpBndAttn = 100;
	
	%define the band-stop filter specs for FIR filter design
	bndEdgeFreqs = [1400 1600 1700 1900];
	stpBndMags = [1 0 1];
	rpplDevs = [10^(1/40)-1 10^-5 10^(1/40)-1];

	%display
	% -> give user opportunity to listen to the noisy.wav file
	% -> otherwise, they can go ahead and implement a filter
	disp('*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=')
	disp('Audio de-noising program')
	userInput = input('    type 1 to listen to noisy.wav or 0 to skip it: ');
	if userInput
		disp(' -> playing noisy.wav...')
		sound(noisyAudio,Fs)
	else
		disp(' ')
		disp(' -> noise filtering through the use of a digital band-stop filter')
		disp(' -> the noisy.wav file in this directory has already been read in')
		disp(' -> the different implementation methods available on this program:')
		disp('	  1. Butterworth')
		disp('	  2. Chebyshev type I')
		disp('	  3. Chebyshev type II')
		disp('	  4. Elliptic')
		disp('	  5. Kaiser')
		disp('	  6. Parks-McClellan')
		userInput = input('pick a method: ');
		
		%filter implementation options
		option = 1;
		switch userInput
			case 1
				disp(' Butterworth Implementation...')
				name = 'Butterworth'; impType = 'I';
				[n, Wn] = buttord(psBndRng,stpBndRng,psBndTol,stpBndAttn);
				[b,a] = butter(n,Wn,'stop');
			case 2
				disp(' Chebyshev type I Implementation...')
				name = 'Chebyshev type I'; impType = 'I';
				[n, Wn] = cheb1ord(psBndRng,stpBndRng,psBndTol,stpBndAttn);
				[b,a] = cheby1(n,psBndTol,Wn,'stop');
			case 3
				disp(' Chebyshev type II Implementation...')
				name = 'Chebyshev type II'; impType = 'I';
				[n, Wn] = cheb2ord(psBndRng,stpBndRng,psBndTol,stpBndAttn);
				[b,a] = cheby2(n,stpBndAttn,Wn,'stop');
			case 4
				disp(' Elliptic Implementation...')
				name = 'Elliptic'; impType = 'I';
				[n, Wn] = ellipord(psBndRng,stpBndRng,psBndTol,stpBndAttn);
				[b,a] = ellip(n,psBndTol,stpBndAttn,Wn,'stop');
			case 5
				disp(' Kaiser Implementation...')
				name = 'Kaiser'; impType = 'F';
				[n, Wn, beta, ftype] = kaiserord(bndEdgeFreqs, stpBndMags, rpplDevs, nyqFreq * 2);
				b = fir1(n, Wn, ftype, kaiser(n+1,beta)); a = 1;
			case 6
				disp(' Parks-McClellan Implementation...')
				name = 'Parks-McClellan'; impType = 'F';
				[n, fo, ao, w] = firpmord(bndEdgeFreqs, stpBndMags, rpplDevs, nyqFreq*2);
				b = firpm(n, fo, ao, w); a = 1;
			otherwise
				disp('NOT AN OPTION!!!')
				option = 0;
		end
		
		if option
			fltrdAudio = filter(b,a,noisyAudio);
			filterAnalysis(a,b,fltrdAudio,nyqFreq,name,n,impType);
			sound(fltrdAudio,Fs)
		end	
	end
end
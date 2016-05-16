% filterAnalysis.m (Matlab function file)
% Brent Hyman
% DSP project -> the analysis
% December 17 2015
%===================================================================
function[] = filterAnalysis(a,b,fltrdAudio,nyqFreq,filterType,n,fImp)

	% -> Display the filter's efficiency
	if fImp == 'I'
		nstr = int2str(2*n);
		opCount = int2str(2*(2*n)+1);
	else
		nstr = int2str(n);
		opCount = int2str(2*n+1);
	end
	disp(' ')
	disp(['   filter is of order: ' nstr])
	disp(['   filter Op count: ' opCount ' add/multiply ops per input cycle'])
	disp(' ')

	% -> plot magnitude response in decibels
	[h,w1] = freqz(b,a,512);
	figure
	plot( (w1/pi)*nyqFreq,20*log10(abs(h)) )
	title([filterType ' Magnitude Response'])
	xlabel('Frequency (Hz)')
	ylabel('Magnitude (db)')
	grid on
	
	% -> plot the group delay (in samples)
	[gd,w2] = grpdelay(b,a);
	figure
	plot( (w2/pi)*nyqFreq,gd )
	title([filterType ' Group Delay'])
	xlabel('Frequency (Hz)')
	ylabel('Group delay (in samples)')	
	grid on
	
	% -> plot pole-zero plot
	figure
	zplane(b,a);
	title([filterType ' Pole-Zero Plot'])
	grid on
	
	% -> plot the impulse response
	if fImp == 'I'
		hn = filter( b , a , [1 zeros(1,99)] );
		figure
		stem(1:100 , hn)
		title([filterType ' Impulse Response (size 100)'])
		xlabel('n')
		ylabel('h[n]')
		grid on
	else
		hn = filter( b , a , [1 zeros(1,249)] );
		figure
		stem(1:250 , hn)
		title([filterType ' Impulse Response (size 250)'])
		xlabel('n')
		ylabel('h[n]')
		grid on
	end
	
end
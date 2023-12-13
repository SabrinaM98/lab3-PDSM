function y = denoising_v1_para_audio(x,limiar)
  [signal,fs] = audioread(x);
  soundsc(signal,fs)
  N = wmaxlev(length(signal),'db4');
  [C,L] = wavedec(signal, N,'db4');
  T = limiar*max(abs(C));
  C1 = C; 
  for k=1:length(C) 
    if abs(C1(k)) < T 
      C1(k)=0; 
    end
  end
  y = waverec(C1,L,'db4');
  plot(y);

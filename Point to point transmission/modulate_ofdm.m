function z = modulate_ofdm(D, fft_size, cp_size, switch_graph)

time_domain_symbols = ifft(D, fft_size); %Doing ifft

% The last cp_size samples of the time-domain symbols are appended to the beginning, creating a cyclic extension.
time_domain_symbols_cp = [time_domain_symbols(end-cp_size+1:end, :); time_domain_symbols];

z = time_domain_symbols_cp(:);  % reshaping into a single column

L= fft_size+cp_size;            %1024+256 bits

B=z(L+1:2*L);                   %Plot One OFDM symbol

% default n = 512, evaluation points, returns n points freq response vector H, angular freq W
   
[H, W] = freqz(B,1,512);         
   if switch_graph==1
      figure;
      subplot(2,1,1);
      plot(real(B)); % have one frame B in time domain
      title('OFDM symbol in time domain');
      xlabel('OFDM symbol sequence');
      ylabel('Amplitude');
    
      subplot(2,1,2);
      plot(W/pi,20*log10(abs(H))); 
      xlabel('\omega/pi');
      ylabel('H in DB');
      title('OFDM symbol in normalize frequency domain');
    
    end
end
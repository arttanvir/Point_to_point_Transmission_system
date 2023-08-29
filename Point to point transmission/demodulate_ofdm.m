function D_tilde = demodulate_ofdm(z_tilde, fft_size, cp_size, switch_graph)
    L = length(z_tilde);
    
    X = reshape(z_tilde, 1, L);
    m = fft_size + cp_size;                     % 1280 lenth of ofdm block with CP
    n = floor(L / m);  
    
    A = X(1:m*n);
    A1 = reshape(A, m, n);
    A2 = A1(cp_size + 1 : m, :);                % removing cp
    
    D_tilde = fft(A2);
    
    if switch_graph
        % Plot the OFDM symbol in symbol space
        figure;
        scatter(real(D_tilde(:)), imag(D_tilde(:)), 'filled');
        xlabel('Real Part');
        ylabel('Imaginary Part');
        title('Demodulated OFDM Symbol in Symbol Space');
        axis equal;
    end
end

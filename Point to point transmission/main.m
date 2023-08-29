%% Group 10
%  Member1_NAME : ARIF RAIHAN TANVIR  (6163010)
%  Member2_NAME : AKIB MOHAMMAD FARUK (6087616)




%% This is main.m example for ICT Lab2
% 
%  In this file, all main parameters are defined and all functions are 
%  called for the phase 1 (OFDM transmission). Please refer to this 
%  structure to write your code. For phase 2, some changes should be 
%  made to consider new parameters and requirements.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;clear;clc;

%% define parameters


switch_graph = 1;
switch_off =  1;                    % 1/0--> switch off/on the block % can be set indivially in the function

fft_size = 1024 ;                   % FFT length /OFDM symbol length
%N_blocks = 42 ;                     % no. of blocks
parity_check_matrix = [1 0 1 1 1 0 0;1 1 1 0 0 1 0;0 1 1 1 0 0 1];          
                                    % code parity check matrix
constellation_order = 4 ;           % 2--> 4QAM; 4-->16QAM; 6-->64QAM
frame_size = 1024*48;                   % frame length
            % no. of zeros added after encoding
%pilot_symbol =                     % pilot symbols In the insertpilots block
cp_size = 256 ;                     % CP length
oversampling_factor = 20 ;          % oversampling factor
downsampling_factor = 20  ;         % downsampling factor

clipping_threshold = 1 ;         
channel_type =  'AWGN' ;            % channel type: 'AWGN', 'FSBF'
%snr_db = 10;                       % SNRs in dB % can be done in a range as well
snr_db = 0:4:20;                        
                      

%% initialize vectors
% You can save the BER result in a vector corresponding to different SNRs

%generate info bits
b = generate_frame(frame_size, 0);

BER_uncoded = zeros(1,length(snr_db));
% OFDM transmission

 for ii = 1 : length(snr_db) % SNR Loop
   
        n_zero_padded_bits = 0;
        switch_graph = 0;

        %channel coding
        c = encode_hamming(b, parity_check_matrix, n_zero_padded_bits, 0);
        
        %modulation
        d = map2symbols(c, constellation_order, switch_graph);
        
        %pilot insertion
        
        N_blocks = length(d) / fft_size;

        if constellation_order == 2
        m = 2;
        elseif constellation_order == 4
        m = 4;
        else
        m = 6;
        end

        QAM_point = zeros(m, 1);
        for k = 0:m-1
            real_part = 2 * mod(k, sqrt(m)) - sqrt(m) + 1;
            imag_part = 2 * floor(k / sqrt(m)) - sqrt(m) + 1;
            QAM_point(k+1) = real_part + 1i * imag_part;
        end

        p = randi([1, m], fft_size, 1);
        pilot_symbol = QAM_point(p);
        pilot_symbol = pilot_symbol / sqrt(m);
        
        D = insert_pilots(d, fft_size, N_blocks, pilot_symbol);
        
        %ofdm modulation
        z = modulate_ofdm(D, fft_size, cp_size, switch_graph);
        
        %tx filter

        s = filter_tx (z, oversampling_factor, switch_graph, switch_off);
        %non-linear hardware
        
        x = impair_tx_hardware(s, clipping_threshold, switch_graph);

        %% channel %%  
 
        %baseband channel 
        y = simulate_channel(x, snr_db(ii), channel_type);
        
        %% receiver %%     
        
        %rx hardware
        s_tilde = impair_rx_hardware(y, clipping_threshold, switch_graph);

        
        
        %rx filter
        
        z_tilde = filter_rx (s_tilde,downsampling_factor,switch_graph,switch_off);
        
        %ofdm demodulation
        D_tilde= demodulate_ofdm(z_tilde, fft_size, cp_size, switch_graph);
        
        %equalizer
        d_bar = equalize_ofdm(D_tilde, pilot_symbol, switch_graph);
        
        %demodulation

        c_hat=detect_symbols(d_bar,constellation_order,switch_graph);
        
        %channel decoding
        b_hat = decode_hamming(c_hat, parity_check_matrix, n_zero_padded_bits, 0, switch_graph);
       
        
        %digital sink
        BER = digital_sink(b, b_hat);
        BER_uncoded(ii) = BER ;
 end
 %%BER_coded
 BER_coded = zeros(1,length(snr_db));
 for ii = 1 : length(snr_db) % SNR Loop
   
        %% transmitter %%
        if ii== length(snr_db)
            switch_graph = 1;
        end       
        n_zero_padded_bits = 0;
        
 
        %channel coding
        c = encode_hamming(b, parity_check_matrix, n_zero_padded_bits, 1);
        
        %modulation
        d = map2symbols(c, constellation_order, switch_graph);
        
        %pilot insertion
        
        N_blocks = length(d) / fft_size;

        if constellation_order == 2
        m = 2;
        elseif constellation_order == 4
        m = 4;
        else
        m = 6;
        end

        QAM_point = zeros(m, 1);
        for k = 0:m-1
            real_part = 2 * mod(k, sqrt(m)) - sqrt(m) + 1;
            imag_part = 2 * floor(k / sqrt(m)) - sqrt(m) + 1;
            QAM_point(k+1) = real_part + 1i * imag_part;
        end

        p = randi([1, m], fft_size, 1);
        pilot_symbol = QAM_point(p);
        pilot_symbol = pilot_symbol / sqrt(m);
        
        D = insert_pilots(d, fft_size, N_blocks, pilot_symbol);
        
        %ofdm modulation
        z = modulate_ofdm(D, fft_size, cp_size, switch_graph);
        
        %tx filter

        s = filter_tx (z, oversampling_factor, switch_graph, switch_off);
        %non-linear hardware
        
        x2 = impair_tx_hardware(s, clipping_threshold, switch_graph);

        %% channel %%  

        %baseband channel 
        y = simulate_channel(x2, snr_db(ii), channel_type);
        
        %% receiver %%     
        
        %rx hardware
        s_tilde = impair_rx_hardware(y, clipping_threshold, switch_graph);
        
        %rx filter
        
        z_tilde = filter_rx (s_tilde,downsampling_factor,switch_graph,switch_off);
        
        %ofdm demodulation
        D_tilde= demodulate_ofdm(z_tilde, fft_size, cp_size, switch_graph);
        
        %equalizer
        d_bar = equalize_ofdm(D_tilde, pilot_symbol, switch_graph);
        
        %demodulation

        c_hat=detect_symbols(d_bar,constellation_order,switch_graph);
        
        %channel decoding
        b_hat = decode_hamming(c_hat, parity_check_matrix, n_zero_padded_bits, 1, switch_graph);
       
        
        %digital sink
        BER = digital_sink(b, b_hat);
        BER_coded(ii) = BER ;
 end

%% plot BER-SNR figure
        figure('name','BER vs SNR ')
        semilogy(snr_db,BER_coded,  'k*-','linewidth',2);
        hold on;
        semilogy(snr_db, BER_uncoded, 'ro-','linewidth',2);
        xlabel('SNR(DB)');
        ylabel('BER coded');
        grid on;
        legend('BER coded', 'BER uncoded');
        
        
        

OD = reshape(x2, 1280, 440);
for symbol_Cp = 1:440
    symbols = OD(:, symbol_Cp);
    symbolpower = abs(symbols).^2;
    peak = max(symbolpower);
    Average = mean(symbolpower);  
    PAPR(symbol_Cp) = peak / Average;
end

figure('name','symbolblock vs PAPR');
plot(1:440, 10*log10(PAPR), 'm*-','linewidth',2);
xlabel('Block');
ylabel('PAPR (dB)');
title('symbolblock vs PAPR');

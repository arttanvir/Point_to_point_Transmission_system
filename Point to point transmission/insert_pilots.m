function D = insert_pilots (d,fft_size,N_blocks, pilot_symbols)

    Qam_Data=reshape(d,fft_size,N_blocks);
    
    D=[pilot_symbols,Qam_Data]; %Inserting known pitot_symbols

end
function d_bar = equalize_ofdm(D_tilde, pilot_symbols, switch_graph)

    
    for i=1:1024
        pilot_symb(i,1)=D_tilde(i,1)/pilot_symbols(i,1); % 1024*1 take the first colum of d_tilde and divide
        
    end

    Data_unequalized=D_tilde(:,2:end);% taking other 42 columns

    [m,n]=size(Data_unequalized);
     Data_equalized=zeros(m,n);
     for i=1:m
        for j=1:n
                Data_equalized(i,j)=(Data_unequalized(i,j))/pilot_symb(i,1);% equalize with the pilot according to the raw number 
        end
     end
     d_bar=reshape(Data_equalized,m*n,1);%column matrix

     if switch_graph==1
        figure('name','Constellation diagram after Equalizer');
        plot(d_bar,'r*');
        title('Constellation diagram after Equalizer');
        xlabel('In-phase Amplitude');
        ylabel('Quadrature Amplitude');
        
     end

end
      
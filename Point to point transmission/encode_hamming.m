function c = encode_hamming(b, parity_check_matrix, n_zero_padded_bits, switch_off)

%calculating generator matrix from given parity_check_matrix
num_bits = size(parity_check_matrix, 2) - size(parity_check_matrix, 1); %dimension for parity matrix

%extracting the parity matrix from given parity check matrix
PT = parity_check_matrix(:, 1:num_bits); %parity_matrix_transpose

G = [eye(4),PT']; %Generator matrix

if switch_off==1
    
    N=length(b)/4; %number of coloums
    reshaped_data_b =reshape(b,4,N); %reshaping full 'b' frame so that each colum has 4 bits
    codeword = mod(G'*reshaped_data_b,2); % encode with generator matrix
    [row, col] = size(codeword);
    
    codeword_without_zeros = reshape(codeword,row*col,1);   %reshape codeword in a single bitstream         
    c_add=zeros(n_zero_padded_bits,1); %a single coloum 0 bit stream with length n_zero_padded_bits
    c=[codeword_without_zeros;c_add]; %output
else
    
    %if switch_off=0, no channel coding will be done
    c_add=zeros(n_zero_padded_bits,1);
    c=cat(1,b,c_add); %output
end
end
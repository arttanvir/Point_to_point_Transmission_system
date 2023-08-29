function c_hat=detect_symbols(d_bar,constellation_order,switch_graph)

    % M is the total number of constellation points in the modulation scheme
    % m is The modulation index
    % MP = 2(M-1)/3
if constellation_order == 2
    m = 2;  % Modulation index or constellation_order , m = log2(M)
    MP = 2; % Value to achieve average symbol power of 1 after normalization
elseif constellation_order == 4
    m = 4;
    MP = 10;
elseif constellation_order == 6
    m = 6;
    MP = 42;
else
    %error('Invalid constellation order');
end

M=2^m;
x=-sqrt(M)+1;
y=x;

d_point=[];
for i1=1:sqrt(M)
    for j1=1:sqrt(M)
        d_point=[d_point; x+y*1i];
        x=x+2;
    end
    x=-sqrt(M)+1;
    y=y+2;
end
d_points=d_point/sqrt(MP); % Normalize decision points by sqrt(MP)
c_hat = [];

for j=1:length(d_bar)
    for index=1:length(d_points)
        error(index) = d_bar(j) - d_points(index);
    end
    final_decision(j) = find(error==min(error(:)))-1; 
    c_hat = [c_hat; de2bi(final_decision(j) ,m, 'left-msb')'];
end

if switch_graph                                                   
    figure = scatterplot(d_bar,1,0,'r.');                                                          
    hold on
    scatterplot(d_points,1,0,'k*',figure)
    title('QAM-Demodulation ouput')
    grid
end
end


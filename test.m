clearvars -except data
a = data.keys;
b = 1;
for class = a
    load(class{1})
    k =0;
    for i=1:120
        w = model(i).weight;
        if length(w) == 128
            k = k+1;
        end
    end
    q(b) = k
    b=b+1;
    clear model;
end
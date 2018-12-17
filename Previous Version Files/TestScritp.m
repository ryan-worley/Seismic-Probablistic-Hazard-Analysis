filenames=["Stripe1_Sa0.10_1col_S.csv","Stripe2_Sa0.35_1col_S.csv",...
    "Stripe3_Sa0.70_1col_S.csv","Stripe4_Sa1.05_1col_S.csv"];
tic
stripe = zeros(4, 1);
for i = 1:length(filenames)
    str = filenames{i};
    split = strsplit(str, {'_Sa', 'Sa', '_'});
    for j = 1:length(split)
        check = str2double(split{j});
        if isnan(check)
            continue
        else
            stripe(i) = check;
            break
        end    
    end
        
end
toc
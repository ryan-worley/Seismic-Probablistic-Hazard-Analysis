function output = maxLikelihood(numberCollapse, total, datax, median, sigma)

prod = 1;
for i = 1:length(numberCollapse)
    choose = nchoosek(total,numberCollapse(i));
    first = (normcdf((log(datax(i)) - log(median))/sigma))^numberCollapse(i);
    second = (1 - normcdf((log(datax(i)) - log(median))/sigma))^(total-numberCollapse(i));
    prod = prod*choose*first*second;
end
output = -prod;


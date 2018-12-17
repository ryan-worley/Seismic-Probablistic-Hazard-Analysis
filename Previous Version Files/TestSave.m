figure
x = [2,3,4];
y = [0,1,2];
plot(x, y)

ax = gca;
save('test.mat', 'ax')


figure 
plot(ax)


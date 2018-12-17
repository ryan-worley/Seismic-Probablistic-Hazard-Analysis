function [app] = ExpectedLoss(app)

handles = app.handles;

%Probability of Demolition At Each EDP
%Loop over each EDP
    prob_demo_edp = normcdf((log(handles.EDP.RIDR)...
        -log(handles.demo.RIDR_median))/handles.demo.RIDR_dispersion);

%Probability of Demolition at Each IM
%Multiple the Probability at each EDP by probability of observing that EDP
%at a certain IM
Sa = handles.hazardDerivative(1,:);
prob_demo_im = zeros(1, length(Sa));

for i=1:length(Sa) %Loop over each IM
        prob_demo_im(i) = trapz(handles.EDP.RIDR, prob_demo_edp'.*handles.EDPtype.RIDR1.pdf_edp_im(:, i)); %multiply by probability of RIDR at each IM at each floor
end

handles.demo.p_im = prob_demo_im;

app.handles = handles;

end





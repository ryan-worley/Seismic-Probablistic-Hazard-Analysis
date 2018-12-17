function [handles] = ExpectedLossFunction(handles)

%Expected Loss Per Damage State
for i = 1:length(handles.Components) %Loop over each component/loss function
    ExpectedLoss_DS = zeros(handles.(handles.Components{i}).NumDS+1,1);
    for j = 1:handles.(handles.Components{i}).NumDS %loop over each damage state
        sigma = handles.(handles.Components{i}).LossParams(j,2);
        median = handles.(handles.Components{i}).LossParams(j,1);
        muln = log(median);
        ExpectedLoss_DS(j+1) = exp(.5*(sigma^2) + muln);
    end
    handles.(handles.Components{i}).ExpectedLoss_DS = ExpectedLoss_DS;
end

%Expected Loss each Componenet Per EDP
for i = 1:length(handles.Components) %Loop over each component/loss function
    ExpectedLoss_EDP=zeros(handles.(handles.Components{i}).NumDS+1,length(handles.EDP.(handles.(handles.Components{i}).EDPtype)));
    for j = 1:length(handles.EDP.(handles.(handles.Components{i}).EDPtype)) %loop over each EDP
        ExpectedLoss_EDP(1:handles.(handles.Components{i}).NumDS+1,j) = handles.(handles.Components{i}).P_Damage(:,j).*handles.(handles.Components{i}).ExpectedLoss_DS;
    end
    handles.(handles.Components{i}).ExpectedLoss_EDP = ExpectedLoss_EDP;
end

for j = 1:handles.numComponents
    EL_EDP_1comp = sum(handles.(handles.Components{j}).ExpectedLoss_EDP);
    handles.(handles.Components{j}).EL_EDP_Component = EL_EDP_1comp;
    for i = 1:handles.numStory % Not sure here about story numbering
        handles.(handles.Components{j}).EL_EDP_Story(i, :) = EL_EDP_1comp * handles.(handles.storys{i}).NumComp(j);
    end
end
%Expected Loss Per IM
%Perhaps organize structure similarly to loss/fragility function structure
%Then we can link EDPs more easily

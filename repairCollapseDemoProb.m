function app = repairCollapseDemoProb(app)

handles = app.handles;

% Add all of the losses for the different story together
handles.Loss_IM = sum(handles.Loss_IM_Story);

% Calculate the probability of demo and repair 
P_NC = 1 - handles.P_collapse;
handles.P_NC_demo = P_NC .* handles.demo.p_im;
handles.P_NC_repair = P_NC.*(1-handles.demo.p_im);

% Calculate the demoLoss and collapseLoss repair loss weighted
handles.demoLoss_IM = handles.P_NC_demo * handles.demolishionCost;
handles.collapseLoss_IM = handles.P_collapse * handles.collapseCost;
handles.ncLoss_IM = handles.P_NC_repair .* handles.Loss_IM;

% Calculate Loss given IM total 
handles.L_IM = handles.ncLoss_IM + handles.collapseLoss_IM + handles.demoLoss_IM;
Sa = handles.hazardCurve(1,:);

app.handles = handles;

 end
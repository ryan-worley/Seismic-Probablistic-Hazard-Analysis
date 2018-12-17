function app = averageAnnualLoss(app)

handles = app.handles;

% Combine all individual losses (already weighted based on P_collapse,
% demo, repair) into loss given IM
handles.L_IM = handles.ncLoss_IM + handles.collapseLoss_IM + handles.demoLoss_IM;
deriv = handles.hazardDerivative(2,:);

handles.deagplot = deriv.*handles.L_IM;
handles.deagplotC = deriv.*handles.collapseLoss_IM;
handles.deagplotR = deriv.*handles.ncLoss_IM;
handles.deagplotD = deriv.*handles.demoLoss_IM;

% Calculate total AAL, and AAL caused by each of the components
handles.AAL = trapz(handles.hazardCurve(1,:), deriv.*handles.L_IM);
AAL_deag_repair = trapz(handles.hazardCurve(1,:), deriv.*handles.ncLoss_IM);
AAL_deag_collapse = trapz(handles.hazardCurve(1,:), deriv.*handles.collapseLoss_IM);
AAL_deag_demo = trapz(handles.hazardCurve(1,:), deriv.*handles.demoLoss_IM);

handles.AAL_collapse = AAL_deag_collapse;
handles.AAL_demo = AAL_deag_demo;
handles.AAL_repair = AAL_deag_repair;

% Find the ratio
lossRatioRepair = AAL_deag_repair/handles.AAL;
lossRatioCollapse = AAL_deag_collapse/handles.AAL;
lossRatioDemo = AAL_deag_demo/handles.AAL;

% Total ratio
lossRatio = handles.AAL/handles.collapseCost;

% Save to handles for later use, perhaps a display or a graph
handles.ratio.totalLoss = lossRatio;
handles.ratio.Repair = lossRatioRepair;
handles.ratio.Demo = lossRatioDemo;
handles.ratio.Collapse = lossRatioCollapse;

% Display the total AAL
disp('Average Annual Loss:')
disp(handles.AAL)

app.handles = handles;
end
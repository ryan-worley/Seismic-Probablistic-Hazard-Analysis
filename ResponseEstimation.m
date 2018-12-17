function [app] = ResponseEstimation(app)

handles = app.handles;


%Initialize Variables
numberCollapse = zeros (length(handles.stripes),1);
medianEDP = zeros (length(handles.stripes),1);
variationEDP = zeros (length(handles.stripes),1);

% Median and Standard Deviation of EDPs
for j=1:length(handles.EDPnames)%Loop over types of EDPs
   for i=1:length(handles.stripes) %Loop Over Stripes
        if contains((handles.EDPnames{j}),'RIDR')
        RIDR = handles.EDPnames(contains(handles.EDPnames,'RIDR'));
        %We have data organized by floor, but I need to compare across
        %floors to max RIDR, maybe we need to add new field when load in
        %data, never need individual RIDR values...
        x = zeros(size(handles.EDPtype.(RIDR{1}).GMData,2),length(RIDR));
        for k = 1:length(RIDR)
            x(:,k) = handles.EDPtype.(RIDR{k}).GMData(i,:);
        end
        a = max(x);
        indices = find(isnan(a)==1);
        numberCollapse (i) = length(indices);
        a(indices) = [];
        medianEDP(i) = geomean(a);
        variationEDP(i) = std(log(a));
        else
        %Loop over EDP Types and Floors
        a = handles.EDPtype.(handles.EDPnames{j}).GMData(i,:);
        indices = find(isnan(a)==1);
        numberCollapse (i) = length(indices);
        a(indices) = [];
        medianEDP(i) = geomean(a);
        variationEDP(i) = std(log(a));
        end
    end
    handles.numberCollapse = numberCollapse;
    handles.EDPtype.(handles.EDPnames{j}).medianEDP = medianEDP;
    handles.EDPtype.(handles.EDPnames{j}).variationEDP = variationEDP;
    meanEDP = medianEDP.*exp(0.5*variationEDP.^2);
    handles.EDPtype.(handles.EDPnames{j}).meanEDP = meanEDP;
    handles.EDPtype.(handles.EDPnames{j}).standarddevEDP = meanEDP.*sqrt(exp(variationEDP.^2)-1);
end

for i=1:length(handles.EDPnames)
    %figure
    %plot(handles.stripes,handles.EDPtype.(handles.EDPnames{i}).GMData, 'Color', [0.8 0.8 0.8])
    %hold on
    %plot(handles.stripes,handles.EDPtype.(handles.EDPnames{i}).meanEDP,'LineWidth',3,'Color','r')
    %plot(stripes,medianEDP(:,i),'LineWidth',3,'Color','r')
%     title([(handles.EDPnames{i}), ' v. IM'])
%     ylabel((handles.EDPnames{i}))
%     xlabel('Sa')
%     set(gca, ...
%       'Box'         , 'off'     , ...
%       'TickDir'     , 'out'     , ...
%       'TickLength'  , [.02 .02] , ...
%       'XMinorTick'  , 'on'      , ...
%       'YMinorTick'  , 'on');
end

%Interpolate to median and dispersion of each EDP given each IM

%Calculate Probability of Each EDP at Each IM
%Requires users name EDP by IDR RIDR and PFA
for i=1:length(handles.EDPnames)    
        
        %Interpolate EDP values for every IM
        median_everyIM = interp1(handles.stripes, handles.EDPtype.(handles.EDPnames{i}).medianEDP, handles.hazardDerivative(1,:)); 
        sig_everyIM = interp1(handles.stripes, handles.EDPtype.(handles.EDPnames{i}).variationEDP, handles.hazardDerivative(1,:));
        %Extrapolate EDP values for every IM
        b = median_everyIM(~isnan(median_everyIM));
        median_everyIM(isnan(median_everyIM)) = b(end)/handles.stripes(end)*handles.hazardDerivative(1,isnan(median_everyIM)); %assuming extrapolate same value as end
        b = sig_everyIM(~isnan(sig_everyIM));
        sig_everyIM(isnan(sig_everyIM)) = b(end)/handles.stripes(end)*handles.hazardDerivative(1,isnan(sig_everyIM)); %assuming extrapolate same value as end
       
    
%        Calculate Probability of each EDP at each IM
%         Rows - EDP
%         Columns - IM
    if contains(handles.EDPnames{i},'RIDR')    
        for j=1:length(median_everyIM)
            handles.EDPtype.(handles.EDPnames{i}).pdf_edp_im(:,j) = (1./(handles.EDP.RIDR.*sig_everyIM(j)*sqrt(2*pi))).*exp(-((log(handles.EDP.RIDR)-log(median_everyIM(j))).^2)./(2*(sig_everyIM(j).^2)));
        end
        cdf = normcdf((log(handles.EDP.RIDR) - log(median_everyIM(j)))/sig_everyIM(j));
        handles.EDPtype.(handles.EDPnames{i}).maf_edp = trapz(handles.hazardDerivative(1,:),handles.hazardDerivative(2,:)'.*(1-cdf));
%         figure
%         plot(handles.EDP.RIDR,handles.EDPtype.(handles.EDPnames{i}).pdf_edp_im(:,50))
%         title(['Probabilty Distribution of ',(handles.EDPnames{i}),' Given Sa = ',num2str(handles.hazardDerivative(1,50)),'g'])
%         xlabel(handles.EDPnames{i})
%     figure
%     plot(handles.EDP.RIDR,handles.EDPtype.(handles.EDPnames{i}).maf_edp)
    elseif contains(handles.EDPnames{i},'IDR')
        for j=1:length(median_everyIM)
            handles.EDPtype.(handles.EDPnames{i}).pdf_edp_im(:,j) = (1./(handles.EDP.IDR.*sig_everyIM(j)*sqrt(2*pi))).*exp(-((log(handles.EDP.IDR)-log(median_everyIM(j))).^2)./(2*(sig_everyIM(j).^2)));
        end
        cdf = normcdf((log(handles.EDP.IDR) - log(median_everyIM(j)))/sig_everyIM(j));
        handles.EDPtype.(handles.EDPnames{i}).maf_edp = trapz(handles.hazardDerivative(1,:),handles.hazardDerivative(2,:)'.*(1-cdf));
%         figure
%         plot(handles.EDP.IDR,handles.EDPtype.(handles.EDPnames{i}).pdf_edp_im(:,50))
%         title(['Probabilty Distribution of ',(handles.EDPnames{i}),' Given Sa = ',num2str(handles.hazardDerivative(1,50)),'g'])
%         xlabel(handles.EDPnames{i})
%     figure
%     plot(handles.EDP.IDR,handles.EDPtype.(handles.EDPnames{i}).maf_edp)
    elseif contains(handles.EDPnames{i},'PFA')
        for j=1:length(median_everyIM)
            handles.EDPtype.(handles.EDPnames{i}).pdf_edp_im(:,j) = (1./(handles.EDP.PFA.*sig_everyIM(j)*sqrt(2*pi))).*exp(-((log(handles.EDP.PFA)-log(median_everyIM(j))).^2)./(2*(sig_everyIM(j).^2)));
        end
        cdf = normcdf((log(handles.EDP.PFA) - log(median_everyIM(j)))/sig_everyIM(j));
        handles.EDPtype.(handles.EDPnames{i}).maf_edp = trapz(handles.hazardDerivative(1,:),handles.hazardDerivative(2,:)'.*(1-cdf));
%     figure
%     plot(handles.EDP.PFA,handles.EDPtype.(handles.EDPnames{i}).maf_edp)
        %         figure
%         plot(handles.EDP.PFA,handles.EDPtype.(handles.EDPnames{i}).pdf_edp_im(:,50))
%         title(['Probabilty Distribution of ',(handles.EDPnames{i}),' Given Sa = ',num2str(handles.hazardDerivative(1,50)),'g'])
%         xlabel(handles.EDPnames{i})
    else
        disp('error')
    end
% 
%     handles.EDPtype.(handles.EDPnames{i}).maf_edp = trapz(handles.hazardDerivative(1,:),(handles.hazardDerivative(2,:).*handles.EDPtype.(handles.EDPnames{i}).pdf_edp_im)');
%     if contains(handles.EDPnames{i},'RIDR') 
% 
%     elseif contains(handles.EDPnames{i},'IDR')
% 
%     elseif contains(handles.EDPnames{i},'PFA')
% 
%     end
end

app.handles = handles;
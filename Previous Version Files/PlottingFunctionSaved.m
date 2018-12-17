  properties (Access = public)
        handles % Structure with many things in it
        hazardFile % Filename of the hazard curve
    end

    methods (Access = public)
    
        function getPolynomialOrder(app)
            order = app.OrderofFittingPolynomialSwitch.Value;
            if order == '3rd'
                app.handles.PolynomialOrder = 3;
            else
                app.handles.PolynomialOrder = 4;
            end
        end
        
        function plotPolyFit(app)
            cla(app.UIAxes2, 'reset')
            loglog(app.UIAxes2, app.handles.hazard(:,1), app.handles.hazard(:,2), 'o') 
            hold(app.UIAxes2, 'on')
            t=text(app.UIAxes2, app.handles.hazard(1,1), min(app.handles.hazardCurve(2,:)), app.handles.str1);
            t.FontSize = 9;
            t.BackgroundColor = 'w';
            t.EdgeColor = 'k';
            loglog(app.UIAxes2,app.handles.hazardCurve(1,:), app.handles.hazardCurve(2,:))
            title(app.UIAxes2,'Seismic Hazard Curve')
            xlabel(app.UIAxes2,'Sa (g)')
            ylabel(app.UIAxes2,'Mean Annual Frequency (1/yr)')
            legend(app.UIAxes2,'Hazard Curve','Polyfit')
            set(app.UIAxes2, ...
              'Box'         , 'off'     , ...
              'TickDir'     , 'out'     , ...
              'TickLength'  , [.02 .02] , ...
              'XMinorTick'  , 'on'      , ...
              'YMinorTick'  , 'on');
            hold(app.UIAxes2, 'off')
            
        end
        
        function plotEDPresponse(app, value)
            cla(app.UIAxes5, 'reset')
            plot(app.UIAxes5,app.handles.stripes,app.handles.EDPtype.(value).GMData, 'Color', [0.8 0.8 0.8])
            hold(app.UIAxes5, 'on');
            plot(app.UIAxes5,app.handles.stripes,app.handles.EDPtype.(value).meanEDP,'LineWidth',3,'Color','r')
            plot(app.UIAxes5,app.handles.stripes,app.handles.EDPtype.(value).medianEDP,'LineWidth',3,'Color','b')
            title(app.UIAxes5,[value, ' v. IM'])
            ylabel(app.UIAxes5,value)
            xlabel(app.UIAxes5,'Sa')
            set(app.UIAxes5, ...
              'Box'         , 'off'     , ...
              'TickDir'     , 'out'     , ...
              'TickLength'  , [.02 .02] , ...
              'XMinorTick'  , 'on'      , ...
              'YMinorTick'  , 'on');
            hold(app.UIAxes5,'off');
            
        end
        
        function plotFragilities(app, value)
            cla(app.UIAxes3, 'reset')
            plot(app.UIAxes3, app.handles.(value).EDP, app.handles.(value).P_Damage, 'LineWidth', 2)
            legendary = strings(1, app.handles.(value).NumDS);
            for i = app.handles.(value).NumDS
            legendary(i) = strcat('DS', num2str(i));
            end
            title(app.UIAxes5, ([(value), ' Fragilities']))
            xlabel(app.UIAxes5, strcat('EDP (', app.handles.(value).EDPtype, ')'))
            ylabel(app.UIAxes5, 'P[Ds > ds | EDP]')
            legend(app.UIAxes5, legendary)
            set(app.UIAxees5, ...
              'Box'         , 'off'     , ...
              'TickDir'     , 'out'     , ...
              'TickLength'  , [.02 .02] , ...
              'XMinorTick'  , 'on'      , ...
              'YMinorTick'  , 'on');
            grid on
            set(app.UIAxes3, 'XLim', [app.handles.(value).EDP(1),app.handles.(value).EDP(end)])

        end
        
        function plotCollapse(n,app)
            cla(app.UIAxes, 'reset')
            plot(app.UIAxes,app.handles.stripes,app.handles.numberCollapse/n,'o')
            hold(app.UIAxes, 'on')
            plot(app.handles.hazardDerivative(1,:),app.handles.P_collapse,'k')
            grid(app.UIAxes, 'on')
            title(app.UIAxes,'Collapse Fragility Function')
            legend(app.UIAxes,'Stripe Analysis Median Collapse', 'Max Likelihood Fragility Fit')
            xlabel(app.UIAxes,'Sa (g)')
            ylabel(app.UIAxes,'P[C]')
            legend(app.UIAxes,'Location','northwest')
            set(app.UIAxes, ...
              'Box'         , 'off'     , ...
              'TickDir'     , 'out'     , ...
              'TickLength'  , [.02 .02] , ...
              'XMinorTick'  , 'on'      , ...
              'YMinorTick'  , 'on');
        end
        
        function plotLossDeaggregation(app)

            hold(app.UIAxes4)
            plot(app.UIAxes4, [0,app.handles.hazardCurve(1,:)], [0, app.handles.L_IM], 'k', 'LineWidth', 1.5)
            plot(app.UIAxes4, app.handles.hazardCurve(1,:), app.handles.ncLoss_IM, '--r')
            plot(app.UIAxes4, app.handles.hazardCurve(1,:), app.handles.collapseLoss_IM, '--g')
            plot(app.UIAxes4, app.handles.hazardCurve(1,:), app.handles.demoLoss_IM, '--b')
            xlabel(app.UIAxes4,'Sa (g)')
            ylabel(app.UIAxes4,'E[L|IM] ($)')
            title(app.UIAxes4,'Expected Loss Given IM')
            legend(app.UIAxes4,'Total Loss', 'No Collapse, Repair', 'Collapse', 'Demo')
            set(gca, ...
              'Box'         , 'off'     , ...
              'TickDir'     , 'out'     , ...
              'TickLength'  , [.02 .02] , ...
              'XMinorTick'  , 'on'      , ...
              'YMinorTick'  , 'on');
            grid on
            hold(app.UIAxes4)
            
        end
        
        function stripes = parseStripes(app, filenames)
            stripes = zeros(length(filenames), 1);
            for i = 1:length(filenames)
                str = filenames{i};
                split = strsplit(str, {'_Sa', 'Sa', 'Sa_', '_'});
                for j = 1:length(split)
                    check = str2double(split{j});
                    if isnan(check)
                        continue
                    else
                        stripes(i) = check;
                        break
                    end
                end
            end
        end
end
        
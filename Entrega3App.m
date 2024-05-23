classdef Entrega3App < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                       matlab.ui.Figure
        TabGroup                       matlab.ui.container.TabGroup
        Tab                            matlab.ui.container.Tab
        TextArea                       matlab.ui.control.TextArea
        cambioPagina                   matlab.ui.control.Button
        Tab2                           matlab.ui.container.Tab
        ExitButton                     matlab.ui.control.Button
        Switch                         matlab.ui.control.Switch
        CoordenadaInicialenXEditFieldLabel  matlab.ui.control.Label
        CoordenadaInicialenXEditField  matlab.ui.control.NumericEditField
        CoordenadaInicialenYEditFieldLabel  matlab.ui.control.Label
        CoordenadaInicialenYEditField  matlab.ui.control.NumericEditField
        ValordeCargaLabel              matlab.ui.control.Label
        ValordeCargaEditField          matlab.ui.control.NumericEditField
        SeparacindeDipolosLabel        matlab.ui.control.Label
        SeparacindeDipolosEditField    matlab.ui.control.NumericEditField
        GRAFICARButton                 matlab.ui.control.Button
        XpointEditFieldLabel           matlab.ui.control.Label
        XpointEditField                matlab.ui.control.NumericEditField
        YpointEditFieldLabel           matlab.ui.control.Label
        YpointEditField                matlab.ui.control.NumericEditField
        MagnitudEditFieldLabel         matlab.ui.control.Label
        MagnitudEditField              matlab.ui.control.NumericEditField
        UIAxes                         matlab.ui.control.UIAxes
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: cambioPagina
        function calcCampoElec(app, event)
            app.TabGroup.SelectedTab = app.Tab2;
        end

        % Button pushed function: ExitButton
        function ExitButtonPushed(app, event)
           close(app.UIFigure);
        end

        % Value changed function: Switch
        function SwitchValueChanged(app, event)
            value = app.Switch.Value;
        end

        % Button pushed function: GRAFICARButton
        function GRAFICARButtonPushed(app, event)
            cla(app.UIAxes);
            orientacion = app.Switch.Value;
            Q = app.ValordeCargaEditField.Value;
            xi = app.CoordenadaInicialenXEditField.Value;
            yi = app.CoordenadaInicialenYEditField.Value;
            sep = app.SeparacindeDipolosEditField.Value;
            dis = 4; % Fixed distance between dipole charges
            long = 8; % How far to extend the line of dipoles
            [xG, yG] = meshgrid(-8:0.3:8);
            hold(app.UIAxes, 'on');
            U = zeros(size(xG));
            V = zeros(size(yG));
            Qp = Q;
            Qn = -Q;
            K = 8.99e9; % Coulomb's constant
            
             if strcmp(orientacion, 'Horizontal')
                Mx1 = xi:sep:xi+long; % x-coordinates for negative charges
                Ny1 = yi*ones(size(Mx1)); % y-coordinates for negative charges
                Mx2 = Mx1; % x-coordinates for positive charges
                Ny2 = (yi+dis)*ones(size(Mx1)); % y-coordinates for positive charges
            elseif strcmp(orientacion, 'Vertical')
                Ny1 = yi:sep:yi+long; % y-coordinates for negative charges
                Mx1 = xi*ones(size(Ny1)); % x-coordinates for negative charges
                Ny2 = Ny1; % y-coordinates for positive charges
                Mx2 = (xi+dis)*ones(size(Ny1)); % x-coordinates for positive charges
            end
            
            for i = 1:length(Mx1)
                % Negative charge contribution
                Rx = xG-Mx1(i);
                Ry = yG - Ny1(i);
                R = sqrt(Rx.^2 + Ry.^2).^3;
                Ex = K.*Qn.*Rx./R;
                Ey = K.*Qn.*Ry./R;
            
                % Positive charge contribution
                Rx = xG - Mx2(i);
                Ry = yG - Ny2(i);
                R = sqrt(Rx.^2+Ry.^2).^3;
                Ex = Ex + K.*Qp.*Rx./R;
                Ey = Ey + K.*Qp.*Ry./R;
                
                % Accumulate the electric field vectors
                U = U + Ex;
                V = V + Ey;
            end
            
            % Normalize vectors for better visualization
            magnitude = sqrt(U.^2 + V.^2);
            U = U ./ magnitude;
            V = V ./ magnitude;
            
            k = 8.99*10^9;
            xpoint = app.XpointEditField.Value;
            ypoint = app.YpointEditField.Value;
            r = sqrt((xpoint - xi)^2 + (ypoint - yi)^2);
            Q = app.ValordeCargaEditField.Value;
            E_mag = k * abs(Q) / r^2;
            
            app.MagnitudEditField.Value = E_mag;
            
      
            scaleFactor = 0.5; % Adjust as needed
            maxHeadSize = 6; % Adjust arrowhead size
            quiver(app.UIAxes, xG, yG, U, V, 'AutoScaleFactor', scaleFactor,'MaxHeadSize', maxHeadSize, 'Color', 'blue', 'LineStyle', '-');
            plot(app.UIAxes, Mx1, Ny1, 'ob', 'MarkerSize', 15, 'LineWidth', 8); % Blue balls
            plot(app.UIAxes, Mx2, Ny2, 'or', 'MarkerSize', 15, 'LineWidth', 8); % Red balls
            plot(app.UIAxes,xpoint, ypoint, 'ok', 'MarkerSize', 15, 'LineWidth', 8);
            app.UIAxes.Title.String = "Modelación del campo de cargas eléctricas";
            app.UIAxes.XLabel.String = 'X';
            app.UIAxes.YLabel.String = 'Y';
            axis(app.UIAxes, 'equal');
            grid(app.UIAxes, 'on');
        end

        % Callback function
        function cambioPagina_2ButtonPushed(app, event)
            app.TabGroup.SelectedTab = app.Tab3;
        end

        % Callback function
        function ExitButton_2Pushed(app, event)
              close(app.UIFigure);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [1 1 640 480];

            % Create Tab
            app.Tab = uitab(app.TabGroup);
            app.Tab.Title = 'Tab';

            % Create TextArea
            app.TextArea = uitextarea(app.Tab);
            app.TextArea.Position = [150 287 340 65];
            app.TextArea.Value = {'                                       Bienvenido '; '                              Al presionar este boton '; '                           podras aprender acerca de '; '                      como Calcular un Campo Electrico'; ''};

            % Create cambioPagina
            app.cambioPagina = uibutton(app.Tab, 'push');
            app.cambioPagina.ButtonPushedFcn = createCallbackFcn(app, @calcCampoElec, true);
            app.cambioPagina.Position = [116 229 174 22];
            app.cambioPagina.Text = 'Campo Electrico';

            % Create Tab2
            app.Tab2 = uitab(app.TabGroup);
            app.Tab2.Title = 'Tab2';

            % Create ExitButton
            app.ExitButton = uibutton(app.Tab2, 'push');
            app.ExitButton.ButtonPushedFcn = createCallbackFcn(app, @ExitButtonPushed, true);
            app.ExitButton.Position = [559 16 62 20];
            app.ExitButton.Text = 'Exit';

            % Create Switch
            app.Switch = uiswitch(app.Tab2, 'slider');
            app.Switch.Items = {'Vertical', 'Horizontal'};
            app.Switch.ValueChangedFcn = createCallbackFcn(app, @SwitchValueChanged, true);
            app.Switch.Position = [522 406 45 20];
            app.Switch.Value = 'Vertical';

            % Create CoordenadaInicialenXEditFieldLabel
            app.CoordenadaInicialenXEditFieldLabel = uilabel(app.Tab2);
            app.CoordenadaInicialenXEditFieldLabel.HorizontalAlignment = 'right';
            app.CoordenadaInicialenXEditFieldLabel.Position = [458 351 75 28];
            app.CoordenadaInicialenXEditFieldLabel.Text = {'Coordenada '; 'Inicial en X'; ''};

            % Create CoordenadaInicialenXEditField
            app.CoordenadaInicialenXEditField = uieditfield(app.Tab2, 'numeric');
            app.CoordenadaInicialenXEditField.Position = [548 357 83 22];

            % Create CoordenadaInicialenYEditFieldLabel
            app.CoordenadaInicialenYEditFieldLabel = uilabel(app.Tab2);
            app.CoordenadaInicialenYEditFieldLabel.HorizontalAlignment = 'right';
            app.CoordenadaInicialenYEditFieldLabel.Position = [458 305 75 28];
            app.CoordenadaInicialenYEditFieldLabel.Text = {'Coordenada '; 'Inicial en Y'};

            % Create CoordenadaInicialenYEditField
            app.CoordenadaInicialenYEditField = uieditfield(app.Tab2, 'numeric');
            app.CoordenadaInicialenYEditField.Position = [548 311 83 22];

            % Create ValordeCargaLabel
            app.ValordeCargaLabel = uilabel(app.Tab2);
            app.ValordeCargaLabel.HorizontalAlignment = 'right';
            app.ValordeCargaLabel.Position = [453 266 88 22];
            app.ValordeCargaLabel.Text = ' Valor de Carga';

            % Create ValordeCargaEditField
            app.ValordeCargaEditField = uieditfield(app.Tab2, 'numeric');
            app.ValordeCargaEditField.Position = [556 266 75 22];

            % Create SeparacindeDipolosLabel
            app.SeparacindeDipolosLabel = uilabel(app.Tab2);
            app.SeparacindeDipolosLabel.HorizontalAlignment = 'right';
            app.SeparacindeDipolosLabel.Position = [458 209 70 42];
            app.SeparacindeDipolosLabel.Text = {'Separación '; 'de '; 'Dipolos'; ''};

            % Create SeparacindeDipolosEditField
            app.SeparacindeDipolosEditField = uieditfield(app.Tab2, 'numeric');
            app.SeparacindeDipolosEditField.Position = [543 229 88 22];

            % Create GRAFICARButton
            app.GRAFICARButton = uibutton(app.Tab2, 'push');
            app.GRAFICARButton.ButtonPushedFcn = createCallbackFcn(app, @GRAFICARButtonPushed, true);
            app.GRAFICARButton.Position = [495 52 100 22];
            app.GRAFICARButton.Text = {'GRAFICAR'; ''};

            % Create XpointEditFieldLabel
            app.XpointEditFieldLabel = uilabel(app.Tab2);
            app.XpointEditFieldLabel.HorizontalAlignment = 'right';
            app.XpointEditFieldLabel.Position = [476 172 40 22];
            app.XpointEditFieldLabel.Text = 'Xpoint';

            % Create XpointEditField
            app.XpointEditField = uieditfield(app.Tab2, 'numeric');
            app.XpointEditField.Position = [531 172 100 22];

            % Create YpointEditFieldLabel
            app.YpointEditFieldLabel = uilabel(app.Tab2);
            app.YpointEditFieldLabel.HorizontalAlignment = 'right';
            app.YpointEditFieldLabel.Position = [476 128 40 22];
            app.YpointEditFieldLabel.Text = 'Ypoint';

            % Create YpointEditField
            app.YpointEditField = uieditfield(app.Tab2, 'numeric');
            app.YpointEditField.Position = [531 128 100 22];

            % Create MagnitudEditFieldLabel
            app.MagnitudEditFieldLabel = uilabel(app.Tab2);
            app.MagnitudEditFieldLabel.HorizontalAlignment = 'right';
            app.MagnitudEditFieldLabel.Position = [460 85 56 22];
            app.MagnitudEditFieldLabel.Text = 'Magnitud';

            % Create MagnitudEditField
            app.MagnitudEditField = uieditfield(app.Tab2, 'numeric');
            app.MagnitudEditField.Position = [531 85 100 22];

            % Create UIAxes
            app.UIAxes = uiaxes(app.Tab2);
            title(app.UIAxes, {'Dipolo'; ''})
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.PlotBoxAspectRatio = [1.19683908045977 1 1];
            app.UIAxes.XLim = [-8 8];
            app.UIAxes.YLim = [-8 8];
            app.UIAxes.XTick = [-8 -6 -4 -2 0 2 4 6 8];
            app.UIAxes.XGrid = 'on';
            app.UIAxes.YGrid = 'on';
            app.UIAxes.Position = [1 18 458 420];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Entrega3App

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end
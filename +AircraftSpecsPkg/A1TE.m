function [Aircraft] = A1TE()
%
% [Aircraft] = A1TE()
% Author: Calvin Gajda
% last updated: 03 Feb 2026
% 
% Assignment 1 - Turboelectric (part a)
% 
% INPUTS:
%     none
%
% OUTPUTS:
%     Aircraft - an aircraft structure to be used for analysis.
%                size/type/units: 1-by-1 / struct / []
%


%% TOP-LEVEL AIRCRAFT REQUIREMENTS %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% expected entry-into-service year
Aircraft.Specs.TLAR.EIS = 2035;

% ** REQUIRED **
% aircraft class, can be either:
%     'Piston'    = piston engine
%     'Turboprop' = turboprop engine
%     'Turbofan'  = turbojet or turbofan engine
Aircraft.Specs.TLAR.Class = "Turboprop";

% ** REQUIRED **
% approximate number of passengers
Aircraft.Specs.TLAR.MaxPax = 90;


%% MODEL CALIBRATION FACTORS %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% calibration factors for lift-drag ratios 
Aircraft.Specs.Aero.L_D.ClbCF = 1;
Aircraft.Specs.Aero.L_D.CrsCF = 1;

% fuel flow calibration factor
Aircraft.Specs.Propulsion.MDotCF = 1;

% airframe weight calibration factor
Aircraft.Specs.Weight.WairfCF = 1;
 

%% VEHICLE PERFORMANCE %%
%%%%%%%%%%%%%%%%%%%%%%%%%

% takeoff speed (m/s)
Aircraft.Specs.Performance.Vels.Tko = 63;

% cruise  speed (mach)
Aircraft.Specs.Performance.Vels.Crs = 0.6;

% takeoff altitude (m)
Aircraft.Specs.Performance.Alts.Tko = 0;

% cruise altitude (m)
Aircraft.Specs.Performance.Alts.Crs = 7600;

% ** REQUIRED **
% design range (m)
Aircraft.Specs.Performance.Range = 750000;

% maximum rate of climb (m/s)
Aircraft.Specs.Performance.RCMax = 10.16;


%% AERODYNAMICS %%
%%%%%%%%%%%%%%%%%%

% lift-drag ratio during climb  
Aircraft.Specs.Aero.L_D.Clb = 19.2 * Aircraft.Specs.Aero.L_D.ClbCF;

% lift-drag ratio during cruise
Aircraft.Specs.Aero.L_D.Crs = 24.000 * Aircraft.Specs.Aero.L_D.CrsCF;

% assume same lift-drag ratio during climb and descent
Aircraft.Specs.Aero.L_D.Des = Aircraft.Specs.Aero.L_D.Clb;

% wing loading (kg / m^2)
Aircraft.Specs.Aero.W_S.SLS = 510;


%% WEIGHTS %%
%%%%%%%%%%%%%

% maximum takeoff weight (kg)
Aircraft.Specs.Weight.MTOW = 30500;

% electric generator weight (kg)
Aircraft.Specs.Weight.EG = NaN;

% electric motor weight (kg)
Aircraft.Specs.Weight.EM = NaN;

% block fuel weight (kg)
Aircraft.Specs.Weight.Fuel = NaN;

% battery weight (kg), leave NaN for propulsion systems without batteries
Aircraft.Specs.Weight.Batt = NaN;


%% PROPULSION %%
%%%%%%%%%%%%%%%%

% ** REQUIRED ** propulsion system architecture, either:
%     (1) "C"   = conventional
%     (2) "E"   = fully electric
%     (3) "TE"  = fully turboelectric
%     (4) "PE"  = partially turboelectric
%     (5) "PHE" = parallel hybrid electric
%     (6) "SHE" = series hybrid electric
%     (7) "O"   = other architecture (specified by the user)
Aircraft.Specs.Propulsion.PropArch.Type = "O";
Aircraft.Specs.Propulsion.PropArch.Arch = [0, 1, 0, 0, 0, 0, 0, 0;
            0, 0, 1, 0, 0, 0, 0, 0;
            0, 0, 0, 1, 1, 0, 0, 0;
            0, 0, 0, 0, 0, 1, 0, 0;
            0, 0, 0, 0, 0, 0, 1, 0;
            0, 0, 0, 0, 0, 0, 0, 1;
            0, 0, 0, 0, 0, 0, 0, 1;
            0, 0, 0, 0, 0, 0, 0, 0]; 
Aircraft.Specs.Propulsion.PropArch.OperUps = @(lam) ...
              [0,1,0,0,0,0,0,0;
               0,0,1,0,0,0,0,0;
               0,0,0,1/2,1/2,0,0,0;
               0,0,0,0,0,1,0,0;
               0,0,0,0,0,0,1,0;
               0,0,0,0,0,0,0,1;
               0,0,0,0,0,0,0,1;
               0,0,0,0,0,0,0,0] ; 

Aircraft.Specs.Propulsion.PropArch.OperDwn = @(lam) ...
              [0,0,0,0,0,0,0,0;
               1,0,0,0,0,0,0,0;
               0,1,0,0,0,0,0,0;
               0,0,1,0,0,0,0,0;
               0,0,1,0,0,0,0,0;
               0,0,0,1,0,0,0,0;
               0,0,0,0,1,0,0,0;
               0,0,0,0,0,1/2,1/2,0]; 

Aircraft.Specs.Propulsion.PropArch.EtaUps = [1,1,1,1,1,1,1,1;
              1,1,0.96,1,1,1,1,1;
              1,1,1,0.96,0.96,1,1,1;
              1,1,1,1,1,0.87,1,1;
              1,1,1,1,1,1,0.87,1;
              1,1,1,1,1,1,1,1;
              1,1,1,1,1,1,1,1;
              1,1,1,1,1,1,1,1;];

Aircraft.Specs.Propulsion.PropArch.EtaDwn = [1,1,1,1,1,1,1,1;
              1,1,1,1,1,1,1,1;
              1,0.96,1,1,1,1,1,1;
              1,1,0.96,1,1,1,1,1;
              1,1,0.96,1,1,1,1,1;
              1,1,1,0.87,1,1,1,1;
              1,1,1,1,0.87,1,1,1;
              1,1,1,1,1,1,1,1;] ; 

Aircraft.Specs.Propulsion.PropArch.SrcType = 1;

Aircraft.Specs.Propulsion.PropArch.TrnType = [1, 3, 0, 0, 2, 2];

% get the engine
Aircraft.Specs.Propulsion.Engine = EngineModelPkg.EngineSpecsPkg.PW_127M;

% number of engines
Aircraft.Specs.Propulsion.NumEngines = 1;

% thrust-weight ratio (if a turbojet/turbofan)
Aircraft.Specs.Propulsion.T_W.SLS = NaN;

% total sea-level static thrust available (N)
Aircraft.Specs.Propulsion.Thrust.SLS = NaN;

% engine propulsive efficiency
Aircraft.Specs.Propulsion.Eta.Prop = .85;


%% POWER %%
%%%%%%%%%%%

% gravimetric specific energy of combustible fuel (kWh/kg)
Aircraft.Specs.Power.SpecEnergy.Fuel = 11.9;


% downstream power splits
Aircraft.Specs.Power.LamDwn.SLS = 0;
Aircraft.Specs.Power.LamDwn.Tko = 0;
Aircraft.Specs.Power.LamDwn.Clb = 0;
Aircraft.Specs.Power.LamDwn.Crs = 0;
Aircraft.Specs.Power.LamDwn.Des = 0;
Aircraft.Specs.Power.LamDwn.Lnd = 0;

% upstream power splits
Aircraft.Specs.Power.LamUps.SLS = 0; 
Aircraft.Specs.Power.LamUps.Tko = 0;
Aircraft.Specs.Power.LamUps.Clb = 0;
Aircraft.Specs.Power.LamUps.Crs = 0;
Aircraft.Specs.Power.LamUps.Des = 0;
Aircraft.Specs.Power.LamUps.Lnd = 0;

% electric motor and generator efficiencies
Aircraft.Specs.Power.Eta.EM = 0.96;
Aircraft.Specs.Power.Eta.EG = 0.96;

% power-weight ratio for the aircraft (kW/kg, if a turboprop)
Aircraft.Specs.Power.P_W.SLS = 0.15;

% power-weight ratio for the electric motor and generator (kW/kg)
% leave as NaN if an electric motor or generator isn't in the powertrain
Aircraft.Specs.Power.P_W.EM = 5;
Aircraft.Specs.Power.P_W.EG = 5;

% battery cells in series and parallel
Aircraft.Specs.Power.Battery.ParCells = NaN; % 100;
Aircraft.Specs.Power.Battery.SerCells = NaN; %

% initial battery SOC (commented value used for electrified aircraft)
Aircraft.Specs.Power.Battery.BegSOC = NaN;%100;



%% SETTINGS (LEAVE AS NaN FOR DEFAULTS) %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% number of control points in each segment
Aircraft.Settings.TkoPoints = NaN;
Aircraft.Settings.ClbPoints = NaN;
Aircraft.Settings.CrsPoints = NaN;
Aircraft.Settings.DesPoints = NaN;

% maximum number of iterations during oew estimation
Aircraft.Settings.OEW.MaxIter = 50;

% oew relative tolerance for convergence
Aircraft.Settings.OEW.Tol = 0.001;

% maximum number of iterations during aircraft sizing
Aircraft.Settings.Analysis.MaxIter = 30;

% analysis type, either:
%     +1 for on -design mode (aircraft performance and sizing)
%     -1 for off-design mode (aircraft performance           )
Aircraft.Settings.Analysis.Type = +1;

% plotting, either:
%     1 for plotting on
%     0 for plotting off
Aircraft.Settings.Plotting = 0;

% make a tble of mission history
%     1 for make table
%     0 for no table
Aircraft.Settings.Table = 0;

% ----------------------------------------------------------

end
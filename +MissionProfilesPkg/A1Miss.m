function [Aircraft] = A1Miss(Aircraft)
%
% [Aircraft] = A1Miss(Aircraft)
% written by Calvin Gajda
% last updated: 03 Feb 2026
%
% Parametric mission for the A1 - Electric Aircraft Assignment (but can be accommodated for any
% regional jet)           
% 
% part 1: fly at design range                    | part 2:      | part 3: 
%                                                |diversion     | 30 min 
%                                                | at 3500 m    | loiter
%                                                |              |
%                                                |              |
%           _____________________________        |              |   
%          /                             \       |              |
%      ___/                               \___   |    __________|___
%     /                                       \  |  _/          |   \_
%    /                                         \_|_/            |     \
% __/                                            |              |      \__
%
%
% INPUTS:
%     Aircraft - aircraft structure (without a mission profile).
%                size/type/units: 1-by-1 / struct / []
%
% OUTPUTS:
%     Aircraft - aircraft structure (with    a mission profile).
%                size/type/units: 1-by-1 / struct / []
%


%% IMPORT THE PERFORMANCE PARAMETERS %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% mission range
Range = Aircraft.Specs.Performance.Range;

% speed type
TAS  = "TAS" ;
EAS  = "EAS" ;
Mach = "Mach";


%% DEFINE THE MISSION TARGETS %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% define the targets (in m or min)
Mission.Target.Valu = [750000; 150000; 30;];

% define the target types ("Dist" or "Time")
Mission.Target.Type = ["Dist"; "Dist"; "Time";];


%% DEFINE THE MISSION SEGMENTS %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% define the segments
Mission.Segs = ["Takeoff"; "Climb";   "Climb";   "Climb"; "Cruise";  "Descent";  "Descent";     "Climb";       "Climb";       "Cruise";   "Cruise";     "Descent";    "Descent";"Descent";"Landing";];

% define the mission id (segments in same mission must be consecutive)
Mission.ID   = [       1;      1;          1;          1;       1;          1;          1;          2;             2;            2;         3;             3;            3;         3;      3;];

% define the starting/ending altitudes (in m)
Mission.AltBeg = [0; 0; 900; 7600; 7600; 7600; 7600; 900; 3500; 3500; 3500; 3500; 3500; 900; 0;];
Mission.AltEnd = [0; 900; 7600; 7600; 7600; 7600; 900; 3500; 3500; 3500; 3500; 3500; 900; 0; 0;];

% define the starting/ending speeds (in m/s or mach)
Mission.VelBeg = [0; 63; 90; 90; 0.6; 0.6; 90; 90; 90; 0.4; 0.4; 0.4; 90; 90; 82;];
Mission.VelEnd = [63; 90; 90; 0.6; 0.6; 90; 90; 90; 0.4; 0.4; 0.4; 90; 90; 82; 0;];

% define the speed types (either "TAS", "EAS", or "Mach")
Mission.TypeBeg = [TAS; TAS; EAS; EAS; Mach; Mach; EAS; EAS; EAS; Mach; Mach; Mach; EAS; EAS; TAS;];
Mission.TypeEnd = [TAS; EAS; EAS; Mach; Mach; EAS; EAS; EAS; Mach; Mach; Mach; EAS; EAS; TAS; TAS;];

% no climb rate defined now (if there was one, it would be in m/s)
Mission.ClbRate = NaN(length(Mission.ID), 1);


%% REMEMBER THE MISSION PROFILE %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% save the information
Aircraft.Mission.Profile = Mission;

% ----------------------------------------------------------

end
%---INPUT SCRIPT FOR MFR Coal Combustion Model-----------------------------
% Reactant Flow Rates:
NG_in = 0.1; % kg/hr Natural Gas (assumed 100% CH4)
COAL = 1.6; % kg/hr coal (including moisture and ash)
% see below for more coal-related variables
Primary = 0.607; % fraction of oxidizer to primary combustion zone
% NOTE: The following 4 variables are flow rates through the burner (i.e.
% excluding burnout oxidizer)
Air_in = 6*Primary; % kg/hr Air (assumed 1 mole O2 to 3.76 moles N2)
O2_in = 0*Primary; % kg/hr Bottled O2 (assumed 100% pure)
CO2_in = 0*Primary; % kg/hr Bottled CO2 (assumed 100% pure)
N2_in = 0*Primary; % kg/hr Bottled N2 (assumed 100% pure)
NO_doping = 0; % ppm NO in the CO2 reactant streams
% Experiment conditions:
P = 85000; % Pressure (Pa) at BYU's elevation
T1 = 300; % initial gas temperature (K)
T2 = 522; % Burnout Oxidizer Pre-heat Temperature (K)
d = 0.127; % diameter of MFR reactor (m)
k_wall = 400; % This empirical heat transfer parameter is tuned to match
% experimental data to account for all heat transfer from
% the combustion that is not explicitly modeled elsewhere.
% This value is linked to the value of the variable Length
% (defined below).
% For a methane-air case, 500 should be used with 0.002 m
% value for Length
% For coal-cases with Length = 0.002 m, 400 is recommended
WallX = [0; % Locations of wall temperature measurements (m)
0.020; % The code interpolates when wall temperatures are
0.045; % required between these locations.
0.071; % (linear interpolation)
0.096;
0.122;
0.147;
0.172;
0.198;
0.413;
0.879;
1.171;
1.475;
1.751];
twallvector = [400; % Wall temperature measurements (K)
1140; % - must correspond to WallX locations.
1203;
1235;
1269;
1286;
1285;
1280;
1268;
1324;
1216;
1118;
1046;
914];
% Variables related to the gas phase reactions:
thermal = 1; % multiplier for thermal NOx mechanism reactions
prompt = 1; % multiplier for prompt NOx mechanism reactions
% (0 to disable, 1 to enable)
mechanism = 1; % Selection of gas phase chemistry mechanism
% 1 = GRI-Mech 3.0
% 2 = GRI-Mech 3.0 + B96 (includes advanced reburning)
% 3 = SKG03
% Variables related to the numerical modeling:
TR1 = 2000; % initial guessed temperature of the CSTR's in ignition network
dt = 0.01; % time step for CSTR network integration (seconds)
% integration continues until steady state is reached (as
% measured by temperature change being less than a tolerance
tolerance = 1e-8; % tolerance on the change in temperature between time
% steps to steady state.
number_reactors = 5; % number of CSTR's in ignition network
Length = 0.002; % length of CSTR's in network (m)
% usually 0.002 m - Grid Independence was
% verified for 0.002 m
% Note that if this is changed then the
% value of k_wall needs to be changed also
Length2 = Length; % Length of CSTR's after ignition network (see also
% comments for Length above)
% Variables related to the CPDCP-NLG coal devolatilization model:
% Radiation Heat Transfer Parameters:
% emissivity of:
emiss = [0.4; % burner
0.5; % walls
0.999; % exhaust tube (a cavity)
0.7]; % particle
tbnr = 400.0; % burner face temperature (K)
texit = 900.0; % exhaust tube temperature (K)
% Time Step Parameters:
timax = 2.0; % maximum devolatilization time modeled (seconds)
%----------------------------------------------------------------------
% Proximate and Ultimate Analysis Data for Coal:
% Stored in array yelem in the order: CHNOS, dry, ash-free mass
% fractions
yelem = [0.7056; 0.0418; 0.0104; 0.2363; 0.0059];
ASTMvol = 49.72; % DAF basis (0 < ASTMvol < 100)
% Only required if C13 NMR data will be estimated
%----------------------------------------------------------------------
% C13 NMR Structural Data for Coal:
% Note: If C13 NMR data are unavailable for your coal, the correlation
% of Genetti and Fletcher will be used to estimate these parameters
% using yelem and ASTMvol (defined above) - if this is the case, set
% mw1 to zero to activate the correlation. The correlation code is in
% the main progam file.
% Genetti, D., "An Advanced Model of Coal Devolatilization Based on
% Chemical Structure," M.S. Thesis, Brigham Young University (1998).
mw1 = 0; % average molecular weight per aromatic cluster
% (includes side chains)
% SET TO ZERO TO ACTIVATE C13 NMR CORRELATION:
% i.e. mw1 = 0;
p0 = 0; % ratio of bridges to total attachments
c0 = 0; % char bridge population
sigp1 = 0; % this is the coordination number sigma+1 (number of
% total attachments per cluster)
mdel = 0; % average molecular weight per side chain
%----------------------------------------------------------------------
rhop = 0.7; % initial particle apparent density (g/cm^3). As explained
% by Fletcher (Comb. Sci. Tech., 63, 89-105, 1989), this
% parameter is artificially lowered in order to match
% measured particle temperatures. This may indicate that
% the reported particle heat capacities are too high, or
% else that the Sandia flow reactor had radial temperature
% gradients near the injector that influenced the heating
% characteristics.
% Note that apparent density is calculated from total
% measured coal mass divided by TOTAL volume, so the
% volume includes voids between particles, and pores in
% the coal.
dp = 121.0e-4; % particle diameter (cm)
swell = 0.0; % swelling factor (dpf/dp0 - 1) dpf = final/max diameter
% dp0 = initial diameter
% Note that this swelling is not the swelling of coal when
% placed in a solvent, rather it is swelling of the coal
% when it softens during heating and escaping gases cause
% expansion of the softened material. This parameter is
% heating rate dependent. It is probably near-zero for high
% rank anthracites and low rank lignites and subbituminous
% coals, but important for medium rank coals - see the book
% by K. Lee Smith et al. (1994): The Structure and Reaction
% Processes of Coal, pg 211.
delhv = -100.0; % Heat of pyrolysis (cal/g), negative indicates
% endothermic
% Nominally -100.0 cal/g
omegaw = 0.0846; % mass fraction of moisture in the parent coal
% (as received, i.e. including ash)
omegaa = 0.0602; % mass fraction of ash in the parent coal (as received)
% Variables related to the char oxidation and gasification model:
COAL_Type = 1;
% 1 = Wyoming Sub-bituminous
% 2 = Illinois #6
% 3 = Pittsburgh #8
gasification = 1; % Char gasification by CO2: 1 = enable, 0 = disable
Q_reactO2_x = 0; % Fraction (0-1) of heterogeneous O2 reaction heat to char
% Nominally 0 because 0.5 and 1.0 gave problems - need to
% adjust in the future possibly.
Q_reactCO2_x = 0; % Fraction (0-1) of heterogeneous O2 reaction heat to char
% Nominally 0 because 0.5 and 1.0 gave problems - need to
% adjust in the future possibly.
%---------END OF USER INPUT SCRIPT-----------------------------------------
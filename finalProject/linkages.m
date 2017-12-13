function linkages(scene)
if nargin < 1
	scene = 0;
end

video = true;
if video == true
	video = VideoWriter('output','MPEG-4');
	video.open();
else
	video = [];
end

links = [];
pins = [];
gearpins = [];
sliders = [];
particles = [];

% lsqnonlin options
opt = optimoptions('lsqnonlin');
opt.Jacobian = 'on';
opt.DerivativeCheck = 'off';
opt.TolFun = 1e-12;
opt.Display = 'off';

% Set up the scene here.
% Note that links don't have to be placed exactly. The first call to
% solveLinkage() will automatically snap the links so that all the
% constraints are satisfied.

% These values can be overridden inside the switch statement
T = 1; % final time
dt = 0.15; % time step
drawHz = 30; % refresh rate
angVel = 2*pi; % driver angular velocity
useOscillatory = false;
range = [ -pi, pi ];

switch scene
	case 0
		% Crank-rocker
		% Bottom link
		links(1).angle = 0; % rotation from the positive x-axis
		links(1).pos = [-10 0]'; % position of the center of rotation
		links(1).verts = [ % display vertices
			-1.0  21.0  21.0 -1.0
			-1.0  -1.0   1.0  1.0
			];
		% Left link
		links(2).angle = pi/2;
		links(2).pos = [-10 0]';
		links(2).verts = [
			-1.0  11.0  11.0 -1.0
			-1.0  -1.0   1.0  1.0
			];
		% Right link
		links(3).angle = pi/2;
		links(3).pos = [10 0]';
		links(3).verts = [
			-1.0  21.0  21.0 -1.0
			-1.0  -1.0   1.0  1.0
			];
		% Top link (note: links don't need to be rectangular)
		links(4).angle = 0;
		links(4).pos = [-10 10]';
		links(4).verts = [
			-1.0  25.0 31.0  31.0  5.0 -1.0
			-1.0  -5.0 -1.0   1.0  3.0  1.0
			];
		
		% Which link is grounded?
		grounded = 1;
		% Which link is the driver?
		% Note: the driver must be attached (with a pin) to the ground.
		driver = 2;
		
		% Bottom-left
		pins(end+1).linkA = 1;
		pins(end).linkB = 2;
		pins(end).pointA = [0,0]';
		pins(end).pointB = [0,0]';
		% Bottom-right
		pins(end+1).linkA = 1;
		pins(end).linkB = 3;
		pins(end).pointA = [20,0]';
		pins(end).pointB = [0,0]';
		% Left-top
		pins(end+1).linkA = 2;
		pins(end).linkB = 4;
		pins(end).pointA = [10,0]';
		pins(end).pointB = [0,0]';
		% Right-top
		pins(end+1).linkA = 3;
		pins(end).linkB = 4;
		pins(end).pointA = [10+10*rand(1),0]'; % pin location on link3 is randomized
		pins(end).pointB = [20,0]';
		
		% List of tracer particles for display
		particles(1).link = 4; % which link?
		particles(1).point = [5,3]'; % tracer particle point in local coords
		particles(2).link = 4;
		particles(2).point = [25,-5]';
	case 1
		% Drag-link
        useOscillatory = false;
        % Bottom link
		links(1).angle = 0; % rotation from the positive x-axis
		links(1).pos = [-10 0]'; % position of the center of rotation
		links(1).verts = [ % display vertices
			-1.0  21.0  21.0 -1.0
			-1.0  -1.0   1.0  1.0
			];
		% Left link
		links(2).angle = pi/2;
		links(2).pos = [-10 0]';
		links(2).verts = [
			-1.0  30.0  30.0 -1.0
			-1.0  -1.0   1.0  1.0
			];
		% Right link
		links(3).angle = pi/2;
		links(3).pos = [10 0]';
		links(3).verts = [
			-1.0  33.0  33.0 -1.0
			-1.0  -1.0   1.0  1.0
			];
		% Top link (note: links don't need to be rectangular)
		links(4).angle = 0;
		links(4).pos = [-10 10]';
		links(4).verts = [
			-1.0  25.0 31.0  31.0  5.0 -1.0
			-1.0  -5.0 -1.0   1.0  3.0  1.0
			];
		
		% Which link is grounded?
		grounded = 1;
		% Which link is the driver?
		% Note: the driver must be attached (with a pin) to the ground.
		driver = 2;
		
		% Bottom-left
		pins(end+1).linkA = 1;
		pins(end).linkB = 2;
		pins(end).pointA = [0,0]';
		pins(end).pointB = [0,0]';
		% Bottom-right
		pins(end+1).linkA = 1;
		pins(end).linkB = 3;
		pins(end).pointA = [20,0]';
		pins(end).pointB = [0,0]';
		% Left-top
		pins(end+1).linkA = 2;
		pins(end).linkB = 4;
		pins(end).pointA = [30,0]';
		pins(end).pointB = [0,0]';
		% Right-top
		pins(end+1).linkA = 3;
		pins(end).linkB = 4;
		pins(end).pointA = [30,0]'; % pin location on link3 is randomized
		pins(end).pointB = [30,0]';
		
		% List of tracer particles for display
		particles(1).link = 4; % which link?
		particles(1).point = [0,0]'; % tracer particle point in local coords
		particles(2).link = 4;
		particles(2).point = [30,0]';
	case 2
		% Double-rocker
        T = 10;
        useOscillatory = true;
        range = [ -pi/12, pi/12 ];
        % Bottom link
		links(1).angle = 0; % rotation from the positive x-axis
		links(1).pos = [-10 0]'; % position of the center of rotation
		links(1).verts = [ % display vertices
			-1.0  21.0  21.0 -1.0
			-1.0  -1.0   1.0  1.0
			];
		% Left link
		links(2).angle = pi/2;
		links(2).pos = [-10 0]';
		links(2).verts = [
			-1.0  21.0  21.0 -1.0
			-1.0  -1.0   1.0  1.0
			];
		% Right link
		links(3).angle = pi/2;
		links(3).pos = [10 0]';
		links(3).verts = [
			-1.0  26.0  26.0 -1.0
			-1.0  -1.0   1.0  1.0
			];
		% Top link (note: links don't need to be rectangular)
		links(4).angle = 0;
		links(4).pos = [-10 10]';
		links(4).verts = [
			-1.0  11.0  11.0  -1.0
			-1.0  -1.0   1.0   1.0
			];
		
		% Which link is grounded?
		grounded = 1;
		% Which link is the driver?
		% Note: the driver must be attached (with a pin) to the ground.
		driver = 2;
		
		% Bottom-left
		pins(end+1).linkA = 1;
		pins(end).linkB = 2;
		pins(end).pointA = [0,0]';
		pins(end).pointB = [0,0]';
		% Bottom-right
		pins(end+1).linkA = 1;
		pins(end).linkB = 3;
		pins(end).pointA = [20,0]';
		pins(end).pointB = [0,0]';
		% Left-top
		pins(end+1).linkA = 2;
		pins(end).linkB = 4;
		pins(end).pointA = [20,0]';
		pins(end).pointB = [0,0]';
		% Right-top
		pins(end+1).linkA = 3;
		pins(end).linkB = 4;
		pins(end).pointA = [25,0]'; % pin location on link3 is randomized
		pins(end).pointB = [10,0]';
		
		% List of tracer particles for display
		particles(1).link = 4; % which link?
		particles(1).point = [0,0]'; % tracer particle point in local coords
		particles(2).link = 4;
		particles(2).point = [10,0]';
	case 3
		% Chebyshev's lambda
        useOscillatory = false;
        % Bottom link
		links(1).angle = 0; % rotation from the positive x-axis
		links(1).pos = [-10 0]'; % position of the center of rotation
		links(1).verts = [ % display vertices
			-1.0  21.0  21.0 -1.0
			-1.0  -1.0   1.0  1.0
			];
		% Left link
		links(2).angle = pi/2;
		links(2).pos = [-10 0]';
		links(2).verts = [
			-1.0  11.0  11.0 -1.0
			-1.0  -1.0   1.0  1.0
			];
		% Right link
		links(3).angle = pi/2;
		links(3).pos = [10 0]';
		links(3).verts = [
			-1.0  26.0  26.0 -1.0
			-1.0  -1.0   1.0  1.0
			];
		% Top link (note: links don't need to be rectangular)
		links(4).angle = 0;
		links(4).pos = [-10 10]';
		links(4).verts = [
			-1.0  51.0  51.0  -1.0
			-1.0  -1.0   1.0   1.0
			];
		
		% Which link is grounded?
		grounded = 1;
		% Which link is the driver?
		% Note: the driver must be attached (with a pin) to the ground.
		driver = 2;
		
		% Bottom-left
		pins(end+1).linkA = 1;
		pins(end).linkB = 2;
		pins(end).pointA = [0,0]';
		pins(end).pointB = [0,0]';
		% Bottom-right
		pins(end+1).linkA = 1;
		pins(end).linkB = 3;
		pins(end).pointA = [20,0]';
		pins(end).pointB = [0,0]';
		% Left-top
		pins(end+1).linkA = 2;
		pins(end).linkB = 4;
		pins(end).pointA = [10,0]';
		pins(end).pointB = [0,0]';
		% Right-top
		pins(end+1).linkA = 3;
		pins(end).linkB = 4;
		pins(end).pointA = [25,0]'; % pin location on link3 is randomized
		pins(end).pointB = [25,0]';
		
		% List of tracer particles for display
		particles(1).link = 4; % which link?
		particles(1).point = [0,0]'; % tracer particle point in local coords
		particles(2).link = 4;
		particles(2).point = [50,0]';
	case 4
		% Peaucellier-Lipkin
	case 5
		% Klann
        useOscillatory = false;
        %Triangle link
		links(1).angle = 0; % rotation from the positive x-axis
		links(1).pos = [0 0]'; % position of the center of rotation
		links(1).verts = [ % display vertices
			-2.0   20.0  -2.0
			-1.0    7.0  13.0
			];
        
        %Driver Link and right rectangle
        links(2).angle = 0; % rotation from the positive x-axis
		links(2).pos = [18 7]'; % position of the center of rotation
		links(2).verts = [ % display vertices
			-1.0   7  7 -1.0
			-1.0  -1.0  1.0  1.0
			];
        
        %Left rectangle link
        links(3).angle = 0; % rotation from the positive x-axis
		links(3).pos = [0 0]'; % position of the center of rotation
		links(3).verts = [ % display vertices
			-1.0   10.0  10.0 -1.0
			-1.0  -1.0  1.0  1.0
			];
        
        %Top rectangle link
        links(4).angle = 0; % rotation from the positive x-axis
		links(4).pos = [0 8]'; % position of the center of rotation
		links(4).verts = [ % display vertices
			-1.0   -21.0 21.0
			-1.0     1.0  1.0
			];
        
        %UpperLeg Joint
        links(5).angle = pi/2; % rotation from the positive x-axis
		links(5).pos = [8 9]'; % position of the center of rotation
		links(5).verts = [ % display vertices
			-1.0   18.0 18.0 -1.0
			-1.0  -1.0  1.0  1.0
			];
        
        %Leg
        links(6).angle = 3*pi/2; % rotation from the positive x-axis
		links(6).pos = [-4 9]'; % position of the center of rotation
		links(6).verts = [ % display vertices
			-1.0   50.0 -1.0
			-1.0  -1.0   1.0
			];
        
        % Which link is grounded?
		grounded = 1;
		% Which link is the driver?
		% Note: the driver must be attached (with a pin) to the ground.
		driver = 2;
        
        %driver pin
        pins(end+1).linkA = 1;
		pins(end).linkB = 2;
		pins(end).pointA = [18,7]'; % pin location on link3 is randomized
		pins(end).pointB = [0,0]';
        
        %Bottom Left -Rectangle Pin
        pins(end+1).linkA = 1;
		pins(end).linkB = 3;
		pins(end).pointA = [0,0]'; % pin location on link3 is randomized
		pins(end).pointB = [0,0]';
        
        %Top Left -RectanglePin
        pins(end+1).linkA = 3;
		pins(end).linkB = 4;
		pins(end).pointA = [9,0]'; % pin location on link3 is randomized
		pins(end).pointB = [-1,0]';
        
        %pin top rect to right rect
        pins(end+1).linkA = 4;
		pins(end).linkB = 2;
		pins(end).pointA = [20,1]'; % pin location on link3 is randomized
		pins(end).pointB = [7,0]';
        
        %pin upper leg joint to triangle
        pins(end+1).linkA = 1;
		pins(end).linkB = 5;
		pins(end).pointA = [0,12]'; % pin location on link3 is randomized
		pins(end).pointB = [0,0]';
        
        %pin uper leg joint to joint connector
        pins(end+1).linkA = 5;
		pins(end).linkB = 6;
		pins(end).pointA = [17,0]'; % pin location on link3 is randomized
		pins(end).pointB = [0,0]';
        
        pins(end+1).linkA = 6;
		pins(end).linkB = 4;
		pins(end).pointA = [17,0]'; % pin location on link3 is randomized
		pins(end).pointB = [-21,1]';
        
		particles(1).link = 4; % which link?
		particles(1).point = [0,0]'; % tracer particle point in local coords
		particles(2).link = 6;
        particles(2).point = [50,0]';
	case 6
        T = 6;
		% Hart's Inversor
        useOscillatory = true;
        range = [-pi/10, pi/10];
        %Grounded
        links(1).angle = 0; % rotation from the positive x-axis
		links(1).pos = [0 0]'; % position of the center of rotation
		links(1).verts = [ % display vertices
			-2.0   2.0   2.0 -2.0
			-0.1  -0.1   0.1  0.1
			];
        %Driver
        links(2).angle = 29*pi/48; % rotation from the positive x-axis
		links(2).pos = [2 0]'; % position of the center of rotation
		links(2).verts = [ % display vertices
            -0.1   4.0   4.0 -0.1
			-0.1  -0.1   0.1  0.1
			];
        
        %Left support leg
        links(3).angle = 5*pi/12; % rotation from the positive x-axis
		links(3).pos = [-2 0]'; % position of the center of rotation
		links(3).verts = [ % display vertices
            -0.1   4.0   4.0 -0.1
			-0.1  -0.1   0.1  0.1
			];
        
        %Left tip
        links(4).angle = 5*pi/12; % rotation from the positive x-axis
		links(4).pos = [-1 3.6]'; % position of the center of rotation
		links(4).verts = [ % display vertices
            -0.1   2.0   2.0 -0.1
			-0.1  -0.1   0.1  0.1
			];
        
        %Left tip
        links(5).angle = 7*pi/12; % rotation from the positive x-axis
		links(5).pos = [1 3.6]'; % position of the center of rotation
		links(5).verts = [ % display vertices
            -0.1   2.0   2.0 -0.1
			-0.1  -0.1   0.1  0.1
			];
        
        %Left tip
        links(6).angle = 0; % rotation from the positive x-axis
		links(6).pos = [-1 3.6]'; % position of the center of rotation
		links(6).verts = [ % display vertices
            -0.1   2.0   2.0 -0.1
			-0.1  -0.1   0.1  0.1
			];
        
        
        grounded = 1;
        driver = 2;
        
        %driver pin
        pins(end+1).linkA = 1;
		pins(end).linkB = 2;
		pins(end).pointA = [2,0]'; % pin location on link3 is randomized
		pins(end).pointB = [0,0]';
        
        %left support pin
        pins(end+1).linkA = 1;
		pins(end).linkB = 3;
		pins(end).pointA = [-2,0]'; % pin location on link3 is randomized
		pins(end).pointB = [0,0]';
        
        %left support pin upper
        pins(end+1).linkA = 3;
		pins(end).linkB = 4;
		pins(end).pointA = [4,0]'; % pin location on link3 is randomized
		pins(end).pointB = [0,0]';
        
        %left support pin upper
        pins(end+1).linkA = 2;
		pins(end).linkB = 5;
		pins(end).pointA = [4,0]'; % pin location on link3 is randomized
		pins(end).pointB = [0,0]';
        
        %left support pin upper
        pins(end+1).linkA = 4;
		pins(end).linkB = 5;
		pins(end).pointA = [2,0]'; % pin location on link3 is randomized
		pins(end).pointB = [2,0]';
        
        %center line to left support
        pins(end+1).linkA = 3;
		pins(end).linkB = 6;
		pins(end).pointA = [3,0]'; % pin location on link3 is randomized
		pins(end).pointB = [0,0]';
        
        %center line to right support
        pins(end+1).linkA = 2;
		pins(end).linkB = 6;
		pins(end).pointA = [3,0]'; % pin location on link3 is randomized
		pins(end).pointB = [2,0]';
        
        particles(1).link = 5; % which link?
		particles(1).point = [2,0]'; % tracer particle point in local coords      
	case 10
		% Extra credit!
        T = 4;
		opt.Jacobian = 'off';
        % Crank-rocker
		% Bottom link
        links(1).gear = false;
		links(1).angle = 0; % rotation from the positive x-axis
		links(1).pos = [-10 0]'; % position of the center of rotation
		links(1).verts = [ % display vertices
			-1.0  21.0  21.0 -1.0
			-1.0  -1.0   1.0  1.0
			];
		% Left link
        links(2).gear = false;
		links(2).angle = pi/2;
		links(2).pos = [-10 0]';
		links(2).verts = [
			-1.0  11.0  11.0 -1.0
			-1.0  -1.0   1.0  1.0
			];
		% Top link (note: links don't need to be rectangular)
        links(3).gear = false;
		links(3).angle = 0;
		links(3).pos = [-10 10]';
		links(3).verts = [
			-1.0 41.0  41.0  -1.0
			-1.0 -1.0   1.0   1.0
			];
		
		% Which link is grounded?
		grounded = 1;
		% Which link is the driver?
		% Note: the driver must be attached (with a pin) to the ground.
		driver = 2;
		
		% Bottom-left
		pins(end+1).linkA = 1;
		pins(end).linkB = 2;
		pins(end).pointA = [0,0]';
		pins(end).pointB = [0,0]';

		% Left-top
		pins(end+1).linkA = 2;
		pins(end).linkB = 3;
		pins(end).pointA = [10,0]';
		pins(end).pointB = [0,0]';
        
		% Right-top
		sliders(1).linkA = 1;
		sliders(1).linkB = 3;
        sliders(1).pointA = [20,0]';
		sliders(1).pointB1 = [30,0]';
		sliders(1).pointB2 = [10,0]';
		
		% List of tracer particles for display
		particles(1).link = 2; % which link?
		particles(1).point = [10,0]'; % tracer particle point in local coords
		particles(2).link = 3;
		particles(2).point = [30,0]';
    case 11
        T = 2;
		opt.Jacobian = 'off';
		% Bottom link
        links(1).gear = false;
        links(1).angle = 0; % rotation from the positive x-axis
		links(1).pos = [-10 0]'; % position of the center of rotation
		links(1).verts = [ % display vertices
			-1.0  21.0  21.0 -1.0
			-1.0  -1.0   1.0  1.0
			];

        %First Gear
        links(2).gear = true;
        links(2).angle = 0;
        links(2).pos = [-10 0]';
        links(2).radius = 10;
        links(2).verts = [
             0
             0
            ];
        links(3).gear = false;
		links(3).angle = 0;
		links(3).pos = [-10 10]';
		links(3).verts = [
			-1.0 41.0  41.0  -1.0
			-1.0 -1.0   1.0   1.0
			];
        links(4).gear = false;
		links(4).angle = 0;
		links(4).pos = [-10 10]';
		links(4).verts = [
			-1.0 41.0  41.0  -1.0
			-1.0 -1.0   1.0   1.0
			];
		
		% Which link is grounded?
		grounded = 1;
		% Which link is the driver?
		% Note: the driver must be attached (with a pin) to the ground.
		driver = 2;
        
        pins(end+1).linkA = 1;
        pins(end).linkB = 2;
        pins(end).pointA = [0,0]';
        pins(end).pointB = [0,0]';
        		% Left-top
		pins(end+1).linkA = 2;
		pins(end).linkB = 3;
		pins(end).pointA = [8,0]';
		pins(end).pointB = [0,0]';
        
        pins(end+1).linkA = 2;
		pins(end).linkB = 4;
		pins(end).pointA = [-3,4]';
		pins(end).pointB = [0,0]';
        
		% Right-top
		sliders(1).linkA = 1;
		sliders(1).linkB = 3;
        sliders(1).pointA = [20,0]';
		sliders(1).pointB1 = [30,0]';
		sliders(1).pointB2 = [10,0]';
        
        % Right-top
		sliders(2).linkA = 1;
		sliders(2).linkB = 4;
        sliders(2).pointA = [20,0]';
		sliders(2).pointB1 = [30,0]';
		sliders(2).pointB2 = [10,0]';
        
		% List of tracer particles for display
		particles(1).link = 2; % which link?
		particles(1).point = [5,0]'; % tracer particle point in local coords
 		particles(2).link = 3;
 		particles(2).point = [40,0]';
        particles(3).link = 4;
        particles(3).point = [40,0]';
        
    case 12
        T = 1.5;
		opt.Jacobian = 'off';
		% Bottom link
        links(1).gear = false;
        links(1).angle = 0; % rotation from the positive x-axis
		links(1).pos = [-10 0]'; % position of the center of rotation
		links(1).verts = [ % display vertices
			-1.0  21.0  21.0 -1.0
			-1.0  -1.0   1.0  1.0
			];

        %First Gear
        links(2).gear = true;
        links(2).angle = 0;
        links(2).pos = [-10 0]';
        links(2).radius = 10;
        links(2).verts = [
             0
             0
            ];

        %Second Gear
        links(3).gear = true;
        links(3).angle = 0;
        links(3).pos = [5 0]';
        links(3).radius = 5;
        links(3).verts = [
             0
             0
            ];
		
		% Which link is grounded?
		grounded = 1;
		% Which link is the driver?
		% Note: the driver must be attached (with a pin) to the ground.
		driver = 2;
        
        pins(end+1).linkA = 1;
        pins(end).linkB = 2;
        pins(end).pointA = [0,0]';
        pins(end).pointB = [0,0]';
        
        pins(end+1).linkA = 1;
        pins(end).linkB = 3;
        pins(end).pointA = [15,0]';
        pins(end).pointB = [0,0]';
        
        gearpins(1).linkA = 2;
        gearpins(1).linkB = 3;
        
		% List of tracer particles for display
		particles(1).link = 2; % which link?
		particles(1).point = [10,0]'; % tracer particle point in local coords
        particles(2).link = 3;
        particles(2).point = [5,0]';
        
    case 13
        T = 40;
		opt.Jacobian = 'off';
		% Bottom link
        links(1).gear = false;
        links(1).angle = 0; % rotation from the positive x-axis
		links(1).pos = [-10 0]'; % position of the center of rotation
		links(1).verts = [ % display vertices
			-1.0  21.0  21.0 -1.0
			-1.0  -1.0   1.0  1.0
			];

        %First Gear
        links(2).gear = true;
        links(2).angle = 0;
        links(2).pos = [-10 0]';
        links(2).radius = 10;
        links(2).verts = [
             0
             0
            ];

        %Second Gear
        links(3).gear = true;
        links(3).angle = 0;
        links(3).pos = [5 0]';
        links(3).radius = 5;
        links(3).verts = [
             0
             0
            ];
        
        links(4).gear = false;
        links(4).angle = 0;
        links(4).pos = [0 8]';
        links(4).verts = [
			-1.0 41.0  41.0  -1.0
			-1.0 -1.0   1.0   1.0
			];
        
        links(5).gear = false;
        links(5).angle = 0;
        links(5).pos = [15 4]';
        links(5).verts = [
			-1.0 21.0  21.0  -1.0
			-1.0 -1.0   1.0   1.0
			];
        
        links(6).gear = false;
        links(6).angle = -90;
        links(6).pos = [15 4]';
        links(6).verts = [
            -1.0 21.0  21.0  -1.0
			-1.0 -1.0   1.0   1.0
			];
		
		% Which link is grounded?
		grounded = 1;
		% Which link is the driver?
		% Note: the driver must be attached (with a pin) to the ground.
		driver = 2;
        
        pins(end+1).linkA = 1;
        pins(end).linkB = 2;
        pins(end).pointA = [0,0]';
        pins(end).pointB = [0,0]';
        
        pins(end+1).linkA = 1;
        pins(end).linkB = 3;
        pins(end).pointA = [15,0]';
        pins(end).pointB = [0,0]';
        
        pins(end+1).linkA = 2;
        pins(end).linkB = 4;
        pins(end).pointA = [0,8]';
        pins(end).pointB = [0,0]';
        
        pins(end+1).linkA = 3;
        pins(end).linkB = 5;
        pins(end).pointA = [0,4]';
        pins(end).pointB = [0,0]';
        
        pins(end+1).linkA = 4;
        pins(end).linkB = 6;
        pins(end).pointA = [40,0]';
        pins(end).pointB = [20,0]';
        
        pins(end+1).linkA = 5;
        pins(end).linkB = 6;
        pins(end).pointA = [20,0]';
        pins(end).pointB = [0,0]';
        
%         % Right-top
% 		sliders(1).linkA = 3;
% 		sliders(1).linkB = 6;
%         sliders(1).pointA = [20,0]';
% 		sliders(1).pointB1 = [20,0]';
% 		sliders(1).pointB2 = [0,0]';
        
        gearpins(1).linkA = 2;
        gearpins(1).linkB = 3;
        gearpins(1).radiusA = 10;
        gearpins(1).radiusB = 5;
        
		% List of tracer particles for display
		particles(1).link = 2; % which link?
		particles(1).point = [10,0]'; % tracer particle point in local coords
        particles(2).link = 3;
        particles(2).point = [5,0]';
        particles(3).link = 4;
        particles(3).point = [40 0]';
        particles(4).link = 5;
        particles(4).point = [20 0]';
    case 14
        T = 5.5;
		opt.Jacobian = 'off';
		% Bottom link
        links(1).gear = false;
        links(1).angle = 0; % rotation from the positive x-axis
		links(1).pos = [-10 0]'; % position of the center of rotation
		links(1).verts = [ % display vertices
			-1.0  26.0  26.0 -1.0
			-1.0  -1.0   1.0  1.0
			];

        %First Gear
        links(2).gear = true;
        links(2).angle = 0;
        links(2).pos = [-10 0]';
        links(2).radius = 10;
        links(2).verts = [
             0
             0
            ];

        %Second Gear
        links(3).gear = true;
        links(3).angle = 0;
        links(3).pos = [5 0]';
        links(3).radius = 5;
        links(3).verts = [
             0
             0
            ];
        %Third Gear
        links(4).gear = true;
        links(4).angle = 0;
        links(4).pos = [12.5 0]';
        links(4).radius = 2.5;
        links(4).verts = [
             0
             0
            ];
		
		% Which link is grounded?
		grounded = 1;
		% Which link is the driver?
		% Note: the driver must be attached (with a pin) to the ground.
		driver = 2;
        
        pins(end+1).linkA = 1;
        pins(end).linkB = 2;
        pins(end).pointA = [0,0]';
        pins(end).pointB = [0,0]';
        
        pins(end+1).linkA = 1;
        pins(end).linkB = 3;
        pins(end).pointA = [15,0]';
        pins(end).pointB = [0,0]';
        
        pins(end+1).linkA = 1;
        pins(end).linkB = 4;
        pins(end).pointA = [22.5 0]';
        pins(end).pointB = [0 0]';
        
        gearpins(1).linkA = 2;
        gearpins(1).linkB = 3;
        
        gearpins(2).linkA = 3;
        gearpins(2).linkB = 4;
        
		% List of tracer particles for display
		particles(1).link = 2; % which link?
		particles(1).point = [10,0]'; % tracer particle point in local coords
        particles(2).link = 3;
        particles(2).point = [5,0]';
        particles(3).link = 4;
        particles(3).point = [2.5,0]';
   case 15
        T = 40;
		opt.Jacobian = 'off';
		% Bottom link
        links(1).gear = false;
        links(1).angle = 0; % rotation from the positive x-axis
		links(1).pos = [-10 0]'; % position of the center of rotation
		links(1).verts = [ % display vertices
			-1.0  26.0  26.0 -1.0
			-1.0  -1.0   1.0  1.0
			];

        %First Gear
        links(2).gear = true;
        links(2).angle = 0;
        links(2).pos = [-10 0]';
        links(2).radius = 10;
        links(2).verts = [
             0
             0
            ];

        %Second Gear
        links(3).gear = true;
        links(3).angle = 0;
        links(3).pos = [5 0]';
        links(3).radius = 5;
        links(3).verts = [
             0
             0
            ];
        %Third Gear
        links(4).gear = true;
        links(4).angle = 0;
        links(4).pos = [12.5 0]';
        links(4).radius = 2.5;
        links(4).verts = [
             0
             0
            ];
        
        links(5).gear = false;
        links(5).angle = -90;
        links(5).pos = [0 10]';
        links(5).verts = [
			-1.0 21.0  21.0  -1.0
			-1.0 -1.0   1.0   1.0
			];
        
        links(6).gear = false;
		links(6).angle = -80;
        links(6).pos = [10 5]';
        links(6).verts = [
			-1.0 21.0  21.0  -1.0
			-1.0 -1.0   1.0   1.0
			];
        
        links(7).gear = false;
        links(7).angle = -90;
        links(7).pos = [-5 20]';
        links(7).verts = [
			-1.0 41.0  41.0  -1.0
			-1.0 -1.0   1.0   1.0
			];
        
        links(8).gear = false;
		links(8).angle = 90;
        links(8).pos = [10 5]';
        links(8).verts = [
			-1.0 21.0  21.0  -1.0
			-1.0 -1.0   1.0   1.0
			];
        
        links(9).gear = false;
        links(9).angle = 90;
        links(9).pos = [12.5 2.5]';
        links(9).verts = [
			-1.0 21.0  21.0  -1.0
			-1.0 -1.0   1.0   1.0
			];
        
        links(10).gear = false;
        links(10).angle = -90;
        links(10).pos = [15 20]';
        links(10).verts = [
			-1.0 11.0  11.0  -1.0
			-1.0 -1.0   1.0   1.0
			];
        
		% Which link is grounded?
		grounded = 1;
		% Which link is the driver?
		% Note: the driver must be attached (with a pin) to the ground.
		driver = 2;
        
        pins(end+1).linkA = 1;
        pins(end).linkB = 2;
        pins(end).pointA = [0,0]';
        pins(end).pointB = [0,0]';
        
        pins(end+1).linkA = 1;
        pins(end).linkB = 3;
        pins(end).pointA = [15,0]';
        pins(end).pointB = [0,0]';
        
        pins(end+1).linkA = 1;
        pins(end).linkB = 4;
        pins(end).pointA = [22.5 0]';
        pins(end).pointB = [0 0]';
        
        pins(end+1).linkA = 2;
        pins(end).linkB = 5;
        pins(end).pointA = [10 0]';
        pins(end).pointB = [0 0]';
        
        pins(end+1).linkA = 3;
        pins(end).linkB = 6;
        pins(end).pointA = [5 0]';
        pins(end).pointB = [0 0]';
        
        pins(end+1).linkA = 3;
        pins(end).linkB = 8;
        pins(end).pointA = [-5 0]';
        pins(end).pointB = [0 0]';
        
        pins(end+1).linkA = 4;
        pins(end).linkB = 9;
        pins(end).pointA = [-2.5 0]';
        pins(end).pointB = [0 0]';
        
        sliders(1).linkA = 5;
        sliders(1).linkB = 7;
        sliders(1).pointA = [20 0]';
        sliders(1).pointB1 = [0 0]';
        sliders(1).pointB2 = [40 0]';
        
        sliders(2).linkA = 6;
        sliders(2).linkB = 7;
        sliders(2).pointA = [20 0]';
        sliders(2).pointB1 = [0 0]';
        sliders(2).pointB2 = [40 0]';
        
        sliders(3).linkA = 8;
        sliders(3).linkB = 10;
        sliders(3).pointA = [20 0]';
        sliders(3).pointB1 = [0 0]';
        sliders(3).pointB2 = [10 0]';
        
        sliders(4).linkA = 9;
        sliders(4).linkB = 10;
        sliders(4).pointA = [20 0]';
        sliders(4).pointB1 = [0 0]';
        sliders(4).pointB2 = [10 0]';
        
        gearpins(1).linkA = 2;
        gearpins(1).linkB = 3;
        
        gearpins(2).linkA = 3;
        gearpins(2).linkB = 4;
        
		% List of tracer particles for display
		particles(1).link = 2; % which link?
		particles(1).point = [10,0]'; % tracer particle point in local coords
        particles(2).link = 3;
        particles(2).point = [5,0]';
        particles(3).link = 4;
        particles(3).point = [2.5,0]';
        particles(4).link = 7;
        particles(4).point = [40, 0]';
        particles(5).link = 7;
        particles(5).point = [0, 0]';
        particles(6).link = 10;
        particles(6).point = [10, 0]';
        particles(7).link = 10;
        particles(7).point = [0, 0]';
end

% Initialize
for i = 1 : length(links)
	links(i).grounded = (i == grounded); %#ok<*AGROW>
	links(i).driver = (i == driver);
	% These target quantities are only used for grounded and driver links
	links(i).angleTarget = links(i).angle;
	links(i).posTarget = links(i).pos;
end
for i = 1 : length(particles)
	particles(i).pointsWorld = zeros(2,0); % transformed points, initially empty
end

% Debug: drawing here to debug scene setup
%drawScene(0,links,pins,gearpins,sliders,particles);

% Simulation loop
t = 0; % current time
t0 = -inf; % last draw time
dt = 0.01;

while t < T % Procedurally set the driver angle.
    if(useOscillatory)
        amplitude = .5*abs(range(2) - range(1));
        center = .5*(range(2) + range(1));
        angVel = amplitude*sin(t)*dt + center;
        links(driver).angleTarget = links(driver).angleTarget + angVel;
    else
        links(driver).angleTarget = links(driver).angleTarget + dt*angVel;
    end
	% Right now, the target angle is being linearly increased, but you may
	% want to do something else.
	
	% Solve for linkage orientations and positions
	[links,feasible] = solveLinkage(links,pins,gearpins,sliders,opt);
	% Update particle positions
	particles = updateParticles(links,particles);
	% Draw scene
	if t - t0 > 1 / drawHz
		drawScene(t,links,pins,gearpins,sliders,particles,video);
		t0 = t;
	end
	% Quit if over-constrained
	if ~feasible
		break;
	end
	t = t + dt;
end
drawScene(t,links,pins,gearpins,sliders,particles,video);
if ~isempty(video)
	video.close();
end
end

%%
function [R,dR] = rotationMatrix(angle)
c = cos(angle);
s = sin(angle);
% Rotation matrix
R = zeros(2);
R(1,1) = c;
R(1,2) = -s;
R(2,1) = s;
R(2,2) = c;
if nargout >= 2
	% Rotation matrix derivative
	dR = zeros(2);
	dR(1,1) = -s;
	dR(1,2) = -c;
	dR(2,1) = c;
	dR(2,2) = -s;
end
end

%%
function [links,feasible] = solveLinkage(links,pins,gearpins,sliders,opt)
nlinks = length(links);
% Extract the current angles and positions into a vector
angPos0 = zeros(3*nlinks,1);
for i = 1 : nlinks
	link = links(i);
    ii = (i-1)*3+(1:3);
    angPos0(ii(1)) = link.angle;
    angPos0(ii(2:3)) = link.pos;
end
% Limits
lb = -inf(size(angPos0));
ub =  inf(size(angPos0));
% Solve for angles and positions
[angPos,r2] = lsqnonlin(@(angPos)objFun(angPos,links,sliders,pins,gearpins),angPos0,lb,ub,opt);
% If the mechanism is feasible, then the residual should be zero
feasible = true;
% if r2 > 1e-6
% 	fprintf('Mechanism is over constrained!\n');
% 	feasible = false;
% end
% Extract the angles and positions from the values in the vector
for i = 1 : length(links)
	ii = (i-1)*3+(1:3);
	links(i).angle = angPos(ii(1));
	links(i).pos = angPos(ii(2:3));
end

% Check for underconstrained configuration.
% This check only works when there are no sliders.
if isempty(sliders)
	[c,J] = objFun(angPos,links,sliders,pins,gearpins); %#ok<ASGLU>
	if rank(J,1e-2) < size(J,2)
		%fprintf('Mechanism is under-constrained!\n');
	end
end
end

%%
function [c,J] = objFun(angPos,links,sliders,pins,gearpins)

nlinks = length(links);
npins = length(pins);
ngearpins = length(gearpins);
nsliders = length(sliders);

% There cannot be any constraints between kinematic links
for i = 1 : length(pins)
	pin = pins(i);
	indLinkA = pin.linkA; % array index of link A
	indLinkB = pin.linkB; % array index of link B
	linkA = links(indLinkA);
	linkB = links(indLinkB);
	kinematicA = linkA.grounded || linkA.driver;
	kinematicB = linkB.grounded || linkB.driver;
    gearA = linkA.gear || linkA.driver;
    gearB = linkA.gear || linkA.driver;
	if kinematicA && kinematicB
        if gearA || gearB
            ngearpins = ngearpins - 1;
        else
            npins = npins - 1;
        end
	end
end
for i = 1 : length(sliders)
	slider = sliders(i);
	indLinkA = slider.linkA; % array index of link A
	indLinkB = slider.linkB; % array index of link B
	linkA = links(indLinkA);
	linkB = links(indLinkB);
	kinematicA = linkA.grounded || linkA.driver;
	kinematicB = linkB.grounded || linkB.driver;
	if kinematicA && kinematicB
		nsliders = nsliders - 1;
	end
end

% Temporarily change angles and positions of the links. These changes will
% be undone when exiting this function.
for i = 1 : nlinks
	ii = (i-1)*3+(1:3);
	links(i).angle = angPos(ii(1));
	links(i).pos = angPos(ii(2:3));
end

% Evaluate constraints
ndof = 3*nlinks;
ncon = 3 + 3 + 2*npins + 2*ngearpins + nsliders; % 3 for ground, 3 for driver, 2*npins, plus 1*nsliders
c = zeros(ncon,1);
J = zeros(ncon,ndof);
k = 0;
% Some angles and positions are fixed
for i = 1 : nlinks
	link = links(i);
	if link.grounded || link.driver
		% Grounded and driver links have their angles and positions
		% prescribed.
		c(k+1    ) = link.angle - link.angleTarget;
		c(k+(2:3)) = link.pos - link.posTarget;
		% The Jacobian of this constraint is the identity matrix
		colAng = (i-1)*3 + 1;
		colPos = (i-1)*3 + (2:3);
		J(k+1,    colAng) = 1;
		J(k+(2:3),colPos) = eye(2);
		k = k + 3;
    end
    if link.gear
        c(k+1    ) = link.angle - link.angleTarget;
        c(k+(2:3)) = link.pos - link.posTarget;
        k = k+3;
    end
end
% Pin constraints
for i = 1 : length(pins)
	pin = pins(i);
	indLinkA = pin.linkA; % array index of link A
	indLinkB = pin.linkB; % array index of link B
	linkA = links(indLinkA);
	linkB = links(indLinkB);
	kinematicA = linkA.grounded || linkA.driver;
	kinematicB = linkB.grounded || linkB.driver;
	if kinematicA && kinematicB
		continue;
	end
	rows = k+(1:2); % row index of this pin constraint
	k = k + 2;
	[Ra,dRa] = rotationMatrix(linkA.angle);
	[Rb,dRb] = rotationMatrix(linkB.angle);
	% Local positions
	ra = pin.pointA;
	rb = pin.pointB;
	% World positions
	xa = Ra * ra + linkA.pos;
	xb = Rb * rb + linkB.pos;
	p = xa(1:2) - xb(1:2);
	c(rows) = p;
	%
	% Optional Jacobian computation
	%
	% Column indices for the angles and positions of links A and B
	colAngA = (indLinkA-1)*3 + 1;
	colPosA = (indLinkA-1)*3 + (2:3);
	colAngB = (indLinkB-1)*3 + 1;
	colPosB = (indLinkB-1)*3 + (2:3);
	% The Jacobian of this constraint is the partial derivative of f wrt
	% the angles and positions of the two links.
	J(rows,colAngA) = dRa * ra;
	J(rows,colPosA) = eye(2);
	J(rows,colAngB) = -dRb * rb;
	J(rows,colPosB) = -eye(2);
end
%gearpin contraints
if ~isempty(gearpins)
    for i = 1 : length(gearpins)
        gpin = gearpins(i);
        indLinkA = gpin.linkA; % array index of link A
        indLinkB = gpin.linkB; % array index of link B
        linkA = links(indLinkA);
        linkB = links(indLinkB);
        kinematicA = linkA.grounded || linkA.driver;
        kinematicB = linkB.grounded || linkB.driver;
        if kinematicA && kinematicB
            continue;
        end
        rows = k+(1:2); % row index of this pin constraint
        k = k + 2;
        [Ra,dRa] = rotationMatrix(linkA.angle);
        [Rb,dRb] = rotationMatrix(linkB.angle);
        % Local positions
        ra = linkA.pos;
        rb = linkB.pos;
        % World positions
        xa = Ra * ra + linkA.pos;
        xb = Rb * rb + linkB.pos;
        c1 = 2*pi*linkA.radius;
        c2 = 2*pi*linkB.radius;
        p = (linkA.angle)*c1 + (linkB.angle)*c2;
        %p = dist(xa, xb);
        c(rows) = p;
    end
end
% Slider constraints
for i = 1 : length(sliders)
    rows = k+(3);
    slide = sliders(i);
    indLinkA = slide.linkA;
    indLinkB = slide.linkB;
    linkA = links(indLinkA);
    linkB = links(indLinkB);
    kinematicA = linkA.grounded || linkA.driver;
	kinematicB = linkB.grounded || linkB.driver;
	if kinematicA && kinematicB
		continue;
    end
    [Ra,dRa] = rotationMatrix(linkA.angle);
	[Rb,dRb] = rotationMatrix(linkB.angle);
	% Local positions
    ra = slide.pointA;
	rb1 = slide.pointB1;
	rb2 = slide.pointB2;
	% World positions
    xa = Ra * ra + linkA.pos;
	xb1 = Rb * rb1 + linkB.pos;
	xb2 = Rb * rb2 + linkB.pos;
	p = .5* det([xa(1) xb1(1) xb2(1);
                 xa(2) xb1(2) xb2(2);
                    1      1     1]);
	c(rows) = p;
    k = k + 3;
    rows = k + (1:3);
    k = k + 3;
    p = dist(xb2, xb1) - (dist(xa, xb2) + dist(xa, xb1));
    c(rows) = p;
end
end

function distance = dist(xa, xb)
distance = sqrt( (xa(1) - xb(1)).^2 + (xa(2) - xb(2)).^2);
end

%%
function particles = updateParticles(links,particles)
% Transform particle position from local to world
for i = 1 : length(particles)
	particle = particles(i);
	link = links(particle.link);
    theta = link.angle;
    R = [ cos(theta) -sin(theta)
          sin(theta) cos(theta) ];
	x = R*particle.point + link.pos;
	% Append world position to the array (grows indefinitely)
	particles(i).pointsWorld(:,end+1) = x;
end
end

%%
function drawScene(t,links,pins,gearpins,sliders,particles,video)
if t == 0
	clf;
	axis equal;
	hold on;
	grid on;
	xlabel('X');
	ylabel('Y');
end
cla;
% Draw links
rlines = [];
glines = [];
blines = [];
nan2 = nan(2,1);
for i = 1 : length(links)
	link = links(i);
	% Draw frame
	R = rotationMatrix(link.angle);
    if link.gear
        p = link.pos; % frame origin
        s = link.radius; % frame display size
        px = p + s*R(:,1); % frame x-axis
        py = p + s*R(:,2); % frame y-axis
        rlines = [rlines, p, px, nan2];
        glines = [glines, p, py, nan2];
    end
	% Draw link geometry
	E = [R,link.pos;0,0,1]; % transformation matrix
    vertsLocal = [link.verts;ones(1,size(link.verts,2))];
    vertsWorld = E * vertsLocal;
    if not(link.gear)
        if link.grounded
            rlines = [rlines, vertsWorld(1:2,[1:end,1]), nan2];
        elseif link.driver
            glines = [glines, vertsWorld(1:2,[1:end,1]), nan2];
        else
            blines = [blines, vertsWorld(1:2,[1:end,1]), nan2];
        end
    else
        angle = linspace(0, 2*pi, 360);
        x = vertsWorld(1,1) + link.radius * cos(angle);
        y = vertsWorld(2,1) + link.radius * sin(angle);
        if link.driver
            plot(x, y, 'g');
        else
            plot(x, y, 'b');
        end
    end
end
plot(rlines(1,:),rlines(2,:),'r');
plot(glines(1,:),glines(2,:),'g');
plot(blines(1,:),blines(2,:),'b');
% Draw pins
xas = [];
xbs = [];
xs = [];
ys = [];
for i = 1 : length(pins)
	pin = pins(i);
	linkA = links(pin.linkA);
	linkB = links(pin.linkB);
	Ra = rotationMatrix(linkA.angle);
	Rb = rotationMatrix(linkB.angle);
	xa = Ra * pin.pointA + linkA.pos;
	xb = Rb * pin.pointB + linkB.pos;
	xas = [xas, xa];
	xbs = [xbs, xb];
end
plot(xas(1,:),xas(2,:),'co','MarkerSize',10,'MarkerFaceColor','c');
plot(xbs(1,:),xbs(2,:),'mx','MarkerSize',10,'LineWidth',2);
% Draw sliders
if ~isempty(sliders)
	for i = 1 : length(sliders)
        slide = sliders(i);
        linkA = links(slide.linkA);
        linkB = links(slide.linkB);
        Ra = rotationMatrix(linkA.angle);
        Rb = rotationMatrix(linkB.angle);
        xa = Ra * slide.pointA + linkA.pos;
        xb1 = Rb * slide.pointB1 + linkB.pos;
        xb2 = Rb * slide.pointB2 + linkB.pos;
        xs = [xs, xb1(1)];
        xs = [xs, xb2(1)];
        ys = [ys, xb1(2)];
        ys = [ys, xb2(2)];
        plot(xa(1),xa(2),'co','MarkerSize',10,'MarkerFaceColor','c');
        plot([xb1(1), xb2(1)],[xb1(2), xb2(2)], 'Color', [0.9,0,0.9], 'LineWidth', 1.5);
    end
end
%draw gearpins
for i = 1 : length(gearpins)
    
end
% Draw particles
ps = [];
ps1 = [];
for i = 1 : length(particles)
	particle = particles(i);
	if ~isempty(particle.pointsWorld)
		ps = [ps, particle.pointsWorld];
		ps1 = [ps1, particle.pointsWorld(:,end)];
	end
	ps = [ps, nan2];
end
plot(ps(1,:),ps(2,:),'k');
plot(ps1(1,:),ps1(2,:),'ko');
% End draw
title(sprintf('t=%.3f',t));
if ~isempty(video)
	frame = getframe(gcf);
	video.writeVideo(frame);
end
drawnow;
end

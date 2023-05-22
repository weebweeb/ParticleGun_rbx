local recoiler = {};
local camera = game.Workspace.CurrentCamera;
local runServ = game:GetService("RunService");
local theta = 0;
local dtdt = 0;
local d2tdt2 = 0;
local phi = 0;
local dpdt = 0;
local d2pdt2 = 0;
local returnagg;
local recoil;
local thetaMax;
local dampConstant;
local t;
local tsl = .017;
local tl = 0;

local RSConnection;

function step()
	local dt = elapsedTime() - t;
	t = elapsedTime();
	
	local tto = tl + dt;
	local timeSteps = math.floor(tto/tsl);
	tl = tto - timeSteps * tsl;
	
	local dpTotal = 0;
	local dthTotal = 0;
	for i = 1, timeSteps do
		local oldA = d2pdt2;
		local oldV = dpdt;
		d2pdt2 = -returnagg*phi - dampConstant*dpdt;
		dpdt = dpdt + dt*((d2pdt2+oldA)/2);
		local dp = dt*((dpdt+oldV)/2);
		dpTotal = dpTotal + dp;
		phi = phi + dp;
		
		oldA = d2tdt2;
		oldV = dtdt;
		d2tdt2 = -returnagg*theta - dampConstant*dtdt;
		dtdt = dtdt + dt*((d2tdt2+oldA)/2);
		local dth = dt*((dtdt+oldV)/2);
		dthTotal = dthTotal + dth;
		theta = theta + dth;
	end
	script.Parent.CamRecoil.Value = Vector3.new(dpTotal, dthTotal, 0)
end

recoiler.init = function()
	t = elapsedTime();
	RSConnection = runServ.RenderStepped:connect(step);
end

recoiler.set = function(k, r, thMax)
	returnagg = k;
	recoil = r;
	thetaMax = thMax;
	dampConstant = 2*math.sqrt(k);
end

recoiler.fire = function()
	dpdt = recoil;
	dtdt = (math.random()*2-1)*thetaMax;
end

recoiler.deactivate = function()
	RSConnection:disconnect();
	
	phi = 0;
	dpdt = 0;
	d2pdt2 = 0;
	theta = 0;
	dtdt = 0;
	d2tdt2 = 0;
	
	tl = 0;
end

return recoiler;

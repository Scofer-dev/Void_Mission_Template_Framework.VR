class VMF_widescreen {
	idd = -1;
	movingEnable = 0;
    duration = 1e+11;
	fadeIn = 1;
	fadeOut = 0;
	onLoad = "uiNamespace setVariable ['VMF_widescreen',_this select 0];";
	
	class ControlsBackground {
		class topbar {
			type = 0;
			idc = -1;
			x = safeZoneX + safeZoneW * -0.00625;
			y = safeZoneY + safeZoneH * -0.02;
			w = safeZoneW * 1.0125;
			h = safeZoneH * 0.18333334;
			style = 0;
			text = "";
			colorBackground[] = {0,0,0,1};
			colorText[] = {0.5137,0.2549,0.851,1};
			font = "PuristaMedium";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
		};
		class bottombar	{
			type = 0;
			idc = -1;
			x = safeZoneX + safeZoneW * -0.00625;
			y = safeZoneY + safeZoneH * 0.83555556;
			w = safeZoneW * 1.0125;
			h = safeZoneH * 0.18333334;
			style = 0;
			text = "";
			colorBackground[] = {0,0,0,1};
			colorText[] = {1,1,1,1};
			font = "PuristaMedium";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);

		};
	};
	class Controls {
		class title {
			type = 0;
			idc = 16120251;
			x = safeZoneX + safeZoneW * 0.01875;
			y = safeZoneY + safeZoneH * 0.86;
			w = safeZoneW * 0.9625;
			h = safeZoneH * 0.11;
			style = 1;
			text = "";
			lineSpacing = 1;
			colorBackground[] = {0,0,0,0};
			colorText[] = {1,1,1,1};
			font = "PuristaMedium";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 8) * 1);	
		};
	};
};
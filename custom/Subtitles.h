class VMF_Subtitles {
	idd = -1;
	movingEnable = 0;
    duration = 1e+11;
	fadeIn = 1;
	fadeOut = 0;
	onLoad = "uiNamespace setVariable ['VMF_subtitles',_this select 0];";
	
	class ControlsBackground {
		class background	{
			type = 0;
			idc = -1;
			x = safeZoneX + safeZoneW * 0.23875;
			y = safeZoneY + safeZoneH * 0.00888889;
			w = safeZoneW * 0.5225;
			h = safeZoneH * 0.12444445;
			style = 0;
			text = "";
			colorBackground[] = {0.15,0.15,0.15,0.5};
			colorText[] = {0,0,0,0};
			font = "PuristaMedium";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
		};
		class separator {
			type = 0;
			idc = -1;
			x = safeZoneX + safeZoneW * 0.23875;
			y = safeZoneY + safeZoneH * 0.04111112;
			w = safeZoneW * 0.5225;
			h = safeZoneH * 0.00222223;
			style = 0;
			text = "";
			colorBackground[] = {1,1,1,0.5};
			colorText[] = {0,0,0,0};
			font = "PuristaMedium";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
		};
	};
	class Controls {
		class title {
			type = 0;
			idc = 1412241;
			x = safeZoneX + safeZoneW * 0.24375;
			y = safeZoneY + safeZoneH * 0.00888889;
			w = safeZoneW * 0.5125;
			h = safeZoneH * 0.02666667;
			style = 2;
			text = "";
			lineSpacing = 1;
			colorBackground[] = {0,0,0,0};
			colorText[] = {1,1,1,1};
			font = "PuristaMedium";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 20) * 1);
			shadow = 0;
			colorShadow[] = {0,0,0,0};
			tooltipColorText[] = {0,0,0,0};
			tooltipColorBox[] = {0,0,0,0};
			tooltipColorShade[] = {0,0,0,0};
		};
		class text {
			type = 0;
			idc = 1412242;
			x = safeZoneX + safeZoneW * 0.24375;
			y = safeZoneY + safeZoneH * 0.04777778;
			w = safeZoneW * 0.5125;
			h = safeZoneH * 0.08555556;
			style = 2+16+512;
			text = "";
			lineSpacing = 1;
			colorBackground[] = {0,0,0,0};
			colorText[] = {1,1,1,1};
			font = "PuristaMedium";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 20) * 1);
			shadow = 0;
			colorShadow[] = {0,0,0,0};
			tooltipColorText[] = {0,0,0,0};
			tooltipColorBox[] = {0,0,0,0};
			tooltipColorShade[] = {0,0,0,0};
		};
	};
};
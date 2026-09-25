import ctrlStatic;
import ctrlStructuredText;
import RscPicture;
import RscListBox;
import RscTree;
import RscButton;


class vmf_vehicleSpawner {
	idd = -1;
	onLoad = "uiNamespace setVariable ['VMF_spawnVehicle_display',_this select 0];";
	
	class ControlsBackground {
		class background: ctrlStatic {
			x = safeZoneX + safeZoneW * 0.24375;
			y = safeZoneY + safeZoneH * 0.12666667;
			w = safeZoneW * 0.5125;
			h = safeZoneH * 0.74555556;
			colorBackground[] = {0.4,0.4,0.4,1};
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
		};
		class title: ctrlStatic	{
			x = safeZoneX + safeZoneW * 0.24375;
			y = safeZoneY + safeZoneH * 0.12666667;
			w = safeZoneW * 0.5125;
			h = safeZoneH * 0.06111112;
			style = 2;
			text = "Spawn Vehicle";
			colorBackground[] = {0.302,0.302,0.302,1};
			colorText[] = {1,1,1,1};
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
		};
		class frame: ctrlStatic	{
			x = safeZoneX + safeZoneW * 0.24375;
			y = safeZoneY + safeZoneH * 0.12666667;
			w = safeZoneW * 0.5125;
			h = safeZoneH * 0.74555556;
			style = 64;
			colorText[] = {0,0,0,1};
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
		};
		class titleFrame: ctrlStatic {
			x = safeZoneX + safeZoneW * 0.24375;
			y = safeZoneY + safeZoneH * 0.12666667;
			w = safeZoneW * 0.5125;
			h = safeZoneH * 0.06111112;
			style = 64;
			colorText[] = {0,0,0,1};
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
		};
		class vehicleListTitle: ctrlStatic {
			x = safeZoneX + safeZoneW * 0.25875;
			y = safeZoneY + safeZoneH * 0.21111112;
			w = safeZoneW * 0.1225;
			h = safeZoneH * 0.03666667;
			style = 2;
			text = "Vehicles";
			colorBackground[] = {0.302,0.302,0.302,1};
			colorText[] = {1,1,1,1};
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
		};
		class vehicleListFrame: ctrlStatic {
			x = safeZoneX + safeZoneW * 0.25875;
			y = safeZoneY + safeZoneH * 0.21111112;
			w = safeZoneW * 0.1225;
			h = safeZoneH * 0.59777778;
			style = 64;
			colorText[] = {0,0,0,1};
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
		};
		class vehicleName: ctrlStructuredText {
			idc = 0709261;
			x = safeZoneX + safeZoneW * 0.38875;
			y = safeZoneY + safeZoneH * 0.21111112;
			w = safeZoneW * 0.168125;
			h = safeZoneH * 0.06777778;
			text = "VEHICLE NAME";
			colorBackground[] = {0,0,0,0};
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			onLoad = "uiNamespace setVariable ['VMF_spawnVehicle_vehicleName',_this select 0];";

			class Attributes {
				size = 2.5;
				color = "#ffffff";
				align = "center";
				valign = "middle";
			};
		};
		class vehicleImage: RscPicture {
			idc = 0709262;
			x = safeZoneX + safeZoneW * 0.5675;
			y = safeZoneY + safeZoneH * 0.21111112;
			w = safeZoneW * 0.17375;
			h = safeZoneH * 0.16777778;
			style = 48;
			text = "";
			colorText[] = {1,1,1,1};
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			onLoad = "uiNamespace setVariable ['VMF_spawnVehicle_vehicleImage',_this select 0];";
		};
		class vehicleImageFrame: ctrlStatic	{
			x = safeZoneX + safeZoneW * 0.5675;
			y = safeZoneY + safeZoneH * 0.21111112;
			w = safeZoneW * 0.17375;
			h = safeZoneH * 0.16777778;
			style = 64;
			colorText[] = {0,0,0,1};
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
		};
		class specBackground: ctrlStatic {
			x = safeZoneX + safeZoneW * 0.39375;
			y = safeZoneY + safeZoneH * 0.39;
			w = safeZoneW * 0.3475;
			h = safeZoneH * 0.41888889;
			colorBackground[] = {0.302,0.302,0.302,1};
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
		};
		class seatsTitle: ctrlStatic {
			x = safeZoneX + safeZoneW * 0.39375;
			y = safeZoneY + safeZoneH * 0.39;
			w = safeZoneW * 0.1725;
			h = safeZoneH * 0.02666667;
			style = 2;
			text = "Seats";
			colorBackground[] = {0.302,0.302,0.302,1};
			colorText[] = {1,1,1,1};
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
		};
		class aceTitle: ctrlStatic {
			x = safeZoneX + safeZoneW * 0.56875;
			y = safeZoneY + safeZoneH * 0.39;
			w = safeZoneW * 0.1725;
			h = safeZoneH * 0.02666667;
			style = 2;
			text = "ACE";
			colorBackground[] = {0.302,0.302,0.302,1};
			colorText[] = {1,1,1,1};
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
		};
		class cargoTitle: ctrlStatic {
			x = safeZoneX + safeZoneW * 0.39375;
			y = safeZoneY + safeZoneH * 0.57555556;
			w = safeZoneW * 0.3475;
			h = safeZoneH * 0.02666667;
			style = 2;
			text = "Cargo";
			colorBackground[] = {0.302,0.302,0.302,1};
			colorText[] = {1,1,1,1};
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
		};
		class specFrame: ctrlStatic {
			x = safeZoneX + safeZoneW * 0.39375;
			y = safeZoneY + safeZoneH * 0.39;
			w = safeZoneW * 0.3475;
			h = safeZoneH * 0.41888889;
			style = 64;
			colorText[] = {0,0,0,1};
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
		};
		class camoTitle: ctrlStatic {
			x = safeZoneX + safeZoneW * 0.39375;
			y = safeZoneY + safeZoneH * 0.27444445;
			w = safeZoneW * 0.1575;
			h = safeZoneH * 0.02666667;
			style = 2;
			text = "Camo Pattern";
			colorBackground[] = {0.302,0.302,0.302,1};
			colorText[] = {1,1,1,1};
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
		};
		class camoFrame: ctrlStatic {
			x = safeZoneX + safeZoneW * 0.39375;
			y = safeZoneY + safeZoneH * 0.27444445;
			w = safeZoneW * 0.1575;
			h = safeZoneH * 0.105;
			style = 64;
			colorText[] = {0,0,0,1};
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
		};
		class currentVehicle: ctrlStructuredText {
			x = safeZoneX + safeZoneW * 0.25375;
			y = safeZoneY + safeZoneH * 0.81888889;
			w = safeZoneW * 0.303125;
			h = safeZoneH * 0.03888889;
			text = "";
			colorBackground[] = {0,0,0,0};
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			onLoad = "uiNamespace setVariable ['VMF_spawnVehicle_currentVehicle',_this select 0];";

			class Attributes {
				size = 1.5;
				color = "#ffffff";
				align = "center";
				valign = "middle";
			};
		};
	};
	class Controls {
		class vehicleList: RscListBox {
			type = 5;
			idc = 0709263;
			x = safeZoneX + safeZoneW * 0.25875;
			y = safeZoneY + safeZoneH * 0.24555556;
			w = safeZoneW * 0.1225;
			h = safeZoneH * 0.56333334;
			colorBackground[] = {0.102,0.102,0.102,1};
			colorDisabled[] = {0.302,0.302,0.302,1};
			colorSelect[] = {1,0,0,1};
			colorText[] = {1,1,1,1};
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			onLoad = "uiNamespace setVariable ['VMF_spawnVehicle_vehicleList',_this select 0];";			
		};
		class camoList: RscListBox {
			type = 5;
			idc = 0709267;
			x = safeZoneX + safeZoneW * 0.39375;
			y = safeZoneY + safeZoneH * 0.29888889;
			w = safeZoneW * 0.1575;
			h = safeZoneH * 0.08;
			colorBackground[] = {0.102,0.102,0.102,1};
			colorDisabled[] = {0.302,0.302,0.302,1};
			colorSelect[] = {1,0,0,1};
			colorText[] = {1,1,1,1};
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			onLoad = "uiNamespace setVariable ['VMF_spawnVehicle_camoList',_this select 0];";
		};
		class specTreeLeft: RscTree {
			idc = 0709264;
			x = safeZoneX + safeZoneW * 0.39375;
			y = safeZoneY + safeZoneH * 0.41444445;
			w = safeZoneW * 0.1735;
			h = safeZoneH * 0.16;
			colorBackground[] = {0.102,0.102,0.102,1};
			colorDisabled[] = {0.2,0.2,0.2,1};
			colorSelection[] = {1,0,0,1};
			colorText[] = {1,1,1,1};
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			onLoad = "uiNamespace setVariable ['VMF_spawnVehicle_specTreeLeft',_this select 0];";
		};
		class specTreeRight: RscTree {
			idc = 0709265;
			x = safeZoneX + safeZoneW * 0.5675;
			y = safeZoneY + safeZoneH * 0.41444445;
			w = safeZoneW * 0.1735;
			h = safeZoneH * 0.16;
			colorBackground[] = {0.102,0.102,0.102,1};
			colorDisabled[] = {0.2,0.2,0.2,1};
			colorSelection[] = {1,0,0,1};
			colorText[] = {1,1,1,1};
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			onLoad = "uiNamespace setVariable ['VMF_spawnVehicle_specTreeRight',_this select 0];";
		};
		class inventoryList: RscListBox {
			idc = 0709266;
			x = safeZoneX + safeZoneW * 0.39375;
			y = safeZoneY + safeZoneH * 0.60555556;
			w = safeZoneW * 0.3475;
			h = safeZoneH * 0.20444445;
			colorBackground[] = {0.102,0.102,0.102,1};
			colorDisabled[] = {0.302,0.302,0.302,1};
			colorSelect[] = {1,0,0,1};
			colorText[] = {1,1,1,1};
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			onLoad = "uiNamespace setVariable ['VMF_spawnVehicle_inventoryList',_this select 0];";
		};
		
		class spawnButton: RscButton {
			idc = 0709268;
			x = safeZoneX + safeZoneW * 0.56875;
			y = safeZoneY + safeZoneH * 0.82111112;
			w = safeZoneW * 0.1625;
			h = safeZoneH * 0.03666667;
			style = 2;
			text = "Spawn Vehicle";
			colorBackground[] = {0.2,0.4,0.2,1};
			colorBackgroundActive[] = {1,0,0,1};
			colorBackgroundDisabled[] = {0.2,0.2,0.2,1};
			colorBorder[] = {0,0,0,0};
			colorDisabled[] = {0.2,0.2,0.2,1};
			colorFocused[] = {0.2,0.2,0.2,1};
			colorShadow[] = {0,0,0,1};
			colorText[] = {1,1,1,1};
			font = "PuristaMedium";
			offsetPressedX = 0.005;
			offsetPressedY = 0.005;
			offsetX = 0.005;
			offsetY = 0.005;
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			onLoad = "uiNamespace setVariable ['VMF_spawnVehicle_spawnButton',_this select 0];";
		};
		class closeButton: RscButton {
			idc = 0709269;
			x = safeZoneX + safeZoneW * 0.73625;
			y = safeZoneY + safeZoneH * 0.13111112;
			w = safeZoneW * 0.018125;
			h = safeZoneH * 0.03111112;
			style = 48;
			text = "a3\ui_f\data\gui\rsc\rscdisplayarcademap\icon_exit_cross_ca.paa";
			colorBackground[] = {0,0,0,0};
			colorText[] = {1,1,1,1};
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			onLoad = "uiNamespace setVariable ['VMF_spawnVehicle_closeButton',_this select 0];";
		};		
	};
};

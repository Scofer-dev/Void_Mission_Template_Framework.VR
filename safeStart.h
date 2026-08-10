class VMF_safeStart_enabled {
    idd = -1;
    fadeIn = 0;
    fadeOut = 0;
    duration = 1e+011;
    movingEnable = 0;

    class Controls {
        class background {
            type = 0;
            idc = -1;
            x = safeZoneX + safeZoneW * 0.015625;
            y = safeZoneY + safeZoneH * 0.95486112;
            w = safeZoneW * 0.11914063;
            h = safeZoneH * 0.03819445;
            style = 2;
            text = "Safe Start Active";
            colorBackground[] = {0.302,0.502,0.302,1};
            colorText[] = {0,0,0,1};
            font = "PuristaMedium";
            sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1.25);
        };
    };
};
class VMF_safeStart_disabled {
    idd = -1;
    fadeIn = 0;
    fadeOut = 3;
    duration = 3;
    movingEnable = 0;

    class Controls {
        class background {
            type = 0;
            idc = -1;
            x = safeZoneX + safeZoneW * 0.015625;
            y = safeZoneY + safeZoneH * 0.95486112;
            w = safeZoneW * 0.11914063;
            h = safeZoneH * 0.03819445;
            style = 2;
            text = "Safe Start Disabled";
            colorBackground[] = {0.8, 0.2, 0.2, 1};
            colorText[] = {0,0,0,1};
            font = "PuristaMedium";
            sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1.25);
        };
    };
};
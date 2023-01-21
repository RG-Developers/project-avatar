hud_variables = {}

hud_variables.HUDShouldHideElements = { 
					'CHudHealth', 
					'CHudBattery', 
					'CHudDamageIndicator' 
					 }
hud_variables.HUDPosition = {
					["XPos"] = ScrW() * 0.002 + 20,
					["YPos"] = ScrH() - ScrH() * 0.015 - 150,
					["FontScale"] = 1,
					["ScientistsScales"] = {
											["Doctype"] = 1,
											["Base"] = 1,
											["Tablet"] = 1,
											["NewTask"] = 1
										 },
					["TesterScales"] = {
										["Base"] = 1,
										["TabPerson"] = 1,
										["TabScore"] = 1,
										["AssaultBar"] = 1
									 },
					["FixerScales"] = {
										["Base"] = 1
									}
					}
hud_variables.FixerData = {
	["Rank"] = "Senior Leutenant",
	["FEID"] = math.random(10000, 99999)
}

return hud_variables
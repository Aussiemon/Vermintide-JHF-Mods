local mod = get_mod("HiDefUIScaling")

return {
	name = "Hi-Def UI Scaling",
	description = mod:localize("mod_description"),
	is_togglable = true,
	options = {
		widgets = {
			{
				setting_id    = "scale",
				type          = "dropdown",
				default_value = 400,
				options = {
					localize = false,
					{text = "133%", value = 133}, -- 1440p
					{text = "166%", value = 166},
					{text = "200%", value = 200}, -- 4k
					{text = "233%", value = 233},
					{text = "266%", value = 266}, -- 5k
					{text = "300%", value = 300},
					{text = "333%", value = 333},
					{text = "366%", value = 366},
					{text = "400%", value = 400}  -- 8k
				}
			}
		}
	}
}
local mod = get_mod("HiDefUIScaling")

return {
	name = "Hi-Def UI Scaling",
	description = mod:localize("scale_description"),
	is_togglable = true,
	options = {
		widgets = {
			{
				setting_id      = "scale_slider",
				type            = "numeric",
				default_value   = 4,
				range           = {0.50, 4.00},
				decimals_number = 2  
			}
		}
	}
}
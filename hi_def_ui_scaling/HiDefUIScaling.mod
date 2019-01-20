return {
	run = function()
		fassert(rawget(_G, "new_mod"), "HiDefUIScaling must be lower than Vermintide Mod Framework in your launcher's load order.")

		new_mod("HiDefUIScaling", {
			mod_script       = "scripts/mods/HiDefUIScaling/HiDefUIScaling",
			mod_data         = "scripts/mods/HiDefUIScaling/HiDefUIScaling_data",
			mod_localization = "scripts/mods/HiDefUIScaling/HiDefUIScaling_localization"
		})
	end,
	packages = {
		"resource_packages/HiDefUIScaling/HiDefUIScaling"
	}
}

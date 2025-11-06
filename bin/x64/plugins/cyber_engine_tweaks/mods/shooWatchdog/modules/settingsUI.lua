local config = require("modules/config")

UI = {}

function UI.subAdd(mod)
	nativeSettings.addSubcategory("/watchdog/global", "Global")
	nativeSettings.addSubcategory("/watchdog/photo", "Photo Mode")
	nativeSettings.addSubcategory("/watchdog/advanced", "Advanced")

	nativeSettings.addSwitch(
		"/watchdog/global",
		"KillProcess",
		"Whether to crash the game when Watchdog times out or not",
		mod.settings.global.KillProcess,
		mod.settingsDefault.global.KillProcess,
		function(state)
			mod.settings.global.KillProcess = state
			mod:applyOptions()
			config.saveFile("config.json", mod.settings)
		end
	)

	nativeSettings.addRangeInt(
		"/watchdog/global",
		"TimeoutSeconds",
		"How long it takes for Watchdog to time out in seconds",
		1,
		10800,
		5,
		mod.settings.global.TimeoutSeconds,
		mod.settingsDefault.global.TimeoutSeconds,
		function(value)
			mod.settings.global.TimeoutSeconds = value
			mod:applyOptions()
			config.saveFile("config.json", mod.settings)
		end
	)

	nativeSettings.addSwitch(
		"/watchdog/photo",
		"KillProcess",
		"Whether to crash the game when Watchdog times out or not",
		mod.settings.photo.KillProcess,
		mod.settingsDefault.photo.KillProcess,
		function(state)
			mod.settings.photo.KillProcess = state
			config.saveFile("config.json", mod.settings)
		end
	)

	nativeSettings.addRangeInt(
		"/watchdog/photo",
		"TimeoutSeconds",
		"How long it takes for Watchdog to time out in seconds",
		1,
		10800,
		5,
		mod.settings.photo.TimeoutSeconds,
		mod.settingsDefault.photo.TimeoutSeconds,
		function(value)
			mod.settings.photo.TimeoutSeconds = value
			config.saveFile("config.json", mod.settings)
		end
	)

	nativeSettings.addSwitch(
		"/watchdog/advanced",
		"ActiveIfDebuggerPresent",
		"",
		mod.settings.advanced.ActiveIfDebuggerPresent,
		mod.settingsDefault.advanced.ActiveIfDebuggerPresent,
		function(state)
			mod.settings.advanced.ActiveIfDebuggerPresent = state
			mod:applyOptions()
			config.saveFile("config.json", mod.settings)
		end
	)

	nativeSettings.addSwitch(
		"/watchdog/advanced",
		"ActiveIfDialogBlocking",
		"",
		mod.settings.advanced.ActiveIfDialogBlocking,
		mod.settingsDefault.advanced.ActiveIfDialogBlocking,
		function(state)
			mod.settings.advanced.ActiveIfDialogBlocking = state
			mod:applyOptions()
			config.saveFile("config.json", mod.settings)
		end
	)

	nativeSettings.addSwitch(
		"/watchdog/advanced",
		"ActiveIfScriptBreakpointBlocking",
		"",
		mod.settings.advanced.ActiveIfScriptBreakpointBlocking,
		mod.settingsDefault.advanced.ActiveIfScriptBreakpointBlocking,
		function(state)
			mod.settings.advanced.ActiveIfScriptBreakpointBlocking = state
			mod:applyOptions()
			config.saveFile("config.json", mod.settings)
		end
	)

	nativeSettings.addSwitch(
		"/watchdog/advanced",
		"DumpJobExecutionContext",
		"",
		mod.settings.advanced.DumpJobExecutionContext,
		mod.settingsDefault.advanced.DumpJobExecutionContext,
		function(state)
			mod.settings.advanced.DumpJobExecutionContext = state
			mod:applyOptions()
			config.saveFile("config.json", mod.settings)
		end
	)

	nativeSettings.addRangeInt(
		"/watchdog/advanced",
		"ThreadFrequencyHz",
		"",
		1,
		60,
		1,
		mod.settings.advanced.ThreadFrequencyHz,
		mod.settingsDefault.advanced.ThreadFrequencyHz,
		function(value)
			mod.settings.advanced.ThreadFrequencyHz = value
			mod:applyOptions()
			config.saveFile("config.json", mod.settings)
		end
	)
end

function UI.subDel()
	nativeSettings.removeSubcategory("/watchdog/global")
	nativeSettings.removeSubcategory("/watchdog/photo")
	nativeSettings.removeSubcategory("/watchdog/advanced")
end

function UI.main(mod)
	nativeSettings = GetMod("nativeSettings")
	if not nativeSettings then
		return
	end

	nativeSettings.addTab("/watchdog", "Watchdog")
	nativeSettings.addSwitch(
		"/watchdog",
		"Enabled",
		"Toggles Watchdog globally",
		mod.settings.enabled,
		mod.settingsDefault.enabled,
		function(state)
			mod.settings.enabled = state
			mod:applyOptions()
			config.saveFile("config.json", mod.settings)
			if not mod.settings.enabled then
				UI.subDel()
			else
				UI.subAdd(mod)
			end
		end
	)

	if mod.settings.enabled then
		UI.subAdd(mod)
	end
end

return UI

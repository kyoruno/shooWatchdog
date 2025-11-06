shoo = {
	settings = {},
	settingsDefault = {
		enabled = true,
		global = {
			KillProcess = true,
			TimeoutSeconds = 120,
		},
		photo = {
			KillProcess = false,
			TimeoutSeconds = 3600,
		},
		advanced = {
			ActiveIfDebuggerPresent = true,
			ActiveIfDialogBlocking = false,
			ActiveIfScriptBreakpointBlocking = false,
			DumpJobExecutionContext = true,
			ThreadFrequencyHz = 15,
		},
	},
	settingsUI = require("modules/settingsUI"),
}

function shoo:applyOptions()
	GameOptions.SetBool("Engine/Watchdog", "Enabled", self.settings.enabled)
	GameOptions.SetBool("Engine/Watchdog", "KillProcess", self.settings.global.KillProcess)
	GameOptions.SetInt("Engine/Watchdog", "TimeoutSeconds", self.settings.global.TimeoutSeconds)
	GameOptions.SetBool("Engine/Watchdog", "ActiveIfDebuggerPresent", self.settings.advanced.ActiveIfDebuggerPresent)
	GameOptions.SetBool("Engine/Watchdog", "ActiveIfDialogBlocking", self.settings.advanced.ActiveIfDialogBlocking)
	GameOptions.SetBool("Engine/Watchdog", "ActiveIfScriptBreakpointBlocking", self.settings.advanced.ActiveIfScriptBreakpointBlocking)
	GameOptions.SetBool("Engine/Watchdog", "DumpJobExecutionContext", self.settings.advanced.DumpJobExecutionContext)
	GameOptions.SetInt("Engine/Watchdog", "ThreadFrequencyHz", self.settings.advanced.ThreadFrequencyHz)
end

function shoo:applyPMOptions()
	GameOptions.SetBool("Engine/Watchdog", "KillProcess", self.settings.photo.KillProcess)
	GameOptions.SetInt("Engine/Watchdog", "TimeoutSeconds", self.settings.photo.TimeoutSeconds)
end

function shoo:new()
	registerForEvent("onInit", function()
		if not Config.fileExists("config.json") then
			Config.createConfig("config.json", self.settingsDefault)
		end

		self.settings = Config.loadFile("config.json")
		self:applyOptions()
		self.settingsUI.main(self)

		Observe("PhotoModePlayerEntityComponent", "OnGameAttach", function(self)
			shoo:applyPMOptions()
		end)

		Observe("PhotoModePlayerEntityComponent", "OnGameDetach", function(self)
			shoo:applyOptions()
		end)
	end)
	return self
end

return shoo:new()

local settingsUI = require("modules/settingsUI")
local config = require("modules/config")

Shoo = {
	settings = {},
	settingsDefault = {
		enabled = true,
		global = {
			KillProcess = true,
			TimeoutSeconds = 180,
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
	CONFIG_PATH = "config.json"
}

function Shoo:applyOptions()
	GameOptions.SetBool("Engine/Watchdog", "Enabled", self.settings.enabled)
	GameOptions.SetBool("Engine/Watchdog", "KillProcess", self.settings.global.KillProcess)
	GameOptions.SetInt("Engine/Watchdog", "TimeoutSeconds", self.settings.global.TimeoutSeconds)
	GameOptions.SetBool("Engine/Watchdog", "ActiveIfDebuggerPresent", self.settings.advanced.ActiveIfDebuggerPresent)
	GameOptions.SetBool("Engine/Watchdog", "ActiveIfDialogBlocking", self.settings.advanced.ActiveIfDialogBlocking)
	GameOptions.SetBool("Engine/Watchdog", "ActiveIfScriptBreakpointBlocking",
		self.settings.advanced.ActiveIfScriptBreakpointBlocking)
	GameOptions.SetBool("Engine/Watchdog", "DumpJobExecutionContext", self.settings.advanced.DumpJobExecutionContext)
	GameOptions.SetInt("Engine/Watchdog", "ThreadFrequencyHz", self.settings.advanced.ThreadFrequencyHz)
end

function Shoo:applyPMOptions()
	GameOptions.SetBool("Engine/Watchdog", "KillProcess", self.settings.photo.KillProcess)
	GameOptions.SetInt("Engine/Watchdog", "TimeoutSeconds", self.settings.photo.TimeoutSeconds)
end

function Shoo:init()
	registerForEvent("onInit", function()
		if not config.fileExists(self.CONFIG_PATH) then
			config.createConfig(self.CONFIG_PATH, self.settingsDefault)
		end

		self.settings = config.loadFile(self.CONFIG_PATH)
		self:applyOptions()
		settingsUI.main(self)

		Observe("PhotoModePlayerEntityComponent", "OnGameAttach", function()
			self:applyPMOptions()
		end)

		Observe("PhotoModePlayerEntityComponent", "OnGameDetach", function()
			self:applyOptions()
		end)
	end)
	return self
end

return Shoo:init()

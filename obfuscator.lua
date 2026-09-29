local Auth = require(game.ServerScriptService.CoreSettings)
-- [auth-gate]
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GameConfig = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("GameConfig"))
local IdentityResolver = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("IdentityResolver"))

local AdminPanelSystem = ReplicatedStorage:WaitForChild(GameConfig.Folders.AdminPanelSystem)
local CheckAccess = AdminPanelSystem:WaitForChild(GameConfig.Remotes.AdminPanel.CheckAccess)

local ADMIN_ROLES = {
	Owner = true,
	HeadAdmin = true,
	Developer = true,
	Admin = true,
	Moderator = true,
}

-- Semua tab yang ada di Admin Panel -- kalau punya role admin, kasih akses semua
local ALL_TABS = {
	Summit = true,
	Checkpoint = true,
	Besttime = true,
	Exclude = true,
	Race = true,
	Title = true,
	Announcement = true,
	AssignRoles = true,
	AdminList = true,
	GiftVIP = true,
}

CheckAccess.OnServerInvoke = function(player)
	local resolved = IdentityResolver.ResolveForPlayer(player, {
		AssignedRole = player:GetAttribute("AssignedRole")
	})

	local role = resolved and resolved.PrimaryRole

	if not (role and ADMIN_ROLES[role]) then
		return { Allowed = false, Tabs = {} }
	end

	return { Allowed = true, Tabs = ALL_TABS }
end

print("[AdminPanelAccessServer] Loaded.")

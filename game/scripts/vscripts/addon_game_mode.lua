-- Generated from template

if CAddonTemplateGameMode == nil then
	CAddonTemplateGameMode = class({})
end

require("gamesetup")
require("libraries.timers")

local numOfZombies = 0

function Precache( context )
	PrecacheResource( "model", "models/heroes/undying/undying_minion.vmdl", context )
	-- Manually precache a single resource
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = CAddonTemplateGameMode()
	GameRules.AddonTemplate:InitGameMode()
end

function CAddonTemplateGameMode:InitGameMode()
	print( "Template addon is loaded." )
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )
	GameSetup:init()
	ListenToGameEvent( "npc_spawned", Dynamic_Wrap(self, "OnUnitSpawned"), self )
	-- Register as a listener for a game event from script.
	local spawner = Entities:FindAllByName("zombie_spawner")
	Timers:CreateTimer(function ()
		if numOfZombies < 500 then
			CreateUnitByName("npc_dota_creature_zombie", spawner[1]:GetAbsOrigin() + RandomVector( 2500 ), true, nil, nil, DOTA_TEAM_BADGUYS )
		end
		return 10.0
	end)
end

function CAddonTemplateGameMode:OnUnitSpawned(args)
	local entH = EntIndexToHScript(args.entindex)
	if entH ~= nil then
		if entH:GetUnitLabel() == "zombie" then
			numOfZombies = numOfZombies + 1
		end
	end
	-- Turn an entity index integer to an HScript representing that entity's script instance.
end

-- Evaluate the state of the game
function CAddonTemplateGameMode:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print( "Template addon script is running." )
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end
--Services--
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--Modules--
local ReplicatedTweening = require(ReplicatedStorage.Modules.ReplicatedTweening)
local TweenModule = require(ReplicatedStorage.Modules.TweenModule)
	

--Private Functions--
local function weldDoor(door: Model)
	
	local hinge = door.PrimaryPart
	local parts: Folder = door.Parts
	
	for _, part: BasePart in parts:GetChildren() do

		if not part:IsA("BasePart") then return end
		if part == hinge then return end
		
		local weld: WeldConstraint = Instance.new("WeldConstraint")
		weld.Part0 = hinge
		weld.Part1 = part
		weld.Parent = hinge
		
	end
	
end

local function getProperties(door: Model)
	
	local hinge = door.PrimaryPart
	local currentRotation = hinge.Rotation.Y
	
	return {
		OpenAngle = currentRotation + door:GetAttribute("OpenAngle") or currentRotation + 90,
		ClosedAngle = currentRotation + door:GetAttribute("ClosedAngle") or currentRotation,
		TweenDuration = door:GetAttribute("TweenDuration")
	}
	
end

local DoorModule = {}
DoorModule.__index = DoorModule


--Public Functions
function DoorModule.new(door: Model)
	local self = setmetatable({}, DoorModule)
  
	self.Door = door
	self.Hinge = door.PrimaryPart
	self.State = false
	self.Properties = getProperties(door)

	weldDoor(self.Door)
	return self
end


function DoorModule:Open()
	
	local TweenDuration = self.Properties.TweenDuration
	local OpenAngle: CFrame = self.Properties.OpenAngle

	self.State = true
	ReplicatedTweening.SineInOut(TweenDuration, {Rotation = Vector3.new(0, OpenAngle, 0)}, self.Hinge):Play()
end


function DoorModule:Close()
	
	local TweenDuration = self.Properties.TweenDuration
	local ClosedAngle: CFrame = self.Properties.ClosedAngle

	self.State = false
	ReplicatedTweening.SineInOut(TweenDuration, {Rotation = Vector3.new(0, ClosedAngle, 0)}, self.Hinge):Play()
end


return DoorModule

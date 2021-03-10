ESX = nil
local showskel = false
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
-- kur za esx

end)


RegisterCommand("skeletal", function(source, args, raw)
  SendNUIMessage({
		action = 'showhide'
  })
end)


RegisterCommand("skelly", function(source, args, raw)
	  local player, distance = ESX.Game.GetClosestPlayer()
	  if distance ~= -1 and distance <= 3.0 then
		  TriggerServerEvent('skeletal:checkplayer', GetPlayerServerId(PlayerId()), GetPlayerServerId(player))
	  else
		  exports['mythic_notify']:DoCustomHudText('error', "Няма пациент наблизо")
	  end
end)

local RandomVehicleInteraction_leg = {
	{interaction = 27, time = 2500},
	{interaction = 6, time = 1000},
  {interaction = 30, time = 2350},
	{interaction = 32, time = 3500},
	{interaction = 31, time = 2300} 
}


local RandomVehicleInteraction_hands = {
	{interaction = 7, time = 2000},
	{interaction = 8, time = 2000},
	{interaction = 20, time = 2000}, 
	{interaction = 21, time = 2000}
}

local head = 100
local left_shoulder = 100
local right_shoulder = 100
local left_arm = 100
local right_arm = 100
local left_hand = 100 
local right_hand = 100 
local chest = 100
local stomach = 100
local left_leg = 100
local right_leg = 100

parts = {

  --- head
  ['Head1'] = 31086,
  ['Head2'] = 20178, 
  ['Head3'] = 47495, 
  ['Head4'] = 17188, 
  ['Head5'] = 39317,

  --- shouders
  ['Lshouder'] = 10706,
  ['Rshouder'] = 64729,

  --- hands
  ['Lhand1'] = 57005,
  ['Rhand1'] = 18905,
  ['Lhand2'] = 28252,
  ['Rhand2'] = 61163,
  ['Lhand3'] = 40269, 
  ['Rhand3'] = 45509,

  --- wrist
  ['Lwrist'] = 28422,
  ['Rwrist'] = 60309,

  --- chest
  ['Chest1'] = 24816, 
  ['Chest2'] = 24817, 
  ['Chest3'] = 24818, 

  --- stomach
  ['Stomach1'] = 57597,
  ['Stomach2'] = 11816,

  --- legs
  ['Lleg1'] = 52301,
  ['Rleg1'] = 14201,
  ['Lleg2'] = 36864,
  ['Rleg2'] = 63931,
  ['Lleg3'] = 51826,
  ['Rleg3'] = 58271,
  

}



local HeadInjury = false
local DamagedBody = false
local InjuredLegs = false
local Healing = false

Citizen.CreateThread(function()
  Citizen.Wait(1000)
  local plyHealth = GetEntityHealth(GetPlayerPed(-1))
  print(plyHealth)
  SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
 local isNotified = false
  while true do
    Citizen.Wait(69)
    local plyPed = GetPlayerPed(-1)
	
	if GetEntityMaxHealth(GetPlayerPed(-1)) ~= 200 then
		SetEntityHealth(GetPlayerPed(-1), 200)
        SetEntityMaxHealth(GetPlayerPed(-1), 200)
    end
	
    local prevHealth = GetEntityHealth(plyPed)

    if prevHealth < plyHealth then 
      local damage = plyHealth - prevHealth
      plyHealth = prevHealth 
      Healing = true
      if DamagedBody then  
        
        exports['mythic_notify']:DoHudText('error', 'Ранен си!',10000)
      else  

		if not isNotified then
			exports['mythic_notify']:DoHudText('error', 'Ранен си!',10000)
			isNotified = true
		end
      end

      local bone = CheckBone()
      if IsPedSwimmingUnderWater(plyPed) then
        DamageBone('Stomach1', damage/4)
      else
        DamageBone(bone, damage)
      end
    elseif prevHealth > plyHealth then 
      if prevHealth == 200 and Healing then
        Healing = false
        Citizen.Wait(555) 
        FullHeal()
      end
      local healdmg = prevHealth - plyHealth
      HealBones(healdmg)
      Citizen.Wait(55) 
      plyHealth = prevHealth
	  isNotified = false
    end   
  end
end)

Citizen.CreateThread(function()
  RequestAnimSet("move_m@injured")
  local tick = 0
  while true do
    Citizen.Wait(0)
    tick = tick + 1
    local plyPed = GetPlayerPed(-1)
    local plyId = PlayerId()

    if head < 85 then
      SetTimecycleModifier('BlackOut') 
      SetTimecycleModifierStrength(0.9 - (head / 100))
      HeadInjury = true
    else
      if HeadInjury then 
        ClearTimecycleModifier() 
        HeadInjury = false 
      end
    end

    if chest < 80 then
      if tick % (round(chest) * 60) == 1 then
        local plyHealth = GetEntityHealth(plyPed)
        SetPlayerHealthRechargeMultiplier(plyId, 0.0)
        if plyHealth > 0 then 
          local dmg = math.random(2, 4)
          ApplyDamageToPed(plyPed, dmg, false)
          
        end
        DamagedBody = true
      end
    elseif DamagedBody then
      SetPlayerHealthRechargeMultiplier(plyId, 0.0)
      DamagedBody = false
    end



    if left_arm < 80 or right_arm < 80 then
      if IsPedShooting(plyPed) then 
        if right_arm < left_arm then   
          ShakeGameplayCam('LARGE_EXPLOSION_SHAKE', (0.25 - (right_arm / 400)))
        else 
          ShakeGameplayCam('LARGE_EXPLOSION_SHAKE', (0.25 - (left_arm / 400)))
        end
      end

      if IsPedInAnyVehicle(plyPed, false) then
        local vehicle = GetVehiclePedIsIn(plyPed, false)
              if GetPedInVehicleSeat(vehicle, -1) == plyPed then
                if right_arm < left_arm then 
                  if tick % (round(right_arm) * 12) == 1 then
                  local whatToFuckThemWith = fuckDriverHands()
                  TaskVehicleTempAction(plyPed, vehicle, whatToFuckThemWith.interaction, (whatToFuckThemWith.time * (1.00 - (right_arm/100))))
                  Citizen.Wait(whatToFuckThemWith.time * (1.00 - (right_arm/100)) + 111)
                  ClearPedTasks(plyPed)
                  end
                else
                  if tick % (round(left_arm) * 12) == 1 then
                  local whatToFuckThemWith = fuckDriverHands()
                  TaskVehicleTempAction(plyPed, vehicle, whatToFuckThemWith.interaction, (whatToFuckThemWith.time * (1.00 - (left_arm/100))))
                  Citizen.Wait(whatToFuckThemWith.time * (1.00 - (left_arm/100)) + 111)
                  ClearPedTasks(plyPed)
                  end
                end 
              end
      end
    end

    if left_leg < 75 or right_leg < 75 then
      local LegDamaged = 100
      if left_leg < right_leg then 
        LegDamaged = left_leg
      else
        LegDamaged = right_leg
      end

      if tick % (round(LegDamaged) * 12) == 1 then
        if math.random(1,6) == 3 then
          if not IsPedInAnyVehicle(plyPed, false) then
          DisablePlayerFiring(plyPed, true)
          SetPedToRagdoll(plyPed, 1000, 1000, 0, 0, 0, 0)
          SetPlayerInvincible(plyPed, false)
          ResetPedRagdollTimer(plyPed)
          else
            local vehicle = GetVehiclePedIsIn(plyPed, false)
              if GetPedInVehicleSeat(vehicle, -1) == plyPed then
                local whatToFuckThemWith = fuckDriverLegs()
                TaskVehicleTempAction(plyPed, vehicle, whatToFuckThemWith.interaction, (whatToFuckThemWith.time * (1.00 - (LegDamaged/100))))
                Citizen.Wait(whatToFuckThemWith.time * (1.00 - (left_arm/100)) + 111)
                ClearPedTasks(plyPed)
              end
          end
        end
      end
      if IsPedJumping(plyPed) and tick % (round(LegDamaged) * 8) == 1 then
        Wait(444)
        SetPedToRagdoll(plyPed, 1000, 1000, 0, 0, 0, 0)
        SetPlayerInvincible(plyPed, false)
        ResetPedRagdollTimer(plyPed)
      end

      InjuredLegs = true
      SetPedMoveRateOverride(plyPed, 0.7)
      SetPedMovementClipset(plyPed, "move_m@injured", true)
    elseif InjuredLegs then
      ResetPedMovementClipset(GetPlayerPed(-1))
      ResetPedWeaponMovementClipset(GetPlayerPed(-1))
      ResetPedStrafeClipset(GetPlayerPed(-1))
      SetPedMoveRateOverride(plyPed, 1.0)
      InjuredLegs = false
    end
 
end
end)

function fuckDriverLegs()

	math.randomseed(GetGameTimer())
	
	local shitFuckDamn = math.random(1, #RandomVehicleInteraction_leg)
	return RandomVehicleInteraction_leg[shitFuckDamn]
end


function fuckDriverHands()

	math.randomseed(GetGameTimer())
	
	local shitFuckDamn = math.random(1, #RandomVehicleInteraction_hands)
	return RandomVehicleInteraction_hands[shitFuckDamn]
end

function DamageBone(bone, damage)
  damage = damage*1.1
  if bone == 'Head1' or bone == 'Head2' or bone == 'Head3' or bone == 'Head4' or bone == 'Head5' then
    head = head - damage
    NUIdamage('head', head)
  elseif bone == 'Lshouder' then 
    left_shoulder = left_shoulder - damage
    NUIdamage('left-shoulder', left_shoulder)
  elseif bone == 'Rshouder' then 
    right_shoulder = right_shoulder - damage
    NUIdamage('right-shoulder', right_shoulder)
  elseif bone == 'Rhand1' or bone == 'Rhand2' or bone == 'Rhand3' then 
    right_arm = right_arm - damage
    NUIdamage('right-arm', right_arm)
  elseif bone == 'Lhand1' or bone == 'Lhand2' or bone == 'Lhand3' then 
    left_arm = left_arm - damage
    NUIdamage('left-arm', left_arm)
  elseif bone == 'Rwrist' then 
    right_hand = right_hand - damage
    NUIdamage('right-hand', right_hand)
  elseif bone == 'Lwrist' then 
    left_hand = left_hand - damage
    NUIdamage('left-hand', left_hand)
  elseif bone == 'Chest1' or bone == 'Chest2' or bone == 'Chest3' then 
    chest = chest - damage
    NUIdamage('chest', chest)
  elseif bone == 'Stomach1' or bone == 'Stomach2' then 
    stomach = stomach - damage
    NUIdamage('stomach', stomach)
  elseif bone == 'Lleg1' or bone == 'Lleg2' or bone == 'Lleg3' then 
    left_leg = left_leg - damage
    NUIdamage('left-leg', left_leg)
    NUIdamage('left-foot', left_leg)
  elseif bone == 'Rleg1' or bone == 'Rleg2' or bone == 'Rleg3' then 
    right_leg = right_leg - damage
    NUIdamage('right-leg', right_leg)
    NUIdamage('right-foot', right_leg)
  else
    damage = damage/2
    head = head - damage
    NUIdamage('head', head)
    left_shoulder = left_shoulder - damage
    NUIdamage('left-shoulder', left_shoulder)
    right_shoulder = right_shoulder - damage
    NUIdamage('right-shoulder', right_shoulder)
    right_arm = right_arm - damage
    NUIdamage('right-arm', right_arm)
    left_arm = left_arm - damage
    NUIdamage('left-arm', left_arm)
    right_hand = right_hand - damage
    NUIdamage('right-hand', right_hand)
    left_hand = left_hand - damage
    NUIdamage('left-hand', left_hand)
    chest = chest - damage
    NUIdamage('chest', chest)
    stomach = stomach - damage
    NUIdamage('stomach', stomach)
    left_leg = left_leg - damage
    NUIdamage('left-leg', left_leg)
    NUIdamage('left-foot', left_leg)
    right_leg = right_leg - damage
    NUIdamage('right-leg', right_leg)
    NUIdamage('right-foot', right_leg)
    Citizen.Wait(222) 
  end
end



function NUIdamage(bone, bonehealth)
  showskel = true
  SendNUIMessage({
		action = 'updatePlayerBones',
    bone   =  bone,
    bonehealth = bonehealth
  })
end

function HealBones(health)
if DamagedBody then
  chest = chest + health
  if chest > 100 then chest = 100 end
  NUIdamage('chest', chest)
end
if HeadInjury then
  head = head + health
  if head > 100 then head = 100 end
  NUIdamage('head', head)
end
 if InjuredLegs then
  left_leg = left_leg + health
  right_leg = right_leg + health
  if left_leg > 100 then left_leg = 100 end
  if right_leg > 100 then right_leg = 100 end
  NUIdamage('left-leg', left_leg)
  NUIdamage('right-leg', right_leg)
  NUIdamage('left-foot', left_leg)
  NUIdamage('right-foot', right_leg)
end
end

function FullHeal()
  SendNUIMessage({action = 'fullhealth'})
  head = 100
  left_shoulder = 100
  right_shoulder = 100
  left_arm = 100
  right_arm = 100
  left_hand = 100 
  right_hand = 100 
  chest = 100
  stomach = 100
  left_leg = 100
  right_leg = 100
end

function CheckBone()
  local FoundLastDamagedBone, LastDamagedBone = GetPedLastDamageBone(GetPlayerPed(-1))
  --print(LastDamagedBone) 
  if FoundLastDamagedBone then
      local DamagedBone = GetKeyOfValue(parts, LastDamagedBone)
      if DamagedBone then
          return DamagedBone
      else
          print('Error: Missing ID:' .. LastDamagedBone)
          return LastDamagedBone
      end
  end
end


function GetKeyOfValue(Table, SearchedFor)
  for Key, Value in pairs(Table) do
      if SearchedFor == Value then
          return Key
      end
  end
  return nil
end

function round(number)
  if (number - (number % 0.1)) - (number - (number % 1)) < 0.5 then
    number = number - (number % 1)
  else
    number = (number - (number % 1)) + 1
  end
 return number
end

RegisterNetEvent('skeletal:getstatus')
AddEventHandler('skeletal:getstatus', function(player1)
  Wait(55)
  TriggerServerEvent('skeletal:sendstatus', player1,head,left_shoulder,right_shoulder,left_arm,right_arm,left_hand,right_hand,chest,stomach,left_leg,right_leg)
end)

RegisterNetEvent('skeletal:showstatus')
AddEventHandler('skeletal:showstatus', function(head,left_shoulder,right_shoulder,left_arm,right_arm,left_hand,right_hand,chest,stomach,left_leg,right_leg)
  if head < 40 then
    TriggerEvent('chatMessage', "* Тежки наранявания по главата *", {255,0,0})
  elseif head < 62 then
    TriggerEvent('chatMessage', "* Средни наранявания по главата *", {255,128,0})
  elseif head < 88 then
    TriggerEvent('chatMessage', "* Леки наранявания по главата *", {255,255,0})
  end

if left_arm < 30 then
  TriggerEvent('chatMessage', "* Тежки наранявания по лявото рамо *", {255,0,0})
elseif left_arm < 52 then
  TriggerEvent('chatMessage', "* Средни наранявания по лявото рамо *", {255,128,0})
elseif left_arm < 88 then
  TriggerEvent('chatMessage', "* Леки наранявания по лявото рамо *", {255,255,0})
end

if right_arm < 30 then
  TriggerEvent('chatMessage', "* Тежки наранявания по дясното рамо *", {255,0,0})
elseif right_arm < 52 then
  TriggerEvent('chatMessage', "* Средни наранявания по дясното рамо *", {255,128,0})
elseif right_arm < 88 then
  TriggerEvent('chatMessage', "* Леки наранявания по дясното рамо *", {255,255,0})
end

if chest < 30 then
  TriggerEvent('chatMessage', "* Тежки наранявания по гърдите *", {255,0,0})
elseif chest < 52 then
  TriggerEvent('chatMessage', "* Средни наранявания по гърдите*", {255,128,0})
elseif chest < 88 then
  TriggerEvent('chatMessage', "* Леки наранявания по гърдите *", {255,255,0})
end

if stomach < 30 then
  TriggerEvent('chatMessage', "* Тежки наранявания по корема *", {255,0,0})
elseif stomach < 52 then
  TriggerEvent('chatMessage', "* Средни наранявания по корема *", {255,128,0})
elseif stomach < 88 then
  TriggerEvent('chatMessage', "* Леки наранявания по корема *", {255,255,0})
end
 
if left_leg < 30 then
  TriggerEvent('chatMessage', "* Тежки наранявания по левия крак *", {255,0,0})
elseif left_leg < 62 then
  TriggerEvent('chatMessage', "* Средни наранявания по левия крак *", {255,128,0})
elseif left_leg < 88 then
  TriggerEvent('chatMessage', "* Леки наранявания по левия крак *", {255,255,0})
end

if right_leg < 30 then
  TriggerEvent('chatMessage', "* Тежки наранявания по десния крак *", {255,0,0})
elseif right_leg < 62 then
  TriggerEvent('chatMessage', "* Средни наранявания по десния крак  *", {255,128,0})
elseif right_leg < 88 then
  TriggerEvent('chatMessage', "* Леки наранявания по десния крак  *", {255,255,0})
end
end)

AddEventHandler('playerSpawned', function()
  Citizen.Wait(0) 
  FullHeal()
end)

function showUI()
  SendNUIMessage({
		action = 'showUI'
  })
end
function hideUI()
  SendNUIMessage({
		action = 'hideUI'
  })
end


Citizen.CreateThread(function()
    Citizen.Wait(1111)
      while true do
        if showskel then
            showskel = false
            showUI()
            Citizen.Wait(7500)
              hideUI()
        end
      Citizen.Wait(10)
      end
end)

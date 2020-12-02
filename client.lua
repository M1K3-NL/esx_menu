local Keys = {
  ['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
  ['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
  ['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
  ['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
  ['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
  ['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
  ['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,
  ['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
  ['NENTER'] = 201, ['N4'] = 108, ['N5'] = 60, ['N6'] = 107, ['N+'] = 96, ['N-'] = 97, ['N7'] = 117, ['N8'] = 61, ['N9'] = 118
}

ESX             				 = nil
engine                   = true

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
    Citizen.Wait(1000)
  while ESX.GetPlayerData().job == nil do
    Citizen.Wait(1000)
  end

  ESX.PlayerData = ESX.GetPlayerData()
      Citizen.Wait(1000)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  ESX.PlayerData.job = job
end) 

function OpenExtrasMenu()
      local ped = PlayerPedId()
      local vehicle = GetVehiclePedIsIn(ped)
      local elements = {}
      for extras = 0, 15 do
        if DoesExtraExist(vehicle, extras) then
          if IsVehicleExtraTurnedOn(vehicle, extras) then
            table.insert(elements, {label = 'Extra #'..extras.." ✔️", value = extras})
          elseif not IsVehicleExtraTurnedOn(vehicle, extras) then
            table.insert(elements, {label = 'Extra #'..extras.." ❌", value = extras})
          end
        end
     end

    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'extras_menu',
      {
        
        title    = _U('extras'),
        align    = Config.Align,
        elements = elements
      },
      function(data, menu)
        
        for extras = 0, 15 do
          if data.current.value == extras then
            if IsVehicleExtraTurnedOn(vehicle, extras) then
              SetVehicleExtra(vehicle, extras, 1)
              ESX.UI.Menu.CloseAll()
              SetVehicleFixed(vehicle)
              OpenExtrasMenu()
            elseif not IsVehicleExtraTurnedOn(vehicle, extras) then
              SetVehicleExtra(vehicle, extras, 0)
              ESX.UI.Menu.CloseAll()
              SetVehicleFixed(vehicle)
              OpenExtrasMenu()
            end
          end
        end
      end,
      function(data, menu)
        menu.close()
        OpenCarMenu()
      end)    
end

function OpenLiveriesMenu()
      local ped = PlayerPedId()
      local vehicle = GetVehiclePedIsIn(ped)
      local elements = {}
      local liveriesCount = GetVehicleLiveryCount(vehicle)
      local currentMods = ESX.Game.GetVehicleProperties(vehicle)
      for livery = 1, liveriesCount do
          if livery == GetVehicleLivery(vehicle) then
            table.insert(elements, {label = 'Livery #'..livery.." ✔️", value = livery})
          else
            table.insert(elements, {label = 'Livery #'..livery.." ❌", value = livery})
          end
     end

    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'extras_menu',
      {
        
        title    = _U('liveries'),
        align    = Config.Align,
        elements = elements
      },
      function(data, menu)
        
        for livery = 1, liveriesCount do
          if data.current.value == livery then
            if GetVehicleLivery(vehicle) == livery then
              SetVehicleLivery(vehicle, 1)
              ESX.UI.Menu.CloseAll()
              SetVehicleFixed(vehicle)
              OpenLiveriesMenu()
            elseif livery ~= GetVehicleLivery(vehicle) then
              SetVehicleLivery(vehicle, livery)
              ESX.UI.Menu.CloseAll()
              SetVehicleFixed(vehicle)
              OpenLiveriesMenu()
            end
          end
        end
      end,
      function(data, menu)
        menu.close()
        OpenCarMenu()
      end)
end

function OpenCarMenu()
  ESX.UI.Menu.CloseAll()

  local closestVehicle, closestDistance = ESX.Game.GetClosestVehicle()
  local player = GetPlayerPed(PlayerId())
  local vehicle = GetVehiclePedIsIn(player,false)
  local engine_status = GetIsVehicleEngineRunning(vehicle)

  local elements = {}

  if IsPedInAnyVehicle(player, 0) and (GetPedInVehicleSeat(GetVehiclePedIsIn(player, 0), -1) == player) then
    if GetVehicleBodyHealth(GetVehiclePedIsIn(GetPlayerPed(-1), 0), -1) >= 1000 then
      table.insert(elements, {label = '⚙️'.._U('extras'), value = 'extras'})
    else
      table.insert(elements, {label = '<span style="color: '..Config.RedColor..';">❗️'.._U('not_available_extras')..'❗️</span>',      value = 'error'})
    end
  else
    table.insert(elements, {label = '<span style="color: '..Config.RedColor..';">❗️'.._U('not_available_extras')..'❗️</span>',      value = 'error'})
  end

  if IsPedInAnyVehicle(player, 0) and (GetPedInVehicleSeat(GetVehiclePedIsIn(player, 0), -1) == player) then
    if GetVehicleBodyHealth(GetVehiclePedIsIn(GetPlayerPed(-1), 0), -1) >= 1000 then
      table.insert(elements, {label = '⚙️'.._U('liveries'), value = 'liveries'})
    else
      table.insert(elements, {label = '<span style="color: '..Config.RedColor..';">❗️'.._U('not_available_liveries')..'❗️</span>',      value = 'error'})
    end
  else
    table.insert(elements, {label = '<span style="color: '..Config.RedColor..';">❗️'.._U('not_available_liveries')..'❗️</span>',      value = 'error'})
  end

  if not IsPedInAnyVehicle(player, 0) and closestVehicle ~= -1 and closestDistance <= 3.0 then
  table.insert(elements, {label = '🚘'.._U('hood'),      value = 'hood'})
  table.insert(elements, {label = '⚙️'.._U('trunk'),      value = 'trunk'})
  end
  if IsPedInAnyVehicle(player, 0) then
      table.insert(elements, {label = '🚪'.._U('doors'),      value = 'all_doors'})
      table.insert(elements, {label = '🚪'.._U('front_doors'),      value = 'front'})
      table.insert(elements, {label = '🚪'.._U('rear_doors'),      value = 'rear'})
      if (GetPedInVehicleSeat(GetVehiclePedIsIn(player, 0), -1) == player) then
        table.insert(elements, {label = '⚙️'.._U('engine'),      value = 'engine'})
      end
  end

 ESX.UI.Menu.Open(
  'default', GetCurrentResourceName(), 'car_menu',
  {
    title    = _U('car_title'),
    align    = Config.Align,
    elements = elements
  },
  function(data, menu)

    if data.current.value == 'error' then
      ESX.ShowNotification(_U('not_available_car'))
    end

    if data.current.value == 'extras' then
        OpenExtrasMenu()
    end

    if data.current.value == 'liveries' then
        OpenLiveriesMenu()
    end

    if data.current.value == 'hood' then		
      if GetVehicleDoorAngleRatio(closestVehicle, 4) > 0.0 then 
            SetVehicleDoorShut(closestVehicle, 4, false)
        else
            SetVehicleDoorOpen(closestVehicle, 4, false)      
       end
    end

    if data.current.value == 'trunk' then
      if GetVehicleDoorAngleRatio(closestVehicle, 5) > 0.0 then 
            SetVehicleDoorShut(closestVehicle, 5, false)
        else
            SetVehicleDoorOpen(closestVehicle, 5, false)      
       end
    end

   if data.current.value == 'all_doors' then
    if GetVehicleDoorAngleRatio(vehicle, 1) > 0.0 then 
        SetVehicleDoorShut(vehicle, 3, false)
        SetVehicleDoorShut(vehicle, 2, false)
        SetVehicleDoorShut(vehicle, 1, false)
        SetVehicleDoorShut(vehicle, 0, false)         
      else
        SetVehicleDoorOpen(vehicle, 3, false)
        SetVehicleDoorOpen(vehicle, 2, false)
        SetVehicleDoorOpen(vehicle, 1, false)
        SetVehicleDoorOpen(vehicle, 0, false)  
     end
    end

  if data.current.value == 'front' then
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'rear_doors', 
      {
        title = _U('front_doors'),
        align = Config.Align,
        elements = {
          {label = '⚙️'.._U('front_left_door'), value = 'left'},
          {label = '⚙️'.._U('front_right_door'), value = 'right'}
        }
      },
      function(data, menu)
        if data.current.value == 'left' then
          if GetVehicleDoorAngleRatio(vehicle, 0) > 0.0 then 
                 SetVehicleDoorShut(vehicle, 0, false)
              else
                SetVehicleDoorOpen(vehicle, 0, false)
            end
        else
          if GetVehicleDoorAngleRatio(vehicle, 1) > 0.0 then 
                 SetVehicleDoorShut(vehicle, 1, false)
              else
                SetVehicleDoorOpen(vehicle, 1, false)
            end
        end
      end,
      function(data, menu)
        menu.close()
        
        OpenCarMenu()
      end)
  end

  if data.current.value == 'rear' then
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'rear_doors', 
      {
        title = _U('rear_doors'),
        align = Config.Align,
        elements = {
          {label = '⚙️'.._U('rear_left_door'), value = 'left'},
          {label = '⚙️'.._U('rear_right_door'), value = 'right'}
        }
      },
      function(data, menu)
        if data.current.value == 'left' then
          if GetVehicleDoorAngleRatio(vehicle, 2) > 0.0 then 
                 SetVehicleDoorShut(vehicle, 2, false)
              else
                SetVehicleDoorOpen(vehicle, 2, false)
            end
        else
          if GetVehicleDoorAngleRatio(vehicle, 3) > 0.0 then 
                 SetVehicleDoorShut(vehicle, 3, false)
              else
                SetVehicleDoorOpen(vehicle, 3, false)
            end
        end
      end,
      function(data, menu)
        menu.close()
        
        OpenCarMenu()
      end)
    end

    if data.current.value == 'engine' then
      if engine == true then
        SetVehicleEngineOn(vehicle, false, false, false)
        engine = false
      elseif engine == false then
        SetVehicleEngineOn(vehicle, true, false, false)
        engine = true
      end
      while engine == false do
        Citizen.Wait(0)
        SetVehicleUndriveable(vehicle, true)
      end
    end

  end,
  function(data, menu)
    menu.close()
    OpenPlayerMenu()
  end)
end

function OpenInformationMenu()

      ESX.UI.Menu.CloseAll()

      ESX.TriggerServerCallback('esx_menu:getInfo', function(info)  
    

    firstname = info.firstname
    lastname  = info.lastname
    birth     = info.dateofbirth
    height    = info.height
    if info.sex == 'm' or info.sex == 'M' then -- Uppercase M is used in jsfour-register
      sex = _U('male')
    else
      sex = _U('female')
    end
    phone     = info.phone
    money     = info.money
    bank      = info.bank
    society   = info.society


    local elements = {}
  
    table.insert(elements, {label = ('📇'.._U('identity_name')..' ' ..firstname.. ' '..lastname)})
    table.insert(elements, {label = ('📅'.._U('birth')..' '..birth)})
    table.insert(elements, {label = ('🚻'.._U('gender')..' '..sex)})
    table.insert(elements, {label = ('📞'.._U('phone')..' '..phone)})
    table.insert(elements, {label = ('💵'.._U('wallet')..' '..money..'$')})
    table.insert(elements, {label = ('💳'.._U('bank')..' '..bank..'$')})
    if ESX.PlayerData.job.name ~= "unemployed" then						
      table.insert(elements, {label = '💼'.._U('job')..' ' .. ESX.PlayerData.job.label .. ' - ' .. ESX.PlayerData.job.grade_label .. '</span>',		value = 'job'})
    else
      table.insert(elements, {label = '<span style="color: '..Config.RedColor..';">❗️'.._U('unemployed')..'❗️</span>'})
    end
  
    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'info_menu',
      {
        
        title    = _U('info_title'),
        align    = Config.Align,
        elements = elements
      },
      function(data, menu)
        
        if data.current.value == 'job' then
          if ESX.PlayerData.job.grade_name == 'boss' or ESX.PlayerData.job.grade_name == 'manager' then
          ESX.ShowNotification(_U('society_account', society))
          end
        end
      end,
      function(data, menu)
        menu.close()
        OpenPlayerMenu()
      end)
    end)
end

function OpenPlayerMenu()
	ESX.UI.Menu.CloseAll()

  local elements = {}
  table.insert(elements, {label = '📋'.._U('info_title'), value = 'info'})		
  table.insert(elements, {label = '🚗'.._U('car_title'), value = 'car'})

  ESX.UI.Menu.Open(
  'default', GetCurrentResourceName(), 'civilian_actions',
  {
    title    = _U('main_title'),
    align    = Config.Align,
    elements = elements
  },
    
    function(data, menu)	

      if data.current.value == 'info' then
        OpenInformationMenu()
      end

      if data.current.value == 'car' then
        OpenCarMenu()
      end

    end,
    function(data, menu)
      menu.close()
    end)
end

Citizen.CreateThread(function()
  while true do
    Wait(0)
    if Config.MenuButton ~= 'none' then
      if IsControlPressed(0, Keys[Config.MenuButton]) then
        OpenPlayerMenu()
      end
    end
  end
end)

RegisterCommand('pmenu', function()
  if Config.MenuButton == 'none' then
    OpenPlayerMenu()
  end
end)

RegisterNetEvent("esx_menu:open")                              
AddEventHandler(
    "esx_menu:open",
    function()
            OpenPlayerMenu()
    end
)


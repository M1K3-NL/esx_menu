ESX = nil
local RegisteredSocieties = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function getMoney(user)
	local xPlayer = ESX.GetPlayerFromId(user)
	return xPlayer.getMoney()
end

function getBank(user)
	local xPlayer = ESX.GetPlayerFromId(user)
	local account = xPlayer.getAccount('bank')
	return account.money
end

function getInfo(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local society = getSociety(xPlayer.job.name)

    if society ~= nil then
        TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
            society_money = account.money
        end)
    else
        society_money = 0
	end

	local identifier = GetPlayerIdentifiers(source)[1]
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local identity = result[1]

		return {
			identifier = identity['identifier'],
			firstname = identity['firstname'],
			lastname = identity['lastname'],
			dateofbirth = identity['dateofbirth'],
			sex = identity['sex'],
			height = identity['height'],
			name = identity['name'],
			doublechar = identity['doublechar'],
            phone = identity['phone_number'],
            money = getMoney(source),
            bank = getBank(source),
			job = identity['job'],
			society = society_money
			
		}
	else
		return nil
	end
end

TriggerEvent('esx_society:getSocieties', function(societies) 
	RegisteredSocieties = societies
end)

function getSociety(name)
  for i=1, #RegisteredSocieties, 1 do
    if RegisteredSocieties[i].name == name then
      return RegisteredSocieties[i]
    end
  end
end

ESX.RegisterServerCallback('esx_menu:getInfo', function(source, cb)
	local info = getInfo(source)

	cb(info)
end)
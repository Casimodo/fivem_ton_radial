ESX = exports["es_extended"]:getSharedObject()
local PlayerData = nil
local jobname = nil

-- ==============================================================================================
-- == Radial Police
-- ==============================================================================================
local function startRadialPolice()
  if PlayerData and PlayerData.job and (PlayerData.job.name == 'police' or PlayerData.job.name == 'bcso') then
    lib.addRadialItem({
      {
        id = 'ton_radial_police',
        label = 'Police',
        icon = 'fa-solid fa-bookmark',
        menu = 'ton_radial_police_action'
      }
    })

    -- Creation du radial detail Police
    lib.registerRadial({
      id = 'ton_radial_police_action',
      items = {
        {
          label = 'Dispatch',
          icon = 'fa-regular fa-trash-can',
          onSelect = function()
            ExecuteCommand('cls')
          end
        },
        {
          label = 'Panique',
          icon = 'fa-solid fa-triangle-exclamation',
          onSelect = function()
            ExecuteCommand('p')
          end
        },
        {
          label = '911',
          icon = 'fa-solid fa-eye',
          onSelect = function()
            ExecuteCommand('911')
          end
        },
        
      }
    })
  end
end

-- ==============================================================================================
-- == Radial Debug
-- ==============================================================================================
local function startRadialDebug()
  
    lib.addRadialItem({
      {
        id = 'ton_radial_debug',
        label = 'Debug',
        icon = 'fa-solid fa-bug-slash',
        menu = 'ton_radial_debug_action'
      }
    })

    -- Creation du radial detail
    lib.registerRadial({
      id = 'ton_radial_debug_action',
      items = {
        {
          label = 'Reset action',
          icon = 'fa-regular fa-circle-stop',
          onSelect = function()
            local playerPed = PlayerPedId()
            ClearPedTasks(playerPed)
            local attachedObjects = GetGamePool('CObject') -- Obtenir tous les objets de la scène
            for _, obj in ipairs(attachedObjects) do
                if DoesEntityExist(obj) and IsEntityAttachedToEntity(obj, playerPed) then
                    DetachEntity(obj, true, true) -- Détache l'objet du joueur
                    DeleteObject(obj) -- Supprime l'objet
                end
            end
          end
        },
        {
          label = 'Relog',
          icon = 'fa-solid fa-users',
          onSelect = function()
            ExecuteCommand('relog')
          end
        },
        
      }
    })
end


-- ==============================================================================================
-- == Radial shortcuts
-- ==============================================================================================
local function startRadialShortcut()
  lib.addRadialItem({
    {
      id = 'ton_radial_shortcut',
      label = 'Animation',
      icon = 'fa-solid fa-bookmark',
      menu = 'ton_radial_shortcut_play'
    }
  })

  -- Permet de construire le menu radial PLAY
  local function construcRadialPlay(dt)
    -- Item pour le play par defaut
    local itemsPlay = {
      {
        label = 'Ajouter',
        icon = 'plus',
        onSelect = function()
          ShowClassicMenu()
        end
      },
      {
        label = 'Supprimer',
        icon = 'minus',
        menu = 'ton_radial_shortcut_remove'
      },
    }
    -- Ajout des items play qui sont en db
    for i = 1, #dt do
      table.insert(itemsPlay,{
        id = "ton_radial_play_" .. i,
        label = dt[i].label,
        icon = 'fa-solid fa-play',
        onSelect = function()
          ExecuteCommand('e ' .. dt[i].anim)
        end
      })    
    end

    -- Creation du radial play
    lib.registerRadial({
      id = 'ton_radial_shortcut_play',
      items = itemsPlay
    })
  end

  -- Permet de construire le menu radial REMOVE
  local function construcRadialRemove(dt)
    -- Item pour le remove par defaut
    local itemsRemove = {}
    -- Ajout des items play qui sont en db
    for i = 1, #dt do
      table.insert(itemsRemove,{
        id = "ton_radial_shortcut_play_" .. i,
        label = dt[i].label,
        icon = 'fa-regular fa-trash-can',
        onSelect = function()
          TriggerServerEvent("ton_radial:removeAnimations", dt[i].id)
        end
      })    
    end

    -- Creation du radial remove
    lib.registerRadial({
      id = 'ton_radial_shortcut_remove',
      items = itemsRemove
    })
  end

  -- Lecture des données en db
  RegisterNetEvent('ton_radial:reloadShorcut')
  AddEventHandler('ton_radial:reloadShorcut', function(dt)

    construcRadialPlay(dt)
    construcRadialRemove(dt)
    print('[ton_shorcut] : reload')
  end)
  TriggerServerEvent("ton_radial:getAnimations")

  -- Gestion d'ajout de shortcuts
  function ShowClassicMenu()
      local input = lib.inputDialog("Ajouter une animation", {
          { type = "input", label = "Nom de l'animation", placeholder = "Danse" },
          { type = "input", label = "Commande d'animation sans le /e ", placeholder = "sitchair" }
      })

      if input then
          TriggerServerEvent("ton_radial:saveAnimation", {
              label = input[1],
              anim = input[2]
          })
      end
  end
end

-- ==============================================================================================
-- == Start Radial avec condition
-- ==============================================================================================
Citizen.CreateThread(function()
  while not ESX do
      Citizen.Wait(10)
  end
    while not ESX.IsPlayerLoaded() do
      Citizen.Wait(10)
  end
  PlayerData = ESX.GetPlayerData()
  jobname = PlayerData.job.name
  --startRadialPolice()
  --startRadialDebug()
  startRadialShortcut()
end)

AddEventHandler('esx:playerLoaded', function(xPlayer)

  PlayerData = ESX.GetPlayerData()
  jobname = PlayerData.job.name
  --startRadialPolice()
  --startRadialDebug()
  startRadialShortcut()
end)
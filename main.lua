StartDebug()


local mod = RegisterMod("More Options Forever", 1)
local verbose = true -- make this false if you don't want console spam
function out(...) if verbose then print(...) end end

local canSpawnBossDrop = false -- Global to prevent a 4th boss drop

-- IF YOU FIND IMPORTANT ITEMS THAT SHOULDN'T GET OVERWRITTEN, ADD THEIR ID's TO THIS LIST
local imporantItemList = {
    CollectibleType.COLLECTIBLE_NEGATIVE, 
    CollectibleType.COLLECTIBLE_POLAROID,
    550, -- broken shovel pt 1
    551, -- broken shovel pt 2
    552, -- mom's shovel
    580, -- red key
    626, -- knife piece 1
    627, -- knife piece 2
    633, -- dogma
    668 -- dad's note
}

--[[ Helper stuff ]]--

function RemoveCollectibles(list)
    for _, item in pairs(list) do
        if item:Exists() then
            item.Visible = false
            item:ToPickup():Morph(EntityType.ENTITY_NULL, 0, 0, false)
        end
    end
    out("Disabled custom collectibles in room")
    mod:RemoveCallback(ModCallbacks.MC_POST_UPDATE, RemoveCollectibles)
end

function SpawnTreasure(isBossRoom)
    local room = Game():GetRoom()
    for x = -80, 80, 80 do
        if isBossRoom and x == 0 then goto skip end
        local spawnPos = room:GetClampedPosition(room:GetCenterPos(), 1)
        spawnPos.X = spawnPos.X + x
        spawnPos = Isaac.GetFreeNearPosition(spawnPos, 1) -- make sure  it doens't overlap anything

        local drop = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0, spawnPos, Vector(0,0), nil)
        ::skip::
    end
    out("Spawned 3 collectibles")
end

-- drop a soul heart if player has More Options or There's Options
function SpawnPityReward()

end

-- todo: special card; cracked key

function IsImportantItem(entity)
    for _, id in pairs(imporantItemList) do
        print("Checking "..entity.SubType.."...")
        if id == entity.SubType then
            out("IsImportantItem: true")
            return true
        end
    end
    out("IsImportantItem: false")
    return false
end

function ClearCustomCollectibles(except)
    local room = Game():GetRoom()
    local entities = Isaac:GetRoomEntities()

    for _, entity in pairs(entities) do
        if not entity then goto skip end
        if not entity.Variant then goto skip end
        if not entity:Exists() then goto skip end
        if IsImportantItem(entity) then goto skip end
        if entity.SubType == except.SubType then out("Skipping touched entity") goto skip end
        if entity.Variant == PickupVariant.PICKUP_COLLECTIBLE then
            if entity.ToPickup then
                --entity.Visible = false
                entity:ToPickup():Morph(EntityType.ENTITY_NULL, 0, 0, false)
                out("Cleared a collectible")
            end
        end
        ::skip::
    end
    out("Done")
end

--[[ Callbacks ]]--

-- Manage globals
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function(_)
    canSpawnBossDrop = false
end)

-- Override treasure room spawn: remove everything
mod:AddCallback(ModCallbacks.MC_PRE_ROOM_ENTITY_SPAWN, function(_, entityType, variant, subtype, gridIndex, seed)
    if Game():GetRoom():GetType() == RoomType.ROOM_TREASURE then
        return {EntityType.ENTITY_NULL, 0, 0}
    end
end)

-- On first visit, spawn three collectibles in treasure room (there should be nothing in it by default)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function(_)
    local room = Game():GetRoom()
    if room:GetType() == RoomType.ROOM_TREASURE and room:IsFirstVisit() then
        SpawnTreasure(false)
    end
end)

-- Replace default boss collectible spawn with nothing (or coin); prevents a 4th drop
mod:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, function(_, entityType, variant, subtype, position, velocity, spawner, seed)
    --[[if Game():GetRoom():GetType() == RoomType.ROOM_BOSS and variant == PickupVariant.PICKUP_COLLECTIBLE then
        if not IsImportantItem({SubType = subtype}) then -- pretend-entity that's usable by IsImportantItem
            out("Overriding boss collectible with coin")
            return {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, 0}
        end
    end]]
end)

-- Spawn TWO custom collectibles after killing a boss (default drop still happens)
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, entity)
    if Game():GetRoom():GetType() == RoomType.ROOM_BOSS and Game():GetRoom():GetAliveEnemiesCount() <= 1 then
        SpawnTreasure(true)
    end
end)

-- When player touches a collectible (that isn't an imporant item,) remove other collectibles in room
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickupEntity, colliderEntity, low)
    if pickupEntity.Variant == PickupVariant.PICKUP_COLLECTIBLE and colliderEntity.Type == EntityType.ENTITY_PLAYER and not IsImportantItem(pickupEntity) then
        ClearCustomCollectibles(pickupEntity)
    end
end)
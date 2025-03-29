ItemTypeDataExtractTool = {}

local function Init(event, name)
    if name ~= "ItemTypeDataExtractTool" then return end
    EVENT_MANAGER:UnregisterForEvent("ItemTypeDataExtractTool", EVENT_ADD_ON_LOADED)
    ItemTypeDataExtractTool.savedVars = ZO_SavedVars:NewAccountWide("ItemTypeDataExtractToolSavedVars", 1, nil, {})
end

function ItemTypeDataExtractTool.GetItemData()
    local lightArmorItems = {}
    local mediumArmorItems = {}
    local heavyArmorItems = {}

    local weaponAxeItems = {}
    local weaponBowItems = {}
    local weaponDaggerItems = {}
    local weaponFireStaffItems = {}
    local weaponFrostStaffItems = {}
    local weaponHammerItems = {}
    local weaponHealingStaffItems = {}
    local weaponLightningStaffItems = {}
    local weaponShieldItems = {}
    local weaponSwordItems = {}
    local weaponTwoHandedAxeItems = {}
    local weaponTwoHandedHammerItems = {}
    local weaponTwoHandedSwordItems = {}

    for itemId = 0, 1e6 do
        local itemLink = "|H1:item:" .. itemId .. ":364:50:0:0:0:18:0:0:0:0:0:0:0:2049:0:0:1:0:0:0|h|h"
        
        -- Extract armor type
        local armorType = GetItemLinkArmorType(itemLink)
        if armorType == ARMORTYPE_LIGHT then
            lightArmorItems[itemId] = 1
        elseif armorType == ARMORTYPE_MEDIUM then
            mediumArmorItems[itemId] = 2
        elseif armorType == ARMORTYPE_HEAVY then
            heavyArmorItems[itemId] = 3
        end

        -- Extract weapon type
        local weaponType = GetItemLinkWeaponType(itemLink)
        if weaponType == WEAPONTYPE_AXE then
            weaponAxeItems[itemId] = 1
        elseif weaponType == WEAPONTYPE_BOW then
            weaponBowItems[itemId] = 2
        elseif weaponType == WEAPONTYPE_DAGGER then
            weaponDaggerItems[itemId] = 3
        elseif weaponType == WEAPONTYPE_FIRE_STAFF then
            weaponFireStaffItems[itemId] = 4
        elseif weaponType == WEAPONTYPE_FROST_STAFF then
            weaponFrostStaffItems[itemId] = 5
        elseif weaponType == WEAPONTYPE_HAMMER then
            weaponHammerItems[itemId] = 6
        elseif weaponType == WEAPONTYPE_HEALING_STAFF then
            weaponHealingStaffItems[itemId] = 7
        elseif weaponType == WEAPONTYPE_LIGHTNING_STAFF then
            weaponLightningStaffItems[itemId] = 8
        elseif weaponType == WEAPONTYPE_SHIELD then
            weaponShieldItems[itemId] = 11
        elseif weaponType == WEAPONTYPE_SWORD then
            weaponSwordItems[itemId] = 12
        elseif weaponType == WEAPONTYPE_TWO_HANDED_AXE then
            weaponTwoHandedAxeItems[itemId] = 13
        elseif weaponType == WEAPONTYPE_TWO_HANDED_HAMMER then
            weaponTwoHandedHammerItems[itemId] = 14
        elseif weaponType == WEAPONTYPE_TWO_HANDED_SWORD then
            weaponTwoHandedSwordItems[itemId] = 15
        end
    end

    ItemTypeDataExtractTool.savedVars.armour = {
        ["LIGHT"] = lightArmorItems,
        ["MEDIUM"] = mediumArmorItems,
        ["HEAVY"] = heavyArmorItems,
    }

    ItemTypeDataExtractTool.savedVars.weapons = {
        ["AXE"] = weaponAxeItems,
        ["BOW"] = weaponBowItems,
        ["DAGGER"] = weaponDaggerItems,
        ["FIRE_STAFF"] = weaponFireStaffItems,
        ["FROST_STAFF"] = weaponFrostStaffItems,
        ["MACE"] = weaponHammerItems,
        ["HEALING_STAFF"] = weaponHealingStaffItems,
        ["LIGHTNING_STAFF"] = weaponLightningStaffItems,
        ["SHIELD"] = weaponShieldItems,
        ["SWORD"] = weaponSwordItems,
        ["TWO_HANDED_AXE"] = weaponTwoHandedAxeItems,
        ["TWO_HANDED_MACE"] = weaponTwoHandedHammerItems,
        ["TWO_HANDED_SWORD"] = weaponTwoHandedSwordItems,
    }
end

-- ^.*= "
-- ",\n
-- replace ([A-z]+,) with \n$1
function ItemTypeDataExtractTool.GenerateDataStringsFromSavedVars()
    local resultStrings = {}

    local function splitString(inputStr, maxLength)
        local chunks = {}
        for i = 1, #inputStr, maxLength do
            table.insert(chunks, inputStr:sub(i, i + maxLength - 1))
        end
        return chunks
    end

    for armorType, itemTable in pairs(ItemTypeDataExtractTool.savedVars.armour) do
        local itemIds = {}
        for itemId, _ in pairs(itemTable) do
            table.insert(itemIds, itemId)
        end

        local resultString = armorType .. "," .. table.concat(itemIds, ",")
        
        local chunks = splitString(resultString, 1900)
        for _, chunk in ipairs(chunks) do
            table.insert(resultStrings, chunk)
        end
    end


    for weaponType, itemTable in pairs(ItemTypeDataExtractTool.savedVars.weapons) do
        local itemIds = {}
        for itemId, _ in pairs(itemTable) do
            table.insert(itemIds, itemId)
        end

        local resultString = weaponType .. "," .. table.concat(itemIds, ",")

        local chunks = splitString(resultString, 1900)
        for _, chunk in ipairs(chunks) do
            table.insert(resultStrings, chunk)
        end
    end

    ItemTypeDataExtractTool.savedVars.strings = resultStrings;
end

EVENT_MANAGER:RegisterForEvent("ItemTypeDataExtractTool", EVENT_ADD_ON_LOADED, Init)
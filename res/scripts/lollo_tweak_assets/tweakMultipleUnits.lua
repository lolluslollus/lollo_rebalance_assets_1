local arrayUtils = require('lollo_tweak_assets.arrayUtils')
local logger = require('lollo_tweak_assets.logger')
local stringUtils = require('lollo_tweak_assets.stringUtils')

local filterOutTweakedMUs = function(fileName, data)
    -- this puts out everything, no good
    if stringUtils.stringEndsWith(fileName, '/ice1.lua')
    or stringUtils.stringEndsWith(fileName, '/mirage.lua')
    or stringUtils.stringEndsWith(fileName, '/re_450.lua')
    or stringUtils.stringEndsWith(fileName, '/tgv_2.lua')
    or stringUtils.stringEndsWith(fileName, '/twindexx.lua')
    then
        print('fileName =', fileName, 'data =') debugPrint(data)
        return false
    end

    return true
end

local getNewMU = function(groupFileName, mu)
    local newMU = api.type.MultipleUnit.new()
    newMU.desc = mu.desc
    newMU.groupFileName = groupFileName
    newMU.name = mu.name .. ' x' .. tostring(#mu.vehicles)
    newMU.vehicles = {}
    -- print('mu.vehicles =') debugPrint(mu.vehicles)
    for _, vehicle in pairs(mu.vehicles) do
        -- print('ONE')
        local newVehicle = api.type.MultipleUnit.Vehicle.new()
        newVehicle.forward = vehicle.forward
        newVehicle.name = vehicle.name
        newMU.vehicles[#newMU.vehicles+1] = newVehicle
        -- print('TWO')
    end
    -- print('newMU =') debugPrint(newMU)

    return newMU
end

local addNewMUVariant = function(primaryGroupFileName, mu, vehicles)
    print('addNewMUVariant starting, secondaryGroupFileName =', mu.secondaryGroupFileName or 'NIL')
    api.res.multipleUnitRep.add(
        tostring(#vehicles) .. 'x' .. (stringUtils.isNullOrEmptyString(mu.secondaryGroupFileName) and primaryGroupFileName or mu.secondaryGroupFileName),
        getNewMU(
            primaryGroupFileName,
            {
                vehicles = vehicles,
                -- vehicles = {
                --     { name = "vehicle/train/twindexx.mdl", forward = true },
                --     { name = "vehicle/train/twindexx_w1.mdl", forward = true },
                --     { name = "vehicle/train/twindexx.mdl", forward = false },
                -- },
                groupFileName = primaryGroupFileName, -- "dualstox_variants.lua",
                name = mu.name,
                desc = mu.desc
            }
        ),
        true
    )
end

local doTweak2 = function(allMUsByGroup)
    for primaryGroupFileName, musInGroup in pairs(allMUsByGroup) do
        logger.print('looping, primaryGroupFileName =') logger.debugPrint(primaryGroupFileName)
        for _, mu in pairs(musInGroup) do
            -- add custom variants, different for every case coz the grouping logic can change between mods
            if primaryGroupFileName == 'C1.lua' then
                if mu.secondaryGroupFileName == 'C1.lua' then
                    addNewMUVariant(
                        primaryGroupFileName,
                        mu,
                        {
                            { name = "vehicle/train/C1_Kopf.mdl", forward = true },
                            { name = "vehicle/train/C1_Wagon.mdl", forward = true },
                            { name = "vehicle/train/C1_ansage.mdl", forward = true },
                            { name = "vehicle/train/C1_Wagon.mdl", forward = false },
                            { name = "vehicle/train/C1_Kopfhinten.mdl", forward = false },
                        }
                    )
                elseif mu.secondaryGroupFileName == 'C1lite.lua' then
                    addNewMUVariant(
                        primaryGroupFileName,
                        mu,
                        {
                            { name = "vehicle/train/C1_Kopflite.mdl", forward = true },
                            { name = "vehicle/train/C1_Wagonlite.mdl", forward = true },
                            { name = "vehicle/train/C1_ansagelite.mdl", forward = true },
                            { name = "vehicle/train/C1_Wagonlite.mdl", forward = false },
                            { name = "vehicle/train/C1_Kopfhintenlite.mdl", forward = false },
                        }
                    )
                elseif mu.secondaryGroupFileName == 'C1schnell.lua' then
                    addNewMUVariant(
                        primaryGroupFileName,
                        mu,
                        {
                            { name = "vehicle/train/C1_Kopfschnell.mdl", forward = true },
                            { name = "vehicle/train/C1_Wagonschnell.mdl", forward = true },
                            { name = "vehicle/train/C1_ansage.mdl", forward = true },
                            { name = "vehicle/train/C1_Wagonschnell.mdl", forward = false },
                            { name = "vehicle/train/C1_Kopfhintenschnell.mdl", forward = false },
                        }
                    )
                elseif mu.secondaryGroupFileName == 'C1liteschnell.lua' then
                    addNewMUVariant(
                        primaryGroupFileName,
                        mu,
                        {
                            { name = "vehicle/train/C1_Kopfliteschnell.mdl", forward = true },
                            { name = "vehicle/train/C1_Wagonliteschnell.mdl", forward = true },
                            { name = "vehicle/train/C1_ansagelite.mdl", forward = true },
                            { name = "vehicle/train/C1_Wagonliteschnell.mdl", forward = false },
                            { name = "vehicle/train/C1_Kopfhintenliteschnell.mdl", forward = false },
                        }
                    )
                end
            elseif primaryGroupFileName == 'C2_Inspiro.lua' then
                if mu.secondaryGroupFileName == 'C2_Inspiro.lua' then
                    addNewMUVariant(
                        primaryGroupFileName,
                        mu,
                        {
                            { name = "vehicle/train/C2_Kopf.mdl", forward = true },
                            { name = "vehicle/train/C2_Wagon.mdl", forward = true },
                            { name = "vehicle/train/C2_ansage.mdl", forward = true },
                            { name = "vehicle/train/C2_Wagon.mdl", forward = false },
                            { name = "vehicle/train/C2_Kopfhinten.mdl", forward = false },
                        }
                    )
                elseif mu.secondaryGroupFileName == 'C2_Inspiroschnell.lua' then
                    addNewMUVariant(
                        primaryGroupFileName,
                        mu,
                        {
                            { name = "vehicle/train/C2_Kopfschnell.mdl", forward = true },
                            { name = "vehicle/train/C2_Wagonschnell.mdl", forward = true },
                            { name = "vehicle/train/C2_ansage.mdl", forward = true },
                            { name = "vehicle/train/C2_Wagonschnell.mdl", forward = false },
                            { name = "vehicle/train/C2_Kopfhintenschnell.mdl", forward = false },
                        }
                    )
                elseif mu.secondaryGroupFileName == 'C2_Inspirokansage.lua' then
                    addNewMUVariant(
                        primaryGroupFileName,
                        mu,
                        {
                            { name = "vehicle/train/C2_Kopfkansage.mdl", forward = true },
                            { name = "vehicle/train/C2_Wagonkansage.mdl", forward = true },
                            { name = "vehicle/train/C2_kansage.mdl", forward = true },
                            { name = "vehicle/train/C2_Wagonkansage.mdl", forward = false },
                            { name = "vehicle/train/C2_Kopfhintenkansage.mdl", forward = false },
                        }
                    )
                elseif mu.secondaryGroupFileName == 'C2_Inspiroschnellkansage.lua' then
                    addNewMUVariant(
                        primaryGroupFileName,
                        mu,
                        {
                            { name = "vehicle/train/C2_Kopfschnellkansage.mdl", forward = true },
                            { name = "vehicle/train/C2_Wagonschnellkansage.mdl", forward = true },
                            { name = "vehicle/train/C2_kansage.mdl", forward = true },
                            { name = "vehicle/train/C2_Wagonschnellkansage.mdl", forward = false },
                            { name = "vehicle/train/C2_Kopfhintenschnellkansage.mdl", forward = false },
                        }
                    )
                end
            elseif primaryGroupFileName == 'ice1.lua' then
                addNewMUVariant(
                    primaryGroupFileName,
                    mu,
                    {
                        { name = "vehicle/train/ice1.mdl", forward = true },
                        { name = "vehicle/train/ice1_waggon_1.mdl", forward = true },
                        { name = "vehicle/train/ice1_waggon_1.mdl", forward = true },
                        { name = "vehicle/train/ice1_waggon_1.mdl", forward = true },
                        { name = "vehicle/train/ice1_waggon_2.mdl", forward = true },
                        { name = "vehicle/train/ice1_waggon_1.mdl", forward = false },
                        { name = "vehicle/train/ice1_waggon_1.mdl", forward = false },
                        { name = "vehicle/train/ice1.mdl", forward = false },
                    }
                )
                addNewMUVariant(
                    primaryGroupFileName,
                    mu,
                    {
                        { name = "vehicle/train/ice1.mdl", forward = true },
                        { name = "vehicle/train/ice1_waggon_1.mdl", forward = true },
                        { name = "vehicle/train/ice1_waggon_1.mdl", forward = true },
                        { name = "vehicle/train/ice1_waggon_1.mdl", forward = true },
                        { name = "vehicle/train/ice1_waggon_1.mdl", forward = true },
                        { name = "vehicle/train/ice1_waggon_1.mdl", forward = true },
                        { name = "vehicle/train/ice1_waggon_2.mdl", forward = true },
                        { name = "vehicle/train/ice1_waggon_1.mdl", forward = false },
                        { name = "vehicle/train/ice1_waggon_1.mdl", forward = false },
                        { name = "vehicle/train/ice1_waggon_1.mdl", forward = false },
                        { name = "vehicle/train/ice1_waggon_1.mdl", forward = false },
                        { name = "vehicle/train/ice1.mdl", forward = false },
                    }
                )
            elseif primaryGroupFileName == 'mirage.lua' then
                addNewMUVariant(
                    primaryGroupFileName,
                    mu,
                    {
                        { name = "vehicle/train/rabde_12_12_front.mdl", forward = true },
                        { name = "vehicle/train/rabde_12_12_waggon.mdl", forward = true },
                        { name = "vehicle/train/rabde_12_12_waggon.mdl", forward = false },
                        { name = "vehicle/train/rabde_12_12_front.mdl", forward = false },
                    }
                )
                addNewMUVariant(
                    primaryGroupFileName,
                    mu,
                    {
                        { name = "vehicle/train/rabde_12_12_front.mdl", forward = true },
                        { name = "vehicle/train/rabde_12_12_waggon.mdl", forward = true },
                        { name = "vehicle/train/rabde_12_12_waggon.mdl", forward = true },
                        { name = "vehicle/train/rabde_12_12_waggon.mdl", forward = false },
                        { name = "vehicle/train/rabde_12_12_front.mdl", forward = false },
                    }
                )
            elseif primaryGroupFileName == 're_450.lua' then
                addNewMUVariant(
                    primaryGroupFileName,
                    mu,
                    {
                        { name = "vehicle/train/re_450.mdl", forward = true },
                        { name = "vehicle/train/re_450_b.mdl", forward = true },
                        { name = "vehicle/train/re_450_b.mdl", forward = true },
                        { name = "vehicle/train/re_450_b.mdl", forward = false },
                        { name = "vehicle/train/re_450_bt.mdl", forward = true },
                    }
                )
                addNewMUVariant(
                    primaryGroupFileName,
                    mu,
                    {
                        { name = "vehicle/train/re_450.mdl", forward = true },
                        { name = "vehicle/train/re_450_b.mdl", forward = true },
                        { name = "vehicle/train/re_450_b.mdl", forward = true },
                        { name = "vehicle/train/re_450_b.mdl", forward = false },
                        { name = "vehicle/train/re_450_b.mdl", forward = false },
                        { name = "vehicle/train/re_450_bt.mdl", forward = true },
                    }
                )
            elseif primaryGroupFileName == 'tgv_2.lua' then
                addNewMUVariant(
                    primaryGroupFileName,
                    mu,
                    {
                        { name = "vehicle/train/tgv.mdl", forward = true },
                        { name = "vehicle/train/tgv_w1.mdl", forward = true },
                        { name = "vehicle/train/tgv_w2.mdl", forward = true },
                        { name = "vehicle/train/tgv_w2.mdl", forward = false },
                        { name = "vehicle/train/tgv_w1.mdl", forward = false },
                        { name = "vehicle/train/tgv.mdl", forward = false },
                    }
                )
                addNewMUVariant(
                    primaryGroupFileName,
                    mu,
                    {
                        { name = "vehicle/train/tgv.mdl", forward = true },
                        { name = "vehicle/train/tgv_w1.mdl", forward = true },
                        { name = "vehicle/train/tgv_w2.mdl", forward = true },
                        { name = "vehicle/train/tgv_w2.mdl", forward = true },
                        { name = "vehicle/train/tgv_w2.mdl", forward = false },
                        { name = "vehicle/train/tgv_w2.mdl", forward = false },
                        { name = "vehicle/train/tgv_w1.mdl", forward = false },
                        { name = "vehicle/train/tgv.mdl", forward = false },
                    }
                )
            elseif primaryGroupFileName == 'twindexx.lua' then
                addNewMUVariant(
                    primaryGroupFileName,
                    mu,
                    {
                        { name = "vehicle/train/twindexx.mdl", forward = true },
                        { name = "vehicle/train/twindexx_w1.mdl", forward = true },
                        { name = "vehicle/train/twindexx.mdl", forward = false },
                    }
                )
                addNewMUVariant(
                    primaryGroupFileName,
                    mu,
                    {
                        { name = "vehicle/train/twindexx.mdl", forward = true },
                        { name = "vehicle/train/twindexx_w1.mdl", forward = true },
                        { name = "vehicle/train/twindexx_w1.mdl", forward = false },
                        { name = "vehicle/train/twindexx.mdl", forward = false },
                    }
                )
                addNewMUVariant(
                    primaryGroupFileName,
                    mu,
                    {
                        { name = "vehicle/train/twindexx.mdl", forward = true },
                        { name = "vehicle/train/twindexx_w1.mdl", forward = true },
                        { name = "vehicle/train/twindexx_w1.mdl", forward = true },
                        { name = "vehicle/train/twindexx_w1.mdl", forward = false },
                        { name = "vehicle/train/twindexx.mdl", forward = false },
                    }
                )
            end
        end
        -- add shorter variants
        -- LOLLO NOTE we do this by hand coz every mod can have its own was of grouping things:
        -- mit ansage, different lengths, etc. Plus, we don't want too much of anything.
        -- for _, desiredVehicleCounter in pairs(desiredVehicleCounters) do
        --     if not(arrayUtils.arrayHasValue(actualVehicleCounters, desiredVehicleCounter)) then

        --     end
        -- end
    end
end

local doTweak1 = function(settings, params)
    local allMUs = api.res.multipleUnitRep.getAll()

    local allMUsByGroup = {}
    for k, groupFileName in pairs(allMUs) do
        local mu = api.res.multipleUnitRep.get(k)
        if mu ~= nil then
            logger.print('k =', k)
            logger.print('groupFileName =', groupFileName)
            logger.print('mu.groupFileName =', mu.groupFileName)

            local newIndex = nil
            if not(stringUtils.isNullOrEmptyString(mu.groupFileName)) then
                -- this is empty in all vehicles without their own group.
                -- it is populated in vehicles with their group.
                -- it is populated and different from groupFileName in groups of multiple units.
                -- groupFileName becomes nested level 1 (secondary) (to keep the waggons together in a combination, in the detail vehicle menu)
                -- and mu.groupFileName nested level 0 (primary) (to get a position in the main vehicle menu).
                logger.print('groupFileName found in mu')
                newIndex = mu.groupFileName
            elseif not(stringUtils.isNullOrEmptyString(groupFileName)) then
                logger.print('groupFileName found in table')
                newIndex = groupFileName
            end
            if newIndex ~= nil then
                if allMUsByGroup[newIndex] == nil then allMUsByGroup[newIndex] = {} end
                -- I cannot touch mu coz it is userdata and it won't let me duplicate it with arrayUtils, it's a stubborn (buggy) table
                -- mu = arrayUtils.cloneDeepOmittingFields(mu, nil, true) -- cannot
                table.insert(allMUsByGroup[newIndex], {
                    desc = mu.desc,
                    name = mu.name,
                    secondaryGroupFileName = groupFileName,
                    vehicles = mu.vehicles
                })
                -- if mu.groupFileName ~= newIndex then logger.print('mu.groupFileName is', mu.groupFileName, 'and newIndex is', newIndex) end
            end
        end
    end
    logger.print('allMUsByGroup =') logger.debugPrint(allMUsByGroup)

    doTweak2(allMUsByGroup)
end

return {
    tweak = doTweak1
}

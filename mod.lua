function data()
    local mySettings = require('lollo_tweak_assets.settings')
    local stringUtils = require('lollo_tweak_assets.stringUtils')
    local tweakAssets = require('lollo_tweak_assets.tweakAssets')

    local function loadConstructionFunc(fileName, data)
        -- the following works, the same with ASSET_DEFAULT does not
        -- if data.type == 'TOWN_BUILDING' then
        --     local originalUpdateFn = data.updateFn
        --     data.updateFn = function(params)
        --         print('LOLLO test tweaked updateFn starting')
        --         local result = originalUpdateFn(params)
        --         if not(result) then return result end

        --         result.personCapacity = { type = "RESIDENTIAL", capacity = 2345, }

        --         return result
        --     end
        --     return data
        -- end
        local modId = tweakAssets.getModId(fileName)
        if not (modId) then
            return data
        end

        if stringUtils.arrayHasValue(mySettings.modIds, modId) then
            -- require("mobdebug").start()
            print('LOLLO loading fileName =', fileName, 'with data.type =', data.type)
            data.autoRemovable = false
            data.buildMode = 'MULTI' --'SINGLE'
            data.categories = { 'building' }
            data.lollo = true
            -- data.preProcessFn = nil --function(_) end
            data.skipCollision = false
            data.skipOnInit = false
            -- data.snapping = {
            --     rail = false,
            --     road = false,
            --     water = false
            -- }
            -- data.upgradeFn = nil
            tweakAssets.adjustParams(data)

            -- tweakAssets.adjustUpdateFn(data) -- LOLLO TODO UG TODO add this once updateFn is correctly overridden.
            -- until then, we override game.config.ConstructWithModules, which works instead.
            -- data.updateFn(tweakAssets.getDefaultParams(data)) -- this works, but it won't work during a game.
        end

        return data
    end

    return {
        info = {
            minorVersion = 0,
            severityAdd = 'NONE',
            severityRemove = 'NONE',
			name = _('NAME'),
			description = _('DESC'),
            tags = {'Europe', 'Script Mod', 'Buildings' },
            authors = {{name = 'Lollus', role = 'CREATOR'}}
        },
        runFn = function (settings, modParams)
            addModifier('loadConstruction', loadConstructionFunc)
            -- the following do nothing
            -- addModifier(
            --     'loadConstructionCategory',
            --     -- tweakAssets.getConstructionCategoryTweaked
            --     function(fileName, data)
            --         print('LOLLO loading construction category', fileName)
            --         print('data =') debugPrint(data)
            --     end
            -- )
            -- addModifier(
            --     'loadConstructionMenu',
            --     -- tweakAssets.getConstructionMenuTweaked
            --     function(fileName, data)
            --         print('LOLLO loading construction menu', fileName)
            --         print('data =') debugPrint(data)
            --     end

            -- )
            local original = game.config.ConstructWithModules
            game.config.ConstructWithModules = function(params)
                if params and params.constrParams and params.constrParams.lolloCapacity then
                    if (mySettings.isExtendedLog) then print('LOLLO ConstructWithModules starting') end
                    tweakAssets.addHiddenParams(params.constrParams)
                    local result = original(params)
                    -- print('LOLLO ConstructWithModules TWO')

                    if params.constrParams.lolloCapacity > 0 then
                        if (mySettings.isExtendedLog) then print('LOLLO ConstructWithModules TWO') end
                        result.personCapacity = {
                            type = ({"RESIDENTIAL", "COMMERCIAL", "INDUSTRIAL"})[(params.constrParams.lolloResComInd or 0) + 1],
                            capacity = params.constrParams.lolloCapacity * 5
                        }
                    else
                        if (mySettings.isExtendedLog) then print('LOLLO ConstructWithModules THREE') end
                        result.personCapacity = nil
                    end

                    return result
                else
                    return original(params)
                end
            end
        end,
    }
end

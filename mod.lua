function data()
    local logger = require('lollo_tweak_assets.logger')
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
            logger.print('LOLLO loading fileName =', fileName, 'with data.type =', data.type)
            data.autoRemovable = false
            data.buildMode = 'MULTI' --'SINGLE'
            data.categories = { 'building' }
            data.lollo = true
            -- data.preProcessFn = nil --function(_) end
            data.skipCollision = false
            -- LOLLO TODO MAYBE for each con, add itself with this set to false and another one set to true,
            -- maybe split in two categories
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

            return data
        end

        if stringUtils.arrayHasValue(mySettings.lmgModIds, modId) then
            logger.print('LOLLO loading fileName =', fileName, 'with data.type =', data.type)
            data.autoRemovable = false
            data.buildMode = 'MULTI' --'SINGLE'
            -- data.categories = { 'building' } -- with these mods, we leave the original category
            data.lollo = true
            data.skipCollision = false
            data.skipOnInit = false
            tweakAssets.adjustParams(data)

            return data
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
        runFn = function (settings)
            addModifier('loadConstruction', loadConstructionFunc)
            -- the following do nothing
            -- addModifier(
            --     'loadConstructionCategory',
            --     -- tweakAssets.getConstructionCategoryTweaked
            --     function(fileName, data)
            --         logger.print('LOLLO loading construction category', fileName)
            --         logger.print('data =') logger.debugPrint(data)
            --     end
            -- )
            -- addModifier(
            --     'loadConstructionMenu',
            --     -- tweakAssets.getConstructionMenuTweaked
            --     function(fileName, data)
            --         logger.print('LOLLO loading construction menu', fileName)
            --         logger.print('data =') logger.debugPrint(data)
            --     end

            -- )
            tweakAssets.adjustGameConfig()
        end,
    }
end

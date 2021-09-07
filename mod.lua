function data()
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
        -- ~= means !=
        -- if stringEndsWith(fileName, '.con') then -- different houses/buildings
        local modId = tweakAssets.getModId(fileName)
        if not (modId) then
            return data
        end

        if modId == '2262626670' -- different houses/buildings
        or modId == '2560352422' -- European Buildings pack 1
        then
            print('LOLLO loading fileName =', fileName, 'with data.type =', data.type)
            data.autoRemovable = false
            data.buildMode = 'SINGLE'
            data.categories = { 'building' }
            data.lollo = true
            data.preProcessFn = nil --function(_) end
            data.skipCollision = false
            data.skipOnInit = false
            -- data.upgradeFn = nil
            if type(data.updateFn) ~= 'function' then return data end

            -- LOLLO TODO do we need this?
            if type(data.upgradeFn) ~= 'function' then
                print('LOLLO upgradeFn set')
                data.upgradeFn = function(_) print('LOLLO upgradeFn started') end
            end
            -- tweakAssets.hideParams(data) -- causes a crash coz certain parameters are not available to updateFn,
            -- which fires once before its tweaked version
            -- LOLLO TODO the trouble is, the tweaked updateFn never fires with these ASSET_DEFAULT things.
            -- It looks like a bug in the game.

            -- local defaultResults = data.updateFn(defaultParams)
            -- print('defaultResults =') debugPrint(defaultResults)

            data.params[#data.params + 1] =
            {
                key = "lolloResCapacity",
                name = _("Lollo Residents"),
                uiType = "SLIDER",
                values = { _("0"), _("5"), _("10"), _("15"), _("20"), _("25"),  _("30"),  _("35"),  _("40"),  _("45"),  _("50"), }
            }
            data.params[#data.params + 1] =
            {
                key = "lolloComCapacity",
                name = _("Lollo Clients"),
                uiType = "SLIDER",
                values = { _("0"), _("5"), _("10"), _("15"), _("20"), _("25"),  _("30"),  _("35"),  _("40"),  _("45"),  _("50"), }
            }

            local originalUpdateFn = data.updateFn
            data.updateFn = function(params)
                print('LOLLO tweaked updateFn starting')
                -- _addHiddenParams(params)
                -- print('LOLLO added hidden params, params =') debugPrint(params)
                local result = originalUpdateFn(params)
                if not(result) then return result end

                result.personCapacity = {}
                if params.lolloResCapacity and params.lolloResCapacity > 0 then
                    result.personCapacity = { type = "RESIDENTIAL", capacity = params.lolloResCapacity * 5, }
                elseif params.lolloComCapacity and params.lolloComCapacity > 0 then
                    result.personCapacity = { type = "COMMERCIAL", capacity = params.lolloComCapacity * 5, }
                end

                print('LOLLO tweaked updateFn is about to return') debugPrint(result)

                return result
            end
            print('LOLLO updateFn set')

            -- data.updateFn(tweakAssets.getDefaultParams(data)) -- this works, but it won't work anymore.

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
        -- postRunFn = function(settings, params)
        --     tweakAssets.tweak(settings, params)
        -- end,
        runFn = function (settings, modParams)
            addModifier('loadConstruction', loadConstructionFunc)
            -- addModifier(
            --     'loadConstructionCategory',
            --     tweakAssets.getConstructionCategoryTweaked
            -- )
            -- addModifier(
            --     'loadConstructionMenu',
            --     tweakAssets.getConstructionMenuTweaked
            -- )
        end,
    }
end

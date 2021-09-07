return {
    stringEndsWith = function(testString, endString)
        if not (endString) then
            return true
        end
        if not (testString) then
            return false
        end
        return string.sub(testString, -(#endString)) == endString
    end,
    stringContains = function(testString, containedString)
        return not (not (string.find(testString, containedString)))
    end,
    getModId = function(fileName)
        -- fileName = "C:/Program Files (x86)/Steam/steamapps/workshop/content/1066780/1943176647/res/config/multiple_unit/oppie_ns_icm_icm3.lua"
        local separatorString = 'workshop/content/1066780/'
        if fileName == nil then
            return nil
        end

        local a, b = string.find(fileName, separatorString)
        if a == nil or b == nil then
            return nil
        end

        return string.sub(fileName, b + 1, b + 10)
    end,
    getDefaultParams = function(data)
        local defaultParams = {}
        if not(data.params) then data.params = {} end
        for _, param in pairs(data.params) do
            defaultParams[param.key] = param.defaultIndex or 0
        end

        return defaultParams
    end,
    hideParams = function(data)
        if not(data.params) then return end

        for _, param in pairs(data.params) do
            if param.key == 'residents'
            or param.key == 'Rcapacities'
            or param.key == 'clients'
            or param.key == 'Ccapacities'
            then
                param.yearFrom = 1800 -- make it invisible
                param.yearTo = 1800 -- make it invisible
            end
            print('LOLLO param =') debugPrint(param)
        end
    end,
    addHiddenParams = function(params)
        if not(params) then return end

        params.residents = 0
        params.Rcapacities = 0
        params.clients = 0
        params.Ccapacities = 0
    end,
}

--[[ return {
    getConstructionTweaked = function(fileName, data)
    -- ~= means !=
    -- if stringEndsWith(fileName, '.con') then -- different houses/buildings
        local modelId = getModId(fileName)
        if not (modelId) then
            return data
        end

        if modelId == '2262626670' then
            -- data.categories = { 'building' }
            -- data.skipCollision = false

            if data.updateFn then
                -- _hideParams(data) -- causes a crash coz certain parameters are not available to updateFn,
                -- which fires once before its tweaked version
                -- LOLLO TODO the trouble is, the tweaked updateFn never fires

                -- local defaultResults = data.updateFn(defaultParams)
                -- print('defaultResults =') debugPrint(defaultResults)

                -- if (defaultResults and not(defaultResults.personCapacity)) then
                    -- data.params[#data.params + 1] =
                    -- {
                    --     key = "lolloResCapacity",
                    --     name = _("Lollo Residents"),
                    --     uiType = "SLIDER",
                    --     values = { _("0"), _("5"), _("10"), _("15"), _("20"), _("25"),  _("30"),  _("35"),  _("40"),  _("45"),  _("50"), }
                    -- }
                    -- data.params[#data.params + 1] =
                    -- {
                    --     key = "lolloComCapacity",
                    --     name = _("Lollo Clients"),
                    --     uiType = "SLIDER",
                    --     values = { _("0"), _("5"), _("10"), _("15"), _("20"), _("25"),  _("30"),  _("35"),  _("40"),  _("45"),  _("50"), }
                    -- }
                -- end

                local originalUpdateFn = data.updateFn
                data.updateFn = function(params)
                    print('LOLLO tweaked updateFn starting')
                    -- _addHiddenParams(params)

                    -- print('LOLLO added hidden params, params =') debugPrint(params)

                    -- local originalResults = originalUpdateFn(params, scriptParams)
                    local result = originalUpdateFn(params)
                    result = {} -- LOLLO TODO remove after testing
                    result.personCapacity = {}
                    if params.lolloResCapacity and params.lolloResCapacity > 0 then
                        result.personCapacity = { type = "RESIDENTIAL", capacity = params.lolloResCapacity * 5, }
                    elseif params.lolloComCapacity and params.lolloComCapacity > 0 then
                        result.personCapacity = { type = "COMMERCIAL", capacity = params.lolloComCapacity * 5, }
                    end

                    print('LOLLO tweaked updateFn is about to return') debugPrint(result)

                    return result
                end

                data.upgradeFn = function(_)
                    print('LOLLO tweaked upgradeFn starting')
                    -- return {}
                end
            end

            return data
        end
    -- end

        return data
    end
} ]]

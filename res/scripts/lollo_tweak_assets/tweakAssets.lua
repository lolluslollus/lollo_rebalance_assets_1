local helpers = {
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

helpers.adjustParams = function(data)
    if (not(data) or type(data.updateFn) ~= 'function') then return end

    helpers.hideParams(data)
    -- tweakAssets.hideParams(data)

    -- local defaultResults = data.updateFn(defaultParams)
    -- print('defaultResults =') debugPrint(defaultResults)

    data.params[#data.params + 1] =
    {
        key = "lolloResComInd",
        name = _("Lollo Clients"),
        uiType = "BUTTON",
        values = { _("Residential"), _("Commercial"), _("Industrial") }
    }
    data.params[#data.params + 1] =
    {
        key = "lolloCapacity",
        name = _("Lollo Capacity"),
        uiType = "SLIDER",
        values = { _("0"), _("5"), _("10"), _("15"), _("20"), _("25"),  _("30"),  _("35"),  _("40"),  _("45"),  _("50"), }
    }
end

helpers.adjustUpdateFn = function(data)
    if (not(data) or type(data.updateFn) ~= 'function') then return end

    local originalUpdateFn = data.updateFn
    data.updateFn = (function(params)
        print('LOLLO tweaked updateFn starting')
        helpers.addHiddenParams(params)
        -- print('LOLLO added hidden params, params =') debugPrint(params)
        local result = originalUpdateFn(params)
        if not(result) then return result end

        if params.lolloCapacity and params.lolloCapacity > 0 then
            result.personCapacity = {
                type = ({"RESIDENTIAL", "COMMERCIAL", "INDUSTRIAL"})[(params.lolloResComInd or 0) + 1],
                capacity = params.lolloCapacity * 5
            }
        else
            result.personCapacity = nil
        end

        print('LOLLO tweaked updateFn is about to return') debugPrint(result)

        return result
    end)
    print('LOLLO updateFn set')
end

return helpers

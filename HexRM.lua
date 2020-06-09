-- HexRM v0.3 beta
-- 作者：Sworgod
-- 邮箱：sworgod@qq.com
-- 文档地址：http://doc.szero.cn/HexRM/

HexRM = {
    MeterListNumber = { string = 1, image = 2, bar = 3, button = 4, bitmap = 5, line = 6, roundline = 7, histogram = 8, rotator = 9, shap = 10 },
    AnimationStatus = false,
    AnimationLastStatus = true,
    AnimationMeterList = {},
    AnimationMeterCount = 0,
    AnimationCount = 0,
    AnimationCountTime = 0,
    Performance = false,
    ControlStats = false,
    ControlList = {},
    ControlCount = 0,
    ControlCountTime = 0
}
function HexRM:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end
function HexRM:JsonToTable(JsonString)
    JsonString = string.gsub(JsonString, '":', '=')
    JsonString = string.gsub(JsonString, '{"', '{')
    JsonString = string.gsub(JsonString, ',"', ',')
    JsonString = string.gsub(JsonString, '%[', '{')
    JsonString = string.gsub(JsonString, '%]', '}')
    return loadstring("return " .. JsonString)()
end
function HexRM:TableToJSON(tableObject)
    return '{}'
end
function HexRM:FadeIn(MeterName, Option)
    return HexRM:AnimationPrefabAdd(MeterName, 1, Option, { aEnd = 255 })
end
function HexRM:FadeInUp(MeterName, Option)
    return self:AnimationPrefabAdd(MeterName, 2, Option, { toEnd = SKIN:GetMeter(MeterName):GetH(), aEnd = 255 })
end
function HexRM:FadeInLeft(MeterName, Option)
    return self:AnimationPrefabAdd(MeterName, 3, Option, { toEnd = SKIN:GetMeter(MeterName):GetW(), aEnd = 255 })
end
function HexRM:FadeOut(MeterName, Option)
    return self:AnimationPrefabAdd(MeterName, 4, Option, { aStart = 255 })
end
function HexRM:FadeOutUp(MeterName, Option)
    return self:AnimationPrefabAdd(MeterName, 5, Option, { inStart = SKIN:GetMeter(MeterName):GetH(), aStart = 255 })
end
function HexRM:FadeOutLeft(MeterName, Option)
    return self:AnimationPrefabAdd(MeterName, 6, Option, { inStart = SKIN:GetMeter(MeterName):GetW(), aStart = 255 })
end
function HexRM:FadeSlideInUp(MeterName, Option)
    local DefaultOption = { inStart = -20, toEnd = 0, aEnd = 255 }
    if not self.Performance then
        DefaultOption.inStart = Option.inStart or SKIN:GetMeter(MeterName):GetY() - SKIN:GetMeter(MeterName):GetH()
        DefaultOption.toEnd = Option.toEnd or SKIN:GetMeter(MeterName):GetY()
    end
    return self:AnimationPrefabAdd(MeterName, 7, Option, DefaultOption)
end
function HexRM:FadeSlideInRight(MeterName, Option)
    local DefaultOption = { inStart = -20, toEnd = 0, aEnd = 255 }
    if not self.Performance then
        DefaultOption.inStart = Option.inStart or SKIN:GetMeter(MeterName):GetX() + SKIN:GetMeter(MeterName):GetW()
        DefaultOption.toEnd = Option.toEnd or SKIN:GetMeter(MeterName):GetX()
    end
    return self:AnimationPrefabAdd(MeterName, 8, Option, DefaultOption)
end
function HexRM:FadeSlideInDown(MeterName, Option)
    return self:AnimationPrefabAdd(MeterName, 9, Option, { inStart = SKIN:GetMeter(MeterName):GetY() + SKIN:GetMeter(MeterName):GetH(), toEnd = SKIN:GetMeter(MeterName):GetY(), aEnd = 255 })
end
function HexRM:FadeSlideInLeft(MeterName, Option)
    return self:AnimationPrefabAdd(MeterName, 10, Option, { inStart = SKIN:GetMeter(MeterName):GetX() - SKIN:GetMeter(MeterName):GetW(), toEnd = SKIN:GetMeter(MeterName):GetX(), aEnd = 255 })
end
function HexRM:FadeSlideOutUp(MeterName, Option)
    return self:AnimationPrefabAdd(MeterName, 11, Option, { inStart = SKIN:GetMeter(MeterName):GetY(), toEnd = SKIN:GetMeter(MeterName):GetY() - SKIN:GetMeter(MeterName):GetH(), aStart = 255 })
end
function HexRM:FadeSlideOutRight(MeterName, Option)
    return self:AnimationPrefabAdd(MeterName, 12, Option, { inStart = SKIN:GetMeter(MeterName):GetX(), toEnd = SKIN:GetMeter(MeterName):GetX() + SKIN:GetMeter(MeterName):GetW(), aStart = 255 })
end
function HexRM:FadeSlideOutDown(MeterName, Option)
    return self:AnimationPrefabAdd(MeterName, 13, Option, { inStart = SKIN:GetMeter(MeterName):GetY(), toEnd = SKIN:GetMeter(MeterName):GetY() + SKIN:GetMeter(MeterName):GetH(), aStart = 255 })
end
function HexRM:FadeSlideOutLeft(MeterName, Option)
    return self:AnimationPrefabAdd(MeterName, 14, Option, { inStart = SKIN:GetMeter(MeterName):GetX(), toEnd = SKIN:GetMeter(MeterName):GetX() - SKIN:GetMeter(MeterName):GetW(), aStart = 255 })
end
function HexRM:FadeRotateIn(MeterName, Option)
    return self:AnimationPrefabAdd(MeterName, 15, Option, { inStart = 45, toEnd = 0, aEnd = 255 })
end
function HexRM:FadeRotateInEqual(MeterName, Option)
    return self:AnimationPrefabAdd(MeterName, 16, Option, { inStart = 45, toEnd = 0, aEnd = 255, option = { w = SKIN:GetMeter(MeterName):GetW(), h = SKIN:GetMeter(MeterName):GetH(), x = SKIN:GetMeter(MeterName):GetX(), y = SKIN:GetMeter(MeterName):GetY() } })
end
function HexRM:FadeRotateOut(MeterName, Option)
    return self:AnimationPrefabAdd(MeterName, 17, Option, { inStart = 0, toEnd = 45, aStart = 255 })
end
function HexRM:FadeRotateOutEqual(MeterName, Option)
    return self:AnimationPrefabAdd(MeterName, 18, Option, { inStart = 0, toEnd = 45, aStart = 255, option = { w = SKIN:GetMeter(MeterName):GetW(), h = SKIN:GetMeter(MeterName):GetH(), x = SKIN:GetMeter(MeterName):GetX(), y = SKIN:GetMeter(MeterName):GetY() } })
end

function HexRM:GetMeterType(MeterName)
    local meter = SKIN:GetMeter(MeterName)
    if not meter then
        return false
    end
    local type = SKIN:GetMeter(MeterName):GetOption('Meter')
    if type == nil or type == '' then
        return false
    end
    type = string.lower(type)
    return type
end

function HexRM:MeterType(MeterName)
    local type = self:GetMeterType(MeterName)
    if type then
        local number = self.MeterListNumber[type]
        if number == nil then
            return false
        end
        return number
    else
        return false
    end
end

function HexRM:AnimationGroupAdd(MeterName, GroupName)
    local group = SKIN:GetMeter(MeterName):GetOption('Group', '')
    GroupName = GroupName or 'AnimationGroup'
    if group ~= '' then
        GroupName = group .. '|' .. GroupName
    end
    SKIN:Bang('!SetOption', MeterName, 'Group', GroupName)
end

function HexRM:AnimationMeterListInit(CallBack)
    self.AnimationMeterList = {}
    self.AnimationMeterCount = 0
    if type(CallBack) == 'function' then
        CallBack()
    end
end

function HexRM:AnimationPrefabAdd(MeterName, AnimationType, Option, DefaultOption)
    local meterTypeNumber = self:MeterType(MeterName)
    if meterTypeNumber then
        if meterTypeNumber == 1 then
            if AnimationType == 2 or AnimationType == 3 or AnimationType == 5 or AnimationType == 6 then
                print('HexRM Warning:Unsupported Meter Type', 'MeterName:' .. MeterName, 'MeterType:' .. 'String')
                return false
            end
        end
    else
        return false
    end
    local defaultOption = { inStart = 0, toEnd = 0, aStart = 0, aEnd = 255, color = '255,255,255', startTime = 0, endTime = 10, delay = 0, tween = 1, debug = false, option = false }
    if not self:Empty(DefaultOption) and type(DefaultOption) == 'table' then
        for k, v in pairs(DefaultOption) do
            defaultOption[k] = v
        end
    end
    Option.color = Option.color or defaultOption.color
    Option.inStart = Option.inStart or defaultOption.inStart
    Option.toEnd = Option.toEnd or defaultOption.toEnd
    Option.aStart = Option.aStart or defaultOption.aStart
    Option.aEnd = Option.aEnd or defaultOption.aEnd
    Option.startTime = Option.startTime or defaultOption.startTime
    Option.endTime = Option.endTime or defaultOption.endTime
    Option.delay = Option.delay or defaultOption.delay
    Option.tween = Option.tween or defaultOption.tween
    Option.callback = Option.callback or false
    Option.option = Option.option or defaultOption.option
    if defaultOption.debug ~= nil then
        Option.debug = defaultOption.debug
    end
    if Option.status == nil then
        Option.status = true
    end
    local option = {}
    local _option = {
        field = '',
        inStart = Option.aStart,
        toEnd = Option.aEnd,
        startTime = Option.startTime,
        endTime = Option.endTime,
        delay = Option.delay,
        text = '',
        tween = Option.tween
    }
    if Option.callback then
        _option.callback = Option.callback
    end
    if Option.color then
        local colorArray = self:StringSplit(Option.color, ',')
        if #colorArray == 1 then
        elseif #colorArray == 2 then
        elseif #colorArray == 3 then
            _option.text = Option.color .. ',#result#'
        elseif #colorArray == 4 then
            _option.text = colorArray[1] .. ',' .. colorArray[2] .. ',' .. colorArray[3] .. ',#result#'
            _option.toEnd = tonumber(colorArray[4])
        end
    end
    if AnimationType == 1 or AnimationType == 4 then
        if Option.field == nil then
            if meterTypeNumber == 1 then
                _option.field = 'FontColor'
            elseif meterTypeNumber == 2 or meterTypeNumber == 3 or meterTypeNumber == 4 or meterTypeNumber == 9 then
                if Option.solidColor ~= nil then
                    _option.field = 'SolidColor'
                elseif Option.barColor ~= nil then
                    _option.field = 'BarColor'
                else
                    _option.field = 'ImageAlpha'
                    _option.text = ''
                end
            elseif meterTypeNumber == 6 or meterTypeNumber == 7 then
                _option.field = 'LineColor'
            elseif meterTypeNumber == 8 then
                _option.field = 'PrimaryColor'
            else
                return false
            end
        else
            _option.field = Option.field
        end
    elseif AnimationType == 2 or AnimationType == 5 then
        table.insert(option, {
            field = 'H',
            inStart = Option.inStart,
            toEnd = Option.toEnd,
            startTime = Option.startTime,
            endTime = Option.endTime,
            delay = Option.delay,
            text = '',
            tween = Option.tween
        })
        if meterTypeNumber == 2 or meterTypeNumber == 3 or meterTypeNumber == 4 or meterTypeNumber == 9 then
            if Option.solidColor ~= nil then
                SKIN:Bang('!SetOption', Option.meterName, 'SolidColor', Option.option.solidColor .. ',' .. self:AnimationExec(Id + 1))
            elseif Option.barColor ~= nil then
                SKIN:Bang('!SetOption', Option.meterName, 'BarColor', Option.option.barColor .. ',' .. self:AnimationExec(Id + 1))
            else
                _option.field = 'ImageAlpha'
                _option.text = ''
            end
        end
    elseif AnimationType == 3 or AnimationType == 6 then
        table.insert(option, {
            field = 'W',
            inStart = Option.inStart,
            toEnd = Option.toEnd,
            startTime = Option.startTime,
            endTime = Option.endTime,
            delay = Option.delay,
            text = '',
            tween = Option.tween
        })
        if meterTypeNumber == 1 then
            _option.field = 'FontColor'
        elseif meterTypeNumber == 2 or meterTypeNumber == 3 then
            _option.field = 'ImageAlpha'
            _option.text = ''
        end
    elseif AnimationType == 7 or AnimationType == 9 or AnimationType == 11 or AnimationType == 13 then
        table.insert(option, {
            field = 'Y',
            inStart = Option.inStart,
            toEnd = Option.toEnd,
            startTime = Option.startTime,
            endTime = Option.endTime,
            delay = Option.delay,
            text = '',
            tween = Option.tween
        })
        if meterTypeNumber == 1 then
            _option.field = 'FontColor'
        elseif meterTypeNumber == 2 or meterTypeNumber == 4 then
            _option.field = 'ImageAlpha'
            _option.text = ''
        end
    elseif AnimationType == 8 or AnimationType == 10 or AnimationType == 12 or AnimationType == 14 then
        table.insert(option, {
            field = 'X',
            inStart = Option.inStart,
            toEnd = Option.toEnd,
            startTime = Option.startTime,
            endTime = Option.endTime,
            delay = Option.delay,
            text = '',
            tween = Option.tween
        })
        --SKIN:GetMeter(Option.meterName):SetX( AnimationExec(Id))
        if meterTypeNumber == 1 then
            _option.field = 'FontColor'
        elseif meterTypeNumber == 2 or meterTypeNumber == 4 then
            _option.field = 'ImageAlpha'
            _option.text = ''
        end
    elseif AnimationType == 15 or AnimationType == 16 or AnimationType == 17 or AnimationType == 18 then
        if meterTypeNumber == 1 then
            table.insert(option, {
                field = 'Angle',
                inStart = Option.inStart,
                toEnd = Option.toEnd,
                startTime = Option.startTime,
                endTime = Option.endTime,
                delay = Option.delay,
                text = 'Rad(#result#)',
                tween = Option.tween
            })
            _option.field = 'FontColor'
        elseif meterTypeNumber == 2 or meterTypeNumber == 4 then
            local __option = {
                field = 'ImageRotate',
                inStart = Option.inStart,
                toEnd = Option.toEnd,
                startTime = Option.startTime,
                endTime = Option.endTime,
                delay = Option.delay,
                text = '',
                tween = Option.tween,
            }
            if AnimationType == 16 or AnimationType == 18 then
                __option.option = Option.option
                __option.callback = function(callbackMeterName, callbackResults)
                    if callbackResults.option then
                        local c = callbackResults.option.w / math.cos(math.rad(45 - callbackResults.number))
                        local C = (callbackResults.option.w ^ 2 + callbackResults.option.h ^ 2) ^ (1 / 2)
                        local multiple = C / c
                        SKIN:Bang('!SetOption', callbackMeterName, 'w', (callbackResults.option.w * multiple))
                        SKIN:Bang('!SetOption', callbackMeterName, 'h', (callbackResults.option.h * multiple))
                        SKIN:Bang('!SetOption', callbackMeterName, 'x', (callbackResults.option.x - (C - c) / 2))
                        SKIN:Bang('!SetOption', callbackMeterName, 'y', (callbackResults.option.y - (C - c) / 2))
                    end
                end
            end
            table.insert(option, __option)
            _option.field = 'ImageAlpha'
            _option.text = ''
        end
    else
        return false
    end
    table.insert(option, _option)
    return HexRM:AnimationMeterListAdd(MeterName, option, Option.status)
end

function HexRM:AnimationMeterListAdd(MeterName, Option, Status)
    if not self:GetMeterType(MeterName) then
        return false
    end
    local optionCount = 0
    if self:Empty(Option) then
        return false
    else
        for key, value in pairs(Option) do
            if self:Empty(value) then
                table.remove(Option, key)
            else
                if self:Empty(value.field) then
                    table.remove(Option, key)
                else
                    if Option[key].status == nil then
                        Option[key].status = true
                    end
                    Option[key].inStart = value.inStart or 0
                    Option[key].toEnd = value.toEnd or 0
                    if value.inStart == value.toEnd then
                        Option[key].status = false
                    end
                    Option[key].startTime = value.startTime or 0
                    Option[key].startTimeCache = Option[key].startTime
                    Option[key].endTime = value.endTime or 10
                    Option[key].delay = value.delay or 0
                    Option[key].text = value.text or ''
                    Option[key].tween = value.tween or 0
                    Option[key].callback = value.callback or false
                    Option[key].option = value.option or false
                    Option[key].infinite = value.infinite or false
                    optionCount = optionCount + 1
                end
            end
        end
    end
    if self:Empty(Option) then
        return false
    end
    if self.AnimationMeterList == nil then
        self:AnimationMeterListInit()
    end
    if Status == nil then
        Status = true
    end
    self.AnimationMeterCount = self.AnimationMeterCount + 1
    local AnimationId = self.AnimationMeterCount
    self.AnimationMeterList[AnimationId] = { meterName = MeterName, status = Status, option = Option, count = optionCount }
    return AnimationId
end

---初始化动画
---@param CallBack function 成功后回调函数
---@return boolean
function HexRM:AnimationInit(CallBack)
    self.AnimationLastStatus = false
    if self:Empty(self.AnimationMeterList) then
        return false
    end
    self.AnimationStatus = true
    self.AnimationStopList = {}
    self.AnimationCount = 0
    self.AnimationCountTime = 0
    local countTime = 0
    for key, value in pairs(self.AnimationMeterList) do
        if self.AnimationCountTime < 0 then
            self.AnimationCount = self.AnimationCount + table.getn(value.option)
            break
        end
        for k, v in pairs(value.option) do
            self.AnimationCount = self.AnimationCount + 1
            if v.infinite then
                self.AnimationCountTime = -1
            end
            if self.AnimationCountTime < 0 then
                break
            end
            countTime = v.endTime - v.startTime + v.delay
            if countTime > 0 and countTime > self.AnimationCountTime then
                self.AnimationCountTime = countTime
            end
        end
    end
    if type(CallBack) == 'function' then
        CallBack()
    end
    return true
end

function HexRM:AnimationAlgorithmRun(option)
    option.number = option.toEnd
    option.status = true
    if option.startTime < option.endTime then
        if option.delay > 0 then
            option.number = option.inStart
        else
            option.startTime = option.startTime + 1
            if option.startTime == option.endTime then
                option.status = false
                option.number = option.toEnd
            else
                local length = option.toEnd - option.inStart
                if option.tween == 1 then
                    option.number = self:EaseIn(option.startTime, length, option.endTime)
                elseif option.tween == 2 then
                    option.number = self:EaseOut(option.startTime, length, option.endTime)
                elseif option.tween == 3 then
                    option.number = self:EaseInOut(option.startTime, length, option.endTime)
                else
                    option.number = self:Linear(option.startTime, length, option.endTime)
                end
                option.number = option.number + option.inStart
            end
        end
    else
        option.startTime = option.endTime
        option.status = false
        option.number = option.toEnd
    end
    return option
end

---执行动画
---@param Id number 动画Id
function HexRM:AnimationRun(Id)
    if self.AnimationMeterList[Id] ~= nil then
        local animation = self.AnimationMeterList[Id]
        if animation.status then
            if self:Empty(animation.option) then
                self.AnimationMeterList[Id].status = false
                return false
            else
                local results = {}
                local animationStatusOverCount = 0
                for k, value in pairs(animation.option) do
                    if value.status then
                        local param = {
                            inStart = value.inStart,
                            toEnd = value.toEnd,
                            startTime = value.startTime,
                            endTime = value.endTime,
                            delay = value.delay,
                            tween = value.tween,
                        }
                        results = self:AnimationAlgorithmRun(param)
                        local result
                        if self:Empty(value.text) then
                            result = results.number
                        else
                            result = string.gsub(value.text, "#result#", results.number);
                        end
                        SKIN:Bang('!SetOption', animation.meterName, value.field, result)
                        if value.delay > 0 then
                            value.delay = value.delay - 1
                        else
                            value.startTime = results.startTime
                            if not results.status then
                                if value.infinite then
                                    local toEnd = value.toEnd
                                    value.toEnd = value.inStart
                                    value.inStart = toEnd
                                    value.startTime = value.startTimeCache
                                else
                                    value.status = results.status
                                    animationStatusOverCount = animationStatusOverCount + 1
                                    self.AnimationCount = self.AnimationCount - 1
                                    self:AnimationStatusCheck()
                                end
                            end
                            if value.callback and type(value.callback) == 'function' then
                                value.callback(animation.meterName, results)
                            end
                        end
                    else
                        animationStatusOverCount = animationStatusOverCount + 1
                    end
                end
                if self.AnimationCountTime > 0 and animationStatusOverCount >= animation.count then
                    self.AnimationMeterList[Id].status = false
                    self:AnimationStatusCheck()
                end
            end
        end
    end
end

---执行所有动画
---@param AutoRecycle boolean
---@param CallBack function 完成后回调函数
function HexRM:AnimationRunAll(AutoRecycle, CallBack)
    if not self.AnimationLastStatus then
        if type(AutoRecycle) == 'table' or type(AutoRecycle) == 'function' then
            CallBack = AutoRecycle
            AutoRecycle = false
        end
        if self:Empty(CallBack) then
            CallBack = { Start = false, Stop = false }
        elseif type(CallBack) == 'function' then
            CallBack = { Start = CallBack, Stop = false }
        else
            CallBack = { Start = (CallBack.start or false), Stop = (CallBack.stop or false) }
        end
        if self.AnimationStatus and not self:Empty(self.AnimationMeterList) then
            for Id, value in pairs(self.AnimationMeterList) do
                if value.status then
                    self:AnimationRun(Id)
                    SKIN:Bang('!UpdateMeter', value.meterName)
                else
                    if AutoRecycle then
                        self:AnimationRecycle(Id)
                    end
                end
            end
            if CallBack.Start and type(CallBack.Start) == 'function' then
                CallBack.Start()
            end
            if self:AnimationStatusCheck() then
                self.AnimationStatus = false
                self:AnimationRecycleAll()
                self:AnimationStopAll(CallBack.Stop)
            end
        else
            self:AnimationRecycleAll()
            self:AnimationStopAll(CallBack.Stop)
        end
    end
end
---开启动画执行
---@param Id number 动画Id
---@param CallBack function 成功后回调函数
---@return boolean
function HexRM:AnimationStart(Id, CallBack)
    if Id then
        local animation = self.AnimationMeterList[Id]
        if self:Empty(animation) then
            return false
        end
        if self:Empty(animation.option) then
            self.AnimationMeterList[Id].status = false
            return false
        else
            for key, value in pairs(animation.option) do
                self.AnimationMeterList[Id].option[key].startTime = value.startTimeCache
                self.AnimationMeterList[Id].option[key].status = true
            end
        end
        self:AnimationMeterStatusSetting(Id, true)
        if CallBack ~= nil and type(CallBack) == 'function' then
            CallBack()
        end
        return true
    end
    return false
end

---开启所有动画执行
---@param CallBack function 成功后回调函数
function HexRM:AnimationPauseAll(CallBack)
    if not self:Empty(self.AnimationMeterList) then
        for Id, animation in pairs(self.AnimationMeterList) do
            if self:Empty(animation) then
                return false
            end
            if self:Empty(animation.option) then
                self.AnimationMeterList[Id].status = false
                return false
            else
                for key, value in pairs(animation.option) do
                    self.AnimationMeterList[Id].option[key].startTime = value.startTimeCache
                    self.AnimationMeterList[Id].option[key].status = true
                end
            end
            self.AnimationMeterList[Id].status = true
        end
    end
    self.AnimationStatus = true
    if CallBack ~= nil and type(CallBack) == 'function' then
        CallBack()
    end
    return true
end

---暂停动画执行
---@param Id number 动画Id
---@param CallBack function 成功后回调函数
---@return boolean
function HexRM:AnimationPause(Id, CallBack)
    if Id then
        self:AnimationMeterStatusSetting(Id, false)
        if CallBack ~= nil and type(CallBack) == 'function' then
            CallBack()
        end
        return true
    end
    return false
end

---暂停所有动画执行
---@param CallBack function 成功后回调函数
function HexRM:AnimationPauseALL(CallBack)
    self.AnimationStatus = false
    if CallBack ~= nil and type(CallBack) == 'function' then
        CallBack()
    end
    return true
end

function HexRM:AnimationContinue(Id, CallBack)
    if Id then
        self:AnimationMeterStatusSetting(Id, true)
        if CallBack ~= nil and type(CallBack) == 'function' then
            CallBack()
        end
        return true
    end
    return false
end

function HexRM:AnimationContinueAll(CallBack)
    if not self:Empty(self.AnimationMeterList) then
        for Id, animation in pairs(self.AnimationMeterList) do
            if self:Empty(animation) then
                return false
            end
            if self:Empty(animation.option) then
                self.AnimationMeterList[Id].status = false
                return false
            else
                for key, value in pairs(animation.option) do
                    self.AnimationMeterList[Id].option[key].status = true
                end
            end
            self.AnimationMeterList[Id].status = true
        end
    end
    self.AnimationStatus = true
    if CallBack ~= nil and type(CallBack) == 'function' then
        CallBack()
    end
    return true
end

---停止动画执行
---@param Id number 动画Id
---@param CallBack function 成功后回调函数
---@return boolean
function HexRM:AnimationStop(Id, CallBack)
    if Id then
        local animation = self.AnimationMeterList[Id]
        if self:Empty(animation) then
            return false
        end
        if self:Empty(animation.option) then
            self.AnimationMeterList[Id].status = false
            return false
        else
            for key, value in pairs(animation.option) do
                self.AnimationMeterList[Id].option[key].startTime = value.endTime
            end
        end
        if CallBack ~= nil and type(CallBack) == 'function' then
            CallBack()
        end
        return true
    end
    return false
end

---停止所有动画执行
---@param CallBack function 成功后回调函数
---@return boolean
function HexRM:AnimationStopAll(CallBack)
    if not self:Empty(self.AnimationMeterList) then
        for Id, animation in pairs(self.AnimationMeterList) do
            if self:Empty(animation) then
                return false
            end
            if self:Empty(animation.option) then
                self.AnimationMeterList[Id].status = false
                return false
            else
                for key, value in pairs(animation.option) do
                    self.AnimationMeterList[Id].option[key].startTime = value.endTime
                end
            end
        end
    end
    self.AnimationLastStatus = true
    if CallBack ~= nil and type(CallBack) == 'function' then
        CallBack()
    end
end

function HexRM:AnimationRecycle(Id, CallBack)
    if Id then
        if not self:Empty(self.AnimationMeterList[Id]) then
            table.remove(self.AnimationMeterList, Id)
            if CallBack ~= nil and type(CallBack) == 'function' then
                CallBack()
            end
            return true
        end
    end
    return false
end

function HexRM:AnimationRecycleAll(CallBack)
    if not self:Empty(self.AnimationMeterList) then
        for Id, animation in pairs(self.AnimationMeterList) do
            if not self:Empty(self.AnimationMeterList[Id]) then
                table.remove(self.AnimationMeterList, Id)
            end
        end
    end
    if CallBack ~= nil and type(CallBack) == 'function' then
        CallBack()
    end
end

---动画状态检查
---@return boolean true 已经完成所有动画  false 正在执行动画
function HexRM:AnimationStatusCheck()
    if self.AnimationCount < 1 then
        self.AnimationStatus = false
        return true
    end
    return false
end

function HexRM:AnimationMeterStatusSetting(Id, Status)
    if self.AnimationMeterList[Id] ~= nil then
        if Status == nil then
            if self.AnimationMeterList[Id].status then
                Status = false
            else
                Status = true
            end
        end
        if Status then
            self.AnimationLastStatus = false
            self.AnimationStatus = true
        end
        self.AnimationMeterList[Id].status = Status
    end
end

---设置动画选项
---@param Id number 动画Id
---@param Option table 动画选项
---@return boolean true 设置成功  false 设置失败
function HexRM:AnimationOptionSetting(Id, Option)
    if not self:Empty(Id) and not self:Empty(self.AnimationMeterList[Id]) and not self:Empty(Option) then
        local animation = self.AnimationMeterList[Id]
        if self:Empty(animation) then
            return false
        end
        if self:Empty(animation.option) then
            self.AnimationMeterList[Id].status = false
            return false
        else
            for key, value in pairs(animation.option) do
                for k, v in pairs(Option) do
                    if value[k] ~= nil then
                        self.AnimationMeterList[Id].option[key][k] = v
                    end
                end
            end
        end
        return true
    end
    return false
end

function HexRM:AnimationActionTimer(Option)
    Option = Option or {}
    Option.MeasureActionTimerName = Option.MeasureActionTimerName or 'MeasureActionTimer'
    Option.MeasureScriptName = Option.MeasureScriptName or 'MeasureScript'
    Option.ExecName = Option.ExecName or 'Start'
    Option.WaitTime = Option.WaitTime or 30
    Option.ExecStart = Option.ExecStart or true
    if self.AnimationCount > 120 and Option.WaitTime < 31 then
        Option.WaitTime = math.floor(self.AnimationCount / 2)
    end
    SKIN:Bang('!SetOption', Option.MeasureActionTimerName, 'DynamicVariables', '1')
    SKIN:Bang('!SetOption', Option.MeasureActionTimerName, 'ActionList1', 'Repeat Start,' .. Option.WaitTime .. ',' .. self.AnimationCountTime)
    SKIN:Bang('!SetOption', Option.MeasureActionTimerName, 'Start', '[!CommandMeasure ' .. Option.MeasureScriptName .. ' ' .. Option.ExecName .. '()][!UpdateMeasure ' .. Option.MeasureActionTimerName .. '][!UpdateMeterGroup AnimationGroup][!Redraw]')
    SKIN:Bang('!UpdateMeasure', Option.MeasureActionTimerName)
    if Option.ExecStart then
        SKIN:Bang('!CommandMeasure', Option.MeasureActionTimerName, 'Execute 1')
    end
end

function HexRM:AnimationString(Len)
    local String = 'ABCDEFGHIJKMNOPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz0123456789~!@#$%^&*()-=_+[]{};\'\\:"|,./<>?/'
    local srt = {}
    for i = 1, Len do
        local index = math.random(1, 25)
        srt[i] = string.sub(String, index, index)
    end
    return table.concat(srt, '')
end

---判断是否为空
---@param param nil 任意类型值
---@return boolean true 为空 false 不为空
function HexRM:Empty(param)
    if param == nil or param == '' then
        return true
    else
        if type(param) == 'table' then
            if next(param) == nil then
                return true
            end
        elseif not param then
            return true
        end
    end
    return false
end

---分割字符串
---@param separator string
---@param string string
---@param limit number
---@return table
function HexRM:StringSplit(string, separator, limit)
    local result = {}
    local count = 0
    limit = limit or 0
    string.gsub(string, '[^' .. separator .. ']+', function(w)
        count = count + 1
        if limit > 0 and limit == count then
            return
        end
        table.insert(result, w)
    end)
    return result
end

---贝塞尔曲线算法
---@param t number 当前百分比
---@param ax number 控制点1 X轴坐标
---@param ay number 控制点1 Y轴坐标
---@param bx number 控制点2 X轴坐标
---@param by number 控制点2 Y轴坐标
function HexRM:CubicBezier(t, ax, ay, bx, by)
    local point1 = { x = 0, y = 0 }
    local point2 = { x = 1, y = 1 }
    local x = point1.x * (1 - t) * (1 - t) * (1 - t) + 3 * ax * t * (1 - t) * (1 - t) + 3 * bx * t * t * (1 - t) + point2.x * t * t * t
    local y = point1.y * (1 - t) * (1 - t) * (1 - t) + 3 * ay * t * (1 - t) * (1 - t) + 3 * by * t * t * (1 - t) + point2.y * t * t * t
    return x * y
end

---Tween EaseInOut
function HexRM:EaseInOut(st, c, et)
    return c * self:CubicBezier(st / et, 1, 0, 0, 1);
end

---Tween EaseOut
function HexRM:EaseOut(st, c, et)
    --t = t / d - 1
    --return -c * (t * t * t * t - 1) + b
    return c * self:CubicBezier(st / et, 0, 0, 0, 1);
end

---Tween EaseIn
function HexRM:EaseIn(st, c, et)
    --t = t / d
    --return c * t * t * t * t + b
    return c * self:CubicBezier(st / et, 1, 0, 1, 1);
end

---Tween Linear
function HexRM:Linear(st, c, et)
    --return c * t / d + b;
    return c * self:CubicBezier(st / et, 0, 0, 1, 1);
end

function HexRM:ControlAdd(SkinName, delay)
    if delay == nil then
        delay = 0
    end
    table.insert(self.ControlList, {
        SkinName = SkinName,
        delay = delay
    })
    self.ControlCount = self.ControlCount + 1
    if self.ControlCountTime < delay then
        self.ControlCountTime = delay
    end
    SKIN:Bang('!DeactivateConfig', SkinName)
end

function HexRM:ControlInit(ActionTimerOption)
    if not self:Empty(ActionTimerOption) then
        if ActionTimerOption == true then
            ActionTimerOption = {}
        end
        ActionTimerOption = ActionTimerOption or {}
        ActionTimerOption.MeasureActionTimerName = ActionTimerOption.MeasureActionTimerName or 'MeasureActionTimer'
        ActionTimerOption.MeasureScriptName = ActionTimerOption.MeasureScriptName or 'MeasureScript'
        ActionTimerOption.ExecName = ActionTimerOption.ExecName or 'Start'
        ActionTimerOption.WaitTime = ActionTimerOption.WaitTime or 1000
        ActionTimerOption.ExecStart = ActionTimerOption.ExecStart or true
        self.ControlCountTime = self.ControlCountTime + 2
        SKIN:Bang('!SetOption', ActionTimerOption.MeasureActionTimerName, 'DynamicVariables', '1')
        SKIN:Bang('!SetOption', ActionTimerOption.MeasureActionTimerName, 'ActionList1', 'Repeat Start,' .. ActionTimerOption.WaitTime .. ',' .. self.ControlCountTime)
        --SKIN:Bang('!SetOption', ActionTimerOption.MeasureActionTimerName, 'ActionList1', 'Repeat Start,' .. ActionTimerOption.WaitTime)
        SKIN:Bang('!SetOption', ActionTimerOption.MeasureActionTimerName, 'Start', '[!CommandMeasure ' .. ActionTimerOption.MeasureScriptName .. ' ' .. ActionTimerOption.ExecName .. '()][!UpdateMeasure ' .. ActionTimerOption.MeasureActionTimerName .. '][!Redraw]')
        SKIN:Bang('!UpdateMeasure', ActionTimerOption.MeasureActionTimerName)
        if ActionTimerOption.ExecStart then
            SKIN:Bang('!CommandMeasure', ActionTimerOption.MeasureActionTimerName, 'Execute 1')
        end
    end
    self.ControlStats = true
end

function HexRM:ControlRunAll()
    if self.ControlStats then
        if not self:Empty(self.ControlList) and self.ControlCount > 0 then
            for key, value in pairs(self.ControlList) do
                if value.delay > 0 then
                    self.ControlList[key].delay = value.delay - 1
                else
                    SKIN:Bang('!ActivateConfig', value.SkinName)
                end
            end
        end
    end
end
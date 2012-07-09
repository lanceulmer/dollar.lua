display.setStatusBar(display.HiddenStatusBar)

local dollar = require('dollar')
local D      = dollar.DollarRecognizer()
local shape  = nil
local points = {}

local bg = display.newRect(0,0,display.contentWidth,display.contentHeight)

local results = display.newText('Result: ', 0, 0, nil, 32)
results:setTextColor(0, 0, 0)
results:setReferencePoint(display.CenterReferencePoint)
results.x, results.y = display.contentWidth * 0.5, 50

local draw = function(points)
    if #points == 2 then
        if shape then
            display.remove(shape)
        end
        shape = display.newLine(points[1].X,points[1].Y,points[2].X,points[2].Y)
        shape:setColor(1,142,223)
        shape.width = 10
    elseif #points > 2 then
        shape:append(points[#points].X,points[#points].Y)
    end
end

local adapter = function(points)
    result = D.Recognize(points, true);
    return 'Result: ' .. result.Name
end

local function onTouch(event)
    if event.phase == 'began' then
        results.text = 'Recording unistroke...'
        points = {}
        local this = {}
        this.X = event.x
        this.Y = event.y
        points[#points+1] = this
        draw(points)
    elseif event.phase == 'moved' then
        local this = {}
        this.X = event.x
        this.Y = event.y
        points[#points+1] = this
        draw(points)
    elseif event.phase == 'ended' or event.phase == 'cancelled' then
        results.text = adapter(points)
    end
end

Runtime:addEventListener('touch', onTouch)

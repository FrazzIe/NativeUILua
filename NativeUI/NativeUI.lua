UIResRectangle = setmetatable({}, UIResRectangle)
UIResRectangle.__index = UIResRectangle
UIResRectangle.__call = function() return "Rectangle" end
UIResText = setmetatable({}, UIResText)
UIResText.__index = UIResText
UIResText.__call = function() return "Text" end
Sprite = setmetatable({}, Sprite)
Sprite.__index = Sprite
Sprite.__call = function() return "Sprite" end
UIMenuItem = setmetatable({}, UIMenuItem)
UIMenuItem.__index = UIMenuItem
UIMenuItem.__call = function() return "UIMenuItem", "UIMenuItem" end
UIMenuCheckboxItem = setmetatable({}, UIMenuCheckboxItem)
UIMenuCheckboxItem.__index = UIMenuCheckboxItem
UIMenuCheckboxItem.__call = function() return "UIMenuItem", "UIMenuCheckboxItem" end
UIMenuListItem = setmetatable({}, UIMenuListItem)
UIMenuListItem.__index = UIMenuListItem
UIMenuListItem.__call = function() return "UIMenuItem", "UIMenuListItem" end
UIMenuSliderItem = setmetatable({}, UIMenuSliderItem)
UIMenuSliderItem.__index = UIMenuSliderItem
UIMenuSliderItem.__call = function() return "UIMenuItem", "UIMenuSliderItem" end
UIMenuColouredItem = setmetatable({}, UIMenuColouredItem)
UIMenuColouredItem.__index = UIMenuColouredItem
UIMenuColouredItem.__call = function() return "UIMenuItem", "UIMenuColouredItem" end
UIMenu = setmetatable({}, UIMenu)
UIMenu.__index = UIMenu
UIMenu.__call = function() return "UIMenu" end
MenuPool = setmetatable({}, MenuPool)
MenuPool.__index = MenuPool

function FormatXWYH(Value, Value2)
    local W, H = GetScreenResolution()
    local XW = Value/W - ((Value / W) - (Value / 1920))
    local YH = Value2/H - ((Value2 / H) - (Value2 / 1080))
    return XW, YH
end

function math.round(num, numDecimalPlaces)
	return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

function tobool(input)
	if input == "true" or tonumber(input) == 1 or input == true then
		return true
	else
		return false
	end
end

function string.split(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end

	return t
end

function string.starts(String, Start)
	return string.sub(String, 1, string.len(Start)) == Start
end

function GetScreenResolutionMaintainRatio()
	local W, H = GetActiveScreenResolution()
	return {Width = 1080 * (W/H), Height = 1080}
end

function IsMouseInBounds(X, Y, Width, Height)
	local Resolution = GetScreenResolutionMaintainRatio()
	local MX, MY = math.round(GetControlNormal(0, 239) * 1920), math.round(GetControlNormal(0, 240) * 1080)
    MX, MY = FormatXWYH(MX, MY)
    X, Y = FormatXWYH(X, Y)
    Width, Height = FormatXWYH(Width, Height)
	return (MX >= X and MX <= X + Width) and (MY > Y and MY < Y + Height)
end

function GetSafeZoneBounds()
	local SafeSize = GetSafeZoneSize()
	SafeSize = math.round(SafeSize, 2)
	SafeSize = (SafeSize * 100) - 90
	SafeSize = 10 - SafeSize

	local W, H = 1920, 1080

	return {X = math.round(SafeSize * ((W/H) * 5.4)), Y = math.round(SafeSize * 5.4)}
end

function Controller()
	return not IsInputDisabled(2)
end

function UIResRectangle.New(X, Y, Width, Height, R, G, B, A)
	local _UIResRectangle = {
		X = tonumber(X) or 0,
		Y = tonumber(Y) or 0,
		Width = tonumber(Width) or 0,
		Height = tonumber(Height) or 0,
		_Colour = {R = tonumber(R) or 255, G = tonumber(G) or 255, B = tonumber(B) or 255, A = tonumber(A) or 255},
	}
	return setmetatable(_UIResRectangle, UIResRectangle)
end

function UIResRectangle:Position(X, Y)
	if tonumber(X) and tonumber(Y) then
		self.X = tonumber(X)
		self.Y = tonumber(Y)
	else
		return {X = self.X, Y = self.Y}
	end
end

function UIResRectangle:Size(Width, Height)
	if tonumber(Width) and tonumber(Height) then
		self.Width = tonumber(Width)
		self.Height = tonumber(Height)
	else
		return {Width = self.Width, Height = self.Height}
	end
end

function UIResRectangle:Colour(R, G, B, A)
    if tonumber(R) and tonumber(G) and tonumber(B) and tonumber(A) then
        self._Colour.R = tonumber(R)
        self._Colour.B = tonumber(B)
        self._Colour.G = tonumber(G)
        self._Colour.A = tonumber(A)
    else
    	return self._Colour
    end
end

function UIResRectangle:Draw()
	local Position = self:Position()
	local Size = self:Size()
	Size.Width, Size.Height = FormatXWYH(Size.Width, Size.Height)
    Position.X, Position.Y = FormatXWYH(Position.X, Position.Y)
	DrawRect(Position.X + Size.Width * 0.5, Position.Y + Size.Height * 0.5, Size.Width, Size.Height, self._Colour.R, self._Colour.G, self._Colour.B, self._Colour.A)
end

function DrawRectangle(X, Y, Width, Height, R, G, B, A)
    X, Y, Width, Height = X or 0, Y or 0, Width or 0, Height or 0
    X, Y = FormatXWYH(X, Y)
    Width, Height = FormatXWYH(Width, Height)
    DrawRect(X + Width * 0.5, Y + Height * 0.5, Width, Height, tonumber(R) or 255, tonumber(G) or 255, tonumber(B) or 255, tonumber(A) or 255)
end

function GetCharacterCount(str)
    local characters = 0
    for c in str:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
        local a = c:byte(1, -1)
        if a ~= nil then
            characters = characters + 1
        end
    end
    return characters
end

function GetByteCount(str)
    local bytes = 0

    for c in str:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
        local a,b,c,d = c:byte(1, -1)
        if a ~= nil then
            bytes = bytes + 1
        end
        if b ~= nil then
            bytes = bytes + 1
        end
        if c ~= nil then
            bytes = bytes + 1
        end
        if d ~= nil then
            bytes = bytes + 1
        end
    end
    return bytes
end

function AddLongStringForAscii(str)
    local maxbytelength = 99
    for i = 0, GetCharacterCount(str), 99 do
        AddTextComponentSubstringPlayerName(string.sub(str, i, math.min(maxbytelength, GetCharacterCount(str) - i))) --needs changed
    end
end

function AddLongStringForUtf8(str)
    local maxbytelength = 99
    local bytecount = GetByteCount(str)

    if bytecount < maxbytelength then
        AddTextComponentSubstringPlayerName(str)
        return
    end

    local startIndex = 0

    for i = 0, GetCharacterCount(str), 1 do
        local length = i - startIndex
        if GetByteCount(string.sub(str, startIndex, length)) > maxbytelength then
            AddTextComponentSubstringPlayerName(string.sub(str, startIndex, length - 1))
            i = i - 1
            startIndex = startIndex + (length - 1)
        end
    end
    AddTextComponentSubstringPlayerName(string.sub(str, startIndex, GetCharacterCount(str) - startIndex))
end 

function AddLongString(str)
    local bytecount = GetByteCount(str)
    if bytecount == GetCharacterCount(str) then
        AddLongStringForAscii(str)
    else
        AddLongStringForUtf8(str)
    end
end

function MeasureStringWidthNoConvert(str, font, scale)
    BeginTextCommandWidth("STRING")
    AddLongString(str)
    return EndTextCommandGetWidth(font) * scale
end

function MeasureStringWidth(str, font, scale)
    return MeasureStringWidthNoConvert(str, font, scale) * 1920
end

function UIResText.New(Text, X, Y, Scale, R, G, B, A, Font, Alignment, DropShadow, Outline, WordWrap)
	local _UIResText = {
        _Text = tostring(Text) or "",
        X = tonumber(X) or 0,
        Y = tonumber(Y) or 0,
        Scale = tonumber(Scale) or 0,
        _Colour = {R = tonumber(R) or 255, G = tonumber(G) or 255, B = tonumber(B) or 255, A = tonumber(A) or 255},
        Font = tonumber(Font) or 0,
        Alignment = Alignment or nil,
        DropShadow = Dropshadow or nil,
        Outline = Outline or nil,
        WordWrap = tonumber(WordWrap) or 0,
    }
	return setmetatable(_UIResText, UIResText)
end

function UIResText:Position(X, Y)
    if tonumber(X) and tonumber(Y) then
        self.X = tonumber(X)
        self.Y = tonumber(Y)
    else
        return {X = self.X, Y = self.Y}
    end
end

function UIResText:Colour(R, G, B, A)
    if tonumber(R) and tonumber(G) and tonumber(B) and tonumber(A) then
        self._Colour.R = tonumber(R)
        self._Colour.B = tonumber(B)
        self._Colour.G = tonumber(G)
        self._Colour.A = tonumber(A)
    else
        return self._Colour
    end
end

function UIResText:Text(Text)
    if tostring(Text) and Text ~= nil then
        self._Text = tostring(Text)
    else
        return self._Text
    end
end

function UIResText:Draw()
    local Position = self:Position()
    Position.X, Position.Y = FormatXWYH(Position.X, Position.Y)

    SetTextFont(self.Font)
    SetTextScale(1.0, self.Scale)
    SetTextColour(self._Colour.R, self._Colour.G, self._Colour.B, self._Colour.A)

    if self.DropShadow then
        SetTextDropShadow()
    end
    if self.Outline then
        SetTextOutline()
    end

    if self.Alignment ~= nil then
        if self.Alignment == 1 or self.Alignment == "Center" or self.Alignment == "Centre" then
            SetTextCentre(true)
        elseif self.Alignment == 2 or self.Alignment == "Right" then
            SetTextRightJustify(true)
            SetTextWrap(0, Position.X)
        end
    end

    if tonumber(self.WordWrap) then
        if tonumber(self.WordWrap) ~= 0 then
            SetTextWrap(Position.X, Position.X + (tonumber(self.WordWrap) / Resolution.Width))
        end
    end

    BeginTextCommandDisplayText("STRING")
    AddLongString(self._Text)
    EndTextCommandDisplayText(Position.X, Position.Y)
end

function DrawText(Text, X, Y, Font, Scale, R, G, B, A, Alignment, DropShadow, Outline, WordWrap)
    X, Y = FormatXWYH(X, Y)
    SetTextFont(Font or 0)
    SetTextScale(1.0, Scale or 0)
    SetTextColour(R or 255, G or 255, B or 255, A or 255)

    if DropShadow then
        SetTextDropShadow()
    end
    if Outline then
        SetTextOutline()
    end

    if Alignment ~= nil then
        if Alignment == 1 or Alignment == "Center" or Alignment == "Centre" then
            SetTextCentre(true)
        elseif Alignment == 2 or Alignment == "Right" then
            SetTextRightJustify(true)
            SetTextWrap(0, X)
        end
    end

    if tonumber(WordWrap) then
        if tonumber(WordWrap) ~= 0 then
            SetTextWrap(X, X + (tonumber(WordWrap) / Resolution.Width))
        end
    end

    BeginTextCommandDisplayText("STRING")
    AddLongString(Text)
    EndTextCommandDisplayText(X, Y)
end

function Sprite.New(TxtDictionary, TxtName, X, Y, Width, Height, Heading, R, G, B, A)
	local _Sprite = {
		TxtDictionary = tostring(TxtDictionary),
		TxtName = tostring(TxtName),
		X = tonumber(X) or 0,
		Y = tonumber(Y) or 0,
		Width = tonumber(Width) or 0, 
		Height = tonumber(Height) or 0,
		Heading = tonumber(Heading) or 0,
		_Colour = {R = tonumber(R) or 255, G = tonumber(G) or 255, B = tonumber(B) or 255, A = tonumber(A) or 255},
	}
	return setmetatable(_Sprite, Sprite)
end

function Sprite:Position(X, Y)
	if tonumber(X) and tonumber(Y) then
		self.X = tonumber(X)
		self.Y = tonumber(Y)
	else
		return {X = self.X, Y = self.Y}
	end
end

function Sprite:Size(Width, Height)
	if tonumber(Width) and tonumber(Width) then
		self.Width = tonumber(Width)
		self.Height = tonumber(Height)
	else
		return {Width = self.Width, Height = self.Height}
	end
end

function Sprite:Colour(R, G, B, A)
	if tonumber(R) and tonumber(G) and tonumber(B) and tonumber(A) then
		self._Colour.R = tonumber(R)
		self._Colour.B = tonumber(B)
		self._Colour.G = tonumber(G)
		self._Colour.A = tonumber(A)
	else
		return self._Colour
	end
end

function Sprite:Draw()
	if not HasStreamedTextureDictLoaded(self.TxtDictionary) then
		RequestStreamedTextureDict(self.TxtDictionary, true)
	end
	local Resolution = GetScreenResolutionMaintainRatio()
	local Position = self:Position()
	local Size = self:Size()
	Size.Width, Size.Height = FormatXWYH(Size.Width, Size.Height)
    Position.X, Position.Y = FormatXWYH(Position.X, Position.Y)
	DrawSprite(self.TxtDictionary, self.TxtName, Position.X + Size.Width * 0.5, Position.Y + Size.Height * 0.5, Size.Width, Size.Height, self.Heading, self._Colour.R, self._Colour.G, self._Colour.B, self._Colour.A)
end

function DrawTexture(TxtDictionary, TxtName, X, Y, Width, Height, Heading, R, G, B, A)
	if not HasStreamedTextureDictLoaded(tostring(TxtDictionary) or "") then
		RequestStreamedTextureDict(tostring(TxtDictionary) or "", true)
	end
	X, Y, Width, Height = X or 0, Y or 0, Width or 0, Height or 0
    X, Y = FormatXWYH(X, Y)
    Width, Height = FormatXWYH(Width, Height)
	DrawSprite(tostring(TxtDictionary) or "", tostring(TxtName) or "", X + Width * 0.5, Y + Height * 0.5, Width, Height, tonumber(Heading) or 0, tonumber(R) or 255, tonumber(G) or 255, tonumber(B) or 255, tonumber(A) or 255)
end

CharacterMap = {
	[' '] = 6, ['!'] = 6,['"'] = 6, ['#'] = 11,['$'] = 10, ['%'] = 17,['&'] = 13, ['\\'] = 4,['('] = 6, [')'] = 6,['*'] = 7,	['+'] = 10,	[','] = 4,	['-'] = 6,	['.'] = 4,	['/'] = 7,	['0'] = 12,	['1'] = 7,	['2'] = 11,	['3'] = 11,	['4'] = 11,	['5'] = 11,	['6'] = 12,	['7'] = 10,	['8'] = 11,	['9'] = 11,	[':'] = 5,	[';'] = 4,	['<'] = 9,	['='] = 9,	['>'] = 9,	['?'] = 10,	['@'] = 15,	['A'] = 12,	['B'] = 13,	['C'] = 14,	['D'] = 14,	['E'] = 12,	['F'] = 12,	['G'] = 15,	['H'] = 14,	['I'] = 5,	['J'] = 11,	['K'] = 13,	['L'] = 11,	['M'] = 16,	['N'] = 14,	['O'] = 16,	['P'] = 12,	['Q'] = 15,	['R'] = 13,	['S'] = 12,	['T'] = 11,	['U'] = 13,	['V'] = 12,	['W'] = 18,	['X'] = 11,	['Y'] = 11,	['Z'] = 12,	['['] = 6,	[']'] = 6,	['^'] = 9,	['_'] = 18,	['`'] = 8,	['a'] = 11,	['b'] = 12,	['c'] = 11,	['d'] = 12,	['e'] = 12,	['f'] = 5,	['g'] = 13,	['h'] = 11,	['i'] = 4,	['j'] = 4,	['k'] = 10,	['l'] = 4,	['m'] = 18,	['n'] = 11,	['o'] = 12,	['p'] = 12,	['q'] = 12,	['r'] = 7,	['s'] = 9,	['t'] = 5,	['u'] = 11,	['v'] = 10,	['w'] = 14,	['x'] = 9,	['y'] = 10,	['z'] = 9,	['{'] = 6,	['|'] = 3,	['}'] = 6,
}

function MeasureString(str)
	local output = 0
	for i = 1, GetCharacterCount(str), 1 do
		if CharacterMap[string.sub(str, i, i)] then
			output = output + CharacterMap[string.sub(str, i, i)] + 1
		end
	end
	return output
end

BadgeStyle = {
	None = 0,
	BronzeMedal = 1,
	GoldMedal = 2,
	SilverMedal = 3,
	Alert = 4,
	Crown = 5,
	Ammo = 6,
	Armour = 7,
	Barber = 8,
	Clothes = 9,
	Franklin = 10,
	Bike = 11,
	Car = 12,
	Gun = 13,
	Heart = 14,
	Makeup = 15,
	Mask = 16,
	Michael = 17,
	Star = 18,
	Tattoo = 19,
	Trevor = 20, 
	Lock = 21,
	Tick = 22
}

BadgeTexture = {
	[0] = function() return "" end,
	[1] = function() return "mp_medal_bronze" end,
	[2] = function() return "mp_medal_gold"	end,
	[3] = function() return "medal_silver" end,
	[4] = function() return "mp_alerttriangle" end,
	[5] = function() return "mp_hostcrown" end,
	[6] = function(Selected) if Selected then return "shop_ammo_icon_b"	else return "shop_ammo_icon_a" end end,
	[7] = function(Selected) if Selected then return "shop_armour_icon_b" else return "shop_armour_icon_a" end end,
	[8] = function(Selected) if Selected then return "shop_barber_icon_b" else return "shop_barber_icon_a"	end	end,
	[9] = function(Selected) if Selected then return "shop_clothing_icon_b"	else return "shop_clothing_icon_a" end end,
	[10] = function(Selected) if Selected then return "shop_franklin_icon_b" else return "shop_franklin_icon_a"	end	end,
	[11] = function(Selected) if Selected then return "shop_garage_bike_icon_b" else return "shop_garage_bike_icon_a" end end,
	[12] = function(Selected) if Selected then return "shop_garage_icon_b" else return "shop_garage_icon_a"	end	end,
	[13] = function(Selected) if Selected then return "shop_gunclub_icon_b" else return "shop_gunclub_icon_a" end end,
	[14] = function(Selected) if Selected then return "shop_health_icon_b" else return "shop_health_icon_a"	end	end,
	[15] = function(Selected) if Selected then return "shop_makeup_icon_b" else	return "shop_makeup_icon_a"	end	end,
	[16] = function(Selected) if Selected then return "shop_mask_icon_b" else return "shop_mask_icon_a"	end	end,
	[17] = function(Selected) if Selected then return "shop_michael_icon_b"	else return "shop_michael_icon_a" end end,
	[18] = function() return "shop_new_star" end,
	[19] = function(Selected) if Selected then return "shop_tattoos_icon_b"	else return "shop_tattoos_icon_" end end,
	[20] = function(Selected) if Selected then return "shop_trevor_icon_b" else return "shop_trevor_icon_a"	end	end,
	[21] = function() return "shop_lock" end,
	[22] = function() return "shop_tick_icon" end,
}

BadgeDictionary = {
	[0] = function(Selected)
		if Selected then
			return "commonmenu"
		else
			return "commonmenu"
		end
	end,
}

BadgeColour = {
	[5] = function(Selected) if Selected then return 0, 0, 0, 255 else return 255, 255, 255, 255 end end,
	[21] = function(Selected) if Selected then return 0, 0, 0, 255 else	return 255, 255, 255, 255 end end,
	[22] = function(Selected) if Selected then return 0, 0, 0, 255 else return 255, 255, 255, 255	end	end,
}

function GetBadgeTexture(Badge, Selected)
	if BadgeTexture[Badge] then
		return BadgeTexture[Badge](Selected)
	else
		return ""
	end
end

function GetBadgeDictionary(Badge, Selected)
	if BadgeDictionary[Badge] then
		return BadgeDictionary[Badge](Selected)
	else
		return "commonmenu"
	end
end

function GetBadgeColour(Badge, Selected)
	if BadgeColour[Badge] then
		return BadgeColour[Badge](Selected)
	else
		return 255, 255, 255, 255
	end
end

function UIMenuItem.New(Text, Description)
	_UIMenuItem = {
		Rectangle = UIResRectangle.New(0, 0, 431, 38, 255, 255, 255, 20),
		Text = UIResText.New(tostring(Text) or "", 8, 0, 0.33, 245, 245, 245, 255, 0),
		_Description = tostring(Description) or "";
		SelectedSprite = Sprite.New("commonmenu", "gradient_nav", 0, 0, 431, 38),
		LeftBadge = { Sprite = Sprite.New("commonmenu", "", 0, 0, 40, 40), Badge = 0},
		RightBadge = { Sprite = Sprite.New("commonmenu", "", 0, 0, 40, 40), Badge = 0},
		LabelText = UIResText.New("", 0, 0, 0.35, 245, 245, 245, 255, 0, "Right"),
		_Selected = false,
		_Hovered = false,
		_Enabled = true,
		_Offset = {X = 0, Y = 0},
		ParentMenu = nil,
		Activated = function(menu) end
	}
	return setmetatable(_UIMenuItem, UIMenuItem)
end

function UIMenuItem:SetParentMenu(Menu)
	if Menu() == "UIMenu" then
		self.ParentMenu = Menu
	else
		return self.ParentMenu
	end
end

function UIMenuItem:Selected(bool)
	if bool ~= nil then
		self._Selected = tobool(bool)
	else
		return self._Selected
	end
end

function UIMenuItem:Hovered(bool)
	if bool ~= nil then
		self._Hovered = tobool(bool)
	else
		return self._Hovered
	end
end

function UIMenuItem:Enabled(bool)
	if bool ~= nil then
		self._Enabled = tobool(bool)
	else
		return self._Enabled
	end
end

function UIMenuItem:Description(str)
	if tostring(str) and str ~= nil then
		self._Description = tostring(str)
	else
		return self._Description
	end
end

function UIMenuItem:Offset(X, Y)
	if tonumber(X) or tonumber(Y) then
		if tonumber(X) then
			self._Offset.X = tonumber(X)
		end
		if tonumber(Y) then
			self._Offset.Y = tonumber(Y)
		end
	else
		return self._Offset
	end
end

function UIMenuItem:Position(Y)
	if tonumber(Y) then
		self.Rectangle:Position(self._Offset.X, Y + 144 + self._Offset.Y)
		self.SelectedSprite:Position(0 + self._Offset.X, Y + 144 + self._Offset.Y)
		self.Text:Position(8 + self._Offset.X, Y + 147 + self._Offset.Y)
		self.LeftBadge.Sprite:Position(0 + self._Offset.X, Y + 142 + self._Offset.Y)
		self.RightBadge.Sprite:Position(385 + self._Offset.X, Y + 142 + self._Offset.Y)
		self.LabelText:Position(420 + self._Offset.X, Y + 148 + self._Offset.Y)
	end
end

function UIMenuItem:RightLabel(Text)
	if tostring(Text) and Text ~= nil then
		self.LabelText:Text(tostring(Text))
	else
		return self.LabelText:Text()
	end
end

function UIMenuItem:SetLeftBadge(Badge)
	if tonumber(Badge) then
		self.LeftBadge.Badge = tonumber(Badge)
	end
end

function UIMenuItem:SetRightBadge(Badge)
	if tonumber(Badge) then
		self.RightBadge.Badge = tonumber(Badge)
	end
end

function UIMenuItem:Text(Text)
	if tostring(Text) and Text ~= nil then
		self.Text:Text(tostring(Text))
	else
		return self.Text:Text()
	end
end

function UIMenuItem:Draw()
	self.Rectangle:Size(431 + self.ParentMenu.WidthOffset, 38)
	self.SelectedSprite:Size(431 + self.ParentMenu.WidthOffset, 38)

	if self._Hovered and not self._Selected then
		self.Rectangle:Draw()
	end

	if self._Selected then
		self.SelectedSprite:Draw()
	end

	if self._Enabled then
		if self._Selected then
			self.Text:Colour(0, 0, 0, 255)
		else
			self.Text:Colour(245, 245, 245, 255)
		end
	else
		self.Text:Colour(163, 159, 148, 255)
	end

	if self.LeftBadge.Badge == BadgeStyle.None then
		self.Text:Position(8 + self._Offset.X, self.Text.Y)
	else
		self.Text:Position(35 + self._Offset.X, self.Text.Y)
		self.LeftBadge.Sprite.TxtDictionary = GetBadgeDictionary(self.LeftBadge.Badge, self._Selected)
		self.LeftBadge.Sprite.TxtName = GetBadgeTexture(self.LeftBadge.Badge, self._Selected)
		self.LeftBadge.Sprite:Colour(GetBadgeColour(self.LeftBadge.Badge, self._Selected))
		self.LeftBadge.Sprite:Draw()
	end

	if self.RightBadge.Badge ~= BadgeStyle.None then
		self.RightBadge.Sprite:Position(385 + self._Offset.X + self.ParentMenu.WidthOffset, self.RightBadge.Sprite.Y)
		self.RightBadge.Sprite.TxtDictionary = GetBadgeDictionary(self.RightBadge.Badge, self._Selected)
		self.RightBadge.Sprite.TxtName = GetBadgeTexture(self.RightBadge.Badge, self._Selected)
		self.RightBadge.Sprite:Colour(GetBadgeColour(self.RightBadge.Badge, self._Selected))
		self.RightBadge.Sprite:Draw()
	end

	if self.LabelText:Text() ~= "" and string.len(self.LabelText:Text()) > 0 then
		self.LabelText:Position(420 + self._Offset.X + self.ParentMenu.WidthOffset, self.LabelText.Y)
		self.LabelText:Draw()
	end

	self.Text:Draw()
end

function UIMenuCheckboxItem.New(Text, Check, Description)
	local _UIMenuCheckboxItem = {
		Base = UIMenuItem.New(Text or "", Description or ""),
		CheckedSprite = Sprite.New("commonmenu", "shop_box_blank", 410, 95, 50, 50),
		Checked = tobool(Check),
		CheckboxEvent = function(item, checked) end,
	}
	return setmetatable(_UIMenuCheckboxItem, UIMenuCheckboxItem)
end

function UIMenuCheckboxItem:SetParentMenu(Menu)
	if Menu() == "UIMenu" then
		self.Base.ParentMenu = Menu
	else
		return self.Base.ParentMenu
	end
end

function UIMenuCheckboxItem:Position(Y)
	if tonumber(Y) then
		self.Base:Position(Y)
		self.CheckedSprite:Position(380 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, Y + 138 + self.Base._Offset.Y)
	end
end

function UIMenuCheckboxItem:Selected(bool)
	if bool ~= nil then
		self.Base._Selected = tobool(bool)
	else
		return self.Base._Selected
	end
end

function UIMenuCheckboxItem:Hovered(bool)
	if bool ~= nil then
		self.Base._Hovered = tobool(bool)
	else
		return self.Base._Hovered
	end
end

function UIMenuCheckboxItem:Enabled(bool)
	if bool ~= nil then
		self.Base._Enabled = tobool(bool)
	else
		return self.Base._Enabled
	end
end

function UIMenuCheckboxItem:Description(str)
	if tostring(str) and str ~= nil then
		self.Base._Description = tostring(str)
	else
		return self.Base._Description
	end
end

function UIMenuCheckboxItem:Offset(X, Y)
	if tonumber(X) or tonumber(Y) then
		if tonumber(X) then
			self.Base._Offset.X = tonumber(X)
		end
		if tonumber(Y) then
			self.Base._Offset.Y = tonumber(Y)
		end
	else
		return self.Base._Offset
	end
end

function UIMenuCheckboxItem:Text(Text)
	if tostring(Text) and Text ~= nil then
		self.Base.Text:Text(tostring(Text))
	else
		return self.Base.Text:Text()
	end
end

function UIMenuCheckboxItem:SetLeftBadge()
	error("This item does not support badges")
end

function UIMenuCheckboxItem:SetRightBadge()
	error("This item does not support badges")
end

function UIMenuCheckboxItem:RightLabel()
	error("This item does not support a right label")
end

function UIMenuCheckboxItem:Draw()
	self.Base:Draw()
	self.CheckedSprite:Position(380 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, self.CheckedSprite.Y)
	if self.Base:Selected() then
		if self.Checked then
			self.CheckedSprite.TxtName = "shop_box_tickb"
		else
			self.CheckedSprite.TxtName = "shop_box_blankb"
		end
	else
		if self.Checked then
			self.CheckedSprite.TxtName = "shop_box_tick"
		else
			self.CheckedSprite.TxtName = "shop_box_blank"
		end
	end
	self.CheckedSprite:Draw()
end

function UIMenuListItem.New(Text, Items, Index, Description)
	if type(Items) ~= "table" then Items = {} end
	if Index == 0 then Index = 1 end
	local _UIMenuListItem = {
		Base = UIMenuItem.New(Text or "", Description or ""),
		Items = Items,
		LeftArrow = Sprite.New("commonmenu", "arrowleft", 110, 105, 30, 30),
		RightArrow = Sprite.New("commonmenu", "arrowright", 280, 105, 30, 30),
		ItemText = UIResText.New("", 290, 104, 0.35, 255, 255, 255, 255, 0, "Right"),
		_Index = tonumber(Index) or 1,
		OnListChanged = function(newindex) end,
		OnListSelected = function(index) end,
	}
	return setmetatable(_UIMenuListItem, UIMenuListItem)
end

function UIMenuListItem:SetParentMenu(Menu)
	if Menu() == "UIMenu" then
		self.Base.ParentMenu = Menu
	else
		return self.Base.ParentMenu
	end
end

function UIMenuListItem:Position(Y)
	if tonumber(Y) then
		self.LeftArrow:Position(300 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, 147 + Y + self.Base._Offset.Y)
		self.RightArrow:Position(400 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, 147 + Y + self.Base._Offset.Y)
		self.ItemText:Position(300 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, 147 + Y + self.Base._Offset.Y)
		self.Base:Position(Y)
	end
end

function UIMenuListItem:Selected(bool)
	if bool ~= nil then
		self.Base._Selected = tobool(bool)
	else
		return self.Base._Selected
	end
end

function UIMenuListItem:Hovered(bool)
	if bool ~= nil then
		self.Base._Hovered = tobool(bool)
	else
		return self.Base._Hovered
	end
end

function UIMenuListItem:Enabled(bool)
	if bool ~= nil then
		self.Base._Enabled = tobool(bool)
	else
		return self.Base._Enabled
	end
end

function UIMenuListItem:Description(str)
	if tostring(str) and str ~= nil then
		self.Base._Description = tostring(str)
	else
		return self.Base._Description
	end
end

function UIMenuListItem:Offset(X, Y)
	if tonumber(X) or tonumber(Y) then
		if tonumber(X) then
			self.Base._Offset.X = tonumber(X)
		end
		if tonumber(Y) then
			self.Base._Offset.Y = tonumber(Y)
		end
	else
		return self.Base._Offset
	end
end

function UIMenuListItem:Text(Text)
	if tostring(Text) and Text ~= nil then
		self.Base.Text:Text(tostring(Text))
	else
		return self.Base.Text:Text()
	end
end

function UIMenuListItem:Index(Index)
	if tonumber(Index) then
		if tonumber(Index) > #self.Items then
			self._Index = 1
		elseif tonumber(Index) < 1 then
			self._Index = #self.Items
		else
			self._Index = tonumber(Index)
		end
	else
		return self._Index
	end
end

function UIMenuListItem:ItemToIndex(Item)
	for i = 1, #self.Items do
		if type(Item) == type(self.Items[i]) and Item == self.Items[i] then
			return self.Items[i]
		end
	end
end

function UIMenuListItem:IndexToItem(Index)
	if tonumber(Index) then
		if tonumber(Index) == 0 then Index = 1 end
		if self.Items[tonumber(Index)] then
			return self.Items[tonumber(Index)]
		end
	end
end

function UIMenuListItem:SetLeftBadge()
	error("This item does not support badges")
end

function UIMenuListItem:SetRightBadge()
	error("This item does not support badges")
end

function UIMenuListItem:RightLabel()
	error("This item does not support a right label")
end

function UIMenuListItem:Draw()
	self.Base:Draw()

	if self:Enabled() then
		if self:Selected() then
			self.ItemText:Colour(0, 0, 0, 255)
			self.LeftArrow:Colour(0, 0, 0, 255)
			self.RightArrow:Colour(0, 0, 0, 255)
		else
			self.ItemText:Colour(245, 245, 245, 255)
			self.LeftArrow:Colour(245, 245, 245, 255)
			self.RightArrow:Colour(245, 245, 245, 255)
		end
	else
		self.ItemText:Colour(163, 159, 148, 255)
		self.LeftArrow:Colour(163, 159, 148, 255)
		self.RightArrow:Colour(163, 159, 148, 255)
	end

	local Text = tostring(self.Items[self._Index])
	local Offset = MeasureStringWidth(Text, 0, 0.35)

	self.ItemText:Text(Text)
	self.LeftArrow:Position(378 - Offset + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, self.LeftArrow.Y)

	if self:Selected() then
		self.LeftArrow:Draw()
		self.RightArrow:Draw()
		self.ItemText:Position(403 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, self.ItemText.Y)
	else
		self.ItemText:Position(418 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, self.ItemText.Y)
	end

	self.ItemText:Draw()
end

function UIMenuSliderItem.New(Text, Items, Index, Description, Divider)
	if type(Items) ~= "table" then Items = {} end
	if Index == 0 then Index = 1 end
	local _UIMenuSliderItem = {
		Base = UIMenuItem.New(Text or "", Description or ""),
		Items = Items,
		ShowDivider = tobool(Divider),
		LeftArrow = Sprite.New("commonmenutu", "arrowleft", 0, 105, 15, 15),
		RightArrow = Sprite.New("commonmenutu", "arrowright", 0, 105, 15, 15),
		Background = UIResRectangle.New(0, 0, 150, 9, 4, 32, 57, 255),
		Slider = UIResRectangle.New(0, 0, 75, 9, 57, 116, 200, 255),
		Divider = UIResRectangle.New(0, 0, 2.5, 20, 245, 245, 245, 255),
		_Index = tonumber(Index) or 1,
		OnSliderChanged = function(newindex) end,
		OnSliderSelected = function(index) end,
	}
	return setmetatable(_UIMenuSliderItem, UIMenuSliderItem)
end

function UIMenuSliderItem:SetParentMenu(Menu)
	if Menu() == "UIMenu" then
		self.Base.ParentMenu = Menu
	else
		return self.Base.ParentMenu
	end
end

function UIMenuSliderItem:Position(Y)
	if tonumber(Y) then
		self.Background:Position(250 + self.Base._Offset.X, Y + 158.5 + self.Base._Offset.Y)
		self.Slider:Position(250 + self.Base._Offset.X, Y + 158.5 + self.Base._Offset.Y)
		self.Divider:Position(323.5 + self.Base._Offset.X, Y + 153 + self.Base._Offset.Y)
		self.LeftArrow:Position(235 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, 155.5 + Y + self.Base._Offset.Y)
		self.RightArrow:Position(400 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, 155.5 + Y + self.Base._Offset.Y)
		self.Base:Position(Y)
	end
end

function UIMenuSliderItem:Selected(bool)
	if bool ~= nil then
		self.Base._Selected = tobool(bool)
	else
		return self.Base._Selected
	end
end

function UIMenuSliderItem:Hovered(bool)
	if bool ~= nil then
		self.Base._Hovered = tobool(bool)
	else
		return self.Base._Hovered
	end
end

function UIMenuSliderItem:Enabled(bool)
	if bool ~= nil then
		self.Base._Enabled = tobool(bool)
	else
		return self.Base._Enabled
	end
end

function UIMenuSliderItem:Description(str)
	if tostring(str) and str ~= nil then
		self.Base._Description = tostring(str)
	else
		return self.Base._Description
	end
end

function UIMenuSliderItem:Offset(X, Y)
	if tonumber(X) or tonumber(Y) then
		if tonumber(X) then
			self.Base._Offset.X = tonumber(X)
		end
		if tonumber(Y) then
			self.Base._Offset.Y = tonumber(Y)
		end
	else
		return self.Base._Offset
	end
end

function UIMenuSliderItem:Text(Text)
	if tostring(Text) and Text ~= nil then
		self.Base.Text:Text(tostring(Text))
	else
		return self.Base.Text:Text()
	end
end

function UIMenuSliderItem:Index(Index)
	if tonumber(Index) then
		if tonumber(Index) > #self.Items then
			self._Index = 1
		elseif tonumber(Index) < 1 then
			self._Index = #self.Items
		else
			self._Index = tonumber(Index)
		end
	else
		return self._Index
	end
end

function UIMenuSliderItem:ItemToIndex(Item)
	for i = 1, #self.Items do
		if type(Item) == type(self.Items[i]) and Item == self.Items[i] then
			return self.Items[i]
		end
	end
end

function UIMenuSliderItem:IndexToItem(Index)
	if tonumber(Index) then
		if tonumber(Index) == 0 then Index = 1 end
		if self.Items[tonumber(Index)] then
			return self.Items[tonumber(Index)]
		end
	end
end

function UIMenuSliderItem:SetLeftBadge()
	error("This item does not support badges")
end

function UIMenuSliderItem:SetRightBadge()
	error("This item does not support badges")
end

function UIMenuSliderItem:RightLabel()
	error("This item does not support a right label")
end

function UIMenuSliderItem:Draw()
	self.Base:Draw()

	if self:Enabled() then
		if self:Selected() then
			self.LeftArrow:Colour(0, 0, 0, 255)
			self.RightArrow:Colour(0, 0, 0, 255)
		else
			self.LeftArrow:Colour(245, 245, 245, 255)
			self.RightArrow:Colour(245, 245, 245, 255)
		end
	else
		self.LeftArrow:Colour(163, 159, 148, 255)
		self.RightArrow:Colour(163, 159, 148, 255)
	end
	
	local Offset = ((self.Background.Width - self.Slider.Width)/(#self.Items - 1)) * (self._Index-1)

	self.Slider:Position(250 + self.Base._Offset.X + Offset, self.Slider.Y)

	if self:Selected() then
		self.LeftArrow:Draw()
		self.RightArrow:Draw()
	end

	self.Background:Draw()
	self.Slider:Draw()
	if self.ShowDivider then
		self.Divider:Draw()
	end
end

function UIMenuColouredItem.New(Text, Description, MainColour, HighlightColour)
	if type(Colour) ~= "table" then Colour = {R = 0, G = 0, B = 0, A = 255} end
	if type(HighlightColour) ~= "table" then Colour = {R = 255, G = 255, B = 255, A = 255} end
	local _UIMenuColouredItem = {
		Base = UIMenuItem.New(Text or "", Description or ""),
		Rectangle = UIResRectangle.New(0, 0, 431, 38, MainColour.R, MainColour.G, MainColour.B, MainColour.A),
		MainColour = MainColour,
		HighlightColour = HighlightColour,
	}
	_UIMenuColouredItem.Base.SelectedSprite:Colour(HighlightColour.R, HighlightColour.G, HighlightColour.B, HighlightColour.A)
	return setmetatable(_UIMenuColouredItem, UIMenuColouredItem)
end

function UIMenuColouredItem:SetParentMenu(Menu)
	if Menu() == "UIMenu" then
		self.Base.ParentMenu = Menu
	else
		return self.Base.ParentMenu
	end
end

function UIMenuColouredItem:Position(Y)
	if tonumber(Y) then
		self.Base:Position(Y)
		self.Rectangle:Position(self.Base._Offset.X, Y + 144 + self.Base._Offset.Y)
	end
end

function UIMenuColouredItem:Selected(bool)
	if bool ~= nil then
		self.Base._Selected = tobool(bool)
	else
		return self.Base._Selected
	end
end

function UIMenuColouredItem:Hovered(bool)
	if bool ~= nil then
		self.Base._Hovered = tobool(bool)
	else
		return self.Base._Hovered
	end
end

function UIMenuColouredItem:Enabled(bool)
	if bool ~= nil then
		self.Base._Enabled = tobool(bool)
	else
		return self.Base._Enabled
	end
end

function UIMenuColouredItem:Description(str)
	if tostring(str) and str ~= nil then
		self.Base._Description = tostring(str)
	else
		return self.Base._Description
	end
end

function UIMenuColouredItem:Offset(X, Y)
	if tonumber(X) or tonumber(Y) then
		if tonumber(X) then
			self.Base._Offset.X = tonumber(X)
		end
		if tonumber(Y) then
			self.Base._Offset.Y = tonumber(Y)
		end
	else
		return self.Base._Offset
	end
end

function UIMenuColouredItem:Text(Text)
	if tostring(Text) and Text ~= nil then
		self.Base.Text:Text(tostring(Text))
	else
		return self.Base.Text:Text()
	end
end

function UIMenuColouredItem:RightLabel(Text)
	if tostring(Text) and Text ~= nil then
		self.Base.LabelText:Text(tostring(Text))
	else
		return self.Base.LabelText:Text()
	end
end

function UIMenuColouredItem:SetLeftBadge(Badge)
	if tonumber(Badge) then
		self.Base.LeftBadge.Badge = tonumber(Badge)
	end
end

function UIMenuColouredItem:SetRightBadge(Badge)
	if tonumber(Badge) then
		self.Base.RightBadge.Badge = tonumber(Badge)
	end
end

function UIMenuColouredItem:Draw()
	self.Rectangle:Draw()
	self.Base:Draw()
end

function UIMenu.New(Title, Subtitle, X, Y, TxtDictionary, TxtName)
	local X, Y = tonumber(X) or 0, tonumber(Y) or 0
	if Title ~= nil then Title = tostring(Title) or "" else Title = "" end
	if Subtitle ~= nil then Subtitle = tostring(Subtitle) or "" else Subtitle = "" end
	if TxtDictionary ~= nil then TxtDictionary = tostring(TxtDictionary) or "commonmenu" else TxtDictionary = "commonmenu" end
	if TxtName ~= nil then TxtName = tostring(TxtName) or "interaction_bgd" else TxtName = "interaction_bgd" end
	local _UIMenu = {
		Logo = Sprite.New(TxtDictionary, TxtName, 0 + X, 0 + Y, 431, 107),
		Banner = nil,
		Title = UIResText.New(Title, 215 + X, 20 + Y, 1.15, 255, 255, 255, 255, 1, 1),
		Subtitle = {ExtraY = 0},
		WidthOffset = 0,
		Position = {X = X, Y = Y},
		Pagination = {Min = 0, Max = 9, Total = 9},
		PageCounter = {PreText = ""},
		Extra = {},
		Description = {},
		Items = {},
		Children = {},
		Controls = {},
		ParentMenu = nil,
		ParentItem = nil,
		_Visible = false,
		ActiveItem = 1000,
		Dirty = false;
		ReDraw = true,
		InstructionalScaleform = RequestScaleformMovie("INSTRUCTIONAL_BUTTONS"),
		InstructionalButtons = {},
		OnIndexChange = function(menu, newindex) end,
		OnListChange = function(menu, list, newindex) end,
		OnSliderChange = function(menu, slider, newindex) end,
		OnCheckboxChange = function(menu, item, checked) end,
		OnListSelect = function(menu, list, index) end,
		OnSliderSelect = function(menu, slider, index) end,
		OnItemSelect = function(menu, item, index) end,
		OnMenuChanged = function(menu, newmenu, forward) end,
		OnMenuClosed = function(menu) end,
		Settings = {
			InstructionalButtons = true,
			FormatDescriptions = true,
			ScaleWithSafezone = true,
			ResetCursorOnOpen = true,
			MouseControlsEnabled = true,
			MouseEdgeEnabled = true,
			ControlDisablingEnabled = true,
			Audio = {
				Library = "HUD_FRONTEND_DEFAULT_SOUNDSET",
				UpDown = "NAV_UP_DOWN",
				LeftRight = "NAV_LEFT_RIGHT",
				Select = "SELECT",
				Back = "BACK",
				Error = "ERROR",
			},
		}
	}

	if Subtitle ~= "" and Subtitle ~= nil then
		_UIMenu.Subtitle.Rectangle = UIResRectangle.New(0 + _UIMenu.Position.X, 107 + _UIMenu.Position.Y, 431, 37, 0, 0, 0, 255)
		_UIMenu.Subtitle.Text = UIResText.New(Subtitle, 8 + _UIMenu.Position.X, 110 + _UIMenu.Position.Y, 0.35, 245, 245, 245, 255, 0)
		if string.starts(Subtitle, "~") then
			_UIMenu.PageCounter.PreText = string.sub(Subtitle, 1, 3)
		end
		_UIMenu.PageCounter.Text = UIResText.New("", 425 + _UIMenu.Position.X, 110 + _UIMenu.Position.Y, 0.35, 245, 245, 245, 255, 0, "Right")
		_UIMenu.Subtitle.ExtraY = 37
	end
	
	_UIMenu.ArrowSprite = Sprite.New("commonmenu", "shop_arrows_upanddown", 190 + _UIMenu.Position.X, 147 + 37 * (_UIMenu.Pagination.Total + 1) + _UIMenu.Position.Y - 37 + _UIMenu.Subtitle.ExtraY, 50, 50)
	_UIMenu.Extra.Up = UIResRectangle.New(0 + _UIMenu.Position.X, 144 + 38 * (_UIMenu.Pagination.Total + 1) + _UIMenu.Position.Y - 37 + _UIMenu.Subtitle.ExtraY, 431, 18, 0, 0, 0, 200)
	_UIMenu.Extra.Down = UIResRectangle.New(0 + _UIMenu.Position.X, 144 + 18 + 38 * (_UIMenu.Pagination.Total + 1) + _UIMenu.Position.Y - 37 + _UIMenu.Subtitle.ExtraY, 431, 18, 0, 0, 0, 200)

	_UIMenu.Description.Bar = UIResRectangle.New(_UIMenu.Position.X, 123, 431, 4, 0, 0, 0, 255)
	_UIMenu.Description.Rectangle = Sprite.New("commonmenu", "gradient_bgd", _UIMenu.Position.X, 127, 431, 30)
	_UIMenu.Description.Text = UIResText.New("Description", _UIMenu.Position.X + 5, 125, 0.35)

	_UIMenu.Background = Sprite.New("commonmenu", "gradient_bgd", _UIMenu.Position.X, 144 + _UIMenu.Position.Y - 37 + _UIMenu.Subtitle.ExtraY, 290, 25)

	Citizen.CreateThread(function()
		if not HasScaleformMovieLoaded(_UIMenu.InstructionalScaleform) then
			_UIMenu.InstructionalScaleform = RequestScaleformMovie("INSTRUCTIONAL_BUTTONS")
			while not HasScaleformMovieLoaded(_UIMenu.InstructionalScaleform) do
				Citizen.Wait(0)
			end
		end
	end)
	return setmetatable(_UIMenu, UIMenu)
end

function UIMenu:SetMenuWidthOffset(Offset)
	if tonumber(Offset) then
		self.WidthOffset = math.floor(tonumber(Offset))
		self.Logo:Size(431 + self.WidthOffset, 107)
		self.Title:Position((self.WidthOffset + self.Position.X + 431) / 2, 20 + self.Position.Y)
		self.PageCounter.Text:Position(425 + self.Position.X + self.WidthOffset, 110 + self.Position.Y)
		if self.Banner ~= nil then
			self.Banner:Size(431 + self.WidthOffset, 107)
		end
	end
end

function UIMenu:DisEnableControls(bool)
	if bool then
		EnableAllControlActions(2)
	else
		DisableAllControlActions(2)
	end

	if bool then
		return
	else
		if Controller() then
			EnableControlAction(0, 2, true)
			EnableControlAction(0, 1, true)
			EnableControlAction(0, 25, true)
			EnableControlAction(0, 24, true)
		else
			EnableControlAction(0, 201, true)
			EnableControlAction(0, 195, true)
			EnableControlAction(0, 196, true)
			EnableControlAction(0, 187, true)
			EnableControlAction(0, 188, true)
			EnableControlAction(0, 189, true)
			EnableControlAction(0, 190, true)
			EnableControlAction(0, 202, true)
			EnableControlAction(0, 217, true)
			EnableControlAction(0, 242, true)
			EnableControlAction(0, 241, true)
			EnableControlAction(0, 239, true)
			EnableControlAction(0, 240, true)
			EnableControlAction(0, 31, true)
			EnableControlAction(0, 30, true)
			EnableControlAction(0, 21, true)
			EnableControlAction(0, 22, true)
			EnableControlAction(0, 23, true)
			EnableControlAction(0, 75, true)
			EnableControlAction(0, 71, true)
			EnableControlAction(0, 72, true)
			EnableControlAction(0, 59, true)
			EnableControlAction(0, 89, true)
			EnableControlAction(0, 9, true)
			EnableControlAction(0, 8, true)
			EnableControlAction(0, 90, true)
			EnableControlAction(0, 76, true)
		end
	end
end

function UIMenu:InstructionalButtons(bool)
	if bool ~= nil then
		self.Settings.InstrucitonalButtons = tobool(bool)
	end
end

function UIMenu:SetBannerSprite(Sprite)
	if Sprite() == "Sprite" then
		self.Logo = Sprite
		self.Logo:Size(431 + self.WidthOffset, 107)
		self.Logo:Position(self.Position.X, self.Position.Y)
		self.Banner = nil
	end
end

function UIMenu:SetBannerRectangle(Rectangle)
	if Rectangle() == "Rectangle" then
		self.Banner = Rectangle
		self.Banner:Size(431 + self.WidthOffset, 107)
		self.Banner:Position(self.Position.X, self.Position.Y)
		self.Logo = nil
	end
end

function UIMenu:CurrentSelection(value)
	if tonumber(value) then
		if #self.Items == 0 then
			self.ActiveItem = 0
		end

		self.Items[self:CurrentSelection()]:Selected(false)
		self.ActiveItem = 1000000 - (1000000 % #self.Items) + tonumber(value)

		if self:CurrentSelection() > self.Pagination.Max then
			self.Pagination.Min = self:CurrentSelection() - self.Pagination.Total
			self.Pagination.Max = self:CurrentSelection()
		elseif self:CurrentSelection() < self.Pagination.Min then
			self.Pagination.Min = self:CurrentSelection()
			self.Pagination.Max = self:CurrentSelection() + self.Pagination.Total
		end 
	else
		if #self.Items == 0 then
			return 1
		else
			if self.ActiveItem % #self.Items == 0 then
				return 1
			else
				return self.ActiveItem % #self.Items + 1
			end
		end
	end
end

function UIMenu:RecaulculateDescriptionPosition()
	self.Description.Bar:Position(self.Position.X, 149 - 37 + self.Subtitle.ExtraY + self.Position.Y)
	self.Description.Rectangle:Position(self.Position.X, 149 - 37 + self.Subtitle.ExtraY + self.Position.Y)
	self.Description.Text:Position(self.Position.X + 8, 155 - 37 + self.Subtitle.ExtraY + self.Position.Y)

	self.Description.Bar:Size(431 + self.WidthOffset, 4)
	self.Description.Rectangle:Size(431 + self.WidthOffset, 30)

	local count = #self.Items
	if count > self.Pagination.Total + 1 then
		count = self.Pagination.Total + 2
	end

	self.Description.Bar:Position(self.Position.X, 38 * count + self.Description.Bar:Position().Y)
	self.Description.Rectangle:Position(self.Position.X, 38 * count + self.Description.Rectangle:Position().Y)
	self.Description.Text:Position(self.Position.X + 8, 38 * count + self.Description.Text:Position().Y)
end

function UIMenu:AddItem(Item)
	if Item() == "UIMenuItem" then
		local SelectedItem = self:CurrentSelection()
		Item:SetParentMenu(self)
		Item:Offset(self.Position.X, self.Position.Y)
		Item:Position((#self.Items * 25) - 37 + self.Subtitle.ExtraY)
		table.insert(self.Items, Item)
		self:RecaulculateDescriptionPosition()
		self:CurrentSelection(SelectedItem)
	end
end

function UIMenu:RemoveItemAt(Index)
	if tonumber(Index) then
		if self.Items(Index) then
			local SelectedItem = self:CurrentSelection()
			if #self.Items > self.Pagination.Total and self.Pagination.Max == #self.Items - 1 then
				self.Pagination.Min = self.Pagination.Min - 1
				self.Pagination.Max = self.Pagination.Max + 1
			end
			table.remove(self.Items, tonumber(Index))
			self:RecaulculateDescriptionPosition()
			self:CurrentSelection(SelectedItem)
		end
	end
end

function UIMenu:RefreshIndex()
	if #self.Items == 0 then
		self.ActiveItem = 1000
		self.Pagination.Max = self.Pagination.Total + 1
		self.Pagination.Min = 0
		return
	end
	self.Items[self:CurrentSelection()]:Selected(false)
	self.ActiveItem = 1000 - (1000 % #self.Items)
	self.Pagination.Max = self.Pagination.Total + 1
	self.Pagination.Min = 0
	self.ReDraw = true
end

function UIMenu:Clear()
	self.Items = {}
	self:RecaulculateDescriptionPosition()
end

function UIMenu:FormatDescription(str)
	if tostring(str) then

		local PixelPerLine = 425 + self.WidthOffset
		local AggregatePixels = 0
		local output = ""
		local words = string.split(tostring(str), " ")

		for i = 1, #words do
			local offset = MeasureStringWidth(words[i], 0, 0.35)
			AggregatePixels = AggregatePixels + offset
			if AggregatePixels > PixelPerLine then
				output = output .. "\n" .. words[i] .. " "
				AggregatePixels = offset + MeasureString(" ")
			else
				output = output .. words[i] .. " "
				AggregatePixels = AggregatePixels + MeasureString(" ")
			end
		end
		return output
	end
end

function UIMenu:DrawCalculations()
	if #self.Items > self.Pagination.Total + 1 then
		self.Background:Size(431 + self.WidthOffset, 38 * (self.Pagination.Total + 1))
	else
		self.Background:Size(431 + self.WidthOffset, 38 * #self.Items)
	end

	self.Extra.Up:Size(431 + self.WidthOffset, 18)
	self.Extra.Down:Size(431 + self.WidthOffset, 18)

	if self.WidthOffset > 0 then
		self.ArrowSprite:Position(190 + self.Position.X + (self.WidthOffset / 2), 147 + 37 * (self.Pagination.Total + 1) + self.Position.Y - 37 + self.Subtitle.ExtraY)
	else
		self.ArrowSprite:Position(190 + self.Position.X + self.WidthOffset, 147 + 37 * (self.Pagination.Total + 1) + self.Position.Y - 37 + self.Subtitle.ExtraY)
	end

	self.ReDraw = false

	if #self.Items ~= 0 and self.Items[self:CurrentSelection()]:Description() ~= "" then
		self:RecaulculateDescriptionPosition()

		local description = self.Items[self:CurrentSelection()]:Description()
		if self.Settings.FormatDescriptions then
			self.Description.Text:Text(self:FormatDescription(description))
		else
			self.Description.Text:Text(description)
		end

		self.Description.Rectangle:Size(431 + self.WidthOffset, (#string.split(self.Description.Text:Text(), "\n") * 25) + 15)
	end
end

function UIMenu:Visible(bool)
	if bool ~= nil then
		self._Visible = tobool(bool)
		self.JustOpened = tobool(bool)
		self.Dirty = tobool(bool)
		self:UpdateScaleform()
		if self.ParentMenu ~= nil or tobool(bool) == false then
			return
		end
		if self.Settings.ResetCursorOnOpen then
			local W, H = GetScreenResolution()
			SetCursorLocation(W / 2, H / 2)
			SetCursorSprite(1)
		end
	else
		return self._Visible
	end
end

function UIMenu:ProcessControl()
	if not self._Visible then
		return
	end

	if self.JustOpened then
		self.JustOpened = false
		return
	end

	if IsDisabledControlJustReleased(0, 177) or IsDisabledControlJustReleased(1, 177) or IsDisabledControlJustReleased(2, 177) or IsDisabledControlJustReleased(0, 199) or IsDisabledControlJustReleased(1, 199) or IsDisabledControlJustReleased(2, 199) then
		self:GoBack()
	end
	if #self.Items == 0 then
		return
	end

	if not self.UpPressed then
		if IsDisabledControlJustPressed(0, 172) or IsDisabledControlJustPressed(1, 172) or IsDisabledControlJustPressed(2, 172) or IsDisabledControlJustPressed(0, 241) or IsDisabledControlJustPressed(1, 241) or IsDisabledControlJustPressed(2, 241) or IsDisabledControlJustPressed(2, 241) then
			Citizen.CreateThread(function()
				self.UpPressed = true
				if #self.Items > self.Pagination.Total + 1 then
					self:GoUpOverflow()
				else
					self:GoUp()
				end
				self:UpdateScaleform()
				Citizen.Wait(100)
				while IsDisabledControlPressed(0, 172) or IsDisabledControlPressed(1, 172) or IsDisabledControlPressed(2, 172) or IsDisabledControlPressed(0, 241) or IsDisabledControlPressed(1, 241) or IsDisabledControlPressed(2, 241) or IsDisabledControlPressed(2, 241) do
					if #self.Items > self.Pagination.Total + 1 then
						self:GoUpOverflow()
					else
						self:GoUp()
					end
					self:UpdateScaleform()
					Citizen.Wait(100)
				end
				self.UpPressed = false
			end)
		end
	end

	if not self.DownPressed then
		if IsDisabledControlJustPressed(0, 173) or IsDisabledControlJustPressed(1, 173) or IsDisabledControlJustPressed(2, 173) or IsDisabledControlJustPressed(0, 242) or IsDisabledControlJustPressed(1, 242) or IsDisabledControlJustPressed(2, 242) then
			Citizen.CreateThread(function()
				self.DownPressed = true
				if #self.Items > self.Pagination.Total + 1 then
					self:GoDownOverflow()
				else
					self:GoDown()
				end
				self:UpdateScaleform()
				Citizen.Wait(100)
				while IsDisabledControlPressed(0, 173) or IsDisabledControlPressed(1, 173) or IsDisabledControlPressed(2, 173) or IsDisabledControlPressed(0, 242) or IsDisabledControlPressed(1, 242) or IsDisabledControlPressed(2, 242) do
					if #self.Items > self.Pagination.Total + 1 then
						self:GoDownOverflow()
					else
						self:GoDown()
					end
					self:UpdateScaleform()
					Citizen.Wait(100)
				end
				self.DownPressed = false
			end)
		end
	end

	if not self.LeftPressed then
		if IsDisabledControlPressed(0, 174) or IsDisabledControlPressed(1, 174) or IsDisabledControlPressed(2, 174) then
			Citizen.CreateThread(function()
				self.LeftPressed = true
				self:GoLeft()
				Citizen.Wait(150)
				while IsDisabledControlPressed(0, 174) or IsDisabledControlPressed(1, 174) or IsDisabledControlPressed(2, 174) do
					self:GoLeft()
					Citizen.Wait(100)
				end
				self.LeftPressed = false
			end)
		end
	end

	if not self.RightPressed then
		if IsDisabledControlPressed(0, 175) or IsDisabledControlPressed(1, 175) or IsDisabledControlPressed(2, 175) then
			Citizen.CreateThread(function()
				self.RightPressed = true
				self:GoRight()
				Citizen.Wait(150)
				while IsDisabledControlPressed(0, 175) or IsDisabledControlPressed(1, 175) or IsDisabledControlPressed(2, 175) do
					self:GoRight()
					Citizen.Wait(100)
				end
				self.RightPressed = false
			end)
		end
	end

	if IsDisabledControlJustPressed(0, 201) or IsDisabledControlJustPressed(1, 201) or IsDisabledControlJustPressed(2, 201) then
		self:SelectItem()
	end
end

function UIMenu:GoUpOverflow()
	if #self.Items <= self.Pagination.Total + 1 then
		return
	end

	if self:CurrentSelection() <= self.Pagination.Min + 1 then
		if self:CurrentSelection() == 1 then
			self.Pagination.Min = #self.Items - (self.Pagination.Total + 1)
			self.Pagination.Max = #self.Items
			self.Items[self:CurrentSelection()]:Selected(false)
			self.ActiveItem = 1000 - (1000 % #self.Items)
			self.ActiveItem = self.ActiveItem + (#self.Items - 1)
			self.Items[self:CurrentSelection()]:Selected(true)
		else
			self.Pagination.Min = self.Pagination.Min - 1
			self.Pagination.Max = self.Pagination.Max - 1
			self.Items[self:CurrentSelection()]:Selected(false)
			self.ActiveItem = self.ActiveItem - 1
			self.Items[self:CurrentSelection()]:Selected(true)
		end
	else
		self.Items[self:CurrentSelection()]:Selected(false)
		self.ActiveItem = self.ActiveItem - 1
		self.Items[self:CurrentSelection()]:Selected(true)
	end
	PlaySoundFrontend(-1, self.Settings.Audio.UpDown, self.Settings.Audio.Library, true)
	self.OnIndexChange(self, self:CurrentSelection())
	self.ReDraw = true
end

function UIMenu:GoUp()
	if #self.Items > self.Pagination.Total + 1 then
		return
	end
	self.Items[self:CurrentSelection()]:Selected(false)
	self.ActiveItem = self.ActiveItem - 1
	self.Items[self:CurrentSelection()]:Selected(true)
	PlaySoundFrontend(-1, self.Settings.Audio.UpDown, self.Settings.Audio.Library, true)
	self.OnIndexChange(self, self:CurrentSelection())
	self.ReDraw = true
end

function UIMenu:GoDownOverflow()
	if #self.Items <= self.Pagination.Total + 1 then
		return
	end

	if self:CurrentSelection() >= self.Pagination.Max then
		if self:CurrentSelection() == #self.Items then
			self.Pagination.Min = 0
			self.Pagination.Max = self.Pagination.Total + 1
			self.Items[self:CurrentSelection()]:Selected(false)
			self.ActiveItem = 1000 - (1000 % #self.Items)
			self.Items[self:CurrentSelection()]:Selected(true)
		else
			self.Pagination.Max = self.Pagination.Max + 1
			self.Pagination.Min = self.Pagination.Max - (self.Pagination.Total + 1)
			self.Items[self:CurrentSelection()]:Selected(false)
			self.ActiveItem = self.ActiveItem + 1
			self.Items[self:CurrentSelection()]:Selected(true)            
		end
	else
		self.Items[self:CurrentSelection()]:Selected(false)
		self.ActiveItem = self.ActiveItem + 1
		self.Items[self:CurrentSelection()]:Selected(true)
	end
	PlaySoundFrontend(-1, self.Settings.Audio.UpDown, self.Settings.Audio.Library, true)
	self.OnIndexChange(self, self:CurrentSelection())
	self.ReDraw = true
end

function UIMenu:GoDown()
	if #self.Items > self.Pagination.Total + 1 then
		return
	end

	self.Items[self:CurrentSelection()]:Selected(false)
	self.ActiveItem = self.ActiveItem + 1
	self.Items[self:CurrentSelection()]:Selected(true) 
	PlaySoundFrontend(-1, self.Settings.Audio.UpDown, self.Settings.Audio.Library, true)
	self.OnIndexChange(self, self:CurrentSelection())
	self.ReDraw = true
end

function UIMenu:GoLeft()
	local type, subtype = self.Items[self:CurrentSelection()]()
	if subtype ~= "UIMenuListItem" and subtype ~= "UIMenuSliderItem" then
		return
	end

	if subtype == "UIMenuListItem" then
		local Item = self.Items[self:CurrentSelection()]
		Item:Index(Item._Index - 1)
		self.OnListChange(self, Item, Item._Index)
		Item.OnListChanged(Item._Index)
		PlaySoundFrontend(-1, self.Settings.Audio.LeftRight, self.Settings.Audio.Library, true)
	elseif subtype == "UIMenuSliderItem" then
		local Item = self.Items[self:CurrentSelection()]
		Item:Index(Item._Index - 1)
		self.OnSliderChange(self, Item, Item:Index())
		Item.OnSliderChanged(Item:Index())
		PlaySoundFrontend(-1, self.Settings.Audio.LeftRight, self.Settings.Audio.Library, true)
	end
end

function UIMenu:GoRight()
	local type, subtype = self.Items[self:CurrentSelection()]()
	if subtype ~= "UIMenuListItem" and subtype ~= "UIMenuSliderItem" then
		return
	end

	if subtype == "UIMenuListItem" then
		local Item = self.Items[self:CurrentSelection()]
		Item:Index(Item._Index + 1)
		self.OnListChange(self, Item, Item._Index)
		Item.OnListChanged(Item._Index)
		PlaySoundFrontend(-1, self.Settings.Audio.LeftRight, self.Settings.Audio.Library, true)
	elseif subtype == "UIMenuSliderItem" then
		local Item = self.Items[self:CurrentSelection()]
		Item:Index(Item._Index + 1)
		self.OnSliderChange(self, Item, Item:Index())
		Item.OnSliderChanged(Item:Index())
		PlaySoundFrontend(-1, self.Settings.Audio.LeftRight, self.Settings.Audio.Library, true)
	end
end

function UIMenu:SelectItem()
	if not self.Items[self:CurrentSelection()]:Enabled() then
		PlaySoundFrontend(-1, self.Settings.Audio.Error, self.Settings.Audio.Library, true)
		return
	end
	local Item = self.Items[self:CurrentSelection()]
	local type, subtype = Item()
	if subtype == "UIMenuCheckboxItem" then
		Item.Checked = not Item.Checked
		PlaySoundFrontend(-1, self.Settings.Audio.Select, self.Settings.Audio.Library, true)
		self.OnCheckboxChange(self, Item, Item.Checked)
		Item.CheckboxEvent(Item, Item.Checked)
	elseif subtype == "UIMenuListItem" then
		PlaySoundFrontend(-1, self.Settings.Audio.Select, self.Settings.Audio.Library, true)
		self.OnListSelect(self, Item, Item._Index)
		Item.OnListSelected(Item._Index)
	elseif subtype == "UIMenuSliderItem" then
		PlaySoundFrontend(-1, self.Settings.Audio.Select, self.Settings.Audio.Library, true)
		self.OnSliderSelect(self, Item, Item._Index)
		Item.OnSliderSelected(Item._Index)
	else
		PlaySoundFrontend(-1, self.Settings.Audio.Select, self.Settings.Audio.Library, true)
		self.OnItemSelect(self, Item, self:CurrentSelection())
		Item.Activated(self)
		if not self.Children[Item] then
			return
		end
		self:Visible(false)
		self.Children[Item]:Visible(true)
		self.OnMenuChanged(self, self.Children[self.Items[self:CurrentSelection()]], true)
	end
end

function UIMenu:GoBack()
	PlaySoundFrontend(-1, self.Settings.Audio.Back, self.Settings.Audio.Library, true)
	self:Visible(false)
	if self.ParentMenu ~= nil then
		self.ParentMenu:Visible(true)
		self.OnMenuChanged(self, self.ParentMenu, false)
		if self.Settings.ResetCursorOnOpen then
			local W, H = GetActiveScreenResolution()
			SetCursorLocation(W / 2, H / 2)
		end
	end
	self.OnMenuClosed(self)
end

function UIMenu:BindMenuToItem(Menu, Item)
	if Menu() == "UIMenu" and Item() == "UIMenuItem" then
		Menu.ParentMenu = self
		Menu.ParentItem = Item
		self.Children[Item] = Menu
	end
end

function UIMenu:ReleaseMenuFromItem(Item)
	if Item() == "UIMenuItem" then
		if not self.Children[Item] then
			return false
		end
		self.Children[Item].ParentMenu = nil
		self.Children[Item].ParentItem = nil
		self.Children[Item] = nil
		return true
	end
end

function UIMenu:Draw()
	if not self._Visible then
		return
	end

	HideHudComponentThisFrame(19)

	if self.Settings.ControlDisablingEnabled then
		self:DisEnableControls(false)
	end

	if self.Settings.InstructionalButtons then
		DrawScaleformMovieFullscreen(self.InstructionalScaleform, 255, 255, 255, 255, 0)
	end

	if self.Settings.ScaleWithSafezone then
		ScreenDrawPositionBegin(76, 84)
		ScreenDrawPositionRatio(0, 0, 0, 0)
	end

	if self.ReDraw then
		self:DrawCalculations()
	end

	if self.Logo then
		self.Logo:Draw()
	elseif self.Banner then
		self.Banner:Draw()
	end

	self.Title:Draw()

	if self.Subtitle.Rectangle then
		self.Subtitle.Rectangle:Draw()
		self.Subtitle.Text:Draw()
	end

	if #self.Items == 0 then
		if self.Settings.ScaleWithSafezone then
			ScreenDrawPositionEnd()
		end
		return
	end

	self.Background:Draw()

	self.Items[self:CurrentSelection()]:Selected(true)

	if self.Items[self:CurrentSelection()]:Description() ~= "" then
		self.Description.Bar:Draw()
		self.Description.Rectangle:Draw()
		self.Description.Text:Draw()
	end

	if #self.Items <= self.Pagination.Total + 1 then
		local count = 0
		for index = 1, #self.Items do
			Item = self.Items[index]
			Item:Position(count * 38 - 37 + self.Subtitle.ExtraY)
			Item:Draw()
			count = count + 1
		end
	else
		local count = 0
		for index = self.Pagination.Min + 1, self.Pagination.Max, 1 do
			if self.Items[index] then
				Item = self.Items[index]				
				Item:Position(count * 38 - 37 + self.Subtitle.ExtraY)
				Item:Draw()
				count = count + 1
			end
		end

		self.Extra.Up:Draw()
		self.Extra.Down:Draw()
		self.ArrowSprite:Draw()

		if self.PageCounter.Text ~= nil then
			local Caption = self.PageCounter.PreText .. self:CurrentSelection() .. " / " .. #self.Items
			self.PageCounter.Text:Text(Caption)
			self.PageCounter.Text:Draw()
		end
	end

	if self.Settings.ScaleWithSafezone then
		ScreenDrawPositionEnd()
	end
end

function UIMenu:ProcessMouse()
	if not self._Visible or self.JustOpened or #self.Items == 0 or tobool(Controller()) or not self.Settings.MouseControlsEnabled then
		EnableControlAction(0, 2, true)
		EnableControlAction(0, 1, true)
		EnableControlAction(0, 25, true)
		EnableControlAction(0, 24, true)
		if self.Dirty then
			for _, Item in pairs(self.Items) do
				if Item:Hovered() then
					Item:Hovered(false)
				end
			end
		end
		return
	end

    local SafeZone = {X = 0, Y = 0}
    if self.Settings.ScaleWithSafezone then
	   SafeZone = GetSafeZoneBounds()
    end

	local Limit = #self.Items
	local Counter = 0

	ShowCursorThisFrame()

	if #self.Items > self.Pagination.Total + 1 then
		Limit = self.Pagination.Max
	end

	if IsMouseInBounds(0, 0, 30, 1080) and self.Settings.MouseEdgeEnabled then
		SetGameplayCamRelativeHeading(GetGameplayCamRelativeHeading() + 5)
		SetCursorSprite(6)
	elseif IsMouseInBounds(GetScreenResolutionMaintainRatio().Width - 30, 0, 30, 1080) and self.Settings.MouseEdgeEnabled then
		SetGameplayCamRelativeHeading(GetGameplayCamRelativeHeading() - 5)
		SetCursorSprite(7)	
	elseif self.Settings.MouseEdgeEnabled then
		SetCursorSprite(1)
	end

	for i = self.Pagination.Min + 1, Limit, 1 do
		local X, Y = self.Position.X + SafeZone.X, self.Position.Y + 144 - 37 + self.Subtitle.ExtraY + (Counter * 38) + SafeZone.Y
		local Width, Height = 431 + self.WidthOffset, 38
		local Item = self.Items[i]
		local Type, SubType = Item()

		if IsMouseInBounds(X, Y, Width, Height) then
			Item:Hovered(true)
			if not self.Controls.MousePressed then
				if IsDisabledControlJustPressed(0, 24) then
					Citizen.CreateThread(function()
						local _X, _Y, _Width, _Height = X, Y, Width, Height
						self.Controls.MousePressed = true
						if Item:Selected() and Item:Enabled() then
							if SubType == "UIMenuListItem" then
								if IsMouseInBounds(Item.LeftArrow.X + SafeZone.X, Item.LeftArrow.Y + SafeZone.Y, Item.LeftArrow.Width, Item.LeftArrow.Height ) then
									self:GoLeft()
								elseif not IsMouseInBounds(Item.RightArrow.X + SafeZone.X, Item.RightArrow.Y + SafeZone.Y, Item.RightArrow.Width, Item.RightArrow.Height) then
									self:SelectItem()
								end
								if IsMouseInBounds(Item.RightArrow.X + SafeZone.X, Item.RightArrow.Y + SafeZone.Y, Item.RightArrow.Width, Item.RightArrow.Height) then
									self:GoRight()
								elseif not IsMouseInBounds(Item.LeftArrow.X + SafeZone.X, Item.LeftArrow.Y + SafeZone.Y, Item.LeftArrow.Width, Item.LeftArrow.Height) then
									self:SelectItem()
								end
							elseif SubType == "UIMenuSliderItem" then
								if IsMouseInBounds(Item.LeftArrow.X + SafeZone.X, Item.LeftArrow.Y + SafeZone.Y, Item.LeftArrow.Width, Item.LeftArrow.Height) then
									self:GoLeft()
								elseif not IsMouseInBounds(Item.RightArrow.X + SafeZone.X, Item.RightArrow.Y + SafeZone.Y, Item.RightArrow.Width, Item.RightArrow.Height) then
									self:SelectItem()
								end
								if IsMouseInBounds(Item.RightArrow.X + SafeZone.X, Item.RightArrow.Y + SafeZone.Y, Item.RightArrow.Width, Item.RightArrow.Height) then
									self:GoRight()
								elseif not IsMouseInBounds(Item.LeftArrow.X + SafeZone.X, Item.LeftArrow.Y + SafeZone.Y, Item.LeftArrow.Width, Item.LeftArrow.Height) then
									self:SelectItem()
								end
							else
								self:SelectItem()
							end
						elseif not Item:Selected() then
							self:CurrentSelection(i-1)
							PlaySoundFrontend(-1, self.Settings.Audio.Error, self.Settings.Audio.Library, true)
							self.OnIndexChange(self, self:CurrentSelection())
							self.ReDraw = true
							self:UpdateScaleform()
						elseif not Item:Enabled() and Item:Selected() then
							PlaySoundFrontend(-1, self.Settings.Audio.Error, self.Settings.Audio.Library, true)
						end
						Citizen.Wait(100)
						while IsDisabledControlPressed(0, 24) and IsMouseInBounds(_X, _Y, _Width, _Height) do
							if Item:Selected() and Item:Enabled() then
								if SubType == "UIMenuListItem" then
									if IsMouseInBounds(Item.LeftArrow.X + SafeZone.X, Item.LeftArrow.Y + SafeZone.Y, Item.LeftArrow.Width, Item.LeftArrow.Height) then
										self:GoLeft()
									end
									if IsMouseInBounds(Item.RightArrow.X + SafeZone.X, Item.RightArrow.Y + SafeZone.Y, Item.RightArrow.Width, Item.RightArrow.Height) then
										self:GoRight()
									end
								elseif SubType == "UIMenuSliderItem" then
									if IsMouseInBounds(Item.LeftArrow.X + SafeZone.X, Item.LeftArrow.Y + SafeZone.Y, Item.LeftArrow.Width, Item.LeftArrow.Height) then
										self:GoLeft()
									end
									if IsMouseInBounds(Item.RightArrow.X + SafeZone.X, Item.RightArrow.Y + SafeZone.Y, Item.RightArrow.Width, Item.RightArrow.Height) then
										self:GoRight()
									end
								end
							elseif not Item:Selected() then
								self:CurrentSelection(i-1)
								PlaySoundFrontend(-1, self.Settings.Audio.Error, self.Settings.Audio.Library, true)
								self.OnIndexChange(self, self:CurrentSelection())
								self.ReDraw = true
								self:UpdateScaleform()
							elseif not Item:Enabled() and Item:Selected() then
								PlaySoundFrontend(-1, self.Settings.Audio.Error, self.Settings.Audio.Library, true)
							end
							Citizen.Wait(100)						
						end
						self.Controls.MousePressed = false
					end)
				end
			end
		else
			Item:Hovered(false)
		end
		Counter = Counter + 1
	end

	local ExtraX, ExtraY = self.Position.X  + SafeZone.X, 144 + 38 * (self.Pagination.Total + 1) + self.Position.Y - 37 + self.Subtitle.ExtraY  + SafeZone.Y

	if #self.Items <= self.Pagination.Total + 1 then return end

	if IsMouseInBounds(ExtraX, ExtraY, 431 + self.WidthOffset, 18) then
		self.Extra.Up:Colour(30, 30, 30, 255)
		if not self.Controls.MousePressed then
			if IsDisabledControlJustPressed(0, 24) then
				Citizen.CreateThread(function()
					local _ExtraX, _ExtraY = ExtraX, ExtraY
					self.Controls.MousePressed = true
					if #self.Items > self.Pagination.Total + 1 then
						self:GoUpOverflow()
					else
						self:GoUp()
					end
					Citizen.Wait(100)
					while IsDisabledControlPressed(0, 24) and IsMouseInBounds(_ExtraX, _ExtraY, 431 + self.WidthOffset, 18) do
						if #self.Items > self.Pagination.Total + 1 then
							self:GoUpOverflow()
						else
							self:GoUp()
						end
						Citizen.Wait(100)
					end
					self.Controls.MousePressed = false				
				end)
			end
		end
	else
		self.Extra.Up:Colour(0, 0, 0, 200)
	end

	if IsMouseInBounds(ExtraX, ExtraY + 18, 431 + self.WidthOffset, 18) then
		self.Extra.Down:Colour(30, 30, 30, 255)
		if not self.Controls.MousePressed then
			if IsDisabledControlJustPressed(0, 24) then
				Citizen.CreateThread(function()
					local _ExtraX, _ExtraY = ExtraX, ExtraY
					self.Controls.MousePressed = true
					if #self.Items > self.Pagination.Total + 1 then
						self:GoDownOverflow()
					else
						self:GoDown()
					end
					Citizen.Wait(100)
					while IsDisabledControlPressed(0, 24) and IsMouseInBounds(_ExtraX, _ExtraY + 18, 431 + self.WidthOffset, 18) do
						if #self.Items > self.Pagination.Total + 1 then
							self:GoDownOverflow()
						else
							self:GoDown()
						end
						Citizen.Wait(100)
					end
					self.Controls.MousePressed = false				
				end)
			end
		end
	else
		self.Extra.Down:Colour(0, 0, 0, 200)
	end
end

function UIMenu:AddInstructionButton(button)
	if type(button) == "table" and #button == 2 then
		table.insert(self.InstructionalButtons)
	end
end

function UIMenu:RemoveInstructionButton(button)
	if type(button) == "table" then
		for i = 1, #self.InstructionalButtons do
			if button == self.InstructionalButtons[i] then
				table.remove(self.InstructionalButtons, i)
				break
			end
		end
	else
		if tonumber(button) then
			if self.InstructionalButtons[tonumber(button)] then
				table.remove(self.InstructionalButtons, tonumber(button))
			end
		end
	end
end

function UIMenu:UpdateScaleform()
	if not self._Visible or not self.Settings.InstructionalButtons then
		return
	end
	
	PushScaleformMovieFunction(self.InstructionalScaleform, "CLEAR_ALL")
	PopScaleformMovieFunction()

	PushScaleformMovieFunction(self.InstructionalScaleform, "TOGGLE_MOUSE_BUTTONS")
	PushScaleformMovieFunctionParameterInt(0)
	PopScaleformMovieFunction()

	PushScaleformMovieFunction(self.InstructionalScaleform, "CREATE_CONTAINER")
	PopScaleformMovieFunction()

	PushScaleformMovieFunction(self.InstructionalScaleform, "SET_DATA_SLOT")
	PushScaleformMovieFunctionParameterInt(0)
	PushScaleformMovieFunctionParameterString(GetControlInstructionalButton(2, 176, 0))
	PushScaleformMovieFunctionParameterString("Select")
	PopScaleformMovieFunction()

	PushScaleformMovieFunction(self.InstructionalScaleform, "SET_DATA_SLOT")
	PushScaleformMovieFunctionParameterInt(1)
	PushScaleformMovieFunctionParameterString(GetControlInstructionalButton(2, 177, 0))
	PushScaleformMovieFunctionParameterString("Back")
	PopScaleformMovieFunction()

	local count = 2

	for i = 1, #self.InstructionalButtons do
		if self.InstructionalButtons[i] then
			if #self.InstructionalButtons[i] == 2 then
				PushScaleformMovieFunction(self.InstructionalScaleform, "SET_DATA_SLOT")
				PushScaleformMovieFunctionParameterInt(count)
				PushScaleformMovieFunctionParameterString(self.InstructionalButtons[i][1])
				PushScaleformMovieFunctionParameterString(self.InstructionalButtons[i][2])
				PopScaleformMovieFunction()
				count = count + 1
			end
		end
	end

	PushScaleformMovieFunction(self.InstructionalScaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
	PushScaleformMovieFunctionParameterInt(-1)
	PopScaleformMovieFunction()
end

function MenuPool.New()
	local _MenuPool = {
		Menus = {}
	}
	return setmetatable(_MenuPool, MenuPool)
end

function MenuPool:AddSubMenu(Menu, Text, Description, KeepPosition)
	if Menu() == "UIMenu" then
		local Item = UIMenuItem.New(tostring(Text), Description or "")
		Menu:AddItem(Item)
		local SubMenu
		if KeepPosition then
			SubMenu = UIMenu.New(Menu.Title:Text(), Text, Menu.Position.X, Menu.Position.Y)
		else
			SubMenu = UIMenu.New(Menu.Title:Text(), Text)
		end
		self:Add(SubMenu)
		Menu:BindMenuToItem(SubMenu, Item)
		return SubMenu
	end
end

function MenuPool:Add(Menu)
	if Menu() == "UIMenu" then
		table.insert(self.Menus, Menu)
	end
end

function MenuPool:MouseEdgeEnabled(bool)
	if bool ~= nil then
		for _, Menu in pairs(self.Menus) do
			Menu.Settings.MouseEdgeEnabled = tobool(bool)
		end
	end
end

function MenuPool:ControlDisablingEnabled(bool)
	if bool ~= nil then
		for _, Menu in pairs(self.Menus) do
			Menu.Settings.ControlDisablingEnabled = tobool(bool)
		end
	end
end

function MenuPool:ResetCursorOnOpen(bool)
	if bool ~= nil then
		for _, Menu in pairs(self.Menus) do
			Menu.Settings.ResetCursorOnOpen = tobool(bool)
		end
	end
end

function MenuPool:FormatDescriptions(bool)
	if bool ~= nil then
		for _, Menu in pairs(self.Menus) do
			Menu.Settings.FormatDescriptions = tobool(bool)
		end
	end
end

function MenuPool:Audio(Attribute, Setting)
	if Attribute ~= nil and Setting ~= nil then
		for _, Menu in pairs(self.Menus) do
			if Menu.Settings.Audio[Attribute] then
				Menu.Settings.Audio[Attribute] = Setting
			end
		end
	end
end

function MenuPool:WidthOffset(offset)
	if tonumber(offset) then
		for _, Menu in pairs(self.Menus) do
			Menu.WidthOffset = tonumber(offset)
		end
	end
end

function MenuPool:CounterPreText(str)
	if str ~= nil then
		for _, Menu in pairs(self.Menus) do
			Menu.PageCounter.PreText = tostring(str)
		end
	end
end

function MenuPool:DisableInstructionalButtons(bool)
	if bool ~= nil then
		for _, Menu in pairs(self.Menus) do
			Menu.Settings.InstructionalButtons = tobool(bool)
		end
	end
end

function MenuPool:RefreshIndex()
	for _, Menu in pairs(self.Menus) do
		Menu:RefreshIndex()
	end
end

function MenuPool:ProcessMenus()
	self:ProcessControl()
	self:ProcessMouse()
	self:Draw()
end

function MenuPool:ProcessControl()
	for _, Menu in pairs(self.Menus) do
		if Menu:Visible() then
			Menu:ProcessControl()
		end
	end
end

function MenuPool:ProcessMouse()
	for _, Menu in pairs(self.Menus) do
		if Menu:Visible() then
			Menu:ProcessMouse()
		end
	end
end

function MenuPool:Draw()
	for _, Menu in pairs(self.Menus) do
		if Menu:Visible() then
			Menu:Draw()
		end
	end
end

function MenuPool:IsAnyMenuOpen()
	local open = false
	for _, Menu in pairs(self.Menus) do
		if Menu:Visible() then
			open = true
			break
		end
	end
	return open
end

function MenuPool:CloseAllMenus()
	for _, Menu in pairs(self.Menus) do
		if Menu:Visible() then
			Menu:Visible(false)
		end
	end
end

function MenuPool:SetBannerSprite(Sprite)
	if Sprite() == "Sprite" then
		for _, Menu in pairs(self.Menus) do
			Menu:SetBannerSprite(Sprite)
		end
	end
end

function MenuPool:SetBannerRectangle(Rectangle)
	if Rectangle() == "Rectangle" then
		for _, Menu in pairs(self.Menus) do
			Menu:SetBannerRectangle(Rectangle)
		end
	end
end

NativeUI = {}

function NativeUI.CreatePool()
	return MenuPool.New()
end

function NativeUI.CreateMenu(Title, Subtitle, X, Y, TxtDictionary, TxtName)
	return UIMenu.New(Title, Subtitle, X, Y, TxtDictionary, TxtName)
end

function NativeUI.CreateItem(Text, Description)
	return UIMenuItem.New(Text, Description)
end

function NativeUI.CreateColouredItem(Text, Description, MainColour, HighlightColour)
	return UIMenuColouredItem.New(Text, Description, MainColour, HighlightColour)
end

function NativeUI.CreateCheckboxItem(Text, Check, Description)
	return UIMenuCheckboxItem.New(Text, Check, Description)
end

function NativeUI.CreateListItem(Text, Items, Index, Description)
	return UIMenuListItem.New(Text, Items, Index, Description)
end

function NativeUI.CreateSliderItem(Text, Items, Index, Description, Divider)
	return UIMenuSliderItem.New(Text, Items, Index, Description, Divider)
end

function NativeUI.CreateSprite(TxtDictionary, TxtName, X, Y, Width, Height, Heading, R, G, B, A)
	return Sprite.New(TxtDictionary, TxtName, X, Y, Width, Height, Heading, R, G, B, A)
end

function NativeUI.CreateRectangle(X, Y, Width, Height, R, G, B, A)
	return UIResRectangle.New(X, Y, Width, Height, R, G, B, A)
end

function NativeUI.CreateText(Text, X, Y, Scale, R, G, B, A, Font, Alignment, DropShadow, Outline, WordWrap)
	return UIResText.New(Text, X, Y, Scale, R, G, B, A, Font, Alignment, DropShadow, Outline, WordWrap)
end
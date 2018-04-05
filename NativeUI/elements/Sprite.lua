Sprite = setmetatable({}, Sprite)
Sprite.__index = Sprite
Sprite.__call = function() return "Sprite" end

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
	Size.Width = Size.Width / Resolution.Width
	Size.Height = Size.Height / Resolution.Height
	DrawSprite(self.TxtDictionary, self.TxtName, (Position.X / Resolution.Width) + Size.Width * 0.5, (Position.Y / Resolution.Height) + Size.Height * 0.5, Size.Width, Size.Height, self.Heading, self._Colour.R, self._Colour.G, self._Colour.B, self._Colour.A)
end

function DrawTexture(TxtDictionary, TxtName, X, Y, Width, Height, Heading, R, G, B, A)
	if not HasStreamedTextureDictLoaded(tostring(TxtDictionary) or "") then
		RequestStreamedTextureDict(tostring(TxtDictionary) or "", true)
	end
	local Resolution = GetScreenResolutionMaintainRatio()
	X, Y, Width, Height = X or 0, Y or 0, Width or 0, Height or 0
	DrawSprite(tostring(TxtDictionary) or "", tostring(TxtName) or "", (tonumber(X) / Resolution.Width) + (tonumber(Width) / Resolution.Width) * 0.5, (tonumber(Y) / Resolution.Height) + (tonumber(Height) / Resolution.Height) * 0.5, tonumber(Width) / Resolution.Width, tonumber(Height) / Resolution.Height, tonumber(Heading) or 0, tonumber(R) or 255, tonumber(G) or 255, tonumber(B) or 255, tonumber(A) or 255)
end
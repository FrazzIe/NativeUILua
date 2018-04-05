# NativeUI in LUA for FiveM.
![NativeUILua Example](https://i.gyazo.com/dbf3d6bed1f98fb765e5c8f25b504607.png)

Original: https://github.com/Guad/NativeUI

Include it in your `__resource.lua` to use
`client_script '@NativeUI/NativeUI.lua'`

## Creation Functions

`NativeUI.CreatePool()` used to handle all your menus

`NativeUI.CreateMenu(Title, Subtitle, X, Y, TxtDictionary, TxtName)` create a UIMenu

`NativeUI.CreateItem(Text, Description)` create a UIMenuItem

`NativeUI.CreateColouredItem(Text, Description)` create a UIMenuColouredItem

`NativeUI.CreateCheckboxItem(Text, Description)` create a UIMenuCheckboxItem

`NativeUI.CreateListItem(Text, Description)` create a UIMenuListItem

`NativeUI.CreateSliderItem(Text, Description)` create a UIMenuSliderItem

`NativeUI.CreateSprite(TxtDictionary, TxtName, X, Y, Width, Height, Heading, R, G, B, A)` create a Sprite

`NativeUI.CreateRectangle(X, Y, Width, Height, R, G, B, A)` create a Rectangle

`NativeUI.CreateText(Text, X, Y, Scale, R, G, B, A, Font, Alignment, DropShadow, Outline, WordWrap)` create Text

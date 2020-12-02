# esx_menu
#### Personal Player Menu for every FiveM RP server. Easy and simple to configurate!

### Requirements:

- essentialmode
- es_extended
- esx_addonaccount
- esx_menu_default
- esx_identity (jsfour-register works too as it is basically the same thing)
- esx_society
- esx_phone (gcphone works too as it is basically the same thing)

### (Optional) Recommendations & Tips
- I will recommend you to check if your esx_menu_default & ShowNotification (in es_extended) function supports emojis and diacritics.
- If you want to change emojis or remove them, go to client.lua and basically remove them from labels.

### Configuration:

#### Locale Config:

- Locale defines language to use.
```lua
Config.Locale       = 'en'
```

#### Menu Config:

- MenuButton defines which button will be used to open menu. If you want the menu to be opened by command then set this variable as 'none' (Command to open is /pmenu)
```lua
Config.MenuButton   = 'F3'
```
- Align defines position of esx_menu_default to appear at.
```lua
Config.Align        = 'center'
```

#### Design Config:

- RedColor defines color in hexcode that is used for red columns in esx_menu.
```lua
Config.RedColor     = '#ff5e5e'
```

### Features:
- Player Menu (RP Info etc.. (If player's job grade is boss or manager, player can press enter on his job element in order to see society account))
- Car Menu (Doors, liveries, extras, engine etc.. (and hood + trunk <- Usable only when player is outside the vehicle))
- Simple configuration for server owners!
- Czech and English translation at the moment.

### Showcase: 
- Car Menu

![Car Menu](https://imgur.com/mXoIulS.png)

- Information Menu

![Information Menu](https://imgur.com/FmcDAoJ.png)



### More things will come after time!

You can edit this script as much as you want. Don't re-publish or sell this script. Thank you.

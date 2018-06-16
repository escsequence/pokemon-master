-- Global variables stored here

-- quick scope access for devs, 420blazeit
l = {
    g = love.graphics,
    maf = love.math,
    d = love.draw,
    aud = love.audio
}


-- Keyboard binding defaults, if nothing is changed in settings - this will be it
keyboard_bindings = {
    move = {
        up = "up",
        down = "down",
        left = "left",
        right = "right"
    },
    pause = "escape",
    select = "enter",
    start = "space",
    a = "x",
    b = "z"
}

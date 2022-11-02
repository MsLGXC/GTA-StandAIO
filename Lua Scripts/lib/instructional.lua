--[[

    INSTRUCTIONAL BUTTONS FOR STAND
    BY NOWIRY

]]

require('natives-1627063482')

instructional = {}

instructional.new = function()
    local self = {}
    
    local scaleform = GRAPHICS.REQUEST_SCALEFORM_MOVIE('instructional_buttons')
    
    self.setup = function(buttons, colour)
        local colour = colour or {
            ['r'] = 0,
            ['g'] = 0,
            ['b'] = 0,
            ['a'] = 80
        }
        while not GRAPHICS.HAS_SCALEFORM_MOVIE_LOADED(scaleform) do
        	wait()
        end
        
        GRAPHICS.DRAW_SCALEFORM_MOVIE_FULLSCREEN(scaleform, 255, 255, 255, 255, 0)

        GRAPHICS.BEGIN_SCALEFORM_MOVIE_METHOD(scaleform, 'CLEAR_ALL')
        GRAPHICS.END_SCALEFORM_MOVIE_METHOD()   

        GRAPHICS.BEGIN_SCALEFORM_MOVIE_METHOD(scaleform, 'SET_CLEAR_SPACE')
        GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_INT(200)
        GRAPHICS.END_SCALEFORM_MOVIE_METHOD()   

        GRAPHICS.BEGIN_SCALEFORM_MOVIE_METHOD(scaleform, 'TOGGLE_MOUSE_BUTTONS')
        GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_BOOL(true)
        GRAPHICS.END_SCALEFORM_MOVIE_METHOD()

        for n, button in pairs(buttons) do
            local strg, controlId, clickable = table.unpack(button) 
        	GRAPHICS.BEGIN_SCALEFORM_MOVIE_METHOD(scaleform, 'SET_DATA_SLOT')
        	GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_INT(n - 1)
        	GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_PLAYER_NAME_STRING(PAD.GET_CONTROL_INSTRUCTIONAL_BUTTON(2, controlId, true)) 
        	GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_TEXTURE_NAME_STRING(strg)
        	GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_BOOL(clickable)
        	GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_INT(controlId)
        	GRAPHICS.END_SCALEFORM_MOVIE_METHOD()
        end

        GRAPHICS.BEGIN_SCALEFORM_MOVIE_METHOD(scaleform, 'SET_BACKGROUND_COLOUR')
        GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_INT(colour.r)
        GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_INT(colour.g)
        GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_INT(colour.b)
        GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_INT(colour.a)
        GRAPHICS.END_SCALEFORM_MOVIE_METHOD()

        GRAPHICS.BEGIN_SCALEFORM_MOVIE_METHOD(scaleform, 'DRAW_INSTRUCTIONAL_BUTTONS')
        GRAPHICS.END_SCALEFORM_MOVIE_METHOD()  

    end

    self.draw = function()
        GRAPHICS.DRAW_SCALEFORM_MOVIE_FULLSCREEN(scaleform, 255, 255, 255, 255, 0)
    end

    return self
end
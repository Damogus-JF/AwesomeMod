SMODS.Atlas {
    key = 'AwesomeDeckAtlas',
    px = 71,
    py = 95,
    path = 'AwesomeDeckAtlas.png'
}

SMODS.Back{
    name = "Ted Deck",
    key = "ted",
    atlas = 'AwesomeDeckAtlas',pos = {x=0,y=0},
    loc_txt = {
        name = 'Ted Deck',
        text = {
            "Start with an Eternal",
            "Riff-Raff",
        },
    },
    apply = function ()
        G.E_MANAGER:add_event(Event({
            func = function ()
                SMODS.add_card({key = 'j_riff_raff',stickers = {'eternal'}})
                return true
            end
        }))
        
    end
}
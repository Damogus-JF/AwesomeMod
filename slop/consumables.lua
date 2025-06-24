SMODS.Atlas {
    key = 'AwesomeAtlasSpectral',
    px = 71,
    py = 95,
    path = 'SpectralAwesomeModAtlas.png'
}

SMODS.Consumable {
    key = 'Upvote',
    set = 'Spectral',
    loc_txt = {
        name = 'Upvote',
        text = {
            'Upgrade the rarity of a random Joker',
            'Give it eternal'
        }
    },
    atlas = 'AwesomeAtlasSpectral', pos = {x=0,y=0},
    use = function (self, info_queue, card)
        
    end
}
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
        local noneternaljokers = {}
        for _, joker in ipairs(G.jokers.cards) do
        if not joker.ability.eternal then
            noneternaljokers[#noneternaljokers + 1] = joker
        end
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                local eligible_card = pseudorandom_element(noneternaljokers, pseudoseed('Aw_Upvote'))
                local rarity = eligible_card.ability.rarity
                if eligible_card.config.center.rarity == 1 then
                    SMODS.destroy_cards(eligible_card)
                    SMODS.add_card({set = 'Joker', rarity = 'Uncommon', stickers = {'eternal'}})
                    
                elseif eligible_card.config.center.rarity == 2 then
                    SMODS.destroy_cards(eligible_card)
                    SMODS.add_card({set = 'Joker', rarity = 'Rare', stickers = {'eternal'}})
                    
                elseif eligible_card.config.center.rarity == 3 or eligible_card.config.center.rarity == 4 then
                    SMODS.destroy_cards(eligible_card)
                    SMODS.add_card({set = 'Joker', legendary = true, stickers = {'eternal'}})

                end
                
                

                
                return true
            end
        }))
        
    end,
    can_use = function (self, card)
        local noneternaljokers = {}
        for _, joker in ipairs(G.jokers.cards) do
        if not joker.ability.eternal then
            noneternaljokers[#noneternaljokers + 1] = joker
        end
    end
        return next(SMODS.Edition:get_edition_cards(G.jokers, true)) and next(noneternaljokers)
    end
}
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
            'Upgrades the rarity of a random Joker,',
            'then gains {C:tarot}Eternal{}'
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
                    
                elseif eligible_card.config.center.rarity == 3 then
                    SMODS.destroy_cards(eligible_card)
                    SMODS.add_card({set = 'Joker', legendary = true, stickers = {'eternal'}})
                    
                elseif eligible_card.config.center.rarity == 4 then
                    SMODS.destroy_cards(eligible_card)
                    SMODS.add_card({key = 'j_chicot', stickers = {'eternal'}})
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
SMODS.Consumable {
    set = "Spectral",
    key = "masha",
    loc_txt = {
        name = 'Mash A',
        text = {
            "Creates a random {C:attention}skip{} tag"
        }
    },
    cost = 6,
    atlas = "AwesomeAtlasSpectral", pos = {x=1, y=0},

    can_use = function(self, card)
		return true
	end,
    use = function(self, card, area, copier)
		local used_consumable = copier or card
		delay(0.4)
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.2,
			func = function()
				play_sound("tarot1")
				local tag = nil
				tag = Tag(get_next_tag_key())
				add_tag(tag)
				used_consumable:juice_up(0.8, 0.5)
				return true
			end,
		}))
		delay(1.2)
    end

}
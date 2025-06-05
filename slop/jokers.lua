SMODS.Atlas {
    key = 'AwesomeAtlas',
    px = 71,
    py = 95,
    path = 'AwesomeModAtlas.png'
}

SMODS.Joker {
    key = 'WhiteMonster',
    loc_txt = {
        name = 'White Monster',
        text = {
            '{X:mult,C:white}X#1#{} mult {}',
            'Decreases by {X:mult,C:white}X#2#{} mult {} at the end of round'
        }
    },
    atlas = 'AwesomeAtlas', pos = { x = 0, y = 0},
    config = { extra = { Xmult = 4, NegXmult = 0.5}},
    loc_vars = function (self, info_queue, card)
        return {
            vars = { card.ability.extra.Xmult, card.ability.extra.NegXmult}
        } 
    end,
    rarity = 2,
    cost = 7,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.joker_main then
            return{
                Xmult_mod = card.ability.extra.Xmult,
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } }
            }
        end
        if context.end_of_round and context.game_over == false and not context.repetition and not context.blueprint then
            card.ability.extra.Xmult = card.ability.extra.Xmult - card.ability.extra.NegXmult
            card:juice_up(0.8, 0.8)
            return {
                message = 'Sluuurp!',
                colour = G.C.MULT
            }
        end
        if card.ability.extra.Xmult <= 1 then
            SMODS.destroy_cards(card)
            return {
                message = 'Empty!',
                colour = G.C.CHIPS
            }
            
        end
    end
}

SMODS.Joker {
    key = 'Chud',
    loc_txt = {
        name = 'Chud',
        text = {
            'Destroy the joker to the right of this',
            'at the end of round and create',
            'a {C:spectral}spectral{} card'
        }
    },
    atlas = 'AwesomeAtlas', pos = { x = 2, y = 0},
    config = {},
    loc_vars = function (self, info_queue, card)
        return {
            vars = { }
        } 
    end,
    rarity = 3,
    cost = 8,
    calculate = function (self, card, context)
        if context.end_of_round and context.game_over == false and not context.repetition then
            local mypos = nil
            for i = 1, #G.jokers.cards do 
                if G.jokers.cards[i] == card then mypos = i; break end
            end
            if mypos and G.jokers.cards[mypos+1] and not self.getting_sliced and not G.jokers.cards[mypos+1].ability.eternal and not G.jokers.cards[mypos+1].getting_sliced then 
                local sliced_card = G.jokers.cards[mypos+1]
                SMODS.destroy_cards(G.jokers.cards[mypos + 1])
                G.E_MANAGER:add_event(Event({
                    func = function ()
                        card:juice_up(0.8,0.8)
                        if #G.consumeables.cards + 1 <= G.consumeables.config.card_limit then
                            local card = SMODS.add_card{set = 'Spectral'}
                        end
                        return true
                    end
                }))
                return {
                    message = 'Billions must die!',
                    colour = G.C.MULT
                }
            else
                return {
                    message = 'Nothing ever happens...',
                    colour = G.C.CHIPS
                }
            end
        end
    end
}
SMODS.Joker {
    key = 'Jeffy',
    loc_txt = {
        name = 'Jeffy',
        text = {
            'If game speed is at 0.5',
            'this joker gives {X:mult,C:white}X#1#{} mult'
        }
    },
    atlas = 'AwesomeAtlas', pos = { x = 0, y = 1},
    config = { extra = { Xmult = 4 } },
    loc_vars = function (self, info_queue, card)
        return {
            vars = { card.ability.extra.Xmult }
        } 
    end,
    rarity = 1,
    cost = 4,
    calculate = function (self, card, context)
        if context.joker_main then
            if G.SETTINGS.GAMESPEED == 0.5 then
                return{ 
                    Xmult_mod = card.ability.extra.Xmult,
                    message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } }
                }
            else
                return {
                    message = 'Why?',
                    colour = G.C.YELLOW,
                    sound = 'Aw_JeffyWhy'
                }
            end
        end
    end
}
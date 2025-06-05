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
            'Gives {X:mult,C:white} X#1# {} mult {}',
            'Decreases by {X:mult,C:white} X#2# {} mult {} at the end of round'
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
            if not card.ability.extra.Xmult <= 1 then
                return {
                    message = 'Sluuurp!',
                    colour = G.C.MULT
                }
            end
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

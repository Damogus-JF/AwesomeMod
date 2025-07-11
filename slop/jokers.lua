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
            '{X:mult,C:white}X#1#{} Mult {}',
            'Decreases by {X:mult,C:white}X#2#{} Mult{}',
            'at the end of round',
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
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.joker_main then
            return{
                Xmult_mod = card.ability.extra.Xmult,
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } }
            }
        end
        if context.after and context.main_eval == true and not context.repetition and not context.blueprint then
            card.ability.extra.Xmult = card.ability.extra.Xmult - card.ability.extra.NegXmult
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
            
            '{X:mult,C:white}X#1#{} Mult{} while',
            'Game speed is at 0.5',
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
    cost = 1,
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
SMODS.Joker {
    key = 'RussianRoulette',
    loc_txt = {
        name = 'Russian Roulette',
        text = {
            '{X:mult,C:white}X#1#{} mult',
            '{C:attention}#2# in #3#{} chance to convert score into negative mult'
        }
    },
    atlas = 'AwesomeAtlas', pos = {x=2, y=1},
    config = { extra = {Xmult = 2, odds = 6, NegXmult = -2} },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {card.ability.extra.Xmult, (G.GAME.probabilities.normal or 1), card.ability.extra.odds, card.ability.extra.NegXmult}
        }
    end,
    rarity = 1,
    cost = 6,
    calculate = function (self, card, context)
        if context.joker_main then
            if pseudorandom('RussianRoulette') < G.GAME.probabilities.normal / card.ability.extra.odds then
                G.E_MANAGER:add_event(Event({
                func = function()
                    card:juice_up(0.3,0.4)
                    return true
                end
                }))
                return{ 
                    Xmult_mod = card.ability.extra.NegXmult,
                    message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.NegXmult } }
                }
            else
                G.E_MANAGER:add_event(Event({
                func = function()
                    card:juice_up(0.3,0.4)
                    return true
                end
                }))
                return{ 
                    Xmult_mod = card.ability.extra.Xmult,
                    message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } }
                }
            end
        end
    end
}
SMODS.Joker {
    key = 'Job',
    loc_txt = {
        name = 'J*b application',
        text = {
            '{X:mult,C:white}X#2#{} Mult per {C:money}$5{} + {X:mult,C:white}X1{}',
            'You gain no interest at the end of round',
            'Currently {X:mult,C:white}X#1#{} Mult',
        }
    },
    atlas = 'AwesomeAtlas', pos = {x=1, y=1},
    config = { extra = {Xmult = 1, Gain = 0.2, incomelastround = 0} },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {card.ability.extra.Xmult, card.ability.extra.Gain, card.ability.extra.incomelastround}
        }
    end,
    rarity = 2,
    cost = 6,
    calculate = function (self, card, context)
        if context.joker_main then
        G.E_MANAGER:add_event(Event({
            func = function()
                card:juice_up(0.3,0.4)
                return true
            end
            }))
            return{ 
                Xmult_mod = card.ability.extra.Xmult,
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } }
            }
        end
    end,
    calc_dollar_bonus = function (self, card)
        card.ability.extra.Xmult = 1 + card.ability.extra.Gain * card.ability.extra.incomelastround
        card.ability.extra.incomelastround = 1 * (G.GAME.interest_cap / 5)
        G.GAME.interest_amount = 0
    end
}
SMODS.Joker {
    key = 'BearFive',
    loc_txt = {
        name = 'Bear5',
        text = {
            'Whenever a five is scored ',
            'this gets {C:mult}+#2#{} Mult',
            '{X:mult,C:white}X#3#{} to current Mult', 
            'and destroy the played card',
            'When a {C:chips}five of clubs{} is scored',
            'Currently {C:mult}+#1#{} Mult'
        }
    },
    atlas = 'AwesomeAtlas', pos = {x=3, y=1},
    config = { extra = { Mult = 5,BaseMultGain = 2, BaseXMultGain = 2}},
    loc_vars = function (self, info_queue, card)
        return {
            vars = {card.ability.extra.Mult,card.ability.extra.BaseMultGain,card.ability.extra.BaseXMultGain }
        }
    end,
    blueprint_compat = true,
    rarity = 2,
    cost = 5,
    calculate = function (self, card, context)
        if context.individual and context.cardarea == G.play and not context.blueprint then
            if context.other_card:get_id() == 5 then
                
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card:juice_up(0.3,0.4)
                        card.ability.extra.Mult = card.ability.extra.Mult + card.ability.extra.BaseMultGain
                        return true
                    end
                }))
                if context.other_card:is_suit("Clubs") then
                    
                    card.ability.extra.Mult = card.ability.extra.Mult * card.ability.extra.BaseXMultGain
                    G.E_MANAGER:add_event(Event({
                        trigger = 'After',
                        delay = 0.4,
                    func = function()
                        SMODS.destroy_cards(context.other_card)
                        return true
                    end
                }))
            end
            end
            
        end
        if context.joker_main then 
            return{ 
                    mult = card.ability.extra.Mult,
                    message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.Mult } }
            }
        end
    end
}

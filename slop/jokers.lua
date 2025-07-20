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
            'loses {X:mult,C:white}X0.5{} Mult{}',
            'for every hand played',
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
    cost = 6,
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
                message = localize{type = 'variable', key = 'a_xmult_minus', vars = { card.ability.extra.NegXmult } },
                colour = G.C.RED
            }
        end
        if card.ability.extra.Xmult <= 1 and not context.blueprint then
            SMODS.destroy_cards(card)
            return {
                message = 'Empty!',
                colour = G.C.FILTER
            }
            
        end
    end
}

SMODS.Joker {
    key = 'Chud',
    loc_txt = {
        name = 'Chud',
        text = {
            'Destroy Joker to the right',
            'and create a {C:spectral}spectral{} card',
            'at end of round',
        }
    },
    atlas = 'AwesomeAtlas', pos = { x = 2, y = 0},
    config = {},
    loc_vars = function (self, info_queue, card)
        return {
            vars = { }
        } 
    end,
    blueprint_compat = false,
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
            'game speed is at 0.5',
        }
    },
    atlas = 'AwesomeAtlas', pos = { x = 0, y = 1},
    config = { extra = { Xmult = 4 } },
    loc_vars = function (self, info_queue, card)
        return {
            vars = { card.ability.extra.Xmult }
        } 
    end,
    blueprint_compat = true,
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
                    colour = G.C.attention,
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
            '{X:mult,C:white}X#1#{} Mult',
            '{C:green}#2# in #3#{} chance for played hand',
            'to subtract from your score',
        }
    },
    atlas = 'AwesomeAtlas', pos = {x=2, y=1},
    config = { extra = {Xmult = 2, odds = 6, NegXmult = -2} },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {card.ability.extra.Xmult, (G.GAME.probabilities.normal or 1), card.ability.extra.odds, card.ability.extra.NegXmult}
        }
    end,
    blueprint_compat = true,
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
            '{X:mult,C:white}X#2#{} Mult for every {C:money}$5 you have',
            'earn no {C:money}interest{} at end of round',
            '{C:inactive}(Currently {X:mult,C:white}X#1#{} {C:inactive}Mult){}',
        }
    },
    atlas = 'AwesomeAtlas', pos = {x=1, y=1},
    config = { extra = {Xmult = 1, Gain = 0.2} },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {1 + (card.ability.extra.Gain * math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or 0)) / 5)), card.ability.extra.Gain}
        }
    end,
    blueprint_compat = true,
    rarity = 3,
    cost = 8,
    calculate = function (self, card, context)
        if context.joker_main then
        G.E_MANAGER:add_event(Event({
            func = function()
                card:juice_up(0.3,0.4)
                return true
            end
            }))
            return{ 
                Xmult_mod = 1 + (card.ability.extra.Gain * math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or 0)) / 5)),
                message = localize { type = 'variable', key = 'a_xmult', vars = { Xmult_mod } }
            }
        end
    end,
    calc_dollar_bonus = function (self, card)
        G.GAME.interest_amount = 0
    end
}

SMODS.Joker {
    key = 'BearFive',
    loc_txt = {
        name = 'Bear5',
        text = {
            'This Joker gains {C:mult}+#2#{} Mult{}',
            'when each played {C:attention}5{} is scored', 
            'if a {C:clubs}5 of Clubs{} scores,',
            'destroy it and double current {C:mult}Mult{}',
            '{C:inactive}(Currently {C:mult}+#1#{} {C:inactive}Mult){}',
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
    rarity = 3,
    cost = 10,
    calculate = function (self, card, context)
        if context.individual and context.cardarea == G.play and not context.blueprint then
            if context.other_card:is_suit("Clubs") then                    
                G.E_MANAGER:add_event(Event({
                    SMODS.destroy_cards(context.other_card),
                    func = function()
                        card:juice_up(0.3,0.4)
                        return true
                    end
                }))
                
                
                card.ability.extra.Mult = card.ability.extra.Mult * 2
                return { 
                    message = localize('k_upgrade_ex'),
                    extra = {focus = card, colour = G.C.MULT, message = 'Doubled!'},
                    focus = card
                }
            end
            if context.other_card:get_id() == 5 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card:juice_up(0.3,0.4)
                        return true
                    end
                }))
                card.ability.extra.Mult = card.ability.extra.Mult + card.ability.extra.BaseMultGain
                return {
                    
                    message = localize('k_upgrade_ex'),
                    extra = {focus = card, colour = G.C.MULT, message = localize{type='variable',key='a_mult',vars={card.ability.extra.BaseMultGain}}},
                    focus = card
                }
            end
            
            
        end
        if context.joker_main then 
            return{ 
                    mult = card.ability.extra.Mult
            }
        end
    end
}

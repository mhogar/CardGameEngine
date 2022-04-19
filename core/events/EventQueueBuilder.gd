extends Resource
class_name EventQueueBuilder

var queue : EventQueue
var log_scripts : StandardLogScripts


func _init(name : String, captured_outputs : Array):
	log_scripts = StandardLogScripts.new()
	
	queue = preload("res://core/events/queue/EventQueue.tscn").instance()
	queue.name = name
	queue.captured_outputs = captured_outputs


func _add_event(event : Event, args : Dictionary) -> EventQueueBuilder:
	queue.add_event(event, args)
	return self
	

func finalize(args : Dictionary) -> EventQueue:
	queue.static_args = args
	return queue


##
# QUEUE EVENTS
##

func sub_queue(builder : EventQueueBuilder, args : Dictionary) -> EventQueueBuilder:
	return _add_event(builder.finalize(args), args)


# Break out of the target queue.
# Inputs: none
# Outputs: none
func break_queue(target_queue : EventQueue) -> EventQueueBuilder:
	var event : Event = preload("res://core/events/queue/BreakQueue.tscn").instance()
	event.target_queue = target_queue
	
	return _add_event(event, {})


##
# CONDITIONAL EVENTS
##

func _add_conditional_event(event : ConditionalEvent, true_event : Event, false_event : Event, args : Dictionary) -> EventQueueBuilder:
	if true_event == null:
		true_event = preload("res://core/events/Event.tscn").instance()
		
	if false_event == null:
		false_event = preload("res://core/events/Event.tscn").instance()
	
	event.init(true_event, false_event)
	return _add_event(event, args)


# Runs the provided event if source_deck is empty.
# Inputs: source_deck
# Outputs: none
func deck_empty_condition(is_empty_event : Event, args : Dictionary) -> EventQueueBuilder:
	return _add_conditional_event(preload("res://core/events/conditional/EmptyDeck.tscn").instance(), is_empty_event, null, args)


# Runs the first provided event if selectable_indices is not empty, else runs the second event.
# Inputs: selectable_indices
# Outputs: none
func has_selectable_indices_condition(has_indices_event : Event, no_indices_event : Event) -> EventQueueBuilder:
	return _add_conditional_event(preload("res://core/events/conditional/HasSelectableIndices.tscn").instance(), has_indices_event, no_indices_event, {})


# Runs the provided event if there are at most num_players left.
# Inputs: num_players
# Outputs: none
func players_left_condition(players_left_event : Event, args : Dictionary) -> EventQueueBuilder:
	return _add_conditional_event(preload("res://core/events/conditional/PlayersLeft.tscn").instance(), players_left_event, null, args)
	

##
# SCRIPTS EVENTS
##

func _add_script_event(event : ScriptEvent, object : Object, func_name : String) -> EventQueueBuilder:
	event.object = object
	event.func_name = func_name
	
	return _add_event(event, {})


# Runs the provided generic script.
# Inputs: none
# Outputs: none
func run_script(object : Object, func_name : String) -> EventQueueBuilder:
	return _add_script_event(preload("res://core/events/script/ScriptEvent.tscn").instance(), object, func_name)


# Runs the provided scoreboard script.
# Inputs: none
# Outputs: none
func scoreboard_script_event(object : Object, func_name : String) -> EventQueueBuilder:
	return _add_script_event(preload("res://core/events/script/ScoreboardScript.tscn").instance(), object, func_name)


# Runs the provided log script.
# Inputs: none
# Outputs: none
func run_log_script(object : Object, func_name : String) -> EventQueueBuilder:
	return _add_script_event(preload("res://core/events/script/LogScript.tscn").instance(), object, func_name)


##
# RULESET EVENTS
##


# Applies the provided ruleset to source_deck.
# Inputs: source_deck
# Outputs: selectable_indices
func apply_ruleset(ruleset : Ruleset, args : Dictionary) -> EventQueueBuilder:
	var event : ApplyRulesetEvent = preload("res://core/events/ruleset/ApplyRuleset.tscn").instance()
	event.ruleset = ruleset
	
	return _add_event(event, args)


##
# CARD EVENTS
##


# Start UX for selecting a card.
# Inputs: source_deck, player, selectable_indices
# Outputs: card_index
func select_card(args : Dictionary) -> EventQueueBuilder:
	return _add_event(preload("res://core/events/card/SelectCard.tscn").instance(), args)


# Select the top card of source_deck.
# Inputs: source_deck
# Outputs: card_index
func select_top_card(args : Dictionary) -> EventQueueBuilder:
	return _add_event(preload("res://core/events/card/SelectTopCard.tscn").instance(), args)
	

# Move the card with card_index in source_deck to dest_deck.
# Inputs: source_deck, card_index, dest_deck
# Outputs: none
func move_card(args : Dictionary) -> EventQueueBuilder:
	return _add_event(preload("res://core/events/card/MoveCard.tscn").instance(), args)


# Move the top card of source_deck to dest_deck.
# Inputs: source_deck, dest_deck
# Outputs: none
func move_top_card(args : Dictionary) -> EventQueueBuilder:
	var builder := EventQueueBuilder.new("MoveTopCard", []) \
		.select_top_card({}) \
		.move_card({})
		
	args["num_iter"] = 1
	return sub_queue(builder, args)


# Moves all cards from source_deck to dest_deck.
# Inputs: source_deck, dest_deck
# Outputs: none
func move_cards(leave_top_card : bool, args : Dictionary) -> EventQueueBuilder:
	var event : MoveCardsEvent = preload("res://core/events/card/MoveCards.tscn").instance()
	event.leave_top_card = leave_top_card
	
	return _add_event(event, args)


##
# DECK EVENTS
##


# Shuffles target deck. 
# Inputs: source_deck / dest_deck
# Outputs: none
func shuffle_pile(deck_type : int, args : Dictionary) -> EventQueueBuilder:
	var event : ShuffleDeckEvent = preload("res://core/events/deck/ShuffleDeck.tscn").instance()
	event.deck_type = deck_type
	
	return _add_event(event, args)


# Builds source_deck using the provided builder.
# Inputs: source_deck
# Outputs: none
func build_deck_event(builder : DeckBuilder, args : Dictionary) -> EventQueueBuilder:
	return _add_event(preload("res://core/events/deck/BuildDeck.tscn").instance(), args)


# Moves all cards from source_deck to dest_deck, then shuffles dest_deck.
# Inputs: source_deck, dest_deck
# Outputs: none
func reshuffle_deck(leave_top_card : bool, args : Dictionary) -> EventQueueBuilder:
	var builder := EventQueueBuilder.new("ReshuffleDeck", []) \
		.move_cards(leave_top_card, {}) \
		.shuffle_pile(Event.DECK_TYPE.DEST, {}) \
		.run_log_script(log_scripts, "reshuffled_deck")
	
	args["num_iter"] = 1
	return sub_queue(builder, args)


##
# PLAYER EVENTS
##


# Rotates the turn to the next player.
# Inputs: none
# Outputs: none
func next_turn() -> EventQueueBuilder:
	return _add_event(preload("res://core/events/player/NextTurn.tscn").instance(), {})


# Selects the player with player_index.
# Inputs: player_index
# Outputs: player
func select_player(args : Dictionary) -> EventQueueBuilder:
	return _add_event(preload("res://core/events/player/SelectPlayer.tscn").instance(), args)


# Select the player's deck with deck_name.
# Inputs: deck_name
# Outputs: source_deck / dest_deck
func select_player_deck(deck_type : int, args : Dictionary) -> EventQueueBuilder:
	var event : SelectPlayerDeckEvent = preload("res://core/events/player/SelectPlayerDeck.tscn").instance()
	event.deck_type = deck_type
	
	return _add_event(event, args)


# Remove the player with player_index.
# Inputs: player_index
# Outputs: none
func remove_player(args : Dictionary) -> EventQueueBuilder:
	return _add_event(preload("res://core/events/player/RemovePlayer.tscn").instance(), args)


# Outs player with player_index from the game.
# Inputs: player_index
# Outputs: none
func player_out(args : Dictionary) -> EventQueueBuilder:
	var builder := EventQueueBuilder.new("PlayerOut", []) \
		.select_player({}) \
		.run_log_script(log_scripts, "player_out") \
		.remove_player({})
	
	args["num_iter"] = 1
	return sub_queue(builder, args)


# Sets the turn to player_index.
# Inputs: player_index
# Outputs: none
func set_turn(args : Dictionary) -> EventQueueBuilder:
	return _add_event(preload("res://core/events/player/SetTurn.tscn").instance(), args)


# Sets num_iter to the number of players. 
# Inputs: none
# Outputs: num_iter
func loop_num_players() -> EventQueueBuilder:
	return _add_event(preload("res://core/events/player/LoopNumPlayers.tscn").instance(), {})


# Deals n cards to each player. Assumes current player is the dealer.
# Inputs: num_iter, deck_name, source_deck
# Outputs: none
func deal_cards(args : Dictionary) -> EventQueueBuilder:
	var deal_card_builder := EventQueueBuilder.new("DealCard", []) \
		.next_turn() \
		.select_player({ "player_index": 0 }) \
		.select_player_deck(Event.DECK_TYPE.DEST, {}) \
		.move_top_card({}) \
	
	var deal_cards_builder := EventQueueBuilder.new("DealCards", []) \
		.loop_num_players() \
		.sub_queue(deal_card_builder, args)
	
	return sub_queue(deal_cards_builder, {})


# Starts UX for player with player_index to play a card from their deck with deck_name to dest_deck.
# Inputs: player_index, deck_name, dest_deck
# Outputs: none
func play_card(ruleset : Ruleset, cant_play_event : Event, hand_emptied_event : Event, args : Dictionary) -> EventQueueBuilder:	
	var play_card_builder := EventQueueBuilder.new("PlayCard", []) \
		.select_card({}) \
		.run_log_script(log_scripts, "card_played") \
		.move_card({}) \
		.deck_empty_condition(hand_emptied_event, {}) \
	
	var try_play_card_builder := EventQueueBuilder.new("TryPlayCard", []) \
		.select_player({}) \
		.select_player_deck(Event.DECK_TYPE.SOURCE, {}) \
		.apply_ruleset(ruleset, {}) \
		.has_selectable_indices_condition(play_card_builder.finalize(args), cant_play_event)
	
	args["num_iter"] = 1
	return sub_queue(try_play_card_builder, args)


# Starts UX for drawing cards from source deck to the player with player_index's deck with deck_name.
# Inputs: num_iter, source_deck, player_index, deck_name
# Outputs: none
func draw_cards(deck_emptied_event : Event, args : Dictionary) -> EventQueueBuilder:
	var builder := EventQueueBuilder.new("DrawCards", []) \
		.apply_ruleset(TopCardRuleset.new(), {}) \
		.select_player({}) \
		.select_card({}) \
		.select_player_deck(Event.DECK_TYPE.DEST, {}) \
		.run_log_script(log_scripts, "card_drawn") \
		.move_card({}) \
		.deck_empty_condition(deck_emptied_event, {})
	
	return sub_queue(builder, args)

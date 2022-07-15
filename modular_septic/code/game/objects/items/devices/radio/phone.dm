GLOBAL_LIST_EMPTY(phone_list)
GLOBAL_LIST_EMPTY(public_phone_list)

/obj/item/cellular_phone
	name = "cellular phone"
	var/brand_name = "ULTRABLUE PRINCE"
	desc = "An allegedly portable phone that comes with primarily communication uses, with the ability to make both public and private calls from anywhere in the world. Data service may vary If you're \
	tightly trapped in a supernatural warehouse with only one way out."
	icon = 'modular_septic/icons/obj/items/device.dmi'
	icon_state = "phone"
	base_icon_state = "phone"
	inhand_icon_state = "electronic"
	worn_icon_state = "pda"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	item_flags = NOBLUDGEON
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_ID | ITEM_SLOT_BELT
	verb_say = "communicates"
	pickup_sound = 'modular_septic/sound/efn/phone_pickup.ogg'
	equip_sound = 'modular_septic/sound/efn/phone_holster.ogg'
	var/callingSomeone = 'modular_septic/sound/efn/phone_call.ogg'
	var/hangUp = 'modular_septic/sound/efn/phone_hangup.ogg'
	var/answer = 'modular_septic/sound/efn/phone_answer.ogg'
	var/phoneDead = 'modular_septic/sound/efn/phone_dead.ogg'
	var/device_insert = 'modular_septic/sound/efn/phone_simcard_insert.ogg'
	var/device_desert = 'modular_septic/sound/efn/phone_simcard_desert.ogg'
	var/phone_press = list('modular_septic/sound/effects/phone_press.ogg', 'modular_septic/sound/effects/phone_press2.ogg', 'modular_septic/sound/effects/phone_press3.ogg', 'modular_septic/sound/effects/phone_press4.ogg')
	var/phone_publicize = 'modular_septic/sound/efn/phone_publicize.ogg'
	var/talking_noises = list('modular_septic/sound/efn/phone_talk1.ogg', 'modular_septic/sound/efn/phone_talk2.ogg', 'modular_septic/sound/efn/phone_talk3.ogg')
	var/beginreset_noise = 'modular_septic/sound/efn/phone_beginreset.ogg'
	var/reset_noise = 'modular_septic/sound/efn/phone_reset.ogg'
	var/query_noise = 'modular_septic/sound/efn/phone_query.ogg'
	var/calling_someone = FALSE
	var/ringring = FALSE
	var/resetting = FALSE
	var/stalling = FALSE
	var/obj/item/cellular_phone/connected_phone
	var/obj/item/cellular_phone/called_phone
	var/obj/item/cellular_phone/paired_phone
	var/obj/item/sim_card/sim_card

	var/reset_time

	var/datum/looping_sound/phone_ringtone/ringtone_soundloop
	var/datum/looping_sound/phone_call/call_soundloop

/obj/item/cellular_phone/examine(mob/user)
	. = ..()
	if(sim_card)
		var/final_card_message = "There's a sim card installed."
		var/final_reset_message = "The blue light is on,"
		var/final_pairing_message = "Someone's on the line."
		if(sim_card.number)
			final_card_message += span_boldnotice(" My number is [sim_card.number]\n")
		if(sim_card.public_name)
			final_card_message += span_boldnotice(" My public name is [sim_card.public_name]\n")
		if(resetting)
			final_reset_message += span_warning(" It's currently undergoing a factory reset.\n")
			final_reset_message += span_boldwarning("[reset_time] deciseconds until It's complete.")
			. += span_notice("[final_reset_message]\n")
		if(paired_phone)
			final_pairing_message += span_boldnotice(" Their phone number is [paired_phone.sim_card.number]")
			. += span_notice("[final_pairing_message]\n")
		. += span_notice("[final_card_message]\n")

/obj/item/cellular_phone/examine_more(mob/user)
	. = list()
	. += span_infoplain("There's an instruction manual on the back of [src].\n")
	. += span_info("The [brand_name] [src] control manual.")
	. += span_info("middle pad button (MMB) for a suprise.")
	. += span_info("left pad button (LMB) to make calls and set your initial name.")
	. += span_info("right pad button (RMB) to configure settings.")
	. += span_info("back switch button (ALT+LMB) to eject current sim card.\n")
	. += span_warning("WARNING: IF YOUR ULTRABLUE PRINCESS HAS BEEN INFECTED WITH A VIRUS, A FACTORY RESET WILL REMOVE ALL SAVED DATA, AS WELL AS THE VIRUS ITSELF.\n")
	. += span_warning("DO NOT ACCEPT OR MAKE ANY CALLS WHILE YOU KNOW YOU HAVE A VIRUS UNTIL YOU MAKE A FACTORY RESET.")

/obj/item/cellular_phone/update_overlays()
	. = ..()
	if(sim_card && !resetting && !stalling)
		. += "[icon_state]_active"
	else if(resetting)
		. += "[icon_state]_resetting"
	else if(stalling)
		. += "[icon_state]_glitch"
	if(ringring)
		. += "[icon_state]_ringring"
	if(paired_phone)
		. += "[icon_state]_paired"

/obj/item/cellular_phone/Initialize(mapload)
	. = ..()
	become_hearing_sensitive(trait_source = ROUNDSTART_TRAIT)
	reset_time = rand(60 SECONDS,120 SECONDS)
	call_soundloop = new(src, FALSE)
	ringtone_soundloop = new(src, FALSE)

/obj/item/cellular_phone/proc/infect_with_virus(mob/living/user/wielder)
	if(sim_card.virus)
		return
	sim_card.virus = new /obj/item/sim_card_virus(src)
	sim_card.virus.our_host = src
	START_PROCESSING(SSobj, sim_card.virus)
	if(sim_card.virus)
		log_game("[src] was infected by malware.")

/obj/item/sim_card
	name = "\improper sim card"
	desc = "Sim, sim, I agree with your statement"
	icon = 'modular_septic/icons/obj/items/device.dmi'
	icon_state = "simcard"
	base_icon_state = "simcard"
	var/public_name
	var/is_public
	var/number
	// Used by viruses, determines if the sim card messes up your next action, turns to false when It's done.
	var/bugged = FALSE
	var/obj/item/sim_card_virus/virus
	var/obj/item/cellular_phone/owner_phone
	w_class = WEIGHT_CLASS_TINY
	item_flags = NOBLUDGEON

/obj/item/sim_card/proc/start_dormant_timer()
	addtimer(CALLBACK(src, .proc/progress_virus), virus.dormancy_timer)

/obj/item/sim_card/proc/progress_virus(mob/living/user, owner_phone)
	if(isnull(owner_phone))
		return
	if(!virus)
		return
	if(virus.dormant)
		virus.dormant = FALSE
	START_PROCESSING(SSobj, virus)
	virus.our_host = src
	virus.stage++
	if(virus.stage > 0)
		virus.stage_increase_prob += 5
	virus.hint(user, hint_chance = 65)

/obj/item/sim_card/Initialize(mapload)
	. = ..()
	number = "[rand(0,9)][rand(0,9)][rand(0,9)][rand(0,9)]-[rand(0,9)][rand(0,9)][rand(0,9)][rand(0,9)]"
	if(GLOB.phone_list[number])
		log_bomber(src, "has been detected as the same phone number as another sim card, It has been exploded!")
		explosion(src, heavy_impact_range = 1, adminlog = TRUE, explosion_cause = src)
		qdel(src)

/obj/item/cellular_phone/Destroy()
	. = ..()
	QDEL_NULL(call_soundloop)
	QDEL_NULL(ringtone_soundloop)

/obj/item/sim_card_virus
	name = "A Virus"
	desc = "How did you PHYSICALLY take out a virus from a phone, how did that even fucking happen? You're not nortan security"
	var/dormant = TRUE
	var/dormancy_timer
	var/stage = 0
	var/virus_screams = list('modular_septic/sound/efn/virus_scream.ogg', 'modular_septic/sound/efn/virus_scream2.ogg', 'modular_septic/sound/efn/virus_scream3.ogg')
	var/virus_acute_hint = 'modular_septic/sound/efn/virus_acute.ogg'
	var/mild_glitches = list("simple_glitch")
	var/moderate_glitches = list("stall")
	var/acute_glitches = list("zap", "fake_call")
	var/final_glitch = list("explode")

	var/initial_virus_noise_prob = 2
	var/initial_virus_noise_volume = 5
	var/stage_increase_prob = 5
	var/virus_noise_prob
	var/virus_noise_volume
	var/obj/item/sim_card/our_host

/obj/item/sim_card_virus/Initialize(mapload)
	. = ..()
	dormancy_timer = rand(2 MINUTES, 8 MINUTES)
	virus_noise_prob = initial_virus_noise_prob
	virus_noise_volume = initial_virus_noise_volume

/obj/item/sim_card_virus/process(delta_time)
	. = ..()
	if(isnull(our_host))
		qdel(src)
		return PROCESS_KILL
	if(DT_PROB(3, delta_time))
		if(dormant)
			our_host.start_dormant_timer()
			return PROCESS_KILL
		var/mob/living/elderly_man
		if(stage == 1)
			mild_effects(elderly_man)
		if(stage == 2)
			mild_effects(elderly_man)
			moderate_effects(elderly_man)
		if(stage == 3)
			mild_effects(elderly_man)
			moderate_effects(elderly_man)
			acute_effects(elderly_man)
		if(stage == 4)
			final_effect(elderly_man)

/obj/item/sim_card_virus/proc/mild_effects(mob/living/user)
	if(isnull(our_host))
		qdel(src)
		return
	if(prob(65) && !our_host.owner_phone.stalling)
		malfunction(user, malfunction = mild_glitches)
		return
	else
		hint(user, hint_chance = 100)
	if(prob(stage_increase_prob))
		our_host.progress_virus()

/obj/item/sim_card_virus/proc/moderate_effects(mob/living/user)
	if(isnull(our_host))
		qdel(src)
		return
	if(our_host.owner_phone.paired_phone && prob(80))
		malfunction(user, malfunction = "phone_glitch")
	else if(prob(60) && !our_host.owner_phone.stalling)
		malfunction(user, malfunction = moderate_glitches)
	else
		hint(user, hint_chance = 100)
	if(prob(stage_increase_prob))
		our_host.progress_virus()

/obj/item/sim_card_virus/proc/acute_effects(mob/living/user)
	if(isnull(our_host))
		qdel(src)
		return
	if(prob(50) && !our_host.owner_phone.stalling)
		malfunction(user, malfunction = acute_glitches)
	else
		hint(user, hint_chance = 100)
	if(prob(stage_increase_prob))
		our_host.progress_virus()

/obj/item/sim_card_virus/proc/final_effect(mob/living/user)
	if(isnull(our_host))
		qdel(src)
		return
	if(prob(20) && !our_host.owner_phone.stalling)
		malfunction(user, malfunction = final_glitch)
	else
		hint(user, hint_chance = 100)
	if(prob(stage_increase_prob))
		our_host.progress_virus()

/obj/item/sim_card_virus/proc/hint(mob/living/user, hint_chance = virus_noise_prob)
	if(isnull(our_host))
		qdel(src)
		return
	if(prob(hint_chance))
		var/hint_message
		playsound(our_host, virus_screams, virus_noise_volume, FALSE)
		if(stage <= 2 && stage != 0)
			hint_message = "[our_host.owner_phone] vibrates."
		else if(stage == 3)
			hint_message = "[our_host.owner_phone] vibrates, the screen flickering."
		else if(stage == 4)
			hint_message = "[our_host.owner_phone] violently vibrates, flashing incoherent errors while the phone's screens blinks and glitches."
			playsound(our_host.owner_phone, virus_acute_hint, 65, FALSE)
		if(hint_message)
			visible_message(span_notice("[hint_message]"))

/obj/item/sim_card_virus/proc/malfunction(mob/living/user, malfunction)
	if(isnull(our_host))
		qdel(src)
		return
	if(malfunction == "simple_glitch")
		our_host.bugged = TRUE
		hint(user, hint_chance = 100)
		return
	if(malfunction == "phone_glitch")
		if(our_host.owner_phone.paired_phone)
			our_host.owner_phone.hang_up(user, connecting_phone = our_host.owner_phone.connected_phone)
			to_chat(user, span_boldwarning("You are forcefully hung up by a system error!"))
			return
	if(malfunction == "stall")
		our_host.owner_phone.stall(stalling_phone = our_host.owner_phone, user)
		return
	if(malfunction == "final_glitch")
		our_host.owner_phone.self_destruct_sequence(exploding_phone = our_host.owner_phone, user)

/obj/item/cellular_phone/attackby(obj/item/I, mob/living/zoomer, params)
	. = ..()
	if(istype(I,/obj/item/sim_card))
		if(sim_card)
			to_chat(zoomer, span_notice("There's already a [sim_card] installed."))
			return
		if(zoomer.transferItemToLoc(I, src))
			to_chat(zoomer, span_notice("I carefully install the [I] into [src]'s sim card slot."))
			playsound(src, device_insert, 65, FALSE)
			sim_card = I
			sim_card.owner_phone = src
			if(sim_card.number)
				GLOB.phone_list[sim_card.number] = src
			if(sim_card.public_name && sim_card.is_public)
				GLOB.public_phone_list[sim_card.public_name] = src
	update_appearance(UPDATE_ICON)

/obj/item/cellular_phone/attack_self_tertiary(mob/user, modifiers)
	. = ..()
	if(resetting)
		to_chat(user, span_warning("It's performing a factory reset!"))
		return
	if(stalling)
		to_chat(user, span_warning("Something's wrong with it!"))
		return
	var/message = pick("[user] types 80085 on the [src].", \
	"[user] violently presses every key on the [src].", \
	"[user] clearly wanted a flip phone in the first place!", \
	"[user] plays raging birds!", \
	"[user] nearly falls asleep at the idea of paying for data!", \
	"[user] has an unregistered hypercam!")
	playsound(src, phone_press, 65, FALSE)
	visible_message(span_boldnotice("[message]"))

/obj/item/cellular_phone/AltClick(mob/user)
	. = ..()
	if(!sim_card)
		to_chat(user, span_notice("There's nothing in the sim card slot."))
		return
	eject_sim_card(user)

/obj/item/cellular_phone/proc/eject_sim_card(mob/living/user)
	if(resetting)
		to_chat(user, span_warning("It's performing a factory reset!"))
		return
	if(stalling)
		to_chat(user, span_warning("Something's wrong with it!"))
		return
	to_chat(user, span_notice("I carefully take out the [sim_card] from the [src]'s sim card slot."))
	playsound(src, device_desert, 65, FALSE)
	user.transferItemToLoc(sim_card, user.loc)
	user.put_in_hands(sim_card)
	if(sim_card.number)
		GLOB.phone_list -= sim_card.number
	if(sim_card.public_name)
		GLOB.public_phone_list -= sim_card.public_name
	sim_card.owner_phone = null
	sim_card = null
	if(connected_phone)
		hang_up(user, connecting_phone = paired_phone)
	update_appearance(UPDATE_ICON)

/obj/item/cellular_phone/proc/gib_them_with_a_delay(mob/living/user)
	playsound(src, 'modular_septic/sound/effects/ted_beeping.wav', 80, FALSE, 2)
	if(user)
		user.sound_hint()
	else
		sound_hint()
	sleep(8)
	user.gib()

/obj/item/cellular_phone/attack_self_secondary(mob/user, modifiers)
	. = ..()
	var/title = "Settings"
	var/mob/living/carbon/human/human_user
	if(ishuman(user))
		human_user = user
	if(resetting)
		to_chat(user, span_warning("It's performing a factory reset!"))
		return
	if(stalling)
		to_chat(user, span_warning("Something's wrong with it!"))
		return
	if(!sim_card)
		to_chat(user, span_notice("I need a sim card installed to perform this function."))
		return
	if(!sim_card.public_name)
		to_chat(user, span_notice("I need to go through the regular set-up process before I access this."))
		return
	if(sim_card.bugged)
		var/hatemessage = list("What the fuck?!", "What the hell?!", "Motherfucker!", "That just doesn't make sense!")
		user.say("[hatemessage]")
		do_random_bug(src, user)
		sim_card.bugged = FALSE
		return
	playsound(src, phone_press, 65, FALSE)
	var/options = list("Change Publicity", "Change Public Name", "Disable Parental Controls", "Self-Status", "Factory Reset")
	if(human_user?.dna.species.id == SPECIES_INBORN)
		options = list("Edit Interweb-Invisibility", "Hide from Scrutiny", "Disable Parental Controls", "What the fuck am I", "I stole this phone, please wipe all the data so I can sell it.")
	var/input = input(user, "What setting would you like to access?", title, "") as null|anything in options
	if(!input)
		return
	if(input == "Self-Status" || input == "What the fuck am I")
		self_status(user)
		return
	if(input == "Change Publicity" || input == "Edit Interweb-Invisibility")
		change_public_status(user)
		return
	if(input == "Change Public Name" || input == "Hide from Scrutiny")
		change_public_name(user)
		return
	if(input == "Disable Parental Controls")
		var/funnymessage = "Not enough access."
		var/parental_figure = pick("MOMMY", "DADDY")
		if(human_user?.dna.species.id == SPECIES_INBORN)
			funnymessage = "MY [parental_figure] TOLD ME NOT TO."
		playsound(src, query_noise, 65, FALSE)
		to_chat(user, span_boldwarning(funnymessage))
		return
	if(input == "Factory Reset" || "I stole this phone, please wipe all the data so I can sell it.")
		factory_reset(user)
		return

/obj/item/cellular_phone/proc/do_random_bug(mob/living/user, list/modifiers)
	if((!sim_card.bugged || !sim_card.virus) && !stalling || !resetting)
		return
	var/action	= pick(.proc/eject_sim_card(user), .proc/self_status(user), .proc/change_public_status(user), .proc/call_prompt(user))
	INVOKE_ASYNC(src, action)

/obj/item/cellular_phone/proc/self_status(mob/living/user)
	if(!sim_card)
		to_chat(user, span_notice("I need a sim card installed to perform this function."))
		return
	if(connected_phone)
		to_chat(user, span_notice("I can't do this while I'm calling someone."))
		return
	var/mob/living/carbon/human/human_user
	if(ishuman(user))
		human_user = user
	playsound(src, query_noise, 65, FALSE)
	if(HAS_TRAIT(human_user, TRAIT_GAKSTER))
		var/gakster_message = "I'm a Gakster Scavenger."
		var/mental_disabilities = pick("Delusional disorder.", "Schizophrenia", "Paraphrenia", "Brief Psychotic Disorder", "a Stroke", "a Traumatic Brain Injury")
		gakster_message += span_boldnotice(" I have [mental_disabilities]")
		to_chat(user, span_notice("[gakster_message]"))
		return
	if(human_user?.dna.species.id == SPECIES_INBORN)
		var/inborn_message = "I'm a human"
		var/unfortunate_circumstance = pick("I'm filled with narcotics and anti-depressants.", "I clearly haven't been loved before. EVER.", "I don't know what I'm doing here.", \
		"I'm too violent, my parents disowned me.")
		if(prob(5))
			unfortunate_circumstance = "I'm a mentally-ill coder with anger issues and a severe distaste for rats that fly."
		inborn_message += span_boldnotice(" [unfortunate_circumstance]")
		to_chat(user, span_notice("[inborn_message]"))
		return
	if(SSjob.GetJobType(/datum/job/denominator))
		var/denominator_message = "I'm an agent of the Third Denomination"
		var/violent_tendancies = pick("I love snapping fingers and breaking bones.", "I want to tear someone open and slowly pull out their organs.", "I cannot comprehend that there's living breathing humans among me.", \
		"I can't stop hurting myself and others around me.", "Someday I'm going to destroy everything.", "I want to lose myself in blood and bits of bone.", "I love skinning people alive.", "I know it takes empathy to be truely sadistic.")
		if(prob(5))
			violent_tendancies = "I hate Internal Bleeding students."
		else if(prob(5))
			violent_tendancies = pick("I just fucking hate this world and the human worms feasting on it's carcass.", "My whole life is just cold, bitter hatred.", "I always wanted to die violently.")
		denominator_message += span_infection(" [violent_tendancies]")
		to_chat(user, span_info("[denominator_message]"))
		return


/obj/item/cellular_phone/proc/change_public_name(mob/living/user)
	if(!sim_card)
		to_chat(user, span_notice("I need a sim card installed to perform this function."))
		return
	if(connected_phone)
		to_chat(user, span_notice("I can't do this while I'm calling someone."))
		return
	var/title = "Undercover"
	if(sim_card.public_name)
		var/input = input(user, "New Username?", title, "") as text|null
		if(!input)
			return
		if((input in GLOB.phone_list) || (input in GLOB.public_phone_list))
			to_chat(user, span_notice("There's someone with this name already."))
			return
		if(input == lowertext("BITCHKILLA555") || input == lowertext("BITCHKILLER555"))
			to_chat(user, span_flashingbigdanger("DONOSED!"))
			user.emote("scream")
			INVOKE_ASYNC(src, .proc/gib_them_with_a_delay, user)
			return
		if(input == lowertext("agent_ronaldo") || input == lowertext("agent ronaldo"))
			to_chat(user, span_bolddanger("You're a terrible person."))
		if(sim_card.is_public)
			GLOB.public_phone_list -= sim_card.public_name
		sim_card.public_name = input
		to_chat(user, span_notice("Username successfully changed."))
		playsound(src, query_noise, 65, FALSE)
		if(sim_card.is_public)
			GLOB.public_phone_list[sim_card.public_name] = src

/obj/item/cellular_phone/proc/change_public_status(mob/living/user)
	if(!sim_card)
		to_chat(user, span_notice("I need a sim card installed to perform this function."))
		return
	if(connected_phone)
		to_chat(user, span_notice("I can't do this while I'm calling someone."))
		return
	if(sim_card.is_public)
		sim_card.is_public = FALSE
		to_chat(user, span_notice("Taken off of the public phone board."))
		playsound(src, query_noise, 65, FALSE)
		GLOB.public_phone_list -= sim_card.public_name
		return
	if(!sim_card.is_public)
		sim_card.is_public = TRUE
		to_chat(user, span_notice("Put on the public phone board."))
		playsound(src, phone_publicize, 65, FALSE)
		GLOB.public_phone_list[sim_card.public_name] = src
		return


/obj/item/cellular_phone/proc/factory_reset(mob/living/user)
	if(!sim_card)
		to_chat(user, span_notice("I need a sim card installed to perform this function."))
		return
	if(connected_phone)
		to_chat(user, span_notice("I can't do this while I'm calling someone."))
		return
	GLOB.phone_list -= sim_card.number
	GLOB.public_phone_list -= sim_card.public_name
	resetting = TRUE
	update_appearance(UPDATE_ICON)
	sim_card.public_name = null
	sim_card.is_public = null
	sim_card.number = null
	sim_card.bugged = FALSE
	qdel(sim_card.virus)
	sim_card.virus = null
	playsound(src, beginreset_noise, 65, FALSE)
	to_chat(user, span_boldnotice("I begin a automated factory reset on the [src]"))
	addtimer(CALLBACK(src, .proc/finalize_factory_reset), reset_time)

/obj/item/cellular_phone/proc/finalize_factory_reset(mob/living/user)
	visible_message(span_notice("[src] has successfully factory reset!"))
	playsound(src, reset_noise, 60, FALSE)
	sim_card.number = "[rand(0,9)][rand(0,9)][rand(0,9)][rand(0,9)]-[rand(0,9)][rand(0,9)][rand(0,9)][rand(0,9)]"
	resetting = FALSE
	reset_time = rand(60 SECONDS,120 SECONDS)
	update_appearance(UPDATE_ICON)

/obj/item/cellular_phone/attack_self(mob/living/user, list/modifiers)
	. = ..()
	var/title = "The Future of Technology"
	var/mob/living/carbon/human/human_user
	if(ishuman(user))
		human_user = user
	if(resetting)
		to_chat(user, span_warning("It's performing a factory reset!"))
		return
	if(stalling)
		to_chat(user, span_warning("Something's wrong with it!"))
		return
	if(!sim_card)
		to_chat(user, span_notice("The [src] doesn't have a sim card installed."))
		return
	if(!sim_card.public_name)
		set_public_name(user)
		return
	if(!sim_card.number)
		to_chat(user, span_notice("It doesn't have a number, press the button on the right and start a factory reset!"))
		return
	if(isnull(sim_card.is_public))
		set_publicity(user)
		return
	if(called_phone || connecting_phone || paired_phone)
		standard_phone_checks(user)
		return
	else
		call_prompt(user)
		return
	update_appearance(UPDATE_ICON)

/obj/item/cellular_phone/proc/set_public_name(mob/living/user, list/modifiers)
	if(resetting)
		to_chat(user, span_warning("It's performing a factory reset!"))
		return
	if(stalling)
		to_chat(user, span_warning("Something's wrong with it!"))
		return
	if(!sim_card)
		to_chat(user, span_notice("The [src] doesn't have a sim card installed."))
		return
	var/input = input(user, "Username?", title, "") as text|null
	if(!input)
		return
	if((input in GLOB.phone_list) || (input in GLOB.public_phone_list))
		to_chat(user, span_notice("There's someone with this name already."))
		return
	if(input == lowertext("BITCHKILLA555") || input == lowertext("BITCHKILLER555"))
		to_chat(user, span_flashingbigdanger("DONOSED!"))
		user.emote("scream")
		INVOKE_ASYNC(src, .proc/gib_them_with_a_delay, user)
		return
	if(input == lowertext("agent_ronaldo") || input == lowertext("agent ronaldo"))
			to_chat(user, span_bolddanger("You're a terrible person."))
	sim_card.public_name = input

/obj/item/cellular_phone/proc/set_publicity(mob/living/user, list/modifiers)
	var/options = list("Yes", "No")
	if(human_user?.dna.species.id == SPECIES_INBORN)
		options = list("MHM", "NAHHHHH")
	var/input = input(user, "Would you like to be a public number?", title, "") as null|anything in options
	if(input == "NAHHHHH" || input == "No")
		sim_card.is_public = FALSE
		GLOB.phone_list = src
		return
	if(!input)
		return
	playsound(src, phone_publicize, 65, FALSE)
	to_chat(user, span_notice("Publicized! All users can now dial your phone: [sim_card.public_name]"))
	GLOB.phone_list[sim_card.number] = src
	GLOB.public_phone_list[sim_card.public_name] = src
	sim_card.is_public = TRUE
	return

/obj/item/cellular_phone/proc/standard_phone_checks(mob/living/user, list_modifiers)
	if(resetting)
		to_chat(user, span_warning("It's performing a factory reset!"))
		return
	if(stalling)
		to_chat(user, span_warning("Something's wrong with it!"))
		return
	if(!sim_card)
		to_chat(user, span_notice("The [src] doesn't have a sim card installed."))
		return
	if(called_phone && !calling_someone)
		var/options = list("Yes", "No")
		if(human_user?.dna.species.id == SPECIES_INBORN)
			options = list("MHM", "NAHHHHH")
		var/input = input(user, "Pick up the phone?", title, "") as null|anything in options
		if(input == "NAHHHHH" || input == "No")
			hang_up(user, connecting_phone = connected_phone)
			return
		if(!input)
			return
		answer(caller = user, caller_phone = src, called_phone = connected_phone)
		update_appearance(UPDATE_ICON)
		return
	if(calling_someone)
		var/options = list("Yes", "No")
		if(human_user?.dna.species.id == SPECIES_INBORN)
			options = list("MHM", "NAHHHHH")
		var/input = input(user, "Hang up?", title, "") as null|anything in options
		if(input == "NAHHHHH" || input == "No")
			return
		if(!input)
			return
		hang_up(user, connecting_phone = connected_phone)
		update_appearance(UPDATE_ICON)
		return

/obj/item/cellular_phone/proc/call_prompt(mob/living/user, list/modifiers)
	if(resetting)
		to_chat(user, span_warning("It's performing a factory reset!"))
		return
	if(stalling)
		to_chat(user, span_warning("Something's wrong with it!"))
		return
	if(!sim_card)
		to_chat(user, span_notice("The [src] doesn't have a sim card installed."))
		return
	if(calling_someone || connected_phone || paired_phone)
		to_chat(user, span_notice("[src] is already connected to a network."))
		return
	var/list/options = GLOB.public_phone_list.Copy()
	options += "Dial Manually"
	options -= sim_card.name
	var/input = input(user, "Who would you like to dial up?", title, "") as null|anything in options
	playsound(src, phone_press, 65, FALSE)
	if(!input)
		return
	var/obj/item/cellular_phone/friend_phone
	if(input == "Dial Manually")
		input = input(user, "Enter Phone Number", title, "") as null|text
		if(!input || !GLOB.phone_list[input]) //Failure
			return
		friend_phone = GLOB.phone_list[input]
	else
		if(!input)
			playsound(src, phone_press, 65, FALSE)
			return
		friend_phone = GLOB.public_phone_list[input]
	if(friend_phone.connected_phone)
		to_chat(user, span_notice("There's too many people on this network."))
		return
	if(friend_phone.sim_card.number == sim_card.number)
		to_chat(user, span_notice("I can't call myself."))
		return
	call_phone(user, connecting_phone = friend_phone)
	update_appearance(UPDATE_ICON)

/obj/item/cellular_phone/proc/call_phone(mob/living/user, list/modifiers, obj/item/cellular_phone/connecting_phone)
	if(!sim_card)
		to_chat(user, span_notice("The [src] doesn't have a sim card installed."))
		return
	if(!sim_card.public_name)
		to_chat(user, span_notice("I need a username to make a call."))
		return
	user.visible_message(span_notice("[user] starts to call someone with their [src]"), \
		span_notice("I start calling [connecting_phone.sim_card.number]"))
	var/calling_time = rand(10,35)
	connecting_phone.called_phone = src
	connecting_phone.connected_phone = src
	connected_phone = connecting_phone
	calling_someone = TRUE
	call_soundloop.start()
	update_appearance(UPDATE_ICON)
	addtimer(CALLBACK(connecting_phone, .proc/start_ringing), calling_time)

/obj/item/cellular_phone/proc/accept_call(mob/living/user, list/modifiers, obj/item/cellular_phone/connecting_phone)
	if(!sim_card)
		to_chat(user, span_notice("The [src] doesn't have a sim card installed."))
		return
	if(!connecting_phone)
		to_chat(user, span_boldnotice("But there's no-one there..."))
		hang_up()
		return
	calling_someone = TRUE

/obj/item/cellular_phone/proc/start_ringing(mob/living/user, list/modifiers, obj/item/cellular_phone/connecting_phone)
	if(!connected_phone) //How did it start ringing?
		hang_up()
		return
	ringtone_soundloop.start()
	ringring = TRUE
	update_appearance(UPDATE_ICON)

/obj/item/cellular_phone/proc/hang_up(mob/living/user, obj/item/cellular_phone/connecting_phone)
	if(!connected_phone)
		to_chat(user, span_notice("There's no-one at the other end."))
		return
	playsound(src, hangUp, 60, FALSE)
	playsound(connected_phone, hangUp, 60, FALSE)
	user.visible_message(span_notice("[user] hangs up their [src]."), \
		span_notice("I hang up the phone."))
	ringtone_soundloop.stop()
	ringring = FALSE
	connecting_phone.ringring = FALSE
	call_soundloop.stop()
	connecting_phone.call_soundloop.stop()
	connecting_phone.ringtone_soundloop.stop()
	connecting_phone.calling_someone = FALSE
	connecting_phone.connected_phone = null
	connecting_phone.called_phone = null
	connecting_phone.paired_phone = null
	paired_phone = null
	connecting_phone.update_appearance(UPDATE_ICON)
	update_appearance(UPDATE_ICON)
	calling_someone = FALSE
	connected_phone = null
	called_phone = null

/obj/item/cellular_phone/proc/answer(mob/living/called, mob/living/caller, obj/item/cellular_phone/caller_phone, obj/item/cellular_phone/called_phone)
	playsound(caller_phone, answer, 65, FALSE)
	to_chat(called, span_notice("You're now speaking to [caller_phone.sim_card.public_name]"))
	to_chat(caller, span_notice("[called_phone.sim_card.public_name] has answered your call."))
	caller_phone.stop_ringing()
	caller_phone.calling_someone = TRUE
	playsound(called_phone, answer, 65, FALSE)
	called_phone.stop_calltone()

	called_phone.paired_phone = caller_phone
	caller_phone.paired_phone = called_phone
	caller_phone.update_appearance(UPDATE_ICON)
	called_phone.update_appearance(UPDATE_ICON)

/obj/item/cellular_phone/proc/stall(obj/item/cellular_phone/stalling_phone, mob/living/user)
	addtimer(CALLBACK(src, .proc/unstall, stalling_phone), rand(50 SECONDS, 1.2 MINUTES))
	visible_message(span_boldwarning("[src]'s screen freezes, and then suddenly glitches, [src] vibrating and making nonsensical noises."))
	stalling = TRUE
	update_appearance(UPDATE_ICON)

/obj/item/cellular_phone/proc/unstall(obj/item/cellular_phone/stalling_phone, mob/living/user)
	to_chat(user, span_notice("[src]'s screen clears up and the glitching seems to stop."))
	stalling = FALSE
	update_appearance(UPDATE_ICON)

/obj/item/cellular_phone/proc/self_destruct_sequence(obj/item/cellular_phone/exploding_phone, mob/living/user)
	if(!sim_card)
		return
	audible_message(span_bigdanger("[src] makes an unnatural whirring and buzzing noise, vibrating uncontrollably!"))
	playsound(src, sim_card.virus.virus_acute_hint, 90, FALSE)
	stalling = TRUE
	update_appearance(UPDATE_ICON)
	addtimer(CALLBACK(src, .proc/self_destruct, exploding_phone), 1.5 SECONDS)

/obj/item/cellular_phone/proc/self_destruct(obj/item/cellular_phone/exploding_phone, mob/living/user)
	if(!sim_card)
		return
	explosion(exploding_phone, light_impact_range = 2, flash_range = 3)

/obj/item/cellular_phone/Hear(message, atom/movable/speaker, datum/language/message_language, raw_message, radio_freq, list/spans, list/message_mods = list())
	. = ..()
	if(get_turf(speaker) != get_turf(src))
		return
	if(paired_phone == speaker)
		visible_message(src, span_warning("[src] makes godawful noises as It falls into a feedback loop!"), \
		span_danger("Sounds like someone is playing MC Serginho!"), MSG_AUDIBLE)
		return
	if(paired_phone)
		playsound(paired_phone, talking_noises, 8, FALSE, -6)
		paired_phone.audible_message(span_info("[src] [verb_say], [message]"), hearing_distance = 1)

/obj/item/cellular_phone/proc/stop_ringing()
	ringtone_soundloop.stop()
	ringring = FALSE
	update_appearance(UPDATE_ICON)

/obj/item/cellular_phone/proc/stop_calltone()
	call_soundloop.stop()

// Generate the full examine string of this atom (including icon for goonchat)
/atom/get_examine_string(mob/user, thats = FALSE)
	return "[icon2html(src, user)] [thats ? "That's ":""][thats ? "<EM><b>[get_examine_name(user)]</b></EM>" : get_examine_name(user)]"

// Calling on_examine()
/atom/examine(mob/user)
	. = list("[get_examine_string(user, TRUE)].")
	. += get_name_chaser(user)
	. += "<br><hr class='infohr'>"
	if(desc)
		. += desc
	if(custom_materials)
		var/list/materials_list = list()
		for(var/i in custom_materials)
			var/datum/material/M = i
			materials_list += "[M.name]"
		. += "<u>[p_they(TRUE)] [p_are()] made out of [english_list(materials_list)]</u>."
	if(reagents)
		if(reagents.flags & TRANSPARENT)
			. += "[p_they(TRUE)] contain[p_s()]:"
			if(length(reagents.reagent_list))
				if(user.can_see_reagents()) //Show each individual reagent
					for(var/datum/reagent/R in reagents.reagent_list)
						. += "[round(R.volume, 0.01)] units of [R.name]"
					if(reagents.is_reacting)
						. += span_warning("It is currently reacting!")
					. += span_notice("The solution's pH is [round(reagents.ph, 0.01)] and has a temperature of [reagents.chem_temp]K.")
				else //Otherwise, just show the total volume
					var/total_volume = 0
					for(var/datum/reagent/R in reagents.reagent_list)
						total_volume += R.volume
					. += "[total_volume] units of various reagents"
			else
				. += "Nothing."
		else if(reagents.flags & AMOUNT_VISIBLE)
			if(reagents.total_volume)
				. += span_notice("[p_they(TRUE)] [p_have()] [reagents.total_volume] unit\s left.")
			else
				. += span_danger("[p_they(TRUE)] [p_are()] empty.")
	var/filth_examine = germ_level_examine(user)
	if(filth_examine)
		. += filth_examine
	var/examine_chaser = examine_chaser(user)
	if(examine_chaser)
		. += examine_chaser
	SEND_SIGNAL(src, COMSIG_PARENT_EXAMINE, user, .)
	if(on_examined_check(user, FALSE))
		user.on_examine_atom(src, FALSE)

/atom/examine_more(mob/user)
	. = list()
	SEND_SIGNAL(src, COMSIG_PARENT_EXAMINE_MORE, user, .)
	if(on_examined_check(user, TRUE))
		user.on_examine_atom(src, TRUE)

/// Currently only matters for items
/atom/proc/germ_level_examine(mob/user)
	return

/// Displayed after germ_level_examine(), but before other examine child calls
/atom/proc/examine_chaser(mob/user)
	return

/// Override this to impede examine messages etc
/atom/proc/on_examined_check(mob/user, examine_more = FALSE)
	return TRUE

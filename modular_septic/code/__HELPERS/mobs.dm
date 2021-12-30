/proc/accessory_list_of_key_for_species(key, datum/species/S, mismatched, ckey)
	var/list/accessory_list = list()
	for(var/name in GLOB.sprite_accessories[key])
		var/datum/sprite_accessory/SP = GLOB.sprite_accessories[key][name]
		if(!mismatched && SP.recommended_species && !(S.id in SP.recommended_species))
			continue
		accessory_list += SP.name
	return accessory_list

/proc/random_accessory_of_key_for_species(key, datum/species/S, mismatched=FALSE, ckey)
	var/list/accessory_list = accessory_list_of_key_for_species(key, S, mismatched, ckey)
	if(!length(accessory_list))
		return
	var/datum/sprite_accessory/SP = GLOB.sprite_accessories[key][pick(accessory_list)]
	if(!SP)
		CRASH("Cant find random accessory of [key] key, for species [S.id]")
	return SP

/proc/assemble_body_markings_from_set(datum/body_marking_set/body_marking_set, list/features, datum/species/pref_species)
	var/list/body_markings = list()
	for(var/name in body_marking_set.body_marking_list)
		var/datum/body_marking/body_marking = GLOB.body_markings[name]
		for(var/zone in GLOB.body_markings_per_limb)
			var/list/marking_list = GLOB.body_markings_per_limb[zone]
			if(name in marking_list)
				if(!body_markings[zone])
					body_markings[zone] = list()
				body_markings[zone][name] = body_marking.get_default_color(features, pref_species)
	return body_markings

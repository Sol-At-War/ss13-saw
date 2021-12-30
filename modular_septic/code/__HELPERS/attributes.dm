/proc/initialize_attributes()
	. = list()
	var/list/attributes = init_subtypes(/datum/attribute)
	for(var/datum/attribute/attribute as anything in attributes)
		if(isnull(attribute.name))
			qdel(attribute)
			continue
		.[attribute.type] = attribute

/proc/initialize_stats()
	. = list()
	for(var/attribute_type in GLOB.all_attributes)
		//no want skill
		if(!ispath(attribute_type, /datum/attribute/stat))
			continue
		.[attribute_type] = GET_ATTRIBUTE_DATUM(attribute_type)

/proc/initialize_skills()
	. = list()
	for(var/skill_type in GLOB.all_attributes)
		//no want stat
		if(!ispath(skill_type, /datum/attribute/skill))
			continue
		.[skill_type] = GET_ATTRIBUTE_DATUM(skill_type)

/proc/initialize_skill_categories()
	. = list()
	for(var/skill_type in GLOB.all_skills)
		var/datum/attribute/skill/skill = GET_ATTRIBUTE_DATUM(skill_type)
		LAZYINITLIST(.[skill.category])
		.[skill.category] += skill_type

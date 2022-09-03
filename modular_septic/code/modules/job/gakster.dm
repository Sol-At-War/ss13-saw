/datum/job/gakster
	title = "Gakster Scavenger"
	department_head = list("Head of Personnel")
	faction = list("neutral", "swarmer")
	supervisors = "no-one"
	selection_color = "#303234"

	outfit = /datum/outfit/gakster

/datum/job/gakster/after_spawn(mob/living/spawned, client/player_client)
	. = ..()
	if(ishuman(spawned))
		spawned.apply_status_effect(/datum/status_effect/gakster_dissociative_identity_disorder)

/datum/outfit/gakster
	name = "Gakster Uniform"

	uniform = /obj/item/clothing/under/itobe
	id = /obj/item/cellphone
	belt = /obj/item/crowbar
	l_pocket = /obj/item/simcard
	back = /obj/item/storage/backpack/satchel/itobe
	backpack_contents = list(
		/obj/item/reagent_containers/hypospray/medipen/retractible/blacktar = 1,
		/obj/item/flashlight/seclite = 1,
	)
	gloves = /obj/item/clothing/gloves/color/black
	shoes = /obj/item/clothing/shoes/jackboots

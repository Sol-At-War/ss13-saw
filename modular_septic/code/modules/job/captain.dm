/datum/job/captain
	title = "Doge"
	department_head = list("CentCom")
	supervisors = "the Nevado Governor"

	//lol micropenis
	min_dicksize = 8
	max_dicksize = 10

	//flat as fuck
	min_breastsize = 0
	max_breastsize = 1

	outfit = /datum/outfit/job/captain/zoomtech

/datum/job/captain/get_captaincy_announcement(mob/living/captain)
	return "[title] [captain.real_name] on deck!"

/datum/outfit/job/captain/zoomtech
	name = "ZoomTech Doge"

	glasses = /obj/item/clothing/glasses/hud/security/sunglasses/zoomtech
	gloves = /obj/item/clothing/gloves/combat/zoomtech
	uniform =  /obj/item/clothing/under/rank/captain/zoomtech
	belt = /obj/item/modular_computer/tablet/preset/advanced
	suit = /obj/item/clothing/suit/armor/vest/capcarapace/zoomtech
	shoes = /obj/item/clothing/shoes/jackboots
	head = /obj/item/clothing/head/caphat/zoomtech
	backpack = /obj/item/storage/backpack/satchel/leather
	satchel = /obj/item/storage/backpack/satchel/leather
	duffelbag = /obj/item/storage/backpack/satchel/leather
	backpack_contents = list(/obj/item/melee/baton/telescopic=1, /obj/item/station_charter=1)

	skillchips = null

/obj/item/clothing/head/helmet
	name = "type II ballistic helmet"
	desc = "A type II armored helmet. Moderate protection against most types of damage. Does not cover the face."
	icon = 'modular_septic/icons/obj/clothing/hats.dmi'
	icon_state = "helmet"
	worn_icon = 'modular_septic/icons/mob/clothing/head.dmi'
	worn_icon_state = "helmet"
	max_integrity = 200
	limb_integrity = 190
	repairable_by = /obj/item/stack/ballistic/plate
	repairable_by_offhand = null
	integrity_failure = 0.1
	subarmor = list(SUBARMOR_FLAGS = NONE, \
                EDGE_PROTECTION = 40, \
                CRUSHING = 13, \
                CUTTING = 15, \
                PIERCING = 34, \
                IMPALING = 5, \
                LASER = 1, \
                ENERGY = 0, \
                BOMB = 8, \
                BIO = 0, \
                FIRE = 2, \
                ACID = 2, \
                MAGIC = 0, \
                WOUND = 0, \
                ORGAN = 0)
	armor_broken_sound = "heavy_helmet"
	armor_damaged_sound = "heavy_helmet"
	armor_damaged_sound_local = "heavy helmet"
	carry_weight = 2.5
	equip_sound = 'modular_septic/sound/armor/equip/helmet_use.wav'
	pickup_sound = 'modular_septic/sound/armor/equip/helmet_pickup.wav'
	drop_sound = 'modular_septic/sound/armor/equip/helmet_drop.wav'

/obj/item/clothing/head/helmet/medium
	name = "\"Evacuador\" type III+ ballistic helmet"
	desc = "A type III+ ballistic helmet. Intermediate protection against most types of damage. Does not cover the face."
	icon = 'modular_septic/icons/obj/clothing/hats.dmi'
	icon_state = "helmet_medium"
	worn_icon = 'modular_septic/icons/mob/clothing/head.dmi'
	worn_icon_state = "helmet_medium"
	max_integrity = 300
	integrity_failure = 0.05
	limb_integrity = 220
	subarmor = list(SUBARMOR_FLAGS = NONE, \
                EDGE_PROTECTION = 58, \
                CRUSHING = 19, \
                CUTTING = 18, \
                PIERCING = 42, \
                IMPALING = 6, \
                LASER = 1, \
                ENERGY = 0, \
                BOMB = 8, \
                BIO = 0, \
                FIRE = 2, \
                ACID = 2, \
                MAGIC = 0, \
                WOUND = 0, \
                ORGAN = 0)
	carry_weight = 2.5

/obj/item/clothing/head/helmet/heavy
	name = "\"Touro-5\" type IV heavy ballistic helmet"
	desc = "A type IV armored heavy helmet. Intermediate protection against most types of damage. Has a-pair of mounts on the sides for a faceshield to protect the face."
	icon = 'modular_septic/icons/obj/clothing/hats.dmi'
	icon_state = "helmet_heavy"
	worn_icon = 'modular_septic/icons/mob/clothing/head.dmi'
	worn_icon_state = "helmet_heavy"
	max_integrity = 400
	integrity_failure = 0.04
	limb_integrity = 350
	subarmor = list(SUBARMOR_FLAGS = NONE, \
                EDGE_PROTECTION = 75, \
                CRUSHING = 24, \
                CUTTING = 24, \
                PIERCING = 50, \
                IMPALING = 14, \
                LASER = 1, \
                ENERGY = 0, \
                BOMB = 13, \
                BIO = 0, \
                FIRE = 2, \
                ACID = 2, \
                MAGIC = 0, \
                WOUND = 0, \
                ORGAN = 0)
	carry_weight = 3.5

//gangstalker bullets
/obj/projectile/bullet/a357
	name = ".357 magnum bullet"
	damage = 56
	wound_bonus = 0

/obj/projectile/bullet/c38
	name = ".38 special bullet"
	damage = 28
	wound_bonus = 0
	bare_wound_bonus = 0
	embedding = list("embed_chance"=30, \
					"fall_chance"=0, \
					"jostle_chance"=5, \
					"ignore_throwspeed_threshold"=TRUE, \
					"pain_stam_pct"=0.5, \
					"pain_mult"=0, \
					"pain_jostle_mult"=6,
					"rip_time"=20)
	embed_falloff_tile = 0
	ricochet_chance = 20

/obj/projectile/bullet/c38/dumdum
	embedding = list("embed_chance"=75, \
					"fall_chance"=0, \
					"jostle_chance"=10, \
					"ignore_throwspeed_threshold"=TRUE, \
					"pain_stam_pct"=0.5, \
					"pain_mult"=0, \
					"pain_jostle_mult"=6,
					"rip_time"=30)

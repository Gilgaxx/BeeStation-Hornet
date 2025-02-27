#define MARAUDER_SHIELD_RECHARGE 600
#define MARAUDER_SHIELD_MAX 4

GLOBAL_LIST_EMPTY(clockwork_marauders)

/mob/living/simple_animal/hostile/clockwork_marauder
	name = "clockwork marauder"
	desc = "A brass machine of destruction,"
	icon = 'icons/mob/clockwork_mobs.dmi'
	icon_state = "clockwork_marauder"
	icon_dead = "anime_fragment"
	combat_mode = TRUE
	health = 140
	maxHealth = 140

	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = INFINITY
	is_flying_animal = TRUE
	move_resist = MOVE_FORCE_OVERPOWERING
	mob_size = MOB_SIZE_LARGE
	pass_flags = PASSTABLE
	damage_coeff = list(BRUTE = 1, BURN = 1, TOX = 0, CLONE = 0, STAMINA = 0, OXY = 0)

	attack_verb_continuous = "slices"
	attack_verb_simple = "slice"
	attack_sound = 'sound/weapons/bladeslice.ogg'
	chat_color = "#CAA25B"
	mobchatspan = "brassmobsay"
	obj_damage = 80
	melee_damage = 24
	faction = list(FACTION_RATVAR)

	initial_language_holder = /datum/language_holder/clockmob

	var/shield_health = MARAUDER_SHIELD_MAX

	var/debris = list(/obj/item/clockwork/alloy_shards/large = 1, \
	/obj/item/clockwork/alloy_shards/medium = 2, \
	/obj/item/clockwork/alloy_shards/small = 3) //Parts left behind when a structure breaks
	discovery_points = 1000

/mob/living/simple_animal/hostile/clockwork_marauder/Initialize(mapload)
	. = ..()
	GLOB.clockwork_marauders += src

/mob/living/simple_animal/hostile/clockwork_marauder/Destroy()
	GLOB.clockwork_marauders -= src
	. = ..()

/mob/living/simple_animal/hostile/clockwork_marauder/Login()
	. = ..()
	if(!. || !client)
		return FALSE
	add_servant_of_ratvar(src)
	to_chat(src, span_brass("You can block up to 4 attacks with your shield, however it requires a welder to be repaired."))

/mob/living/simple_animal/hostile/clockwork_marauder/death(gibbed)
	. = ..()
	for(var/item in debris)
		var/count = debris[item]
		for(var/i in 1 to count)
			new item(get_turf(src))
	qdel(src)

/mob/living/simple_animal/hostile/clockwork_marauder/attacked_by(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/nullrod))
		apply_damage(15, BURN)
		if(shield_health > 0)
			damage_shield()
		playsound(src,'sound/hallucinations/veryfar_noise.ogg',40,1)
	if(I.tool_behaviour == TOOL_WELDER)
		welder_act(user, I)
		return
	. = ..()

/mob/living/simple_animal/hostile/clockwork_marauder/bullet_act(obj/projectile/Proj)
	//Block Ranged Attacks
	if(shield_health > 0)
		damage_shield()
		to_chat(src, span_warning("Your shield blocks the attack."))
		return BULLET_ACT_BLOCK
	return ..()

/mob/living/simple_animal/hostile/clockwork_marauder/proc/damage_shield()
	shield_health --
	playsound(src, 'sound/magic/clockwork/anima_fragment_attack.ogg', 60, TRUE)
	if(shield_health == 0)
		to_chat(src, span_userdanger("Your shield breaks!"))
		to_chat(src, span_brass("You require a welding tool to repair your damaged shield!"))

/mob/living/simple_animal/hostile/clockwork_marauder/welder_act(mob/living/user, obj/item/I)
	if(do_after(user, 25, target=src))
		health = min(health + 10, maxHealth)
		to_chat(user, span_notice("You repair some of [src]'s damage."))
		if(shield_health < MARAUDER_SHIELD_MAX)
			shield_health ++
			playsound(src, 'sound/magic/charge.ogg', 60, TRUE)
	return TRUE

#undef MARAUDER_SHIELD_RECHARGE
#undef MARAUDER_SHIELD_MAX

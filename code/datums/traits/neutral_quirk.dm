//traits with no real impact that can be taken freely
//MAKE SURE THESE DO NOT MAJORLY IMPACT GAMEPLAY. those should be positive or negative traits.

/datum/quirk/no_taste
	name = "Ageusia"
	desc = "You can't taste anything! Toxic food will still poison you."
	icon = "meh-blank"
	value = 0
	mob_trait = TRAIT_AGEUSIA
	gain_text = span_notice("You can't taste anything!")
	lose_text = span_notice("You can taste again!")
	medical_record_text = "Patient suffers from ageusia and is incapable of tasting food or reagents."

/datum/quirk/vegetarian
	name = "Vegetarian"
	desc = "You find the idea of eating meat morally and physically repulsive."
	icon = "carrot"
	value = 0
	gain_text = span_notice("You feel repulsion at the idea of eating meat.")
	lose_text = span_notice("You feel like eating meat isn't that bad.")
	medical_record_text = "Patient reports a vegetarian diet."

/datum/quirk/vegetarian/add()
	var/mob/living/carbon/human/H = quirk_target
	var/obj/item/organ/tongue/T = H.getorganslot(ORGAN_SLOT_TONGUE)
	T?.liked_food &= ~MEAT
	T?.disliked_food |= MEAT

/datum/quirk/vegetarian/remove()
	var/mob/living/carbon/human/H = quirk_target
	var/obj/item/organ/tongue/T = H.getorganslot(ORGAN_SLOT_TONGUE)
	if(H)
		if(initial(T.liked_food) & MEAT)
			T?.liked_food |= MEAT
		if(!(initial(T.disliked_food) & MEAT))
			T?.disliked_food &= ~MEAT

/datum/quirk/pineapple_liker
	name = "Ananas Affinity"
	desc = "You find yourself greatly enjoying fruits of the ananas genus. You can't seem to ever get enough of their sweet goodness!"
	icon = "thumbs-up"
	value = 0
	gain_text = span_notice("You feel an intense craving for pineapple.")
	lose_text = span_notice("Your feelings towards pineapples seem to return to a lukewarm state.")
	medical_record_text = "Patient demonstrates a pathological love of pineapple."

/datum/quirk/pineapple_liker/add()
	var/mob/living/carbon/human/H = quirk_target
	var/obj/item/organ/tongue/T = H.getorganslot(ORGAN_SLOT_TONGUE)
	T?.liked_food |= PINEAPPLE

/datum/quirk/pineapple_liker/remove()
	var/mob/living/carbon/human/H = quirk_target
	var/obj/item/organ/tongue/T = H.getorganslot(ORGAN_SLOT_TONGUE)
	T?.liked_food &= ~PINEAPPLE

/datum/quirk/pineapple_hater
	name = "Ananas Aversion"
	desc = "You find yourself greatly detesting fruits of the ananas genus. Serious, how the hell can anyone say these things are good? And what kind of madman would even dare putting it on a pizza!?"
	icon = "thumbs-down"
	value = 0
	gain_text = span_notice("You find yourself pondering what kind of idiot actually enjoys pineapples.")
	lose_text = span_notice("Your feelings towards pineapples seem to return to a lukewarm state.")
	medical_record_text = "Patient demonstrates a pathological hate of pineapple."

/datum/quirk/pineapple_hater/add()
	var/mob/living/carbon/human/H = quirk_target
	var/obj/item/organ/tongue/T = H.getorganslot(ORGAN_SLOT_TONGUE)
	T?.disliked_food |= PINEAPPLE

/datum/quirk/pineapple_hater/remove()
	var/mob/living/carbon/human/H = quirk_target
	var/obj/item/organ/tongue/T = H.getorganslot(ORGAN_SLOT_TONGUE)
	T?.disliked_food &= ~PINEAPPLE

/datum/quirk/deviant_tastes
	name = "Deviant Tastes"
	desc = "You dislike food that most people enjoy, and find delicious what they don't."
	icon = "grin-tongue-squint"
	value = 0
	gain_text = span_notice("You start craving something that tastes strange.")
	lose_text = span_notice("You feel like eating normal food again.")
	medical_record_text = "Patient demonstrates irregular nutrition preferences."

/datum/quirk/deviant_tastes/add()
	var/mob/living/carbon/human/H = quirk_target
	var/obj/item/organ/tongue/T = H.getorganslot(ORGAN_SLOT_TONGUE)
	var/liked = T?.liked_food
	T?.liked_food = T?.disliked_food
	T?.disliked_food = liked

/datum/quirk/deviant_tastes/remove()
	var/mob/living/carbon/human/H = quirk_target
	var/obj/item/organ/tongue/T = H.getorganslot(ORGAN_SLOT_TONGUE)
	T?.liked_food = initial(T?.liked_food)
	T?.disliked_food = initial(T?.disliked_food)

/datum/quirk/monochromatic
	name = "Monochromacy"
	desc = "You suffer from full colorblindness, and perceive nearly the entire world in blacks and whites."
	icon = "adjust"
	value = 0
	medical_record_text = "Patient is afflicted with almost complete color blindness."

/datum/quirk/monochromatic/add()
	quirk_target.add_client_colour(/datum/client_colour/monochrome)

/datum/quirk/monochromatic/post_spawn()
	if(quirk_holder.assigned_role == JOB_NAME_DETECTIVE)
		to_chat(quirk_target, span_boldannounce("Mmm. Nothing's ever clear on this station. It's all shades of gray."))
		quirk_target.playsound_local(quirk_target, 'sound/ambience/ambidet1.ogg', 50, FALSE)

/datum/quirk/monochromatic/remove()
	quirk_target.remove_client_colour(/datum/client_colour/monochrome)

/datum/quirk/mute
	name = "Mute"
	desc = "You are unable to speak."
	icon = "volume-mute"
	value = 0
	mob_trait = TRAIT_MUTE
	gain_text = span_danger("You feel unable to talk.")
	lose_text = span_notice("You feel able to talk again.")
	medical_record_text = "Patient is unable to speak."

extends Node

var item_data
var loot_data
var affix_data_raw
var affix_data = {}

const SwordNames = {"names" : ["Shadowfang","Azurewrath","Assurance","ForgetMeNot","Red Obsidian","Abyssal Shard","Aetherius","Agatha","Alpha","Amnesia","Anduril",
					"Anger's Tear","Apocalypse","Armageddon","Arondite","Ashrune","Betrayal","Betrayer","Blackest Heart","Blackout","Blade of a Thousand Cuts",
					"Blade of the Grave","Blazefury","Blazeguard","Blight's Plight","Blind Justice","Blinkstrike","Bloodquench","Bloodweep","Broken Promise",
					"Brutality","Cataclysm","Catastrophe","Celeste","Chaos","Cometfell","Convergence","Corruption","Darkheart","Darkness","Dawn","Dawn of Ruins",
					"Dawnbreaker","Deathbringer","Deathraze","Decimation","Desolation","Despair","Destiny's Song","Devine","Devourer","Dirge","Divine Light",
					"Doomblade","Doombringer","Draughtbane","Due Diligence","Early Retirement","Echo","Piece Maker","Eclipse","Endbringer","Epilogue","Espada",
					"Eternal Harmony","Eternal Rest","Extinction","Faithkeeper","Fallen Champion","Fate","Final Achievement","Fleshrender","Florance","Frenzy",
					"Fury","Ghost Reaver","Ghostwalker","Gladius","Glimmer","Godslayer","Grasscutter","Grieving Blade","Gutrender","Hatred's Bite","Heartseeker",
					"Heartstriker","Hell's Scream","Hellfire","Hellreaver","Hollow Silence","Honor's Call","Hope's End","Infamy","Interrogator","Justice","Justifier",
					"King's Defender","King's Legacy","Kinslayer","Klinge","Knight's Fall","Knightfall","Lament","Last Rites","Last Words","Lazarus","Life's Limit",
					"Lifedrinker","Light's Bane","Lightbane","Lightbringer","Lightning","Limbo","Loyalty","Malice","Mangler","Massacre","Mercy","Misery's End",
					"Morbid Doom","Morbid Will","Mournblade","Narcoleptic","Needle","Nethersbane","Night's Edge","Night's Fall","Nightbane","Nightcrackle",
					"Nightfall","Nirvana","Oathbreaker","Oathkeeper","Oblivion","Omega","Orenmir","Peacekeeper","Perfect Storm","Persuasion","Prick","Purifier",
					"Rage","Ragespike","Ragnarok","Reaper","Reaper's Toll","Reckoning","Reign of Misery","Remorse","Requiem","Requiem of the Lost","Retirement",
					"Righteous Might","Rigormortis","Savagery","Scalpel","Scar","Seethe","Severance","Shadow Strike","Shadowsteel","Silence","Silencer",
					"Silver Saber","Silverlight","Skullcrusher","Slice of Life","Soul Reaper","Soulblade","Soulrapier","Spada","Spike","Spineripper","Spiteblade",
					"Stalker","Starshatterer","Sting","Stinger","Storm","Storm Breaker","Stormbringer","Stormcaller","Storm-Weaver","Striker","Sun Strike",
					"Suspension","Swan Song","The Ambassador","The Black Blade","The End","The Facelifter","The Light","The Oculus","The Stake","The Untamed",
					"The Unyielding","The Void","Thorn","Thunder","Toothpick","Tranquility","Treachery","Trinity","Tyrhung","Unending Tyranny","Unholy Might",
					"Valkyrie","Vanquisher","Vengeance","Venom","Venomshank","Warmonger","Widow Maker","Willbreaker","Winterthorn","Wit's End","Witherbrand",
					"Wolf","Worldbreaker","Worldslayer"],
					
					#EPIC/LEGENDARY ADDITION
					"types": ["Annihilation","Betrayer","Blade","Blessed Blade","Blood Blade","Bond","Boon","Breaker","Bringer","Broadsword","Butcher",
					"Call","Carver","Champion","Claymore","Conqueror","Crusader","Cry","Cunning","Dark Blade","Dawn","Defender","Defiler","Deflector",
					"Destroyer","Doomblade","Edge","Ender","Etcher","Executioner","Favor","Ferocity","Foe","Gift","Glory","Greatsword","Guardian","Heirloom",
					"Hope","Incarnation","Jaws","Katana","Last Hope","Last Stand","Legacy","Longblade","Longsword","Mageblade","Memory","Might","Oath","Pact",
					"Pledge","Promise","Protector","Quickblade","Rapier","Ravager","Razor","Reach","Reaper","Reaver","Runed Blade","Saber","Sabre","Savagery",
					"Scimitar","Sculptor","Secret","Shortsword","Skewer","Slayer","Slicer","Soul","Spellblade","Spine","Swiftblade","Sword","Terror","Token",
					"Tribute","Vengeance","Voice","Warblade","Warglaive","Whisper","Wit"]}

const ChestNames = ["Armament","Scales","Guard","Bastion","Steel","Defense","Bane","Bond","Boon","Call","Champion","Conqueror","Crusader","Cry",
					"Curator","Dawn","Fall","End","Demise","Birth","Death","Edge","Blight","Burden","Blessing","Fortune","Defender","Defiler","Deflector",
					"Destroyer","Emissary","Ender","Favor","Foe","Gift","Glory","Guard","Guardian","Heirloom","Hero","Hope","Incarnation","Keeper","Last Hope",
					"Last Stand","Legacy","Memory","Might","Oath","Pact","Pledge","Promise","Protection","Protector","Reach","Shepherd","Soul","Steward","Terror",
					"Token","Tribute","Vengeance","Vindicator","Visage","Voice","Ward","Warden","Whisper","Wit","Vest","Chestguard","Armor","Tunic","Breastplate",
					"Chestplate","Batteplate","Chestpiece","Cuirass","Greatplate"]

const WeaponPrefixes = ["Massive","Military","Amber Infused","Ancient","Anguish","Annihilation","Antique","Arcane","Arched","Assassination","Atuned",
					"Oathkeeper's","Bandit's","Baneful","Banished","Barbarian","Barbaric","Battleworn","Blazefury","Blood Infused","Blood-Forged","Bloodcursed",
					"Bloodied","Bloodlord's","Bloodsurge","Bloodvenom","Bone Crushing","Bonecarvin","Brutal","Brutality","Burnished","Captain's","Cataclysm",
					"Cataclysmic","Cold-Forged","Corroded","Corrupted","Crazed","Crying","Cursed","Curved","Dancing","Decapitating","Defiled","Demonic","Deserted",
					"Desire's","Desolation","Destiny's","Dire","Doom","Doom's","Dragon's","Dragonbreath","Ebon","Eerie","Enchanted","Engraved","Eternal",
					"Executing","Exiled","Extinction","Faith's","Faithful","Fancy","Fearful","Feral","Fierce","Fiery","Fire Infused","Fireguard","Firesoul",
					"Firestorm","Flaming","Flimsy","Forsaken","Fortune's","Fragile","Frail","Frenzied","Frost","Frozen","Furious","Fusion","Ghastly",
					"Ghost-Forged","Ghostly","Gladiator","Gladiator's","Gleaming","Glinting","Greedy","Grieving","Guard's","Guardian's","Hailstorm",
					"Hateful","Haunted","Heartless","Hollow","Holy","Honed","Honor's","Hope's","Hopeless","Howling","Hungering","Improved","Incarnated",
					"Infused","Inherited","Isolated","Jade Infused","Judgement","Knightly","Legionnaire's","Liar's","Lich","Lightning","Lonely","Loyal",
					"Lustful","Lusting","Mage's","Malevolent","Malicious","Malignant","Mended","Mercenary","Misfortune's","Misty","Moonlit","Mourning",
					"Nightmare","Ominous","Peacekeeper","Phantom","Polished","Possessed","Pride's","Prideful","Primitive","Promised","Protector's",
					"Deluded","Proud","Recruit's","Reforged","Reincarnated","Relentless","Remorseful","Renewed","Renovated","Replica","Restored",
					"Retribution","Ritual","Roaring","Ruby Infused","Rune-Forged","Rusty","Sailor's","Sapphire Infused","Savage","Shadow","Sharpened",
					"Silent","Singed","Singing","Sinister","Skullforge","Skyfall","Smooth","Solitude's","Sorrow's","Soul","Soul Infused","Soul-Forged",
					"Soulcursed","Soulless","Spectral","Spectral-Forged","Spiteful","Storm","Storm-Forged","Stormfury","Stormguard","Terror","Thirsting",
					"Thirsty","Thunder","Thunder-Forged","Thunderfury","Thunderguard","Thundersoul","Thunderstorm","Timeworn","Tormented","Trainee's",
					"Treachery's","Twilight","Twilight's","Twisted","Tyrannical","Undead","Unholy","Vengeance","Vengeful","Venom","Vicious","Vindication",
					"Vindictive","Void","Volcanic","Vowed","War-Forged","Warlord's","Warp","Warped","Whistling","Wicked","Wind's","Wind-Forged","Windsong",
					"Woeful","Wrathful","Wretched","Yearning","Zealous"]

const WeaponSuffixes = ["of Agony","of Ancient Power","of Anguish","of Ashes","of Assassins","of Black Magic","of Blessed Fortune","of Blessings",
					"of Blight","of Blood","of Bloodlust","of Broken Bones","of Broken Dreams","of Broken Families","of Burdens","of Chaos","of Closing Eyes",
					"of Conquered Worlds","of Corruption","of Cruelty","of Cunning","of Dark Magic","of Dark Souls","of Darkness","of Decay","of Deception",
					"of Degradation","of Delusions","of Denial","of Desecration","of Diligence","of Dismay","of Dragonsouls","of Due Diligence","of Echoes",
					"of Ended Dreams","of Ending Hope","of Ending Misery","of Eternal Bloodlust","of Eternal Damnation","of Eternal Glory","of Eternal Justice",
					"of Eternal Rest","of Eternal Sorrow","of Eternal Struggles","of Eternity","of Executions","of Faded Memories","of Fallen Souls","of Fools",
					"of Frost","of Frozen Hells","of Fury","of Giants","of Giantslaying","of Grace","of Grieving Widows","of Hate","of Hatred","of Hell's Games",
					"of Hellish Torment","of Heroes","of Holy Might","of Honor","of Hope","of Horrid Dreams","of Horrors","of Illuminated Dreams",
					"of Illumination","of Immortality","of Inception","of Infinite Trials","of Insanity","of Invocation","of Justice","of Light's Hope",
					"of Lost Comrades","of Lost Hope","of Lost Voices","of Lost Worlds","of Magic","of Mercy","of Misery","of Mountains","of Mourning",
					"of Mystery","of Necromancy","of Nightmares","of Oblivion","of Perdition","of Phantoms","of Power","of Pride","of Pride's Fall",
					"of Putrefaction","of Reckoning","of Redemption","of Regret","of Riddles","of Secrecy","of Secrets","of Shadow Strikes","of Shadows",
					"of Shifting Sands","of Shifting Worlds","of Silence","of Slaughter","of Souls","of Stealth","of Storms","of Subtlety","of Suffering",
					"of Suffering's End","of Summoning","of Terror","of Thunder","of Time-Lost Memories","of Timeless Battles","of Titans","of Torment",
					"of Traitors","of Trembling Hands","of Trials","of Truth","of Twilight's End","of Twisted Visions","of Unholy Blight","of Unholy Might",
					"of Vengeance","of Visions","of Wasted Time","of Widows","of Wizardry","of Woe","of Wraiths","of Zeal","of the Ancients","of the Banished",
					"of the Basilisk","of the Beast","of the Blessed","of the Breaking Storm","of the Brotherhood","of the Burning Sun","of the Caged Mind",
					"of the Cataclysm","of the Champion","of the Claw","of the Corrupted","of the Covenant","of the Crown","of the Damned","of the Daywalker",
					"of the Dead","of the Depth","of the Dreadlord","of the Earth","of the East","of the Emperor","of the Empty Void","of the End",
					"of the Enigma","of the Fallen","of the Falling Sky","of the Flame","of the Forest","of the Forgotten","of the Forsaken","of the Gladiator",
					"of the Harvest","of the Immortal","of the Incoming Storm","of the Insane","of the King","of the Lasting Night","of the Leviathan",
					"of the Light","of the Lion","of the Lionheart","of the Lone Victor","of the Lone Wolf","of the Lost","of the Moon","of the Moonwalker",
					"of the Night Sky","of the Night","of the Nightstalker","of the North","of the Occult","of the Oracle","of the Phoenix","of the Plague",
					"of the Prince","of the Protector","of the Queen","of the Serpent","of the Setting Sun","of the Shadows","of the Sky","of the South",
					"of the Stars","of the Storm","of the Summoner","of the Sun","of the Sunwalker","of the Talon","of the Undying","of the Victor",
					"of the Void","of the West","of the Whispers","of the Wicked","of the Wind","of the Wolf","of the World","of the Wretched"]

const ArmorPrefixes = ["Ancient","Arcane","Atuned","Bandit's","Baneful","Banished","Barbarian","Barbaric","Battleworn","Blood Infused","Blood-Forged",
					"Bloodcursed","Bloodied","Bloodlord's","Bloodsurge","Brutal","Brutality","Burnished","Captain's","Cataclysm","Cataclysmic","Challenger",
					"Challenger's","Champion","Champion's","Cold-Forged","Conqueror","Conqueror's","Corrupted","Crazed","Crying","Cursed","Defender","Defender's",
					"Defiled","Demonic","Desire's","Desolation","Destiny's","Dire","Doom","Doom's","Dragon's","Dragon","Ebon","Enchanted","Engraved","Eternal",
					"Exile","Extinction","Faith's","Faithful","Fearful","Feral","Fierce","Fiery","Fire Infused","Firesoul","Forsaken","Fortune's","Frenzied",
					"Frost","Frozen","Furious","Fusion","Ghastly","Ghost-Forged","Ghostly","Gladiator","Gladiator's","Grieving","Guard's","Guardian's","Hatred",
					"Haunted","Heartless","Hero","Hero's","Hollow","Holy","Honed","Honor's","Hope's","Hopeless","Howling","Hungering","Incarnated","Infused",
					"Inherited","Jade Infused","Judgement","Keeper's","Knightly","Legionnaire's","Liar's","Lich","Lightning","Lonely","Loyal","Lusting",
					"Malevolent","Malicious","Malignant","Massive","Mended","Mercenary","Military","Misfortune's","Mourning","Nightmare","Oathkeeper's",
					"Ominous","Peacekeeper","Peacekeeper's","Phantom","Possessed","Pride's","Primal","Prime","Primitive","Promised","Protector's","Proud",
					"Recruit's","Reforged","Reincarnated","Relentless","Remorse","Renewed","Renovated","Restored","Retribution","Ritual","Roaring",
					"Ruby Infused","Rune-Forged","Savage","Sentinel","Shadow","Silent","Singing","Sinister","Soldier's","Solitude's","Sorrow's","Soul",
					"Soul Infused","Soul-Forged","Soulless","Spectral","Spite","Storm","Storm-Forged","Stormfury","Stormguard","Terror","Thunder",
					"Thunder-Forged","Thunderfury","Thunderguard","Thundersoul","Thunderstorm","Timeworn","Tormented","Trainee's","Treachery's","Twilight",
					"Twilight's","Twisted","Tyrannical","Undead","Unholy","Vanquisher","Vengeance","Vengeful","Vicious","Victor","Vindication","Vindicator",
					"Vindictive","War-Forged","Warden's","Warlord's","Warped","Warrior","Warrior's","Whistling","Wicked","Wind's","Wind-Forged","Windsong",
					"Woeful","Wrathful","Wretched","Yearning","Zealous"]

const ArmorSuffixes = ["Absorption","the Phoenix","Adventure","Agony","Ancient Power","Ancient Powers","Anger","Anguish","Annihilation","Arcane Magic",
					"Arcane Power","Arcane Resist","Archery","Ashes","Assassination","Assassins","Assaults","Auras","Awareness","Barriers","Beginnings",
					"Binding","Black Magic","Blast Protection","Blessed Fortune","Blessed Fortunes","Blessings","Blight","Blood","Bloodlust","Bloodshed",
					"Bravery","Broken Bones","Broken Dreams","Broken Families","Broken Worlds","Burdens","Carnage","Cataclysms","Chaos","Clarity",
					"Conquered Worlds","Corruption","Courage","Creation","Cunning","Danger","Dark Magic","Dark Powers","Dark Souls","Darkness","Dawn",
					"Decay","Deception","Defiance","Deflection","Delirium","Delusions","Demon Fire","Demons","Denial","Desecration","Despair","Destruction",
					"Devotion","Diligence","Discipline","Dishonor","Dismay","Dominance","Domination","Doom","Dragons","Dragonsouls","Dread","Dreams",
					"Due Diligence","Duels","Dusk","Echoes","Enchantments","Ended Dreams","Ending Hope","Ending Misery","Ends","Eternal Bloodlust",
					"Eternal Damnation","Eternal Glory","Eternal Justice","Eternal Rest","Eternal Sorrow","Eternal Struggles","Eternity","Executions",
					"Extinction","Faded Memories","Fallen Kings","Fallen Souls","Fire","Fire Magic","Fire Power","Fire Protection","Fire Resist","Fools",
					"Forging","Fortitude","Fortune","Frost","Frost Power","Frost Resist","Frozen Hells","Fury","Ghosts","Giants","Giantslaying","Glory",
					"Grace","Greed","Grieving Widows","Guardians","Hate","Hatred","Healing","Hell","Hell's Games","Hellfire","Hellish Torment","Heroes",
					"Holy Might","Honor","Hope","Horrors","Ice","Ice Magic","Illusions","Immortality","Inception","Infinite Trials","Infinity","Insanity",
					"Justice","Kings","Life","Lifemending","Lifestealing","Light's Hope","Limbo","Lost Comrades","Lost Hope","Lost Souls","Lost Voices",
					"Lost Worlds","Mercy","Might","Miracles","Misery","Mists","Moonlight","Mysteries","Mystery","Nature","Necromancy","Nightmares","Oblivion",
					"Paradise","Patience","Phantoms","Power","Prayers","Pride","Pride's Fall","Prophecies","Protection","Putrefaction","Reckoning","Recoil",
					"Redemption","Regret","Regrets","Resilience","Respect","Riddles","Ruins","Runes","Salvation","Secrecy","Secrets","Serenity","Shadows",
					"Shifting Sands","Silence","Slaughter","Slaying","Smite","Solitude","Souls","Stealth","Stone","Storms","Strength","Subtlety","Suffering",
					"Suffering's End","Sunfire","Sunlight","Swordbreaking","Tears","Terror","Terrors","Thieves","Thorns","Thunder","Thunders","Titans","Torment",
					"Traitors","Trust","Truth","Truths","Twilight","Twilight's End","Twisted Visions","Undoing","Unholy Blight","Unholy Might","Valiance","Valor",
					"Vengeance","Vigor","Visions","War","Whispers","Wisdom","Woe","Wonders","Wraiths","Zeal","the Ancients","the Archer","the Banished",
					"the Basilisk","the Bear","the Beast","the Berserker","the Blessed","the Boar","the Breaking Storm","the Brotherhood","the Burning Sun",
					"the Caged Mind","the Cataclysm","the Champion","the Claw","the Corrupted","the Covenant","the Crown","the Crusader","the Damned",
					"the Day","the Daywalker","the Dead","the Depth","the Depths","the Dragons","the Dreadlord","the Eagle","the Earth","the East",
					"the Eclipse","the Emperor","the End","the Enigma","the Fallen","the Falling Sky","the Flames","the Forest","the Forests","the Forgotten",
					"the Forsaken","the Gargoyle","the Gladiator","the Gods","the Harvest","the Hunter","the Immortal","the Immortals","the Incoming Storm",
					"the Insane","the Isles","the King","the Knight","the Lasting Night","the Leviathan","the Light","the Lion","the Lionheart","the Lone Victor",
					"the Lone Wolf","the Lost","the Mage","the Moon","the Moonwalker","the Mountain","the Mountains","the Night","the Night Sky","the Nightstalker",
					"the North","the Occult","the Oracle","the Phoenix","the Plague","the Prince","the Princess","the Prisoner","the Prodigy","the Prophecy",
					"the Prophet","the Protector","the Queen","the Scourge","the Seer","the Serpent","the Setting Sun","the Shadows","the Sky","the South",
					"the Stars","the Steward","the Storm","the Summoner","the Sun","the Sunwalker","the Swamp","the Talon","the Titans","the Undying",
					"the Victor","the Void","the Volcano","the Ward","the Warrior","the West","the Whale","the Whispers","the Wicked","the Wind","the Wolf",
					"the World","the Wretched"]



func _ready():
	#ITEMS
	var itemdata_file = File.new()
	itemdata_file.open("res://Data/GameItemTable.json", File.READ)
	var itemdata_json = JSON.parse(itemdata_file.get_as_text())
	itemdata_file.close()
	item_data = itemdata_json.result
	
	#DROPTABLES
	var lootdata_file = File.new()
	lootdata_file.open("res://Data/GameLootTable.json", File.READ)
	var lootdata_json = JSON.parse(lootdata_file.get_as_text())
	lootdata_file.close()
	loot_data = lootdata_json.result
	
	#AFFIXES
	var affixdata_file = File.new()
	affixdata_file.open("res://Data/GameAffixTable.json", File.READ)
	var affixdata_json = JSON.parse(affixdata_file.get_as_text())
	affixdata_file.close()
	affix_data_raw = affixdata_json.result
	for affix_group in affix_data_raw:
		var affixes_array = []
		for affix in affix_data_raw[affix_group]:
			match affix_data_raw[affix_group][affix]:
				"yes":
					affixes_array.append(affix)
				"no":
					pass
		affix_data[affix_group] = affixes_array

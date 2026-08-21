-- Category name
-- { suffix ={} , list={} },

function getStorageLocation(item_id)
    for i=1,#categories do
        for _, suffix in ipairs(categories[i].suffix) do
            if item_id:find(suffix) then return i end
        end
        if table.findCategory(categories[i].list, item_id) then
            return i
        end
    end
    return nil
end


function table.findCategory(array, target)
    for index, value in ipairs(array) do
        if value == target then
            return index
        end
    end
    return nil
end


categories = {
    -- Common blocks
    {
    suffix={},
    list={
    'minecraft:cobbled_deepslate',
    'minecraft:cobblestone',
    'minecraft:sand',
    }},


    -- Junk blocks
    {
    suffix={},
    list={
    'minecraft:dirt',
    'minecraft:diorite',
    'minecraft:granite',
    'minecraft:gravel',
    'minecraft:netherrack',
    }},
    

    -- Decorative blocks
    {
    suffix={
    'bricks',
    'pillar',
    'tiles',
    'sandstone',
    },
    list={
    'minecraft:smooth_stone',
    'minecraft:smooth_basalt',
    'minecraft:polished_deepslate',
    'minecraft:packed_mud',
    'minecraft:blackstone',
    'minecraft:mossy_cobblestone',
    'minecraft:end_stone',
    'minecraft:smooth_quartz',
    'minecraft:polished_granite',
    'minecraft:amethyst_block',
    'minecraft:quartz_block',
    'minecraft:chiseled_deepslate',
    'minecraft:purpur_block',
    'minecraft:prismarine',
    'minecraft:polished_basalt',
    'minecraft:chiseled_polished_blackstone',
    'minecraft:dark_prismarine',
    'minecraft:basalt',
    'minecraft:reinforced_deepslate',
    'minecraft:gilded_blackstone',
    'minecraft:polished_blackstone',
    'minecraft:polished_andesite',
    'minecraft:polished_diorite',
    'minecraft:chiseled_quartz_block',
    }},


     -- Wood blocks
    {
    suffix={
    '_planks',
    '_log',
    '_wood',
    '_stem',
    '_hyphae',
    },
    list={
    'minecraft:bamboo_block',
    'minecraft:stripped_bamboo_block',
    }},


    -- Crafted items
    {
    suffix={
    'table',
    'torch',
    'lantern',
    'lamp',
    'furnace',
    'anvil',
    'rail',
    'glass',
    'glass_pane',
    'campfire',
    '_advanced',
    '_normal',
    },
    list={
    'minecraft:chest',
    'minecraft:chain',
    'minecraft:smoker',
    'minecraft:composter',
    'minecraft:grindstone',
    'minecraft:stonecutter',
    'minecraft:jukebox',
    'minecraft:note_block',
    'minecraft:scaffolding',
    'minecraft:ladder',
    'minecraft:lodestone',
    'minecraft:conduit',
    'minecraft:beacon',
    'minecraft:bell',
    'minecraft:cauldron',
    'minecraft:brewing_stand',
    'minecraft:barrel',
    'minecraft:lectern',
    'minecraft:chiseled_bookshelf',
    'minecraft:bookshelf',
    'minecraft:beehive',
    'minecraft:armor_stand',
    'minecraft:item_frame',
    'minecraft:daylight_detector',
    'minecraft:sticky_piston',
    'minecraft:piston',
    'minecraft:hopper',
    'minecraft:dropper',
    'minecraft:dispenser',
    'minecraft:observer',
    'minecraft:tripwire_hook',
    'minecraft:lever',
    'minecraft:comparator',
    'minecraft:repeater',
    'minecraft:honeycomb_block',
    'minecraft:slime_block',
    'minecraft:honey_block',
    'minecraft:carved_pumpkin',
    }},


    -- Crafted blocks
    {
    suffix={
    'door',
    'button',
    'gate',
    'slab',
    '_plate',
    'fence',
    'stairs',
    'wall',
    'fence'
    },
    list={
    }},


    --Tools
    {
    suffix={
    "_axe",
    "_pickaxe",
    "_sword",
    "_shovel",
    "_hoe",
    '_helmet',
    '_chestplate',
    '_leggings',
    '_boots',
    '_horse_armor',
    'boat'
    },
    list={
    'minecraft:glass_bottle',
    'minecraft:flint_and_steel',
    'create:hand_crank',
    'minecraft:spyglass',
    'minecraft:minecart',
    'minecraft:elytra',
    'minecraft:water_bucket',
    'minecraft:warped_fungus_on_a_stick',
    'create:copper_backtank',
    'minecraft:fishing_rod',
    'minecraft:bucket',
    'minecraft:crossbow',
    'minecraft:recovery_compass',
    'minecraft:trident',
    'create:goggles',
    'create:extendo_grip',
    'minecraft:totem_of_undying',
    'minecraft:wooden_axe',
    'create:netherite_backtank',
    'minecraft:lead',
    'create:linked_controller',
    'minecraft:shield',
    'minecraft:carrot_on_a_stick',
    'create:wand_of_symmetry',
    'minecraft:compass',
    'minecraft:bow',
    'minecraft:powder_snow_bucket',
    'minecraft:shears',
    'minecraft:lava_bucket',
    'minecraft:saddle',
    'create:wrench',
    'minecraft:brush',
    'create:potato_cannon',
    "minecraft:name_tag",
    }},


    --Plants/farming
    {
    suffix={
    'seeds',
    'sapling',
    'potato',
    'apple',
    'berries',
    'fungus',
    'mushroom',
    'carrot',
    },
    list={
    'minecraft:melon',
    'minecraft:sugar_cane',
    'minecraft:lily_pad',
    'minecraft:pumpkin',
    'minecraft:kelp',
    'minecraft:cactus',
    'minecraft:mangrove_propagule',
    'minecraft:cocoa_beans',
    'minecraft:pitcher_pod',
    'minecraft:hay_block',
    'minecraft:melon_slice',
    'minecraft:dried_kelp',
    'minecraft:beetroot',
    'minecraft:chorus_fruit',        
    }},


    --Mob drops
    {
    suffix={
    'salmon',
    'fish',
    'chicken',
    'pie',
    'rabbit',
    'egg',
    'hide',
    'cod',
    'beef',
    'sac',
    },
    list={
    'minecraft:scute',
    'minecraft:blaze_rod',
    'minecraft:frogspawn',
    'minecraft:mutton',
    'minecraft:bone',
    'minecraft:milk_bucket',
    'minecraft:cake',
    'minecraft:cookie',
    'minecraft:cooked_porkchop',
    'minecraft:rotten_flesh',
    'minecraft:slime_ball',
    'minecraft:string',
    'minecraft:leather',
    'minecraft:feather',
    'minecraft:porkchop',
    'minecraft:cooked_beef',
    'minecraft:cooked_mutton',
    'minecraft:honeycomb',
    'minecraft:bread',
    'minecraft:ender_pearl',
    'minecraft:chicken',
    'minecraft:nautilus_shell',
    'minecraft:magma_cream',
    'minecraft:spider_eye',
    'minecraft:gunpowder',
    'minecraft:phantom_membrane',
    'minecraft:ghast_tear',
    }},


    -- Ores/Ingots
    {
    suffix={
    'copper',
    'iron',
    'gold',
    'zinc',
    'dust',
    'sheet',
    'nugget',
    'ingot',
    'scrap',
    'shard',
    },
    list={
    'minecraft:quartz',
    'minecraft:diamond',
    'minecraft:lapis_lazuli',
    'minecraft:emerald',
    'minecraft:charcoal',
    'minecraft:coal',
    'minecraft:flint',
    'minecraft:redstone',
    'minecraft:nether_brick',
    'minecraft:brick',
    'minecraft:prismarine_crystals',
    'create:polished_rose_quartz',
    'create:rose_quartz',
    'create:andesite_alloy',
    'create:powdered_obsidian',
    'minecraft:andesite',
    }},


    -- Create blocks
    {
    suffix={
    },
    list={
    'create:water_wheel',
    'create:clutch',
    'create:gearbox',
    'create:nozzle',
    'create:encased_chain_drive',
    'create:large_cogwheel',
    'create:cogwheel',
    'create:adjustable_chain_gearshift',
    'create:large_water_wheel',
    'create:gearshift',
    'create:millstone',
    'create:encased_fan',
    'create:vertical_gearbox',
    'create:turntable',
    'create:cuckoo_clock',
    'create:belt_connector',
    'create:shaft',
    'create:depot',
    'create:blaze_burner',
    'create:empty_blaze_burner',
    'create:basin',
    'create:mechanical_mixer',
    'create:mechanical_press',
    'create:crushing_wheel',
    'create:mechanical_pump',
    'create:fluid_pipe',
    'create:metal_bracket',
    'create:wooden_bracket',
    'create:stressometer',
    'create:speedometer',
    'create:smart_chute',
    'create:chute',
    'create:weighted_ejector',
    'create:portable_fluid_interface',
    'create:spout',
    'create:item_drain',
    'create:hose_pulley',
    'create:fluid_tank',
    'create:copper_valve_handle',
    'create:fluid_valve',
    'create:smart_fluid_pipe',
    'create:mechanical_bearing',
    'create:windmill_bearing',
    'create:gantry_shaft',
    'create:gantry_carriage',
    'create:piston_extension_pole',
    'create:sticky_mechanical_piston',
    'create:mechanical_piston',
    'create:steam_whistle',
    'create:steam_engine',
    }},
}

return {categories = categories, getStorageLocation = getStorageLocation}

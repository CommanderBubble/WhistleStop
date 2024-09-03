ICONPATH = "__WhistleStopFactories__/graphics/research/"

data:extend(
{
    {
        type = "technology",
        name = "wsf-big-assembler-research",
        icon = ICONPATH.."wsf-big-assembler.png",
        icon_size = 512,
        effects = {
            {
                type = "unlock-recipe",
                recipe = "wsf-big-assembler"
            }
        },
        prerequisites = {
            "automation-3",
            "space-science-pack"
        },
        unit = {
            count = 1000,
            ingredients = {
                { 
                    "automation-science-pack",
                    1
                },
                {
                    "logistic-science-pack",
                    1
                },
                {
                    "production-science-pack",
                    1
                },
                {
                    "utility-science-pack",
                    1
                },
                {
                    "space-science-pack",
                    1
                }
            },
            time = 360
        },
        order = "wsf-a"
    },
    {
        type = "technology",
        name = "wsf-big-centrifuge-research",
        icon = ICONPATH.."wsf-big-chemplant.png",
        icon_size = 512,
        effects = {
            {
                type = "unlock-recipe",
                recipe = "wsf-big-centrifuge"
            }
        },
        prerequisites = { 
            "uranium-processing",
            "space-science-pack"
        },
        unit = {
            count = 1000,
            ingredients = {
                { 
                    "automation-science-pack",
                    1
                },
                {
                    "logistic-science-pack",
                    1
                },
                {
                    "production-science-pack",
                    1
                },
                {
                    "utility-science-pack",
                    1
                },
                {
                    "space-science-pack",
                    1
                }
            },
            time = 360
        },
        order = "wsf-b"
    },
    {
        type = "technology",
        name = "wsf-big-chemplant-research",
        icon = ICONPATH.."wsf-big-chemplant.png",
        icon_size = 512,
        effects = {
            {
                type = "unlock-recipe",
                recipe = "wsf-big-chemplant"
            }
        },
        prerequisites = { 
            "oil-processing",
            "space-science-pack"
        },
        unit = {
            count = 1000,
            ingredients = {
                { 
                    "automation-science-pack",
                    1
                },
                {
                    "logistic-science-pack",
                    1
                },
                {
                    "production-science-pack",
                    1
                },
                {
                    "utility-science-pack",
                    1
                },
                {
                    "space-science-pack",
                    1
                }
            },
            time = 360
        },
        order = "wsf-c"
    },
    {
        type = "technology",
        name = "wsf-big-furnace-research",
        icon = ICONPATH.."wsf-big-furnace.png",
        icon_size = 512,
        effects = {
            {
                type = "unlock-recipe",
                recipe = "wsf-big-furnace"
            }
        },
        prerequisites = { 
            "advanced-material-processing-2",
            "space-science-pack"
        },
        unit = {
            count = 1000,
            ingredients = {
                { 
                    "automation-science-pack",
                    1
                },
                {
                    "logistic-science-pack",
                    1
                },
                {
                    "production-science-pack",
                    1
                },
                {
                    "utility-science-pack",
                    1
                },
                {
                    "space-science-pack",
                    1
                }
            },
            time = 360
        },
        order = "wsf-d"
    },
    {
        type = "technology",
        name = "wsf-big-refinery-research",
        icon = ICONPATH.."wsf-big-chemplant.png",
        icon_size = 512,
        effects = {
            {
                type = "unlock-recipe",
                recipe = "wsf-big-refinery"
            }
        },
        prerequisites = { 
            "oil-processing",
            "space-science-pack"
        },
        unit = {
            count = 1000,
            ingredients = {
                { 
                    "automation-science-pack",
                    1
                },
                {
                    "logistic-science-pack",
                    1
                },
                {
                    "production-science-pack",
                    1
                },
                {
                    "utility-science-pack",
                    1
                },
                {
                    "space-science-pack",
                    1
                }
            },
            time = 360
        },
        order = "wsf-e"
    }
})
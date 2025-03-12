local anm2_data = {
    Spritesheets = {
        [0] = "Monsters/Classic/Monster_141_Maw.png",
    },
    Animations = {
        NeckSegment = {
            FrameNum = 2,
            Loop = false,
            LayerAnimations = {
                [0] = {
                    {
                        XPosition = 0,
                        YPosition = 0,
                        XScale = 100,
                        YScale = 100,
                        Rotation = 0,
                        CombinationID = 1,
                        frame = 0,
                        Visible = true,
                    },
                },
            },
            RootAnimation = {
                {
                    XPosition = 0,
                    YPosition = 0,
                    XScale = 100,
                    YScale = 100,
                    Rotation = 0,
                    frame = 0,
                    Visible = true,
                },
            },
            NullAnimations = {
            },
        },
    },
    Layers = {
        [0] = 0,
    },
    AttributeCombinations = {
        [0] = {
            [1] = {
                Height = 32,
                Width = 32,
                XCrop = 32,
                XPivot = 16,
                YCrop = 0,
                YPivot = 16,
            },
        },
    },
    AttributeDetail = {
        [0] = {
            [1] = {
                st = 13,
                ed = 19,
            },
        },
    },
}

return anm2_data
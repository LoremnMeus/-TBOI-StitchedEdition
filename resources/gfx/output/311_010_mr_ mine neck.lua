local anm2_data = {
    Spritesheets = {
        [0] = "monsters/afterbirthplus/mr_mine.png",
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
                Height = 16,
                Width = 16,
                XCrop = 48,
                XPivot = 8,
                YCrop = 0,
                YPivot = 8,
            },
        },
    },
    AttributeDetail = {
        [0] = {
            [1] = {
                st = 4,
                ed = 11,
            },
        },
    },
}

return anm2_data
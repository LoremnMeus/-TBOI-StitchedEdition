local anm2_data = {
    Spritesheets = {
        [0] = "grid/props_momsroom.png",
    },
    Animations = {
        Idle = {
            FrameNum = 1,
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
                        Interpolated = false,
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
                    Interpolated = false,
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
                Height = 63,
                Width = 96,
                XCrop = 192,
                XPivot = 48,
                YCrop = 0,
                YPivot = 48,
            },
        },
    },
    AttributeDetail = {
        [0] = {
            [1] = {
                st = 7,
                ed = 57,
            },
        },
    },
}

return anm2_data
local anm2_data = {
    Spritesheets = {
        [0] = "bosses/repentance/visage_plasma.png",
        [1] = "bosses/repentance/visage_glow.png",
    },
    Animations = {
        Idle = {
            FrameNum = 6,
            Loop = true,
            LayerAnimations = {
                [1] = {
                    {
                        XPosition = 0,
                        YPosition = -16,
                        XScale = 60,
                        YScale = 60,
                        Rotation = 0,
                        CombinationID = 1,
                        frame = 0,
                        Visible = true,
                        Interpolated = true,
                    },
                    {
                        XPosition = 0,
                        YPosition = -16,
                        XScale = 60,
                        YScale = 60,
                        Rotation = 0,
                        CombinationID = 1,
                        frame = 2,
                        Visible = true,
                        Interpolated = true,
                    },
                    {
                        XPosition = 0,
                        YPosition = -16,
                        XScale = 60,
                        YScale = 60,
                        Rotation = 0,
                        CombinationID = 1,
                        frame = 4,
                        Visible = true,
                        Interpolated = true,
                    },
                    {
                        XPosition = 0,
                        YPosition = -16,
                        XScale = 60,
                        YScale = 60,
                        Rotation = 0,
                        CombinationID = 1,
                        frame = 5,
                        Visible = true,
                        Interpolated = true,
                    },
                },
                [0] = {
                    {
                        XPosition = 0,
                        YPosition = -16,
                        XScale = 100,
                        YScale = 100,
                        Rotation = 0,
                        CombinationID = 1,
                        frame = 0,
                        Visible = true,
                        Interpolated = true,
                    },
                    {
                        XPosition = 0,
                        YPosition = -16,
                        XScale = 100,
                        YScale = 100,
                        Rotation = 0,
                        CombinationID = 2,
                        frame = 2,
                        Visible = true,
                        Interpolated = true,
                    },
                    {
                        XPosition = 0,
                        YPosition = -16,
                        XScale = 100,
                        YScale = 100,
                        Rotation = 0,
                        CombinationID = 3,
                        frame = 4,
                        Visible = true,
                        Interpolated = true,
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
        [1] = 1,
        [0] = 0,
    },
    AttributeCombinations = {
        [1] = {
            [1] = {
                Height = 256,
                Width = 256,
                XCrop = 0,
                XPivot = 128,
                YCrop = 0,
                YPivot = 128,
            },
        },
        [0] = {
            [1] = {
                Height = 48,
                Width = 48,
                XCrop = 0,
                XPivot = 24,
                YCrop = 0,
                YPivot = 24,
            },
            [2] = {
                Height = 48,
                Width = 48,
                XCrop = 48,
                XPivot = 24,
                YCrop = 0,
                YPivot = 24,
            },
            [3] = {
                Height = 48,
                Width = 48,
                XCrop = 96,
                XPivot = 24,
                YCrop = 0,
                YPivot = 24,
            },
        },
    },
    AttributeDetail = {
        [1] = {
            [1] = {
                st = 58,
                ed = 199,
            },
        },
        [0] = {
            [1] = {
                st = 11,
                ed = 42,
            },
            [2] = {
                st = 2,
                ed = 37,
            },
            [3] = {
                st = 11,
                ed = 44,
            },
        },
    },
}

return anm2_data
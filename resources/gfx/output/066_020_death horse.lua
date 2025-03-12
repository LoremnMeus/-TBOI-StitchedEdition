local anm2_data = {
    Spritesheets = {
        [0] = "Bosses/Classic/Boss_064_Death.png",
    },
    Animations = {
        Dash = {
            FrameNum = 2,
            Loop = true,
            LayerAnimations = {
                [0] = {
                    {
                        XPosition = 1,
                        YPosition = -8,
                        XScale = 97,
                        YScale = 103,
                        Rotation = 0,
                        CombinationID = 1,
                        frame = 0,
                        Visible = true,
                        Interpolated = false,
                    },
                    {
                        XPosition = 0,
                        YPosition = -7,
                        XScale = 100,
                        YScale = 100,
                        Rotation = 0,
                        CombinationID = 1,
                        frame = 1,
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
                [0] = {
                    Visible = true,
                    Frames = {
                    },
                },
                [1] = {
                    Visible = true,
                    Frames = {
                        {
                            XPosition = 15,
                            YPosition = -32,
                            XScale = 100,
                            YScale = 100,
                            frame = 0,
                            Visible = true,
                        },
                    },
                },
            },
        },
        Death = {
            FrameNum = 1,
            Loop = false,
            LayerAnimations = {
                [0] = {
                    {
                        XPosition = 1,
                        YPosition = -8,
                        XScale = 97,
                        YScale = 103,
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
                [0] = {
                    Visible = true,
                    Frames = {
                        {
                            XPosition = 3,
                            YPosition = -13,
                            XScale = 426,
                            YScale = 466,
                            frame = 0,
                            Visible = true,
                        },
                    },
                },
                [1] = {
                    Visible = true,
                    Frames = {
                    },
                },
            },
        },
    },
    Layers = {
        [0] = 0,
    },
    AttributeCombinations = {
        [0] = {
            [1] = {
                Height = 48,
                Width = 64,
                XCrop = 96,
                XPivot = 32,
                YCrop = 48,
                YPivot = 32,
            },
        },
    },
    AttributeDetail = {
        [0] = {
            [1] = {
                st = 24,
                ed = 30,
            },
        },
    },
}

return anm2_data
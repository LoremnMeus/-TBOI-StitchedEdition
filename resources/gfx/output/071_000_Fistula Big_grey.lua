local anm2_data = {
    Spritesheets = {
        [0] = "Bosses/Classic/Boss_025_Fistula.png",
    },
    Animations = {
        Biggest = {
            FrameNum = 1,
            Loop = false,
            LayerAnimations = {
                [0] = {
                    {
                        XPosition = -2,
                        YPosition = -32,
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
                [0] = {
                    Visible = true,
                    Frames = {
                    },
                },
                [1] = {
                    Visible = true,
                    Frames = {
                        {
                            XPosition = 0,
                            YPosition = -68,
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
                        XPosition = -2,
                        YPosition = -32,
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
                [0] = {
                    Visible = true,
                    Frames = {
                        {
                            XPosition = -3,
                            YPosition = -32,
                            XScale = 825,
                            YScale = 850,
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
                Height = 96,
                Width = 80,
                XCrop = 0,
                XPivot = 38,
                YCrop = 0,
                YPivot = 44,
            },
        },
    },
    AttributeDetail = {
        [0] = {
            [1] = {
                st = 6,
                ed = 71,
            },
        },
    },
}

return anm2_data
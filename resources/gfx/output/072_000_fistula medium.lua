local anm2_data = {
    Spritesheets = {
        [0] = "Bosses/Classic/Boss_025_Fistula.png",
    },
    Animations = {
        Big = {
            FrameNum = 1,
            Loop = false,
            LayerAnimations = {
                [0] = {
                    {
                        XPosition = -2,
                        YPosition = -22,
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
                            YPosition = -44,
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
                        YPosition = -22,
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
                            XPosition = -2,
                            YPosition = -21,
                            XScale = 441,
                            YScale = 412,
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
                Height = 64,
                Width = 64,
                XCrop = 96,
                XPivot = 30,
                YCrop = 0,
                YPivot = 33,
            },
        },
    },
    AttributeDetail = {
        [0] = {
            [1] = {
                st = 15,
                ed = 52,
            },
        },
    },
}

return anm2_data
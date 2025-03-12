local anm2_data = {
    Spritesheets = {
        [0] = "Monsters/Classic/Monster_189b_Slide.png",
    },
    Animations = {
        Spikes = {
            FrameNum = 2,
            Loop = false,
            LayerAnimations = {
                [0] = {
                    {
                        XPosition = -24,
                        YPosition = -24,
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
                            XPosition = 0,
                            YPosition = -25,
                            XScale = 100,
                            YScale = 100,
                            frame = 0,
                            Visible = true,
                        },
                    },
                },
            },
        },
        ["No-Spikes"] = {
            FrameNum = 2,
            Loop = false,
            LayerAnimations = {
                [0] = {
                    {
                        XPosition = -24,
                        YPosition = -24,
                        XScale = 100,
                        YScale = 100,
                        Rotation = 0,
                        CombinationID = 2,
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
                            XPosition = 0,
                            YPosition = -25,
                            XScale = 100,
                            YScale = 100,
                            frame = 0,
                            Visible = true,
                        },
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
                Width = 48,
                XCrop = 0,
                XPivot = 0,
                YCrop = 0,
                YPivot = 0,
            },
            [2] = {
                Height = 48,
                Width = 48,
                XCrop = 48,
                XPivot = 0,
                YCrop = 0,
                YPivot = 0,
            },
        },
    },
    AttributeDetail = {
        [0] = {
            [1] = {
                st = 1,
                ed = 46,
            },
            [2] = {
                st = 9,
                ed = 35,
            },
        },
    },
}

return anm2_data
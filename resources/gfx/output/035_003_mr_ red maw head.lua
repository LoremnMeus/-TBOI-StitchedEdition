local anm2_data = {
    Spritesheets = {
        [0] = "Monsters/Classic/Monster_142_RedMaw.png",
    },
    Animations = {
        Down = {
            FrameNum = 2,
            Loop = false,
            LayerAnimations = {
                [0] = {
                    {
                        XPosition = 0,
                        YPosition = -7,
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
                            YPosition = -34,
                            XScale = 100,
                            YScale = 100,
                            frame = 0,
                            Visible = true,
                        },
                    },
                },
            },
        },
        Appear = {
            FrameNum = 20,
            Loop = false,
            LayerAnimations = {
                [0] = {
                    {
                        XPosition = 1,
                        YPosition = -7,
                        XScale = 70,
                        YScale = 130,
                        Rotation = 0,
                        CombinationID = 1,
                        frame = 0,
                        Visible = true,
                        Interpolated = true,
                    },
                    {
                        XPosition = 0,
                        YPosition = -5,
                        XScale = 120,
                        YScale = 80,
                        Rotation = 0,
                        CombinationID = 1,
                        frame = 2,
                        Visible = true,
                        Interpolated = true,
                    },
                    {
                        XPosition = 0,
                        YPosition = -7,
                        XScale = 100,
                        YScale = 100,
                        Rotation = 0,
                        CombinationID = 1,
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
                [0] = {
                    Visible = true,
                    Frames = {
                        {
                            XPosition = 0,
                            YPosition = -34,
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
                Height = 32,
                Width = 32,
                XCrop = 0,
                XPivot = 16,
                YCrop = 0,
                YPivot = 26,
            },
        },
    },
    AttributeDetail = {
        [0] = {
            [1] = {
                st = 2,
                ed = 27,
            },
        },
    },
}

return anm2_data
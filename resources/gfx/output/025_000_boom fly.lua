local anm2_data = {
    Spritesheets = {
        [0] = "Monsters/Classic/Monster_096_BoomFly.png",
    },
    Animations = {
        Fly = {
            FrameNum = 2,
            Loop = true,
            LayerAnimations = {
                [0] = {
                    {
                        XPosition = 0,
                        YPosition = -8,
                        XScale = 100,
                        YScale = 100,
                        Rotation = 0,
                        CombinationID = 1,
                        frame = 0,
                        Visible = true,
                        Interpolated = false,
                    },
                    {
                        XPosition = 0,
                        YPosition = -8,
                        XScale = 100,
                        YScale = 100,
                        Rotation = 0,
                        CombinationID = 2,
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
                        {
                            XPosition = 0,
                            YPosition = -35,
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
            FrameNum = 28,
            Loop = false,
            LayerAnimations = {
                [0] = {
                    {
                        XPosition = 0,
                        YPosition = 6,
                        XScale = 100,
                        YScale = 100,
                        Rotation = 0,
                        CombinationID = 2,
                        frame = 0,
                        Visible = true,
                        Interpolated = true,
                    },
                    {
                        XPosition = 0,
                        YPosition = -8,
                        XScale = 60,
                        YScale = 140,
                        Rotation = 0,
                        CombinationID = 2,
                        frame = 6,
                        Visible = true,
                        Interpolated = true,
                    },
                    {
                        XPosition = 0,
                        YPosition = -7,
                        XScale = 120,
                        YScale = 80,
                        Rotation = 0,
                        CombinationID = 2,
                        frame = 8,
                        Visible = true,
                        Interpolated = true,
                    },
                    {
                        XPosition = 0,
                        YPosition = -8,
                        XScale = 100,
                        YScale = 100,
                        Rotation = 0,
                        CombinationID = 2,
                        frame = 10,
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
                            YPosition = -35,
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
                YPivot = 28,
            },
            [2] = {
                Height = 32,
                Width = 32,
                XCrop = 32,
                XPivot = 16,
                YCrop = 0,
                YPivot = 28,
            },
        },
    },
    AttributeDetail = {
        [0] = {
            [1] = {
                st = 6,
                ed = 27,
            },
            [2] = {
                st = 0,
                ed = 27,
            },
        },
    },
}

return anm2_data
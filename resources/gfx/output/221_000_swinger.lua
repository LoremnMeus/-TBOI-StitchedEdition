local anm2_data = {
    Spritesheets = {
        [0] = "monsters/rebirth/monster_221_swinger.png",
    },
    Animations = {
        Body = {
            FrameNum = 32,
            Loop = true,
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
                        Interpolated = true,
                    },
                    {
                        XPosition = 0,
                        YPosition = 0,
                        XScale = 110,
                        YScale = 90,
                        Rotation = 0,
                        CombinationID = 1,
                        frame = 8,
                        Visible = true,
                        Interpolated = true,
                    },
                    {
                        XPosition = 0,
                        YPosition = 0,
                        XScale = 100,
                        YScale = 100,
                        Rotation = 0,
                        CombinationID = 1,
                        frame = 16,
                        Visible = true,
                        Interpolated = true,
                    },
                    {
                        XPosition = 0,
                        YPosition = 0,
                        XScale = 90,
                        YScale = 110,
                        Rotation = 0,
                        CombinationID = 1,
                        frame = 24,
                        Visible = true,
                        Interpolated = true,
                    },
                    {
                        XPosition = 0,
                        YPosition = 0,
                        XScale = 100,
                        YScale = 100,
                        Rotation = 0,
                        CombinationID = 1,
                        frame = 31,
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
                            YPosition = -40,
                            XScale = 100,
                            YScale = 100,
                            frame = 0,
                            Visible = true,
                        },
                    },
                },
            },
        },
        Head = {
            FrameNum = 4,
            Loop = true,
            LayerAnimations = {
                [0] = {
                    {
                        XPosition = 0,
                        YPosition = -24,
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
                        YPosition = -24,
                        XScale = 100,
                        YScale = 100,
                        Rotation = 0,
                        CombinationID = 3,
                        frame = 2,
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
                            YPosition = -40,
                            XScale = 100,
                            YScale = 100,
                            frame = 0,
                            Visible = true,
                        },
                    },
                },
            },
        },
        Cord = {
            FrameNum = 1,
            Loop = true,
            LayerAnimations = {
                [0] = {
                    {
                        XPosition = 8,
                        YPosition = -6,
                        XScale = 100,
                        YScale = 100,
                        Rotation = 0,
                        CombinationID = 4,
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
                YCrop = 64,
                YPivot = 16,
            },
            [2] = {
                Height = 32,
                Width = 32,
                XCrop = 0,
                XPivot = 16,
                YCrop = 0,
                YPivot = 16,
            },
            [3] = {
                Height = 32,
                Width = 32,
                XCrop = 32,
                XPivot = 16,
                YCrop = 0,
                YPivot = 16,
            },
            [4] = {
                Height = 16,
                Width = 16,
                XCrop = 0,
                XPivot = 16,
                YCrop = 32,
                YPivot = 16,
            },
        },
    },
    AttributeDetail = {
        [0] = {
            [1] = {
                st = 8,
                ed = 24,
            },
            [2] = {
                st = 3,
                ed = 28,
            },
            [3] = {
                st = 3,
                ed = 28,
            },
            [4] = {
                st = 3,
                ed = 12,
            },
        },
    },
}

return anm2_data
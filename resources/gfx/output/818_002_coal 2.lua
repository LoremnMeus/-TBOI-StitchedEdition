local anm2_data = {
    Spritesheets = {
        [0] = "monsters/repentance/818.002_coal.png",
        [1] = "monsters/repentance/818.002_coalspider.png",
    },
    Animations = {
        IdleRock = {
            FrameNum = 12,
            Loop = true,
            LayerAnimations = {
                [1] = {
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
                        YPosition = 0,
                        XScale = 100,
                        YScale = 100,
                        Rotation = 0,
                        CombinationID = 3,
                        frame = 4,
                        Visible = true,
                        Interpolated = true,
                    },
                    {
                        XPosition = 0,
                        YPosition = 0,
                        XScale = 100,
                        YScale = 100,
                        Rotation = 0,
                        CombinationID = 4,
                        frame = 6,
                        Visible = true,
                        Interpolated = true,
                    },
                    {
                        XPosition = 0,
                        YPosition = 0,
                        XScale = 100,
                        YScale = 100,
                        Rotation = 0,
                        CombinationID = 5,
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
                        CombinationID = 6,
                        frame = 10,
                        Visible = true,
                        Interpolated = true,
                    },
                },
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
                        XScale = 100,
                        YScale = 100,
                        Rotation = 0,
                        CombinationID = 1,
                        frame = 6,
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
                        frame = 11,
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
                            YPosition = -18,
                            XScale = 100,
                            YScale = 100,
                            frame = 0,
                            Visible = true,
                        },
                    },
                },
                [1] = {
                    Visible = true,
                    Frames = {
                        {
                            XPosition = 0,
                            YPosition = -5,
                            XScale = 50,
                            YScale = 50,
                            frame = 1,
                            Visible = true,
                        },
                    },
                },
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
                Height = 32,
                Width = 32,
                XCrop = 0,
                XPivot = 16,
                YCrop = 96,
                YPivot = 26,
            },
            [2] = {
                Height = 32,
                Width = 32,
                XCrop = 32,
                XPivot = 16,
                YCrop = 96,
                YPivot = 26,
            },
            [3] = {
                Height = 32,
                Width = 32,
                XCrop = 64,
                XPivot = 16,
                YCrop = 96,
                YPivot = 26,
            },
            [4] = {
                Height = 32,
                Width = 32,
                XCrop = 96,
                XPivot = 16,
                YCrop = 96,
                YPivot = 26,
            },
            [5] = {
                Height = 32,
                Width = 32,
                XCrop = 128,
                XPivot = 16,
                YCrop = 96,
                YPivot = 26,
            },
            [6] = {
                Height = 32,
                Width = 32,
                XCrop = 160,
                XPivot = 16,
                YCrop = 96,
                YPivot = 26,
            },
        },
        [0] = {
            [1] = {
                Height = 32,
                Width = 32,
                XCrop = 0,
                XPivot = 16,
                YCrop = 32,
                YPivot = 23,
            },
        },
    },
    AttributeDetail = {
        [1] = {
            [1] = {
                st = 4,
                ed = 32,
            },
            [2] = {
                st = 5,
                ed = 32,
            },
            [3] = {
                st = 6,
                ed = 32,
            },
            [4] = {
                st = 5,
                ed = 32,
            },
            [5] = {
                st = 4,
                ed = 31,
            },
            [6] = {
                st = 4,
                ed = 32,
            },
        },
        [0] = {
            [1] = {
                st = 13,
                ed = 25,
            },
        },
    },
}

return anm2_data
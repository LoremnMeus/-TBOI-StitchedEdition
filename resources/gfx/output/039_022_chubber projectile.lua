local anm2_data = {
    Spritesheets = {
        [0] = "Monsters/Classic/ChubberWorm.png",
    },
    Animations = {
        Down = {
            FrameNum = 4,
            Loop = true,
            LayerAnimations = {
                [0] = {
                    {
                        XPosition = 0,
                        YPosition = -12,
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
                        YPosition = -14,
                        XScale = 100,
                        YScale = 100,
                        Rotation = 0,
                        CombinationID = 2,
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
        Side = {
            FrameNum = 4,
            Loop = true,
            LayerAnimations = {
                [0] = {
                    {
                        XPosition = 0,
                        YPosition = -12,
                        XScale = 100,
                        YScale = 100,
                        Rotation = 0,
                        CombinationID = 3,
                        frame = 0,
                        Visible = true,
                        Interpolated = true,
                    },
                    {
                        XPosition = 0,
                        YPosition = -12,
                        XScale = 100,
                        YScale = 100,
                        Rotation = 0,
                        CombinationID = 4,
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
        Up = {
            FrameNum = 4,
            Loop = true,
            LayerAnimations = {
                [0] = {
                    {
                        XPosition = 0,
                        YPosition = -12,
                        XScale = 100,
                        YScale = 100,
                        Rotation = 0,
                        CombinationID = 5,
                        frame = 0,
                        Visible = true,
                        Interpolated = true,
                    },
                    {
                        XPosition = 0,
                        YPosition = -12,
                        XScale = 100,
                        YScale = 100,
                        Rotation = 0,
                        CombinationID = 6,
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
                Height = 32,
                Width = 32,
                XCrop = 0,
                XPivot = 16,
                YCrop = 0,
                YPivot = 16,
            },
            [2] = {
                Height = 32,
                Width = 32,
                XCrop = 32,
                XPivot = 16,
                YCrop = 0,
                YPivot = 16,
            },
            [3] = {
                Height = 32,
                Width = 32,
                XCrop = 64,
                XPivot = 16,
                YCrop = 0,
                YPivot = 16,
            },
            [4] = {
                Height = 32,
                Width = 32,
                XCrop = 96,
                XPivot = 16,
                YCrop = 0,
                YPivot = 16,
            },
            [5] = {
                Height = 32,
                Width = 32,
                XCrop = 0,
                XPivot = 16,
                YCrop = 32,
                YPivot = 16,
            },
            [6] = {
                Height = 32,
                Width = 32,
                XCrop = 32,
                XPivot = 16,
                YCrop = 32,
                YPivot = 16,
            },
        },
    },
    AttributeDetail = {
        [0] = {
            [1] = {
                st = 4,
                ed = 28,
            },
            [2] = {
                st = 5,
                ed = 27,
            },
            [3] = {
                st = 8,
                ed = 24,
            },
            [4] = {
                st = 9,
                ed = 24,
            },
            [5] = {
                st = 4,
                ed = 28,
            },
            [6] = {
                st = 5,
                ed = 26,
            },
        },
    },
}

return anm2_data
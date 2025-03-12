local anm2_data = {
    Spritesheets = {
        [0] = "grid/props_livingroom.png",
        [1] = "grid/tv_light.png",
    },
    Animations = {
        Idle = {
            FrameNum = 1,
            Loop = false,
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
                        Interpolated = false,
                    },
                },
                [1] = {
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
        Idle2 = {
            FrameNum = 6,
            Loop = true,
            LayerAnimations = {
                [0] = {
                    {
                        XPosition = 0,
                        YPosition = 0,
                        XScale = 100,
                        YScale = 100,
                        Rotation = 0,
                        CombinationID = 2,
                        frame = 0,
                        Visible = true,
                        Interpolated = false,
                    },
                    {
                        XPosition = 0,
                        YPosition = 0,
                        XScale = 100,
                        YScale = 100,
                        Rotation = 0,
                        CombinationID = 3,
                        frame = 3,
                        Visible = true,
                        Interpolated = false,
                    },
                },
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
                        Interpolated = false,
                    },
                    {
                        XPosition = 0,
                        YPosition = 0,
                        XScale = 100,
                        YScale = 100,
                        Rotation = 0,
                        CombinationID = 1,
                        frame = 3,
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
                            XPosition = -5,
                            YPosition = -20,
                            XScale = 100,
                            YScale = 100,
                            frame = 0,
                            Visible = true,
                        },
                        {
                            XPosition = -5,
                            YPosition = -20,
                            XScale = 80,
                            YScale = 80,
                            frame = 3,
                            Visible = true,
                        },
                    },
                },
            },
        },
    },
    Layers = {
        [0] = 0,
        [1] = 1,
    },
    AttributeCombinations = {
        [0] = {
            [1] = {
                Height = 93,
                Width = 104,
                XCrop = 156,
                XPivot = 52,
                YCrop = 0,
                YPivot = 80,
            },
            [2] = {
                Height = 93,
                Width = 104,
                XCrop = 156,
                XPivot = 52,
                YCrop = 93,
                YPivot = 80,
            },
            [3] = {
                Height = 93,
                Width = 104,
                XCrop = 156,
                XPivot = 52,
                YCrop = 186,
                YPivot = 80,
            },
        },
        [1] = {
            [1] = {
                Height = 256,
                Width = 256,
                XCrop = 0,
                XPivot = 128,
                YCrop = 0,
                YPivot = 48,
            },
        },
    },
    AttributeDetail = {
        [0] = {
            [1] = {
                st = 25,
                ed = 88,
            },
            [2] = {
                st = 25,
                ed = 88,
            },
            [3] = {
                st = 25,
                ed = 87,
            },
        },
        [1] = {
            [1] = {
                st = 12,
                ed = 217,
            },
        },
    },
}

return anm2_data
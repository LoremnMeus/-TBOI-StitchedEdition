local anm2_data = {
    Spritesheets = {
        [0] = "grid/props_livingroom.png",
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
    },
    Layers = {
        [0] = 0,
    },
    AttributeCombinations = {
        [0] = {
            [1] = {
                Height = 78,
                Width = 156,
                XCrop = 0,
                XPivot = 78,
                YCrop = 0,
                YPivot = 60,
            },
            [2] = {
                Height = 78,
                Width = 156,
                XCrop = 0,
                XPivot = 78,
                YCrop = 78,
                YPivot = 60,
            },
            [3] = {
                Height = 78,
                Width = 156,
                XCrop = 0,
                XPivot = 78,
                YCrop = 156,
                YPivot = 60,
            },
        },
    },
    AttributeDetail = {
        [0] = {
            [1] = {
                st = 18,
                ed = 73,
            },
            [2] = {
                st = 18,
                ed = 73,
            },
            [3] = {
                st = 18,
                ed = 74,
            },
        },
    },
}

return anm2_data
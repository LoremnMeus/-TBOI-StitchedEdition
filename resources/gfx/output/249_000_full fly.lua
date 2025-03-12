local anm2_data = {
    Spritesheets = {
        [0] = "Monsters/Rebirth/monster_249_full fly.png",
    },
    Animations = {
        Idle = {
            FrameNum = 2,
            Loop = true,
            LayerAnimations = {
                [0] = {
                    {
                        XPosition = 0,
                        YPosition = -23,
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
                        YPosition = -22,
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
                            XPosition = -1,
                            YPosition = -32,
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
        },
    },
    AttributeDetail = {
        [0] = {
            [1] = {
                st = 14,
                ed = 30,
            },
            [2] = {
                st = 14,
                ed = 30,
            },
        },
    },
}

return anm2_data
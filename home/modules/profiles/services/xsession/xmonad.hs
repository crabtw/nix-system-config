import XMonad

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName

import XMonad.Layout.NoBorders
import XMonad.Layout.ToggleLayouts

import XMonad.Util.Run (spawnPipe)

import qualified Data.Map as M
import System.IO

myPP bar = xmobarPP
    { ppOutput = hPutStrLn bar
    , ppTitle = xmobarColor "#00ff00" "" . shorten 80
    }

myLayout = toggleLayouts (noBorders Full) defaultLayout
  where
    defaultLayout = avoidStruts $ smartBorders layout
    layout = Mirror tiled ||| Full ||| tiled
    tiled = Tall 1 (3/100) (1/2)

myKeys x = M.union (newKeys x) (keys def x)
  where
    newKeys x = M.fromList
        [ ((modMask x, xK_f), sendMessage ToggleLayout)
        , ((modMask x, xK_p), spawn "dmenu_run")
        , ((modMask x, xK_q), return ())
        ]

myManageHook = manageHook def <+> manageDocks

myHandleEventHook = handleEventHook def <+> docksEventHook

main = do
    xmobar <- spawnPipe "xmobar"
    xmonad $ def
        { layoutHook = myLayout
        , logHook = dynamicLogWithPP $ myPP xmobar
        , keys = myKeys
        , modMask = mod4Mask
        , manageHook = myManageHook
        , handleEventHook = myHandleEventHook
        , terminal = "wezterm"
        }

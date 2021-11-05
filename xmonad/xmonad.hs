--
-- xmonad config file.
--
--
--Imports

--Base
import XMonad
import Data.Monoid
import System.Exit
import qualified XMonad.StackSet as W
import qualified Data.Map        as M

--Actions
import XMonad.Actions.Search
import XMonad.Actions.NoBorders

--Hooks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.SetWMName
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat, doCenterFloat)


--Layouts
import XMonad.Layout.SimplestFloat
import XMonad.Layout.ResizableTile
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Tabbed

--Layouts modifiers
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
import XMonad.Layout.ShowWName
import XMonad.Layout.Renamed
import XMonad.Layout.Magnifier
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
import XMonad.Layout.NoBorders
import XMonad.Layout.Simplest
import XMonad.Layout.Spacing
import XMonad.Layout.SubLayouts
import XMonad.Layout.WindowNavigation
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))
import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))

--Util
import XMonad.Util.SpawnOnce
import XMonad.Util.Run
import XMonad.Util.EZConfig
import XMonad.Actions.CycleWS
import XMonad.Util.NamedScratchpad



-- My preferred terminal program.
--
myTerminal      = "alacritty"

-- My preferred font to use 
--
myFont :: String
myFont = "xft:Hack Nerd Font:size=10:antialias=true:hinting=true"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
-- put 0 to disable borders
myBorderWidth   = 0

-- modMask lets you specify which modkey you want to use.
-- mod1mask is alt, mod4 is the super/windows key
myModMask       = mod4Mask

-- The default number of workspaces (virtual screens) and their names.
--
xmobarEscape :: String -> String
xmobarEscape = concatMap doubleLts
    where
        doubleLts '<' = "<<"
        doubleLts x   = [x]

myWorkspaces :: [String]
myWorkspaces = clickable . map xmobarEscape
               -- $ ["dev", "www", "code", "funz", "nuzac", "idk", "etc"]
               $ ["dev", "www", "code", "editz", "notes", "nuzac"]
    where
        clickable l = [ "<action=xdotool key super+" ++ show n ++ ">" ++ ws ++ "</action>" |
                      (i,ws) <- zip [1..9] l,
                      let n = i ]

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

-- Border colors for unfocused and focused windows.
--
myNormalBorderColor  = "#e1d9c8"
myFocusedBorderColor = "#d58546"

------------------------------------------------------------------------
-- Key bindings.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm,               xK_Return ), spawn $ XMonad.terminal conf)

    -- launch rofi
    , ((modm,               xK_l     ), spawn "rofi -show drun")

    , ((modm .|. controlMask, xK_l   ), spawn "rofi -show run")

    -- close focused window
    , ((modm,               xK_c     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    -- , ((modm,               xK_n     ), refresh)

    -- move to the previous Workspace
    , ((modm,               xK_b     ), prevWS)

    -- move to the next Workspace
    , ((modm,               xK_v     ), nextWS)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)

    -- open the pulsemixer scratchpad
    , ((modm .|. controlMask, xK_a   ), namedScratchpadAction scratchpads "pulsemixer")

    -- open the todo.md scratchpad
    , ((modm .|. controlMask, xK_n   ), namedScratchpadAction scratchpads "cmus")

    -- terminal scratchpad blablabla
    , ((modm .|. controlMask, xK_t   ), namedScratchpadAction scratchpads "scratchpad" )

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm .|. shiftMask, xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    , ((modm .|. shiftMask, xK_h     ), sendMessage MirrorShrink)
    -- Expand the master area
    , ((modm,               xK_n     ), sendMessage Expand)

    , ((modm .|. shiftMask, xK_n     ), sendMessage MirrorExpand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm,               xK_i     ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm,               xK_d     ), sendMessage (IncMasterN (-1)))
    
    -- , ((modm,  xK_g ),   withFocused toggleBorder)

    -- set my keyboard layouts
    , ((modm,               xK_F9    ), spawn "setxkbmap -layout br")

    , ((modm .|. shiftMask, xK_F9    ), spawn "setxkbmap -layout us")

    , ((modm,               xK_F10   ), spawn "setxkbmap -layout br -variant dvorak")

    , ((modm .|. shiftMask, xK_F10   ), spawn "setxkbmap -layout us -variant dvorak")

    , ((modm .|. controlMask, xK_F10 ), spawn "setxkbmap -layout us -variant dvp")

    , ((modm,               xK_F11   ), spawn "sed -i 's/*Gruvdark/*Gruvlight/' .config/alacritty/alacritty.yml")

    , ((modm,               xK_F12   ), spawn "sed -i 's/*Gruvlight/*Gruvdark/' .config/alacritty/alacritty.yml")

    -- change the brightness of the screen
    , ((modm,               xK_F3    ), spawn "bri.sh up")

    , ((modm,               xK_F4    ), spawn "bri.sh down")

    -- previous song, next or play-pause
    , ((modm,               xK_F5    ), spawn "playerctl --player=cmus,spotify,spotifyd previous")

    , ((modm,               xK_F6    ), spawn "playerctl --player=cmus,spotify,spotifyd next")

    , ((modm,               xK_F7    ), spawn "playerctl --player=cmus,spotify,spotifyd play-pause")

    -- change the volume up or down by 10
    , ((modm,               xK_F1    ), spawn "vol.sh up")

    , ((modm,               xK_F2    ), spawn "vol.sh down")

    , ((modm,               xK_F8    ), spawn "vol.sh mute")

    -- my passwordsssss
    , ((modm .|. shiftMask, xK_l     ), spawn "passmenu --type")

    -- Toggle the status bar
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    , ((modm .|. shiftMask, xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]


------------------------------------------------------------------------
-- Scratchpads cuz why the fuck not?

scratchpads = [ NS "pulsemixer" spawnPmix findPmix managePmix
              , NS "cmus" spawnCmus findCmus manageCmus
              , NS "scratchpad" spawnTerm findTerm manageTerm
              ]
  where
    spawnPmix  = myTerminal ++ " -t pulsemixer -e pulsemixer"
    findPmix   = title =? "pulsemixer"
    managePmix = customFloating $ W.RationalRect l t w h
               where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w
    spawnCmus  = myTerminal ++ " -t cmus -e cmus"
    findCmus   = title =? "cmus"
    manageCmus = customFloating $ W.RationalRect l t w h
               where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w
    spawnTerm  = myTerminal ++ " -t scratchpad"
    findTerm   = title =? "scratchpad"
    manageTerm = customFloating $ W.RationalRect l t w h
               where
                 h = 0.6
                 w = 0.6
                 t = 0.8 -h
                 l = 0.8 -w

------------------------------------------------------------------------
-- Layouts:
--
-- The available layouts. Each layout is separated by |||.
--

-- setting the collors for tabs layout and tabs sub layout
myTabTheme = def { fontName          = myFont 
                 , activeColor         = "#46d9ff"
                 , inactiveColor       = "#313846"
                 , activeBorderColor   = "#46d9ff"
                 , inactiveBorderColor = "#282c34"
                 , activeTextColor     = "#282c34"
                 , inactiveTextColor   = "#d0d0d0"
                 }


-- defining the spacing between windows (gaps)
-- but when only 1 window is open, I don't have gaps

mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw True (Border i i i i) True (Border i i i i) True

-- here I define my layoutzzzzzzz
floats   = renamed [Replace "floats"]
            -- $ smartBorders
            $ limitWindows 20 simplestFloat
tall     = renamed [Replace "tall"]
            $ smartBorders
            $ windowNavigation
            $ addTabs shrinkText myTabTheme
            $ subLayout [] (smartBorders Simplest)
            $ limitWindows 8
            $ mySpacing 2
            $ ResizableTall 1 (3/100) (1/2) []
-- monocle  = renamed [Replace "monocle"]
--             $ smartBorders
--             $ windowNavigation
--             $ subLayout [] (smartBorders Simplest)
--             $ limitWindows 2 Full
tabs     = renamed [Replace "tabs"]
            $ tabbed shrinkText myTabTheme

myLayout = avoidStruts $ T.toggleLayouts floats
           $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout
         where
           myDefaultLayout =     tall 
                             ||| Mirror tall
                             ||| noBorders tabs
                             -- ||| noBorders monocle
                             ||| floats

     -- default tiling algorithm partitions the screen into two panes
     -- tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     -- nmaster = 1

     -- Default proportion of screen occupied by master pane
     -- ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     -- delta   = 3/100

------------------------------------------------------------------------
-- Window rules:
--
myManageHook = composeAll
    [ className =? "heroic"        --> doFloat
    -- , className =? "mpv"         --> doFloat
    , className =? "Steam (Runtime)" --> doFloat
    , className =? "Wine"           --> doFloat
    , className =? "Gimp-2.10"      --> doFloat
    , className =? "Pcmanfm"        --> doFloat
    , className =? "Electron"       --> doFloat
    , className =? "Chromium"       --> doShift ( myWorkspaces !! 1 )
    , className =? "spotify"        --> doShift ( myWorkspaces !! 5 )
    , className =? "kdenlive"       --> doShift ( myWorkspaces !! 3 )
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore 
    ] <+> namedScratchpadManageHook scratchpads 

------------------------------------------------------------------------
-- Event handling
--
-- do this to tell xmobar to fuck off when I'm fullscreen
-- also to use the fullscreen on games, watching fullscreen youtube videos and etc
myEventHook = handleEventHook def <+> fullscreenEventHook

------------------------------------------------------------------------
-- Startup hook

myStartupHook = do
    spawnOnce "xcape -e Caps_Lock=Escape && setxkbmap -option caps:ctrl_modifier,shift:both_capslock &"
    -- for some reason if I try to just run the setxkbmap after the firlt setxkb, the first
    -- runs perfectly fine, but the second never runs, so I just did this and it works fine
    -- and don't try to make "cmd & cmd" cuz It will not load the second command
    -- it needs to have 2 && signs
    spawnOnce "feh --bg-fill images/Wallpapers/haskell.jpg && setxkbmap -layout us -variant dvorak &"
    spawnOnce "xsetroot -cursor_name left_ptr &"
    spawnOnce "xset r rate 300 50 &"
    spawnOnce "xrdb -merge ~/.Xresources &"
    spawnOnce "picom --experimental-backends &"
    -- spawnOnce "setxkbmap -layout us -variant dvorak &"
    -- spawnOnce "xautolock -locker "lock.sh" -time 1" -- it will lock the screen with my lock.sh after 1 minute of sleep
    spawnOnce "dunst"
    setWMName "XMonad"

------------------------------------------------------------------------
-- Run xmonad with the settings specified.
--
main = do
   -- spawns the xmobar on the monitors i specified
   xmproc0 <- spawnPipe "xmobar -x 0 /home/rodrigo/.config/xmobar/xmobarrc"
   -- xmproc1 <- spawnPipe "xmobar -x 1 /home/rodrigo/.config/xmobar/xmobarrc"
   xmonad . ewmh $ docks def {


      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,



      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = dynamicLogWithPP xmobarPP
                               { ppOutput = \x -> hPutStrLn xmproc0 x
                                               -- >> hPutStrLn xmproc1 x
                               , ppCurrent = xmobarColor "#d58546" "" . wrap "[ " " ]" -- Current workspace in xmobar
                               , ppVisible = xmobarColor "#e1d9c8" ""                -- Visible but not current workspace
                               -- , ppHidden = xmobarColor "#a020f0" "" . wrap "*" ""   -- Hidden workspaces in xmobar
                               , ppHidden = xmobarColor "#a020f0" ""                 -- Hidden workspaces in xmobar
                               , ppHiddenNoWindows = xmobarColor "#e1d9c8" ""        -- Hidden workspaces (no windows)
                               , ppTitle = xmobarColor "#e1d9c8" "" . shorten 70    -- Title of active window in xmobar default 60
                               , ppSep =  "<fc=#666666> | </fc>"                     -- Separators in xmobar
                               , ppUrgent = xmobarColor "#e1d9c8" "" . wrap "!" "!"  -- Urgent workspace
                               , ppExtras  = [windowCount]                           -- # of windows current workspace
                               , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]
                               },
        startupHook        = myStartupHook
      }
      `additionalKeysP`
      [ ("M-S-s", spawn "maim -s -u ~/images/screenshots/$(date +%b-%d:%H:%M:%S).png") 
      , ("M-C-s", spawn "lock.sh")
      , ("M-C-m", spawn "rofi -show emoji -modi emoji")
      , ("M-f",   spawn "pcmanfm")
      , ("M-o",   spawn "obsidian")
      , ("M-M1-f", sendMessage (T.Toggle "floats")) -- doesn't work that way for more than 1 layout
      , ("M-S-f", sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts)
      , ("M-C-h", decWindowSpacing 2 >> decScreenSpacing 2)
      , ("M-C-g", incWindowSpacing 2 >> incScreenSpacing 2)
      , ("M-M1-h", sendMessage $ pullGroup L)
      , ("M-M1-n", sendMessage $ pullGroup R)
      , ("M-M1-k", sendMessage $ pullGroup U)
      , ("M-M1-j", sendMessage $ pullGroup D)
      , ("M-M1-m", withFocused (sendMessage . MergeAll))
      , ("M-/", withFocused (sendMessage . UnMerge))
      , ("M-C-w", onGroup W.focusUp')
      , ("M-C-v", onGroup W.focusDown')]

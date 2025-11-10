{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.mango;
in
{
  imports = [
    inputs.mango.hmModules.mango
  ];

  options.homeManagerModules.desktop.windowManagers.mango = {
    enable = mkOption {
      type = types.bool;
      # default = config.homeManagerModules.desktop.windowManagers.enable;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      grim
      slurp
      playerctl
      brightnessctl
    ];

    homeManagerModules.desktop.windowManagers.utils = {
      wofi.enable = true;
      swaync.enable = true;
      cliphist.enable = true;
      swayosd.enable = true;
      dolphin.enable = true;
      polkit.enable = true;
      systemd.enable = true;
      wlogout.enable = true;
      swayidle.enable = true;
      swaybg.enable = true;
    };

    wayland.windowManager.mango = {
      enable = true;

      # More option see https://github.com/DreamMaoMao/mango/wiki/
      settings = ''
        # Window effect
        blur=1
        blur_layer=0
        blur_optimized=1
        blur_params_num_passes = 3
        # blur_params_radius = 5
        # blur_params_noise = 0.02
        # blur_params_brightness = 0.9
        # blur_params_contrast = 0.9
        # blur_params_saturation = 1.1

        shadows = 1
        layer_shadows = 1
        shadow_only_floating = 1
        shadows_size = 5
        shadows_blur = 10
        shadows_position_x = 0
        shadows_position_y = 0
        shadowscolor= 0x45475aff

        border_radius=8
        no_radius_when_single=0
        focused_opacity=1.0
        unfocused_opacity=1.0

        # Animation Configuration(support type:zoom,slide)
        # tag_animation_direction: 0-horizontal,1-vertical
        animations=1
        layer_animations=1
        animation_type_open=slide
        animation_type_close=slide
        animation_fade_in=1
        animation_fade_out=1
        tag_animation_direction=1
        zoom_initial_ratio=0.3
        zoom_end_ratio=0.8
        fadein_begin_opacity=0.5
        fadeout_begin_opacity=0.8
        animation_duration_move=400
        animation_duration_open=320
        animation_duration_tag=280
        animation_duration_close=600
        animation_curve_open=0.46,1.0,0.29,1
        animation_curve_move=0.46,1.0,0.29,1
        animation_curve_tag=0.46,1.0,0.29,1
        animation_curve_close=0.08,0.92,0,1

        # Scroller Layout Setting
        scroller_structs=20
        scroller_default_proportion=0.8
        scroller_focus_center=0
        scroller_prefer_center=0
        edge_scroller_pointer_focus=1
        scroller_default_proportion_single=1.0
        scroller_proportion_preset=0.5,0.8,1.0

        # Master-Stack Layout Setting (tile,spiral,dwindle)
        new_is_master=1
        default_mfact=0.55
        default_nmaster=1
        smartgaps=0

        # Overview Setting
        hotarea_size=10
        enable_hotarea=1
        ov_tab_mode=0
        overviewgappi=5
        overviewgappo=30

        # Misc
        no_border_when_single=0
        axis_bind_apply_timeout=100
        focus_on_activate=1
        inhibit_regardless_of_visibility=0
        sloppyfocus=1
        warpcursor=1
        focus_cross_monitor=0
        focus_cross_tag=0
        enable_floating_snap=0
        snap_distance=30
        cursor_size=24
        drag_tile_to_tile=1

        # keyboard
        repeat_rate=35
        repeat_delay=500
        numlockon=1
        xkb_rules_layout=us

        # Trackpad
        # need relogin to make it apply
        disable_trackpad=0
        tap_to_click=1
        tap_and_drag=1
        drag_lock=1
        trackpad_natural_scrolling=0
        disable_while_typing=1
        left_handed=0
        middle_button_emulation=0
        swipe_min_threshold=0

        # mouse
        mouse_natural_scrolling=0
        accel_profile=1
        accel_speed=-0.675
        adaptive_sync=0

        # Display
        monitorrule=DP-1,0.55,1,tile,0,1,0,0,2560,1440,165
        monitorrule=HDMI-A-1,0.55,1,tile,0,1,2560,0,3440,1440,175

        # Appearance
        gappih=4
        gappiv=4
        gappoh=4
        gappov=4
        scratchpad_width_ratio=0.8
        scratchpad_height_ratio=0.9
        borderpx=2
        rootcolor=0x000000ff
        bordercolor=0x45475aff
        focuscolor=0x89b4faff
        maxmizescreencolor=0x89aa61ff
        urgentcolor=0xf38ba8ff
        scratchpadcolor=0x516c93ff
        globalcolor=0xb153a7ff
        overlaycolor=0x14a57cff

        # layout support:
        # horizontal:tile,scroller,grid,monocle,spiral,dwindle
        # vertical:vertical_tile,vertical_scroller,vertical_grid,vertical_monocle,vertical_spiral,vertical_dwindle
        tagrule=id:1,layout_name:tile
        tagrule=id:2,layout_name:tile
        tagrule=id:3,layout_name:tile
        tagrule=id:4,layout_name:tile
        tagrule=id:5,layout_name:tile
        tagrule=id:6,layout_name:tile
        tagrule=id:7,layout_name:tile
        tagrule=id:8,layout_name:tile
        tagrule=id:9,layout_name:tile

        # Key Bindings
        # key name refer to `xev` or `wev` command output,
        # mod keys name: super,ctrl,alt,shift,none

        # reload config
        bind=SUPER+Ctrl,r,reload_config

        # Screenshots
        bind=none,Print,spawn_shell,grim "$HOME/Pictures/screenshots/dwl/$(date +%Y-%m-%d_%H-%m-%s).png"
        bind=shift,Print,spawn_shell,grim -g "$(slurp)" "$HOME/Pictures/screenshots/dwl/$(date +%Y-%m-%d_%H-%m-%s).png"

        # Menus
        bind=SUPER,s,spawn,wofi --show drun
        bind=SUPER,x,spawn,wlogout
        bind=SUPER,c,spawn,wofi-emoji
        bind=SUPER,d,spawn_shell,cliphist list | wofi --dmenu | cliphist decode | wl-copy

        # Apps
        bind=SUPER,a,spawn,joplin-desktop
        bind=SUPER,r,spawn,zen
        bind=SUPER,Return,spawn,wezterm

        # Window management - DWL style
        bind=SUPER,e,focusstack,next
        bind=SUPER,i,focusstack,prev
        bind=SUPER,n,incnmaster,1
        bind=SUPER,o,incnmaster,-1
        bind=SUPER,l,setmfact,-0.05
        bind=SUPER,u,setmfact,+0.05
        bind=SUPER,l,increase_proportion,0.1
        bind=SUPER,u,increase_proportion,-0.1
        bind=SUPER,y,zoom
        bind=SUPER,Tab,view,last
        bind=SUPER,w,killclient

        # Layout switching - DWL style
        bind=SUPER,j,setlayout,tile
        bind=SUPER,m,setlayout,scroller
        bind=SUPER,k,setlayout,monocle
        bind=SUPER,h,setlayout,spiral
        bind=SUPER,space,switch_layout

        # Window states
        bind=SUPER+SHIFT,space,togglefloating
        bind=SUPER,t,togglefullscreen
        bind=SUPER,F5,togglefakefullscreen
        bind=SUPER,g,togglegaps

        # Tag operations
        bind=SUPER,1,view,1
        bind=SUPER,2,view,2
        bind=SUPER,3,view,3
        bind=SUPER,4,view,4
        bind=SUPER,5,view,5
        bind=SUPER,6,view,6
        bind=SUPER,7,view,7
        bind=SUPER,8,view,8
        bind=SUPER,9,view,9
        bind=SUPER,0,view,all

        bind=SUPER+SHIFT,exclam,tag,1
        bind=SUPER+SHIFT,at,tag,2
        bind=SUPER+SHIFT,numbersign,tag,3
        bind=SUPER+SHIFT,dollar,tag,4
        bind=SUPER+SHIFT,percent,tag,5
        bind=SUPER+SHIFT,asciicircum,tag,6
        bind=SUPER+SHIFT,ampersand,tag,7
        bind=SUPER+SHIFT,asterisk,tag,8
        bind=SUPER+SHIFT,parenleft,tag,9
        bind=SUPER+SHIFT,parenright,tag,all

        bind=SUPER+CTRL,1,toggleview,1
        bind=SUPER+CTRL,2,toggleview,2
        bind=SUPER+CTRL,3,toggleview,3
        bind=SUPER+CTRL,4,toggleview,4
        bind=SUPER+CTRL,5,toggleview,5
        bind=SUPER+CTRL,6,toggleview,6
        bind=SUPER+CTRL,7,toggleview,7
        bind=SUPER+CTRL,8,toggleview,8
        bind=SUPER+CTRL,9,toggleview,9

        bind=SUPER+CTRL+SHIFT,exclam,toggletag,1
        bind=SUPER+CTRL+SHIFT,at,toggletag,2
        bind=SUPER+CTRL+SHIFT,numbersign,toggletag,3
        bind=SUPER+CTRL+SHIFT,dollar,toggletag,4
        bind=SUPER+CTRL+SHIFT,percent,toggletag,5
        bind=SUPER+CTRL+SHIFT,asciicircum,toggletag,6
        bind=SUPER+CTRL+SHIFT,ampersand,toggletag,7
        bind=SUPER+CTRL+SHIFT,asterisk,toggletag,8
        bind=SUPER+CTRL+SHIFT,parenleft,toggletag,9

        # Monitor operations
        bind=SUPER,comma,focusmon,left
        bind=SUPER,period,focusmon,right
        bind=SUPER+SHIFT,less,tagmon,left
        bind=SUPER+SHIFT,greater,tagmon,right

        # Media Keys (from DWL SHARED_KEYS)
        bind=none,XF86AudioRaiseVolume,spawn,swayosd-client --output-volume raise
        bind=none,XF86AudioLowerVolume,spawn,swayosd-client --output-volume lower
        bind=none,XF86AudioMute,spawn,swayosd-client --output-volume mute-toggle
        bind=CTRL,XF86AudioRaiseVolume,spawn,swayosd-client --input-volume raise
        bind=CTRL,XF86AudioLowerVolume,spawn,swayosd-client --input-volume lower
        bind=CTRL,XF86AudioMute,spawn,swayosd-client --input-volume mute-toggle
        bind=none,XF86MonBrightnessUp,spawn,swayosd-client --brightness raise
        bind=none,XF86MonBrightnessDown,spawn,swayosd-client --brightness lower
        bind=SHIFT,XF86MonBrightnessUp,spawn,playerctl shuffle Toggle
        bind=SHIFT,XF86MonBrightnessDown,spawn,playerctl loop Track
        bind=CTRL,XF86MonBrightnessUp,spawn,playerctl loop None
        bind=CTRL,XF86MonBrightnessDown,spawn,playerctl loop Playlist
        bind=SHIFT,XF86AudioRaiseVolume,spawn,playerctl volume 0.1+
        bind=SHIFT,XF86AudioLowerVolume,spawn,playerctl volume 0.1-
        bind=SHIFT,XF86AudioMute,spawn,playerctl volume 0
        bind=none,XF86AudioPlay,spawn,playerctl play-pause
        bind=none,XF86AudioNext,spawn,playerctl next
        bind=none,XF86AudioPrev,spawn,playerctl previous

        # System controls
        bind=SUPER+CTRL,q,quit

        # Mouse Button Bindings (adapted from DWL)
        mousebind=SUPER,btn_left,moveresize,curmove
        mousebind=SUPER,btn_middle,togglefloating,0
        mousebind=SUPER,btn_right,moveresize,curresize

        # Axis Bindings (keeping some original functionality)
        axisbind=SUPER,UP,viewtoleft_have_client
        axisbind=SUPER,DOWN,viewtoright_have_client

        # layer rule
        layerrule=animation_type_open:zoom,layer_name:wofi
        layerrule=animation_type_close:zoom,layer_name:wofi
      '';

      autostart_sh = ''
        dbus-update-activation-environment --systemd --all
        systemctl --user start wlroots-session.target
      '';
    };
  };
}

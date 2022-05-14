# Copyright © 2021 rdbende <rdbende@gmail.com>
# A stunning light/dark theme for ttk based on Microsoft's Sun Valley visual style

package require Tk 8.6

namespace eval ttk::theme::sun-valley-light {
    variable version 1.0
    package provide ttk::theme::sun-valley-light $version

    ttk::style theme create sun-valley-light -parent clam -settings {
        variable images
        variable s [image create photo -file [file join [file dirname [info script]] light.png] -format png]
        foreach {k x y w h} [list card 0 0 50 50 notebook-border 50 0 40 40 notebook 0 50 40 40 switch-off-disabled 50 40 40 20 switch-off-hover 40 60 40 20 switch-off-pressed 90 0 40 20 switch-off-rest 90 20 40 20 switch-on-disabled 90 40 40 20 switch-on-hover 80 60 40 20 switch-on-pressed 0 90 40 20 switch-on-rest 0 110 40 20 tab-hover 40 80 32 32 tab-rest 72 80 32 32 tab-selected 130 0 32 32 scale-thumb-disabled 0 130 22 22 scale-thumb-hover 130 32 22 22 scale-thumb-pressed 22 130 22 22 scale-thumb-rest 130 54 22 22 scale-trough-hor 120 76 22 22 scale-trough-vert 44 112 22 22 treeheading-hover 44 134 22 22 treeheading-pressed 66 112 22 22 treeheading-rest 66 134 22 22 button-accent-disabled 142 76 20 20 button-accent-hover 142 96 20 20 button-accent-pressed 104 98 20 20 button-accent-rest 124 116 20 20 button-close-hover 88 136 20 20 button-close-pressed 108 136 20 20 button-disabled 128 136 20 20 button-hover 144 116 20 20 button-pressed 162 0 20 20 button-rest 162 20 20 20 button-titlebar-hover 162 40 20 20 button-titlebar-pressed 162 60 20 20 check-disabled 162 80 20 20 check-hover 0 156 20 20 check-pressed 20 152 20 20 check-rest 40 156 20 20 check-tri-disabled 60 156 20 20 check-tri-hover 80 156 20 20 check-tri-pressed 100 156 20 20 check-tri-rest 120 156 20 20 check-unsel-disabled 140 156 20 20 check-unsel-hover 148 136 20 20 check-unsel-pressed 160 156 20 20 check-unsel-rest 20 172 20 20 entry-disabled 182 0 20 20 entry-focus 0 176 20 20 entry-hover 182 20 20 20 entry-invalid 182 40 20 20 entry-rest 182 60 20 20 progress-pbar-hor 182 80 20 5 progress-pbar-vert 88 112 5 20 progress-trough-hor 182 85 20 5 progress-trough-vert 93 112 5 20 radio-disabled 182 90 20 20 radio-hover 180 110 20 20 radio-pressed 180 130 20 20 radio-rest 180 150 20 20 radio-unsel-disabled 180 170 20 20 radio-unsel-hover 40 176 20 20 radio-unsel-pressed 60 176 20 20 radio-unsel-rest 80 176 20 20 scroll-hor-thumb 100 190 20 12 scroll-hor-trough 120 190 20 12 scroll-vert-thumb 168 100 12 20 scroll-vert-trough 168 120 12 20 arrow-down 40 50 10 5 arrow-right 20 192 5 10 arrow-up 120 60 10 5 empty 152 32 10 10 sizegrip 25 192 10 10 scroll-down 0 196 8 6 scroll-left 98 112 6 8 scroll-right 162 100 6 8 scroll-up 35 196 8 6 separator 200 110 1 1] {
            set images($k) [image create photo -width $w -height $h]
            $images($k) copy $s -from $x $y [expr {$x+$w}] [expr {$y+$h}]
        }
        unset s

        array set colors {
            -fg             "#202020"
            -bg             "#fafafa"
            -disabledfg     "#a0a0a0"
            -selectfg       "#ffffff"
            -selectbg       "#2f60d8"
        }

        ttk::style layout TButton {
            Button.button -children {
                Button.padding -children {
                    Button.label -side left -expand 1
                }
            }
        }

        ttk::style layout Toolbutton {
            Toolbutton.button -children {
                Toolbutton.padding -children {
                    Toolbutton.label -side left -expand 1
                }
            }
        }

        ttk::style layout TMenubutton {
            Menubutton.button -children {
                Menubutton.padding -children {
                    Menubutton.label -side left -expand 1
                    Menubutton.indicator -side right -sticky nsew
                }
            }
        }

        ttk::style layout TOptionMenu {
            OptionMenu.button -children {
                OptionMenu.padding -children {
                    OptionMenu.label -side left -expand 1
                    OptionMenu.indicator -side right -sticky nsew
                }
            }
        }

        ttk::style layout Accent.TButton {
            AccentButton.button -children {
                AccentButton.padding -children {
                    AccentButton.label -side left -expand 1
                }
            }
        }

        ttk::style layout Titlebar.TButton {
            TitlebarButton.button -children {
                TitlebarButton.padding -children {
                    TitlebarButton.label -side left -expand 1
                }
            }
        }

        ttk::style layout Close.Titlebar.TButton {
            CloseButton.button -children {
                CloseButton.padding -children {
                    CloseButton.label -side left -expand 1
                }
            }
        }

        ttk::style layout TCheckbutton {
            Checkbutton.button -children {
                Checkbutton.padding -children {
                    Checkbutton.indicator -side left
                    Checkbutton.label -side right -expand 1
                }
            }
        }

        ttk::style layout Switch.TCheckbutton {
            Switch.button -children {
                Switch.padding -children {
                    Switch.indicator -side left
                    Switch.label -side right -expand 1
                }
            }
        }

        ttk::style layout Toggle.TButton {
            ToggleButton.button -children {
                ToggleButton.padding -children {
                    ToggleButton.label -side left -expand 1
                }
            }
        }

        ttk::style layout TRadiobutton {
            Radiobutton.button -children {
                Radiobutton.padding -children {
                    Radiobutton.indicator -side left
                    Radiobutton.label -side right -expand 1
                }
            }
        }

        ttk::style layout Vertical.TScrollbar {
            Vertical.Scrollbar.trough -sticky ns -children {
                Vertical.Scrollbar.uparrow -side top
                Vertical.Scrollbar.downarrow -side bottom
                Vertical.Scrollbar.thumb -expand 1
            }
        }

        ttk::style layout Horizontal.TScrollbar {
            Horizontal.Scrollbar.trough -sticky ew -children {
                Horizontal.Scrollbar.leftarrow -side left
                Horizontal.Scrollbar.rightarrow -side right
                Horizontal.Scrollbar.thumb -expand 1
            }
        }

        ttk::style layout TSeparator {
            TSeparator.separator -sticky nsew
        }

        ttk::style layout TCombobox {
            Combobox.field -sticky nsew -children {
                Combobox.padding -expand 1 -sticky nsew -children {
                    Combobox.textarea -sticky nsew
                }
            }
            null -side right -sticky ns -children {
                Combobox.arrow -sticky nsew
            }
        }

        ttk::style layout TSpinbox {
            Spinbox.field -sticky nsew -children {
                Spinbox.padding -expand 1 -sticky nsew -children {
                    Spinbox.textarea -sticky nsew
                }

            }
            null -side right -sticky nsew -children {
                Spinbox.uparrow -side left -sticky nsew
                Spinbox.downarrow -side right -sticky nsew
            }
        }

        ttk::style layout Card.TFrame {
            Card.field {
                Card.padding -expand 1
            }
        }

        ttk::style layout TLabelframe {
            Labelframe.border {
                Labelframe.padding -expand 1 -children {
                    Labelframe.label -side left
                }
            }
        }

        ttk::style layout TNotebook {
            Notebook.border -children {
                TNotebook.Tab -expand 1
                Notebook.client -sticky nsew
            }
        }

        ttk::style layout Treeview.Item {
            Treeitem.padding -sticky nsew -children {
                Treeitem.image -side left -sticky {}
                Treeitem.indicator -side left -sticky {}
                Treeitem.text -side left -sticky {}
            }
        }

        # Button
        ttk::style configure TButton -padding {8 4} -anchor center -foreground $colors(-fg)

        ttk::style map TButton -foreground \
            [list disabled #a2a2a2 \
                pressed #636363 \
                active #1a1a1a]

        ttk::style element create Button.button image \
            [list $images(button-rest) \
                {selected disabled} $images(button-disabled) \
                disabled $images(button-disabled) \
                selected $images(button-rest) \
                pressed $images(button-pressed) \
                active $images(button-hover) \
            ] -border 4 -sticky nsew

        # Toolbutton
        ttk::style configure Toolbutton -padding {8 4} -anchor center

        ttk::style element create Toolbutton.button image \
            [list $images(empty) \
                {selected disabled} $images(button-disabled) \
                selected $images(button-rest) \
                pressed $images(button-pressed) \
                active $images(button-hover) \
            ] -border 4 -sticky nsew

        # Menubutton
        ttk::style configure TMenubutton -padding {8 4 0 4}

        ttk::style element create Menubutton.button \
            image [list $images(button-rest) \
                disabled $images(button-disabled) \
                pressed $images(button-pressed) \
                active $images(button-hover) \
            ] -border 4 -sticky nsew

        ttk::style element create Menubutton.indicator image $images(arrow-down) -width 28 -sticky {}

        # OptionMenu
        ttk::style configure TOptionMenu -padding {8 4 0 4}

        ttk::style element create OptionMenu.button \
            image [list $images(button-rest) \
                disabled $images(button-disabled) \
                pressed $images(button-pressed) \
                active $images(button-hover) \
            ] -border 4 -sticky nsew

        ttk::style element create OptionMenu.indicator image $images(arrow-down) -width 28 -sticky {}

        # Accent.TButton
        ttk::style configure Accent.TButton -padding {8 4} -anchor center -foreground #ffffff

        ttk::style map Accent.TButton -foreground \
            [list disabled #ffffff \
                pressed #c1d8ee]

        ttk::style element create AccentButton.button image \
            [list $images(button-accent-rest) \
                {selected disabled} $images(button-accent-disabled) \
                disabled $images(button-accent-disabled) \
                selected $images(button-accent-rest) \
                pressed $images(button-accent-pressed) \
                active $images(button-accent-hover) \
            ] -border 4 -sticky nsew

        # Titlebar.TButton
        ttk::style configure Titlebar.TButton -padding {8 4} -anchor center -foreground #1a1a1a

        ttk::style map Titlebar.TButton -foreground \
            [list disabled #a0a0a0 \
                pressed #606060 \
                active #191919]

        ttk::style element create TitlebarButton.button image \
            [list $images(empty) \
                disabled $images(empty) \
                pressed $images(button-titlebar-pressed) \
                active $images(button-titlebar-hover) \
            ] -border 4 -sticky nsew

        # Close.Titlebar.TButton
        ttk::style configure Close.Titlebar.TButton -padding {8 4} -anchor center -foreground #1a1a1a

        ttk::style map Close.Titlebar.TButton -foreground \
            [list disabled #a0a0a0 \
                pressed #efc6c2 \
                active #ffffff]

        ttk::style element create CloseButton.button image \
            [list $images(empty) \
                disabled $images(empty) \
                pressed $images(button-close-pressed) \
                active $images(button-close-hover) \
            ] -border 4 -sticky nsew

        # Checkbutton
        ttk::style configure TCheckbutton -padding 4

        ttk::style element create Checkbutton.indicator image \
            [list $images(check-unsel-rest) \
                {alternate disabled} $images(check-tri-disabled) \
                {selected disabled} $images(check-disabled) \
                disabled $images(check-unsel-disabled) \
                {pressed alternate} $images(check-tri-hover) \
                {active alternate} $images(check-tri-hover) \
                alternate $images(check-tri-rest) \
                {pressed selected} $images(check-hover) \
                {active selected} $images(check-hover) \
                selected $images(check-rest) \
                {pressed !selected} $images(check-unsel-pressed) \
                active $images(check-unsel-hover) \
            ] -width 26 -sticky w

        # Switch.TCheckbutton
        ttk::style element create Switch.indicator image \
            [list $images(switch-off-rest) \
                {selected disabled} $images(switch-on-disabled) \
                disabled $images(switch-off-disabled) \
                {pressed selected} $images(switch-on-pressed) \
                {active selected} $images(switch-on-hover) \
                selected $images(switch-on-rest) \
                {pressed !selected} $images(switch-off-pressed) \
                active $images(switch-off-hover) \
            ] -width 46 -sticky w

        # Toggle.TButton
        ttk::style configure Toggle.TButton -padding {8 4 8 4} -anchor center -foreground $colors(-fg)

        ttk::style map Toggle.TButton -foreground \
            [list {selected disabled} #ffffff \
                {selected pressed} #636363 \
                selected #ffffff \
                pressed #c1d8ee \
                disabled #a2a2a2 \
                active #1a1a1a
            ]

        ttk::style element create ToggleButton.button image \
            [list $images(button-rest) \
                {selected disabled} $images(button-accent-disabled) \
                disabled $images(button-disabled) \
                {pressed selected} $images(button-rest) \
                {active selected} $images(button-accent-hover) \
                selected $images(button-accent-rest) \
                {pressed !selected} $images(button-accent-rest) \
                active $images(button-hover) \
            ] -border 4 -sticky nsew

        # Radiobutton
        ttk::style configure TRadiobutton -padding 4

        ttk::style element create Radiobutton.indicator image \
            [list $images(radio-unsel-rest) \
                {selected disabled} $images(radio-disabled) \
                disabled $images(radio-unsel-disabled) \
                {pressed selected} $images(radio-pressed) \
                {active selected} $images(radio-hover) \
                selected $images(radio-rest) \
                {pressed !selected} $images(radio-unsel-pressed) \
                active $images(radio-unsel-hover) \
            ] -width 26 -sticky w

        # Scrollbar
        ttk::style element create Horizontal.Scrollbar.trough image $images(scroll-hor-trough) -sticky ew -border 6
        ttk::style element create Horizontal.Scrollbar.thumb image $images(scroll-hor-thumb) -sticky ew -border 3

        ttk::style element create Horizontal.Scrollbar.rightarrow image $images(scroll-right) -sticky {} -width 12
        ttk::style element create Horizontal.Scrollbar.leftarrow image $images(scroll-left) -sticky {} -width 12

        ttk::style element create Vertical.Scrollbar.trough image $images(scroll-vert-trough) -sticky ns -border 6
        ttk::style element create Vertical.Scrollbar.thumb image $images(scroll-vert-thumb) -sticky ns -border 3

        ttk::style element create Vertical.Scrollbar.uparrow image $images(scroll-up) -sticky {} -height 12
        ttk::style element create Vertical.Scrollbar.downarrow image $images(scroll-down) -sticky {} -height 12

        # Scale
        ttk::style element create Horizontal.Scale.trough image $images(scale-trough-hor) \
            -border 5 -padding 0

        ttk::style element create Vertical.Scale.trough image $images(scale-trough-vert) \
            -border 5 -padding 0

        ttk::style element create Scale.slider \
            image [list $images(scale-thumb-rest) \
                disabled $images(scale-thumb-disabled) \
                pressed $images(scale-thumb-pressed) \
                active $images(scale-thumb-hover) \
            ] -sticky {}

        # Progressbar
        ttk::style element create Horizontal.Progressbar.trough image $images(progress-trough-hor) \
            -border 1 -sticky ew

        ttk::style element create Horizontal.Progressbar.pbar image $images(progress-pbar-hor) \
            -border 2 -sticky ew

        ttk::style element create Vertical.Progressbar.trough image $images(progress-trough-vert) \
            -border 1 -sticky ns

        ttk::style element create Vertical.Progressbar.pbar image $images(progress-pbar-vert) \
            -border 2 -sticky ns

        # Entry
        ttk::style configure TEntry -foreground $colors(-fg)

        ttk::style map TEntry -foreground \
            [list disabled #0a0a0a \
                pressed #636363 \
                active #626262
            ]

        ttk::style element create Entry.field \
            image [list $images(entry-rest) \
                {focus hover !invalid} $images(entry-focus) \
                invalid $images(entry-invalid) \
                disabled $images(entry-disabled) \
                {focus !invalid} $images(entry-focus) \
                hover $images(entry-hover) \
            ] -border 5 -padding 8 -sticky nsew

        # Combobox
        ttk::style configure TCombobox -foreground $colors(-fg)

        ttk::style configure ComboboxPopdownFrame -borderwidth 1 -relief solid

        ttk::style map TCombobox -foreground \
            [list disabled #0a0a0a \
                pressed #636363 \
                active #626262
            ]

        ttk::style map TCombobox -selectbackground [list \
            {readonly hover} $colors(-selectbg) \
            {readonly focus} $colors(-selectbg) \
        ] -selectforeground [list \
            {readonly hover} $colors(-selectfg) \
            {readonly focus} $colors(-selectfg) \
        ]

        ttk::style element create Combobox.field \
            image [list $images(entry-rest) \
                {readonly disabled} $images(button-disabled) \
                {readonly pressed} $images(button-pressed) \
                {readonly hover} $images(button-hover) \
                readonly $images(button-rest) \
                invalid $images(entry-invalid) \
                disabled $images(entry-disabled) \
                focus $images(entry-focus) \
                hover $images(entry-hover) \
            ] -border 5 -padding {8 8 28 8}

        ttk::style element create Combobox.arrow image $images(arrow-down) -width 35 -sticky {}

        # Spinbox
        ttk::style configure TSpinbox -foreground $colors(-fg)

        ttk::style map TSpinbox -foreground \
            [list disabled #0a0a0a \
                pressed #636363 \
                active #626262
            ]

        ttk::style element create Spinbox.field \
            image [list $images(entry-rest) \
                invalid $images(entry-invalid) \
                disabled $images(entry-disabled) \
                focus $images(entry-focus) \
                hover $images(entry-hover) \
            ] -border 5 -padding {8 8 54 8} -sticky nsew

        ttk::style element create Spinbox.uparrow image $images(arrow-up) -width 35 -sticky {}
        ttk::style element create Spinbox.downarrow image $images(arrow-down) -width 35 -sticky {}

        # Sizegrip
        ttk::style element create Sizegrip.sizegrip image $images(sizegrip) \
            -sticky nsew

        # Separator
        ttk::style element create TSeparator.separator image $images(separator)

        # Card
        ttk::style element create Card.field image $images(card) \
            -border 10 -padding 4 -sticky nsew

        # Labelframe
        ttk::style element create Labelframe.border image $images(card) \
            -border 5 -padding 4 -sticky nsew

        # Notebook
        ttk::style configure TNotebook -padding 1

        ttk::style element create Notebook.border \
            image $images(notebook-border) -border 5 -padding 5

        ttk::style element create Notebook.client image $images(notebook)

        ttk::style element create Notebook.tab \
            image [list $images(tab-rest) \
                selected $images(tab-selected) \
                active $images(tab-hover) \
            ] -border 13 -padding {16 14 16 6} -height 32

        # Treeview
        ttk::style element create Treeview.field image $images(card) \
            -border 5

        ttk::style element create Treeheading.cell \
            image [list $images(treeheading-rest) \
                pressed $images(treeheading-pressed) \
                active $images(treeheading-hover)
            ] -border 5 -padding 15 -sticky nsew

        ttk::style element create Treeitem.indicator \
            image [list $images(arrow-right) \
                user2 $images(empty) \
                user1 $images(arrow-down) \
            ] -width 26 -sticky {}

        ttk::style configure Treeview -foregound #1a1a1a -background $colors(-bg) -rowheight [expr {[font metrics font -linespace] + 2}]
        ttk::style map Treeview \
            -background [list selected #f0f0f0] \
            -foreground [list selected #191919]

        # Panedwindow
        # Insane hack to remove clam's ugly sash
        ttk::style configure Sash -gripcount 0
    }
}

namespace eval ttk::theme::sun-valley-dark {
    variable version 1.0
    package provide ttk::theme::sun-valley-dark $version

    ttk::style theme create sun-valley-dark -parent clam -settings {
        variable images
        variable s [image create photo -file [file join [file dirname [info script]] dark.png] -format png]
        foreach {k x y w h} [list card 0 0 50 50 notebook-border 50 0 50 50 notebook 0 50 40 40 switch-off-disabled 40 50 40 20 switch-off-hover 40 70 40 20 switch-off-pressed 100 0 40 20 switch-off-rest 100 20 40 20 switch-on-disabled 100 40 40 20 switch-on-hover 80 60 40 20 switch-on-pressed 80 80 40 20 switch-on-rest 0 100 40 20 tab-hover 40 100 32 32 tab-rest 72 100 32 32 tab-selected 104 100 32 32 scale-thumb-disabled 140 0 22 22 scale-thumb-hover 140 22 22 22 scale-thumb-pressed 140 44 22 22 scale-thumb-rest 136 66 22 22 scale-trough-hor 136 88 22 22 scale-trough-vert 136 110 22 22 treeheading-hover 0 132 22 22 treeheading-pressed 22 132 22 22 treeheading-rest 44 132 22 22 button-accent-disabled 66 132 20 20 button-accent-hover 86 132 20 20 button-accent-pressed 106 132 20 20 button-accent-rest 126 132 20 20 button-close-hover 162 0 20 20 button-close-pressed 162 20 20 20 button-disabled 162 40 20 20 button-hover 162 60 20 20 button-pressed 158 80 20 20 button-rest 158 100 20 20 button-titlebar-hover 158 120 20 20 button-titlebar-pressed 0 154 20 20 check-disabled 20 154 20 20 check-hover 40 154 20 20 check-pressed 60 154 20 20 check-rest 80 152 20 20 check-tri-disabled 100 152 20 20 check-tri-hover 120 152 20 20 check-tri-pressed 140 152 20 20 check-tri-rest 160 140 20 20 check-unsel-disabled 160 160 20 20 check-unsel-hover 182 0 20 20 check-unsel-pressed 182 20 20 20 check-unsel-rest 182 40 20 20 entry-disabled 182 60 20 20 entry-focus 180 80 20 20 entry-hover 0 180 20 20 entry-invalid 180 100 20 20 entry-rest 178 120 20 20 progress-pbar-hor 80 50 20 5 progress-pbar-vert 146 132 5 20 progress-trough-hor 120 60 20 5 progress-trough-vert 151 132 5 20 radio-disabled 20 180 20 20 radio-hover 180 140 20 20 radio-pressed 40 180 20 20 radio-rest 180 160 20 20 radio-unsel-disabled 60 180 20 20 radio-unsel-hover 80 180 20 20 radio-unsel-pressed 100 180 20 20 radio-unsel-rest 120 180 20 20 scroll-hor-thumb 0 120 20 12 scroll-hor-trough 140 172 20 12 scroll-vert-thumb 160 180 10 20 scroll-vert-trough 170 180 12 20 arrow-down 80 55 10 5 arrow-right 0 90 5 10 arrow-up 90 55 10 5 empty 5 90 10 10 sizegrip 15 90 10 10 scroll-down 0 174 8 6 scroll-left 80 172 6 8 scroll-right 86 172 6 8 scroll-up 8 174 8 6 separator 120 65 1 1] {
            set images($k) [image create photo -width $w -height $h]
            $images($k) copy $s -from $x $y [expr {$x+$w}] [expr {$y+$h}]
        }
        unset s

        array set colors {
            -fg             "#ffffff"
            -bg             "#1c1c1c"
            -disabledfg     "#595959"
            -selectfg       "#ffffff"
            -selectbg       "#2f60d8"
        }

        ttk::style layout TButton {
            Button.button -children {
                Button.padding -children {
                    Button.label -side left -expand 1
                }
            }
        }

        ttk::style layout Toolbutton {
            Toolbutton.button -children {
                Toolbutton.padding -children {
                    Toolbutton.label -side left -expand 1
                }
            }
        }

        ttk::style layout TMenubutton {
            Menubutton.button -children {
                Menubutton.padding -children {
                    Menubutton.label -side left -expand 1
                    Menubutton.indicator -side right -sticky nsew
                }
            }
        }

        ttk::style layout TOptionMenu {
            OptionMenu.button -children {
                OptionMenu.padding -children {
                    OptionMenu.label -side left -expand 1
                    OptionMenu.indicator -side right -sticky nsew
                }
            }
        }

        ttk::style layout Accent.TButton {
            AccentButton.button -children {
                AccentButton.padding -children {
                    AccentButton.label -side left -expand 1
                }
            }
        }

        ttk::style layout Titlebar.TButton {
            TitlebarButton.button -children {
                TitlebarButton.padding -children {
                    TitlebarButton.label -side left -expand 1
                }
            }
        }

        ttk::style layout Close.Titlebar.TButton {
            CloseButton.button -children {
                CloseButton.padding -children {
                    CloseButton.label -side left -expand 1
                }
            }
        }

        ttk::style layout TCheckbutton {
            Checkbutton.button -children {
                Checkbutton.padding -children {
                    Checkbutton.indicator -side left
                    Checkbutton.label -side right -expand 1
                }
            }
        }

        ttk::style layout Switch.TCheckbutton {
            Switch.button -children {
                Switch.padding -children {
                    Switch.indicator -side left
                    Switch.label -side right -expand 1
                }
            }
        }

        ttk::style layout Toggle.TButton {
            ToggleButton.button -children {
                ToggleButton.padding -children {
                    ToggleButton.label -side left -expand 1
                }
            }
        }

        ttk::style layout TRadiobutton {
            Radiobutton.button -children {
                Radiobutton.padding -children {
                    Radiobutton.indicator -side left
                    Radiobutton.label -side right -expand 1
                }
            }
        }

        ttk::style layout Vertical.TScrollbar {
            Vertical.Scrollbar.trough -sticky ns -children {
                Vertical.Scrollbar.uparrow -side top
                Vertical.Scrollbar.downarrow -side bottom
                Vertical.Scrollbar.thumb -expand 1
            }
        }

        ttk::style layout Horizontal.TScrollbar {
            Horizontal.Scrollbar.trough -sticky ew -children {
                Horizontal.Scrollbar.leftarrow -side left
                Horizontal.Scrollbar.rightarrow -side right
                Horizontal.Scrollbar.thumb -expand 1
            }
        }

        ttk::style layout TSeparator {
            TSeparator.separator -sticky nsew
        }

        ttk::style layout TCombobox {
            Combobox.field -sticky nsew -children {
                Combobox.padding -expand 1 -sticky nsew -children {
                    Combobox.textarea -sticky nsew
                }
            }
            null -side right -sticky ns -children {
                Combobox.arrow -sticky nsew
            }
        }

        ttk::style layout TSpinbox {
            Spinbox.field -sticky nsew -children {
                Spinbox.padding -expand 1 -sticky nsew -children {
                    Spinbox.textarea -sticky nsew
                }

            }
            null -side right -sticky nsew -children {
                Spinbox.uparrow -side left -sticky nsew
                Spinbox.downarrow -side right -sticky nsew
            }
        }

        ttk::style layout Card.TFrame {
            Card.field {
                Card.padding -expand 1
            }
        }

        ttk::style layout TLabelframe {
            Labelframe.border {
                Labelframe.padding -expand 1 -children {
                    Labelframe.label -side left
                }
            }
        }

        ttk::style layout TNotebook {
            Notebook.border -children {
                TNotebook.Tab -expand 1
                Notebook.client -sticky nsew
            }
        }

        ttk::style layout Treeview.Item {
            Treeitem.padding -sticky nsew -children {
                Treeitem.image -side left -sticky {}
                Treeitem.indicator -side left -sticky {}
                Treeitem.text -side left -sticky {}
            }
        }

        # Button
        ttk::style configure TButton -padding {8 4} -anchor center -foreground $colors(-fg)

        ttk::style map TButton -foreground \
            [list disabled #7a7a7a \
                pressed #d0d0d0]

        ttk::style element create Button.button image \
            [list $images(button-rest) \
                {selected disabled} $images(button-disabled) \
                disabled $images(button-disabled) \
                selected $images(button-rest) \
                pressed $images(button-pressed) \
                active $images(button-hover) \
            ] -border 4 -sticky nsew

        # Toolbutton
        ttk::style configure Toolbutton -padding {8 4} -anchor center

        ttk::style element create Toolbutton.button image \
            [list $images(empty) \
                {selected disabled} $images(button-disabled) \
                selected $images(button-rest) \
                pressed $images(button-pressed) \
                active $images(button-hover) \
            ] -border 4 -sticky nsew

        # Menubutton
        ttk::style configure TMenubutton -padding {8 4 0 4}

        ttk::style element create Menubutton.button \
            image [list $images(button-rest) \
                disabled $images(button-disabled) \
                pressed $images(button-pressed) \
                active $images(button-hover) \
            ] -border 4 -sticky nsew

        ttk::style element create Menubutton.indicator image $images(arrow-down) -width 28 -sticky {}

        # OptionMenu
        ttk::style configure TOptionMenu -padding {8 4 0 4}

        ttk::style element create OptionMenu.button \
            image [list $images(button-rest) \
                disabled $images(button-disabled) \
                pressed $images(button-pressed) \
                active $images(button-hover) \
            ] -border 4 -sticky nsew

        ttk::style element create OptionMenu.indicator image $images(arrow-down) -width 28 -sticky {}

        # Accent.TButton
        ttk::style configure Accent.TButton -padding {8 4} -anchor center -foreground #000000

        ttk::style map Accent.TButton -foreground \
            [list pressed #25536a \
                disabled #a5a5a5]

        ttk::style element create AccentButton.button image \
            [list $images(button-accent-rest) \
                {selected disabled} $images(button-accent-disabled) \
                disabled $images(button-accent-disabled) \
                selected $images(button-accent-rest) \
                pressed $images(button-accent-pressed) \
                active $images(button-accent-hover) \
            ] -border 4 -sticky nsew

        # Titlebar.TButton
        ttk::style configure Titlebar.TButton -padding {8 4} -anchor center -foreground #ffffff

        ttk::style map Titlebar.TButton -foreground \
            [list disabled #6f6f6f \
                pressed #d1d1d1 \
                active #ffffff]

        ttk::style element create TitlebarButton.button image \
            [list $images(empty) \
                disabled $images(empty) \
                pressed $images(button-titlebar-pressed) \
                active $images(button-titlebar-hover) \
            ] -border 4 -sticky nsew

        # Close.Titlebar.TButton
        ttk::style configure Close.Titlebar.TButton -padding {8 4} -anchor center -foreground #ffffff

        ttk::style map Close.Titlebar.TButton -foreground \
            [list disabled #6f6f6f \
                pressed #e8bfbb \
                active #ffffff]

        ttk::style element create CloseButton.button image \
            [list $images(empty) \
                disabled $images(empty) \
                pressed $images(button-close-pressed) \
                active $images(button-close-hover) \
            ] -border 4 -sticky nsew

        # Checkbutton
        ttk::style configure TCheckbutton -padding 4

        ttk::style element create Checkbutton.indicator image \
            [list $images(check-unsel-rest) \
                {alternate disabled} $images(check-tri-disabled) \
                {selected disabled} $images(check-disabled) \
                disabled $images(check-unsel-disabled) \
                {pressed alternate} $images(check-tri-hover) \
                {active alternate} $images(check-tri-hover) \
                alternate $images(check-tri-rest) \
                {pressed selected} $images(check-hover) \
                {active selected} $images(check-hover) \
                selected $images(check-rest) \
                {pressed !selected} $images(check-unsel-pressed) \
                active $images(check-unsel-hover) \
            ] -width 26 -sticky w

        # Switch.TCheckbutton
        ttk::style element create Switch.indicator image \
            [list $images(switch-off-rest) \
                {selected disabled} $images(switch-on-disabled) \
                disabled $images(switch-off-disabled) \
                {pressed selected} $images(switch-on-pressed) \
                {active selected} $images(switch-on-hover) \
                selected $images(switch-on-rest) \
                {pressed !selected} $images(switch-off-pressed) \
                active $images(switch-off-hover) \
            ] -width 46 -sticky w

        # Toggle.TButton
        ttk::style configure Toggle.TButton -padding {8 4 8 4} -anchor center -foreground $colors(-fg)

        ttk::style map Toggle.TButton -foreground \
            [list {selected disabled} #a5a5a5 \
                {selected pressed} #d0d0d0 \
                selected #000000 \
                pressed #25536a \
                disabled #7a7a7a
            ]

        ttk::style element create ToggleButton.button image \
            [list $images(button-rest) \
                {selected disabled} $images(button-accent-disabled) \
                disabled $images(button-disabled) \
                {pressed selected} $images(button-rest) \
                {active selected} $images(button-accent-hover) \
                selected $images(button-accent-rest) \
                {pressed !selected} $images(button-accent-rest) \
                active $images(button-hover) \
            ] -border 4 -sticky nsew

        # Radiobutton
        ttk::style configure TRadiobutton -padding 4

        ttk::style element create Radiobutton.indicator image \
            [list $images(radio-unsel-rest) \
                {selected disabled} $images(radio-disabled) \
                disabled $images(radio-unsel-disabled) \
                {pressed selected} $images(radio-pressed) \
                {active selected} $images(radio-hover) \
                selected $images(radio-rest) \
                {pressed !selected} $images(radio-unsel-pressed) \
                active $images(radio-unsel-hover) \
            ] -width 26 -sticky w

        # Scrollbar
        ttk::style element create Horizontal.Scrollbar.trough image $images(scroll-hor-trough) -sticky ew -border 6
        ttk::style element create Horizontal.Scrollbar.thumb image $images(scroll-hor-thumb) -sticky ew -border 3

        ttk::style element create Horizontal.Scrollbar.rightarrow image $images(scroll-right) -sticky {} -width 12
        ttk::style element create Horizontal.Scrollbar.leftarrow image $images(scroll-left) -sticky {} -width 12

        ttk::style element create Vertical.Scrollbar.trough image $images(scroll-vert-trough) -sticky ns -border 6
        ttk::style element create Vertical.Scrollbar.thumb image $images(scroll-vert-thumb) -sticky ns -border 3

        ttk::style element create Vertical.Scrollbar.uparrow image $images(scroll-up) -sticky {} -height 12
        ttk::style element create Vertical.Scrollbar.downarrow image $images(scroll-down) -sticky {} -height 12

        # Scale
        ttk::style element create Horizontal.Scale.trough image $images(scale-trough-hor) \
            -border 5 -padding 0

        ttk::style element create Vertical.Scale.trough image $images(scale-trough-vert) \
            -border 5 -padding 0

        ttk::style element create Scale.slider \
            image [list $images(scale-thumb-rest) \
                disabled $images(scale-thumb-disabled) \
                pressed $images(scale-thumb-pressed) \
                active $images(scale-thumb-hover) \
            ] -sticky {}

        # Progressbar
        ttk::style element create Horizontal.Progressbar.trough image $images(progress-trough-hor) \
            -border 1 -sticky ew

        ttk::style element create Horizontal.Progressbar.pbar image $images(progress-pbar-hor) \
            -border 2 -sticky ew

        ttk::style element create Vertical.Progressbar.trough image $images(progress-trough-vert) \
            -border 1 -sticky ns

        ttk::style element create Vertical.Progressbar.pbar image $images(progress-pbar-vert) \
            -border 2 -sticky ns

        # Entry
        ttk::style configure TEntry -foreground $colors(-fg)

        ttk::style map TEntry -foreground \
            [list disabled #757575 \
                pressed #cfcfcf
            ]

        ttk::style element create Entry.field \
            image [list $images(entry-rest) \
                {focus hover !invalid} $images(entry-focus) \
                invalid $images(entry-invalid) \
                disabled $images(entry-disabled) \
                {focus !invalid} $images(entry-focus) \
                hover $images(entry-hover) \
            ] -border 5 -padding 8 -sticky nsew

        # Combobox
        ttk::style configure TCombobox -foreground $colors(-fg)

        ttk::style map TCombobox -foreground \
            [list disabled #757575 \
                pressed #cfcfcf
            ]

        ttk::style configure ComboboxPopdownFrame -borderwidth 1 -relief solid

        ttk::style map TCombobox -selectbackground [list \
            {readonly hover} $colors(-selectbg) \
            {readonly focus} $colors(-selectbg) \
        ] -selectforeground [list \
            {readonly hover} $colors(-selectfg) \
            {readonly focus} $colors(-selectfg) \
        ]

        ttk::style element create Combobox.field \
            image [list $images(entry-rest) \
                {readonly disabled} $images(button-disabled) \
                {readonly pressed} $images(button-pressed) \
                {readonly hover} $images(button-hover) \
                readonly $images(button-rest) \
                invalid $images(entry-invalid) \
                disabled $images(entry-disabled) \
                focus $images(entry-focus) \
                hover $images(entry-hover) \
            ] -border 5 -padding {8 8 28 8}

        ttk::style element create Combobox.arrow image $images(arrow-down) -width 35 -sticky {}

        # Spinbox
        ttk::style configure TSpinbox -foreground $colors(-fg)

        ttk::style map TSpinbox -foreground \
            [list disabled #757575 \
                pressed #cfcfcf
            ]

        ttk::style element create Spinbox.field \
            image [list $images(entry-rest) \
                invalid $images(entry-invalid) \
                disabled $images(entry-disabled) \
                focus $images(entry-focus) \
                hover $images(entry-hover) \
            ] -border 5 -padding {8 8 54 8} -sticky nsew

        ttk::style element create Spinbox.uparrow image $images(arrow-up) -width 35 -sticky {}
        ttk::style element create Spinbox.downarrow image $images(arrow-down) -width 35 -sticky {}

        # Sizegrip
        ttk::style element create Sizegrip.sizegrip image $images(sizegrip) \
            -sticky nsew

        # Separator
        ttk::style element create TSeparator.separator image $images(separator)

        # Card
        ttk::style element create Card.field image $images(card) \
            -border 10 -padding 4 -sticky nsew

        # Labelframe
        ttk::style element create Labelframe.border image $images(card) \
            -border 5 -padding 4 -sticky nsew

        # Notebook
        ttk::style configure TNotebook -padding 1

        ttk::style element create Notebook.border \
            image $images(notebook-border) -border 5 -padding 5

        ttk::style element create Notebook.client image $images(notebook)

        ttk::style element create Notebook.tab \
            image [list $images(tab-rest) \
                selected $images(tab-selected) \
                active $images(tab-hover) \
            ] -border 13 -padding {16 14 16 6} -height 32

        # Treeview
        ttk::style element create Treeview.field image $images(card) \
            -border 5

        ttk::style element create Treeheading.cell \
            image [list $images(treeheading-rest) \
                pressed $images(treeheading-pressed) \
                active $images(treeheading-hover)
            ] -border 5 -padding 15 -sticky nsew

        ttk::style element create Treeitem.indicator \
            image [list $images(arrow-right) \
                user2 $images(empty) \
                user1 $images(arrow-down) \
            ] -width 26 -sticky {}

        ttk::style configure Treeview -background $colors(-bg) -rowheight [expr {[font metrics font -linespace] + 2}]
        ttk::style map Treeview \
            -background [list selected #292929] \
            -foreground [list selected $colors(-selectfg)]

        # Panedwindow
        # Insane hack to remove clam's ugly sash
        ttk::style configure Sash -gripcount 0
    }
}

option add *tearOff 0

proc set_theme {mode} {
	if {$mode == "dark"} {
		ttk::style theme use "sun-valley-dark"

		array set colors {
		    -fg             "#ffffff"
		    -bg             "#1c1c1c"
		    -disabledfg     "#595959"
		    -selectfg       "#ffffff"
		    -selectbg       "#2f60d8"
		}

        ttk::style configure . \
            -background $colors(-bg) \
            -foreground $colors(-fg) \
            -troughcolor $colors(-bg) \
            -focuscolor $colors(-selectbg) \
            -selectbackground $colors(-selectbg) \
            -selectforeground $colors(-selectfg) \
            -insertwidth 1 \
            -insertcolor $colors(-fg) \
            -fieldbackground $colors(-selectbg) \
            -font {"Microsoft YaHei UI" 10} \
            -borderwidth 0 \
            -relief flat

        tk_setPalette \
        	background [ttk::style lookup . -background] \
            foreground [ttk::style lookup . -foreground] \
            highlightColor [ttk::style lookup . -focuscolor] \
            selectBackground [ttk::style lookup . -selectbackground] \
            selectForeground [ttk::style lookup . -selectforeground] \
            activeBackground [ttk::style lookup . -selectbackground] \
            activeForeground [ttk::style lookup . -selectforeground]

        ttk::style map . -foreground [list disabled $colors(-disabledfg)]

        option add *font [ttk::style lookup . -font]
        option add *Menu.selectcolor $colors(-fg)
        option add *Menu.background #2f2f2f

	} elseif {$mode == "light"} {
		ttk::style theme use "sun-valley-light"

		array set colors {
		    -fg             "#202020"
		    -bg             "#fafafa"
		    -disabledfg     "#a0a0a0"
		    -selectfg       "#ffffff"
		    -selectbg       "#2f60d8"
		}

        ttk::style configure . \
            -background $colors(-bg) \
            -foreground $colors(-fg) \
            -troughcolor $colors(-bg) \
            -focuscolor $colors(-selectbg) \
            -selectbackground $colors(-selectbg) \
            -selectforeground $colors(-selectfg) \
            -insertwidth 1 \
            -insertcolor $colors(-fg) \
            -fieldbackground $colors(-selectbg) \
            -font {"Microsoft YaHei UI" 10} \
            -borderwidth 0 \
            -relief flat

        tk_setPalette background [ttk::style lookup . -background] \
            foreground [ttk::style lookup . -foreground] \
            highlightColor [ttk::style lookup . -focuscolor] \
            selectBackground [ttk::style lookup . -selectbackground] \
            selectForeground [ttk::style lookup . -selectforeground] \
            activeBackground [ttk::style lookup . -selectbackground] \
            activeForeground [ttk::style lookup . -selectforeground]

        ttk::style map . -foreground [list disabled $colors(-disabledfg)]

        option add *font [ttk::style lookup . -font]
        option add *Menu.selectcolor $colors(-fg)
        option add *Menu.background #e7e7e7
	}
}

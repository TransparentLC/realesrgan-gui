# Copyright © 2021 rdbende <rdbende@gmail.com>
# A stunning light/dark theme for ttk based on Microsoft's Sun Valley visual style
package require Tk 8.6
namespace eval ttk::theme::sun-valley-light {
variable v 1.0
package provide ttk::theme::sun-valley-light $v
ttk::style theme create sun-valley-light -parent clam -settings {
variable i
variable s [image create photo -file [file join [file dirname [info script]] light.png] -format png]
foreach {k x y w h} [list au 0 0 50 50 aa 50 0 40 40 av 0 50 40 40 w 50 40 40 20 T 40 60 40 20 C 90 0 40 20 ab 90 20 40 20 D 90 40 40 20 ac 80 60 40 20 J 0 90 40 20 ad 0 110 40 20 aq 40 80 32 32 aw 72 80 32 32 ai 130 0 32 32 q 0 130 22 22 K 130 32 22 22 x 22 130 22 22 U 130 54 22 22 V 120 76 22 22 L 44 112 22 22 M 44 134 22 22 y 66 112 22 22 W 66 134 22 22 d 142 76 20 20 h 142 96 20 20 o 104 98 20 20 c 124 116 20 20 E 88 136 20 20 r 108 136 20 20 a 128 136 20 20 e 144 116 20 20 f 162 0 20 20 b 162 20 20 20 p 162 40 20 20 l 162 60 20 20 ae 162 80 20 20 S 0 156 20 20 az 20 152 20 20 ao 40 156 20 20 F 60 156 20 20 m 80 156 20 20 at 100 156 20 20 af 120 156 20 20 s 140 156 20 20 N 148 136 20 20 z 160 156 20 20 X 20 172 20 20 i 182 0 20 20 j 0 176 20 20 n 182 20 20 20 k 182 40 20 20 t 182 60 20 20 O 182 80 20 5 G 88 112 5 20 A 182 85 20 5 u 93 112 5 20 ag 182 90 20 20 ak 180 110 20 20 ah 180 130 20 20 ap 180 150 20 20 v 180 170 20 20 P 40 176 20 20 B 60 176 20 20 Y 80 176 20 20 Z 100 190 20 12 Q 120 190 20 12 R 168 100 12 20 H 168 120 12 20 g 40 50 10 5 al 20 192 5 10 ax 120 60 10 5 I 152 32 10 10 ay 25 192 10 10 am 0 196 8 6 an 98 112 6 8 aj 162 100 6 8 ar 35 196 8 6 as 200 110 1 1] {
set i($k) [image create photo -width $w -height $h]
$i($k) copy $s -from $x $y [expr {$x+$w}] [expr {$y+$h}]
}
unset s
array set c {a #202020 b #fafafa c #a0a0a0 d #ffffff e #2f60d8}
ttk::style layout TButton {Button.button -children {Button.padding -children {Button.label -side left -expand 1}}}
ttk::style layout Toolbutton {Toolbutton.button -children {Toolbutton.padding -children {Toolbutton.label -side left -expand 1}}}
ttk::style layout TMenubutton {Menubutton.button -children {Menubutton.padding -children {Menubutton.label -side left -expand 1 Menubutton.indicator -side right -sticky nsew}}}
ttk::style layout TOptionMenu {OptionMenu.button -children {OptionMenu.padding -children {OptionMenu.label -side left -expand 1 OptionMenu.indicator -side right -sticky nsew}}}
ttk::style layout Accent.TButton {AccentButton.button -children {AccentButton.padding -children {AccentButton.label -side left -expand 1}}}
ttk::style layout Titlebar.TButton {TitlebarButton.button -children {TitlebarButton.padding -children {TitlebarButton.label -side left -expand 1}}}
ttk::style layout Close.Titlebar.TButton {CloseButton.button -children {CloseButton.padding -children {CloseButton.label -side left -expand 1}}}
ttk::style layout TCheckbutton {Checkbutton.button -children {Checkbutton.padding -children {Checkbutton.indicator -side left Checkbutton.label -side right -expand 1}}}
ttk::style layout Switch.TCheckbutton {Switch.button -children {Switch.padding -children {Switch.indicator -side left Switch.label -side right -expand 1}}}
ttk::style layout Toggle.TButton {ToggleButton.button -children {ToggleButton.padding -children {ToggleButton.label -side left -expand 1}}}
ttk::style layout TRadiobutton {Radiobutton.button -children {Radiobutton.padding -children {Radiobutton.indicator -side left Radiobutton.label -side right -expand 1}}}
ttk::style layout Vertical.TScrollbar {Vertical.Scrollbar.trough -sticky ns -children {Vertical.Scrollbar.uparrow -side top Vertical.Scrollbar.downarrow -side bottom Vertical.Scrollbar.thumb -expand 1}}
ttk::style layout Horizontal.TScrollbar {Horizontal.Scrollbar.trough -sticky ew -children {Horizontal.Scrollbar.leftarrow -side left Horizontal.Scrollbar.rightarrow -side right Horizontal.Scrollbar.thumb -expand 1}}
ttk::style layout TSeparator {TSeparator.separator -sticky nsew}
ttk::style layout TCombobox {Combobox.field -sticky nsew -children {Combobox.padding -expand 1 -sticky nsew -children {Combobox.textarea -sticky nsew}} null -side right -sticky ns -children {Combobox.arrow -sticky nsew}}
ttk::style layout TSpinbox {Spinbox.field -sticky nsew -children {Spinbox.padding -expand 1 -sticky nsew -children {Spinbox.textarea -sticky nsew}} null -side right -sticky nsew -children {Spinbox.uparrow -side left -sticky nsew Spinbox.downarrow -side right -sticky nsew}}
ttk::style layout Card.TFrame {Card.field {Card.padding -expand 1}}
ttk::style layout TLabelframe {Labelframe.border {Labelframe.padding -expand 1 -children {Labelframe.label -side left}}}
ttk::style layout TNotebook {Notebook.border -children {TNotebook.Tab -expand 1 Notebook.client -sticky nsew}}
ttk::style layout Treeview.Item {Treeitem.padding -sticky nsew -children {Treeitem.image -side left -sticky {} Treeitem.indicator -side left -sticky {} Treeitem.text -side left -sticky {}}}
ttk::style configure TButton -padding {8 4} -anchor center -foreground $c(a)
ttk::style map TButton -foreground [list disabled #a2a2a2 pressed #636363 active #1a1a1a]
ttk::style element create Button.button image [list $i(b) {selected disabled} $i(a) disabled $i(a) selected $i(b) pressed $i(f) active $i(e)] -border 4 -sticky nsew
ttk::style configure Toolbutton -padding {8 4} -anchor center
ttk::style element create Toolbutton.button image [list $i(I) {selected disabled} $i(a) selected $i(b) pressed $i(f) active $i(e)] -border 4 -sticky nsew
ttk::style configure TMenubutton -padding {8 4 0 4}
ttk::style element create Menubutton.button image [list $i(b) disabled $i(a) pressed $i(f) active $i(e)] -border 4 -sticky nsew
ttk::style element create Menubutton.indicator image $i(g) -width 28 -sticky {}
ttk::style configure TOptionMenu -padding {8 4 0 4}
ttk::style element create OptionMenu.button image [list $i(b) disabled $i(a) pressed $i(f) active $i(e)] -border 4 -sticky nsew
ttk::style element create OptionMenu.indicator image $i(g) -width 28 -sticky {}
ttk::style configure Accent.TButton -padding {8 4} -anchor center -foreground #ffffff
ttk::style map Accent.TButton -foreground [list disabled #ffffff pressed #c1d8ee]
ttk::style element create AccentButton.button image [list $i(c) {selected disabled} $i(d) disabled $i(d) selected $i(c) pressed $i(o) active $i(h)] -border 4 -sticky nsew
ttk::style configure Titlebar.TButton -padding {8 4} -anchor center -foreground #1a1a1a
ttk::style map Titlebar.TButton -foreground [list disabled #a0a0a0 pressed #606060 active #191919]
ttk::style element create TitlebarButton.button image [list $i(I) disabled $i(I) pressed $i(l) active $i(p)] -border 4 -sticky nsew
ttk::style configure Close.Titlebar.TButton -padding {8 4} -anchor center -foreground #1a1a1a
ttk::style map Close.Titlebar.TButton -foreground [list disabled #a0a0a0 pressed #efc6c2 active #ffffff]
ttk::style element create CloseButton.button image [list $i(I) disabled $i(I) pressed $i(r) active $i(E)] -border 4 -sticky nsew
ttk::style configure TCheckbutton -padding 4
ttk::style element create Checkbutton.indicator image [list $i(X) {alternate disabled} $i(F) {selected disabled} $i(ae) disabled $i(s) {pressed alternate} $i(m) {active alternate} $i(m) alternate $i(af) {pressed selected} $i(S) {active selected} $i(S) selected $i(ao) {pressed !selected} $i(z) active $i(N)] -width 26 -sticky w
ttk::style element create Switch.indicator image [list $i(ab) {selected disabled} $i(D) disabled $i(w) {pressed selected} $i(J) {active selected} $i(ac) selected $i(ad) {pressed !selected} $i(C) active $i(T)] -width 46 -sticky w
ttk::style configure Toggle.TButton -padding {8 4 8 4} -anchor center -foreground $c(a)
ttk::style map Toggle.TButton -foreground [list {selected disabled} #ffffff {selected pressed} #636363 selected #ffffff pressed #c1d8ee disabled #a2a2a2 active #1a1a1a]
ttk::style element create ToggleButton.button image [list $i(b) {selected disabled} $i(d) disabled $i(a) {pressed selected} $i(b) {active selected} $i(h) selected $i(c) {pressed !selected} $i(c) active $i(e)] -border 4 -sticky nsew
ttk::style configure TRadiobutton -padding 4
ttk::style element create Radiobutton.indicator image [list $i(Y) {selected disabled} $i(ag) disabled $i(v) {pressed selected} $i(ah) {active selected} $i(ak) selected $i(ap) {pressed !selected} $i(B) active $i(P)] -width 26 -sticky w
ttk::style element create Horizontal.Scrollbar.trough image $i(Q) -sticky ew -border 6
ttk::style element create Horizontal.Scrollbar.thumb image $i(Z) -sticky ew -border 3
ttk::style element create Horizontal.Scrollbar.rightarrow image $i(aj) -sticky {} -width 12
ttk::style element create Horizontal.Scrollbar.leftarrow image $i(an) -sticky {} -width 12
ttk::style element create Vertical.Scrollbar.trough image $i(H) -sticky ns -border 6
ttk::style element create Vertical.Scrollbar.thumb image $i(R) -sticky ns -border 3
ttk::style element create Vertical.Scrollbar.uparrow image $i(ar) -sticky {} -height 12
ttk::style element create Vertical.Scrollbar.downarrow image $i(am) -sticky {} -height 12
ttk::style element create Horizontal.Scale.trough image $i(V) -border 5 -padding 0
ttk::style element create Vertical.Scale.trough image $i(L) -border 5 -padding 0
ttk::style element create Scale.slider image [list $i(U) disabled $i(q) pressed $i(x) active $i(K)] -sticky {}
ttk::style element create Horizontal.Progressbar.trough image $i(A) -border 1 -sticky ew
ttk::style element create Horizontal.Progressbar.pbar image $i(O) -border 2 -sticky ew
ttk::style element create Vertical.Progressbar.trough image $i(u) -border 1 -sticky ns
ttk::style element create Vertical.Progressbar.pbar image $i(G) -border 2 -sticky ns
ttk::style configure TEntry -foreground $c(a)
ttk::style map TEntry -foreground [list disabled #0a0a0a pressed #636363 active #626262]
ttk::style element create Entry.field image [list $i(t) {focus hover !invalid} $i(j) invalid $i(k) disabled $i(i) {focus !invalid} $i(j) hover $i(n)] -border 5 -padding 8 -sticky nsew
ttk::style configure TCombobox -foreground $c(a)
ttk::style configure ComboboxPopdownFrame -borderwidth 1 -relief solid
ttk::style map TCombobox -foreground [list disabled #0a0a0a pressed #636363 active #626262]
ttk::style map TCombobox -selectbackground [list {readonly hover} $c(e) {readonly focus} $c(e)] -selectforeground [list {readonly hover} $c(d) {readonly focus} $c(d)]
ttk::style element create Combobox.field image [list $i(t) {readonly disabled} $i(a) {readonly pressed} $i(f) {readonly hover} $i(e) readonly $i(b) invalid $i(k) disabled $i(i) focus $i(j) hover $i(n)] -border 5 -padding {8 8 28 8}
ttk::style element create Combobox.arrow image $i(g) -width 35 -sticky {}
ttk::style configure TSpinbox -foreground $c(a)
ttk::style map TSpinbox -foreground [list disabled #0a0a0a pressed #636363 active #626262]
ttk::style element create Spinbox.field image [list $i(t) invalid $i(k) disabled $i(i) focus $i(j) hover $i(n)] -border 5 -padding {8 8 54 8} -sticky nsew
ttk::style element create Spinbox.uparrow image $i(ax) -width 35 -sticky {}
ttk::style element create Spinbox.downarrow image $i(g) -width 35 -sticky {}
ttk::style element create Sizegrip.sizegrip image $i(ay) -sticky nsew
ttk::style element create TSeparator.separator image $i(as)
ttk::style element create Card.field image $i(au) -border 10 -padding 4 -sticky nsew
ttk::style element create Labelframe.border image $i(au) -border 5 -padding 4 -sticky nsew
ttk::style configure TNotebook -padding 1
ttk::style element create Notebook.border image $i(aa) -border 5 -padding 5
ttk::style element create Notebook.client image $i(av)
ttk::style element create Notebook.tab image [list $i(aw) selected $i(ai) active $i(aq)] -border 13 -padding {16 14 16 6} -height 32
ttk::style element create Treeview.field image $i(au) -border 5
ttk::style element create Treeheading.cell image [list $i(W) pressed $i(y) active $i(M)] -border 5 -padding 15 -sticky nsew
ttk::style element create Treeitem.indicator image [list $i(al) user2 $i(I) user1 $i(g)] -width 26 -sticky {}
ttk::style configure Treeview -foregound #1a1a1a -background $c(b) -rowheight [expr {[font metrics font -linespace] + 2}]
ttk::style map Treeview -background [list selected #f0f0f0] -foreground [list selected #191919]
ttk::style configure Sash -gripcount 0
}}
namespace eval ttk::theme::sun-valley-dark {
variable v 1.0
package provide ttk::theme::sun-valley-dark $v
ttk::style theme create sun-valley-dark -parent clam -settings {
variable i
variable s [image create photo -file [file join [file dirname [info script]] dark.png] -format png]
foreach {k x y w h} [list au 0 0 50 50 aa 50 0 50 50 av 0 50 40 40 w 40 50 40 20 T 40 70 40 20 C 100 0 40 20 ab 100 20 40 20 D 100 40 40 20 ac 80 60 40 20 J 80 80 40 20 ad 0 100 40 20 aq 40 100 32 32 aw 72 100 32 32 ai 104 100 32 32 q 140 0 22 22 K 140 22 22 22 x 140 44 22 22 U 136 66 22 22 V 136 88 22 22 L 136 110 22 22 M 0 132 22 22 y 22 132 22 22 W 44 132 22 22 d 66 132 20 20 h 86 132 20 20 o 106 132 20 20 c 126 132 20 20 E 162 0 20 20 r 162 20 20 20 a 162 40 20 20 e 162 60 20 20 f 158 80 20 20 b 158 100 20 20 p 158 120 20 20 l 0 154 20 20 ae 20 154 20 20 S 40 154 20 20 az 60 154 20 20 ao 80 152 20 20 F 100 152 20 20 m 120 152 20 20 at 140 152 20 20 af 160 140 20 20 s 160 160 20 20 N 182 0 20 20 z 182 20 20 20 X 182 40 20 20 i 182 60 20 20 j 180 80 20 20 n 0 180 20 20 k 180 100 20 20 t 178 120 20 20 O 80 50 20 5 G 146 132 5 20 A 120 60 20 5 u 151 132 5 20 ag 20 180 20 20 ak 180 140 20 20 ah 40 180 20 20 ap 180 160 20 20 v 60 180 20 20 P 80 180 20 20 B 100 180 20 20 Y 120 180 20 20 Z 0 120 20 12 Q 140 172 20 12 R 160 180 10 20 H 170 180 12 20 g 80 55 10 5 al 0 90 5 10 ax 90 55 10 5 I 5 90 10 10 ay 15 90 10 10 am 0 174 8 6 an 80 172 6 8 aj 86 172 6 8 ar 8 174 8 6 as 120 65 1 1] {
set i($k) [image create photo -width $w -height $h]
$i($k) copy $s -from $x $y [expr {$x+$w}] [expr {$y+$h}]
}
unset s
array set c {a #ffffff b #1c1c1c c #595959 d #ffffff e #2f60d8}
ttk::style layout TButton {Button.button -children {Button.padding -children {Button.label -side left -expand 1}}}
ttk::style layout Toolbutton {Toolbutton.button -children {Toolbutton.padding -children {Toolbutton.label -side left -expand 1}}}
ttk::style layout TMenubutton {Menubutton.button -children {Menubutton.padding -children {Menubutton.label -side left -expand 1 Menubutton.indicator -side right -sticky nsew}}}
ttk::style layout TOptionMenu {OptionMenu.button -children {OptionMenu.padding -children {OptionMenu.label -side left -expand 1 OptionMenu.indicator -side right -sticky nsew}}}
ttk::style layout Accent.TButton {AccentButton.button -children {AccentButton.padding -children {AccentButton.label -side left -expand 1}}}
ttk::style layout Titlebar.TButton {TitlebarButton.button -children {TitlebarButton.padding -children {TitlebarButton.label -side left -expand 1}}}
ttk::style layout Close.Titlebar.TButton {CloseButton.button -children {CloseButton.padding -children {CloseButton.label -side left -expand 1}}}
ttk::style layout TCheckbutton {Checkbutton.button -children {Checkbutton.padding -children {Checkbutton.indicator -side left Checkbutton.label -side right -expand 1}}}
ttk::style layout Switch.TCheckbutton {Switch.button -children {Switch.padding -children {Switch.indicator -side left Switch.label -side right -expand 1}}}
ttk::style layout Toggle.TButton {ToggleButton.button -children {ToggleButton.padding -children {ToggleButton.label -side left -expand 1}}}
ttk::style layout TRadiobutton {Radiobutton.button -children {Radiobutton.padding -children {Radiobutton.indicator -side left Radiobutton.label -side right -expand 1}}}
ttk::style layout Vertical.TScrollbar {Vertical.Scrollbar.trough -sticky ns -children {Vertical.Scrollbar.uparrow -side top Vertical.Scrollbar.downarrow -side bottom Vertical.Scrollbar.thumb -expand 1}}
ttk::style layout Horizontal.TScrollbar {Horizontal.Scrollbar.trough -sticky ew -children {Horizontal.Scrollbar.leftarrow -side left Horizontal.Scrollbar.rightarrow -side right Horizontal.Scrollbar.thumb -expand 1}}
ttk::style layout TSeparator {TSeparator.separator -sticky nsew}
ttk::style layout TCombobox {Combobox.field -sticky nsew -children {Combobox.padding -expand 1 -sticky nsew -children {Combobox.textarea -sticky nsew}} null -side right -sticky ns -children {Combobox.arrow -sticky nsew}}
ttk::style layout TSpinbox {Spinbox.field -sticky nsew -children {Spinbox.padding -expand 1 -sticky nsew -children {Spinbox.textarea -sticky nsew}} null -side right -sticky nsew -children {Spinbox.uparrow -side left -sticky nsew Spinbox.downarrow -side right -sticky nsew}}
ttk::style layout Card.TFrame {Card.field {Card.padding -expand 1}}
ttk::style layout TLabelframe {Labelframe.border {Labelframe.padding -expand 1 -children {Labelframe.label -side left}}}
ttk::style layout TNotebook {Notebook.border -children {TNotebook.Tab -expand 1 Notebook.client -sticky nsew}}
ttk::style layout Treeview.Item {Treeitem.padding -sticky nsew -children {Treeitem.image -side left -sticky {} Treeitem.indicator -side left -sticky {} Treeitem.text -side left -sticky {}}}
ttk::style configure TButton -padding {8 4} -anchor center -foreground $c(a)
ttk::style map TButton -foreground [list disabled #7a7a7a pressed #d0d0d0]
ttk::style element create Button.button image [list $i(b) {selected disabled} $i(a) disabled $i(a) selected $i(b) pressed $i(f) active $i(e)] -border 4 -sticky nsew
ttk::style configure Toolbutton -padding {8 4} -anchor center
ttk::style element create Toolbutton.button image [list $i(I) {selected disabled} $i(a) selected $i(b) pressed $i(f) active $i(e)] -border 4 -sticky nsew
ttk::style configure TMenubutton -padding {8 4 0 4}
ttk::style element create Menubutton.button image [list $i(b) disabled $i(a) pressed $i(f) active $i(e)] -border 4 -sticky nsew
ttk::style element create Menubutton.indicator image $i(g) -width 28 -sticky {}
ttk::style configure TOptionMenu -padding {8 4 0 4}
ttk::style element create OptionMenu.button image [list $i(b) disabled $i(a) pressed $i(f) active $i(e)] -border 4 -sticky nsew
ttk::style element create OptionMenu.indicator image $i(g) -width 28 -sticky {}
ttk::style configure Accent.TButton -padding {8 4} -anchor center -foreground #000000
ttk::style map Accent.TButton -foreground [list pressed #25536a disabled #a5a5a5]
ttk::style element create AccentButton.button image [list $i(c) {selected disabled} $i(d) disabled $i(d) selected $i(c) pressed $i(o) active $i(h)] -border 4 -sticky nsew
ttk::style configure Titlebar.TButton -padding {8 4} -anchor center -foreground #ffffff
ttk::style map Titlebar.TButton -foreground [list disabled #6f6f6f pressed #d1d1d1 active #ffffff]
ttk::style element create TitlebarButton.button image [list $i(I) disabled $i(I) pressed $i(l) active $i(p)] -border 4 -sticky nsew
ttk::style configure Close.Titlebar.TButton -padding {8 4} -anchor center -foreground #ffffff
ttk::style map Close.Titlebar.TButton -foreground [list disabled #6f6f6f pressed #e8bfbb active #ffffff]
ttk::style element create CloseButton.button image [list $i(I) disabled $i(I) pressed $i(r) active $i(E)] -border 4 -sticky nsew
ttk::style configure TCheckbutton -padding 4
ttk::style element create Checkbutton.indicator image [list $i(X) {alternate disabled} $i(F) {selected disabled} $i(ae) disabled $i(s) {pressed alternate} $i(m) {active alternate} $i(m) alternate $i(af) {pressed selected} $i(S) {active selected} $i(S) selected $i(ao) {pressed !selected} $i(z) active $i(N)] -width 26 -sticky w
ttk::style element create Switch.indicator image [list $i(ab) {selected disabled} $i(D) disabled $i(w) {pressed selected} $i(J) {active selected} $i(ac) selected $i(ad) {pressed !selected} $i(C) active $i(T)] -width 46 -sticky w
ttk::style configure Toggle.TButton -padding {8 4 8 4} -anchor center -foreground $c(a)
ttk::style map Toggle.TButton -foreground [list {selected disabled} #a5a5a5 {selected pressed} #d0d0d0 selected #000000 pressed #25536a disabled #7a7a7a]
ttk::style element create ToggleButton.button image [list $i(b) {selected disabled} $i(d) disabled $i(a) {pressed selected} $i(b) {active selected} $i(h) selected $i(c) {pressed !selected} $i(c) active $i(e)] -border 4 -sticky nsew
ttk::style configure TRadiobutton -padding 4
ttk::style element create Radiobutton.indicator image [list $i(Y) {selected disabled} $i(ag) disabled $i(v) {pressed selected} $i(ah) {active selected} $i(ak) selected $i(ap) {pressed !selected} $i(B) active $i(P)] -width 26 -sticky w
ttk::style element create Horizontal.Scrollbar.trough image $i(Q) -sticky ew -border 6
ttk::style element create Horizontal.Scrollbar.thumb image $i(Z) -sticky ew -border 3
ttk::style element create Horizontal.Scrollbar.rightarrow image $i(aj) -sticky {} -width 12
ttk::style element create Horizontal.Scrollbar.leftarrow image $i(an) -sticky {} -width 12
ttk::style element create Vertical.Scrollbar.trough image $i(H) -sticky ns -border 6
ttk::style element create Vertical.Scrollbar.thumb image $i(R) -sticky ns -border 3
ttk::style element create Vertical.Scrollbar.uparrow image $i(ar) -sticky {} -height 12
ttk::style element create Vertical.Scrollbar.downarrow image $i(am) -sticky {} -height 12
ttk::style element create Horizontal.Scale.trough image $i(V) -border 5 -padding 0
ttk::style element create Vertical.Scale.trough image $i(L) -border 5 -padding 0
ttk::style element create Scale.slider image [list $i(U) disabled $i(q) pressed $i(x) active $i(K)] -sticky {}
ttk::style element create Horizontal.Progressbar.trough image $i(A) -border 1 -sticky ew
ttk::style element create Horizontal.Progressbar.pbar image $i(O) -border 2 -sticky ew
ttk::style element create Vertical.Progressbar.trough image $i(u) -border 1 -sticky ns
ttk::style element create Vertical.Progressbar.pbar image $i(G) -border 2 -sticky ns
ttk::style configure TEntry -foreground $c(a)
ttk::style map TEntry -foreground [list disabled #757575 pressed #cfcfcf]
ttk::style element create Entry.field image [list $i(t) {focus hover !invalid} $i(j) invalid $i(k) disabled $i(i) {focus !invalid} $i(j) hover $i(n)] -border 5 -padding 8 -sticky nsew
ttk::style configure TCombobox -foreground $c(a)
ttk::style map TCombobox -foreground [list disabled #757575 pressed #cfcfcf]
ttk::style configure ComboboxPopdownFrame -borderwidth 1 -relief solid
ttk::style map TCombobox -selectbackground [list {readonly hover} $c(e) {readonly focus} $c(e)] -selectforeground [list {readonly hover} $c(d) {readonly focus} $c(d)]
ttk::style element create Combobox.field image [list $i(t) {readonly disabled} $i(a) {readonly pressed} $i(f) {readonly hover} $i(e) readonly $i(b) invalid $i(k) disabled $i(i) focus $i(j) hover $i(n)] -border 5 -padding {8 8 28 8}
ttk::style element create Combobox.arrow image $i(g) -width 35 -sticky {}
ttk::style configure TSpinbox -foreground $c(a)
ttk::style map TSpinbox -foreground [list disabled #757575 pressed #cfcfcf]
ttk::style element create Spinbox.field image [list $i(t) invalid $i(k) disabled $i(i) focus $i(j) hover $i(n)] -border 5 -padding {8 8 54 8} -sticky nsew
ttk::style element create Spinbox.uparrow image $i(ax) -width 35 -sticky {}
ttk::style element create Spinbox.downarrow image $i(g) -width 35 -sticky {}
ttk::style element create Sizegrip.sizegrip image $i(ay) -sticky nsew
ttk::style element create TSeparator.separator image $i(as)
ttk::style element create Card.field image $i(au) -border 10 -padding 4 -sticky nsew
ttk::style element create Labelframe.border image $i(au) -border 5 -padding 4 -sticky nsew
ttk::style configure TNotebook -padding 1
ttk::style element create Notebook.border image $i(aa) -border 5 -padding 5
ttk::style element create Notebook.client image $i(av)
ttk::style element create Notebook.tab image [list $i(aw) selected $i(ai) active $i(aq)] -border 13 -padding {16 14 16 6} -height 32
ttk::style element create Treeview.field image $i(au) -border 5
ttk::style element create Treeheading.cell image [list $i(W) pressed $i(y) active $i(M)] -border 5 -padding 15 -sticky nsew
ttk::style element create Treeitem.indicator image [list $i(al) user2 $i(I) user1 $i(g)] -width 26 -sticky {}
ttk::style configure Treeview -background $c(b) -rowheight [expr {[font metrics font -linespace] + 2}]
ttk::style map Treeview -background [list selected #292929] -foreground [list selected $c(d)]
ttk::style configure Sash -gripcount 0
}}
option add *tearOff 0
proc set_theme {m} {
if {$m == "dark"} {
ttk::style theme use "sun-valley-dark"
array set c {a #ffffff b #1c1c1c c #595959 d #ffffff e #2f60d8}
ttk::style configure . -background $c(b) -foreground $c(a) -troughcolor $c(b) -focuscolor $c(e) -selectbackground $c(e) -selectforeground $c(d) -insertwidth 1 -insertcolor $c(a) -fieldbackground $c(e) -font {"Microsoft YaHei UI" 10} -borderwidth 0 -relief flat
tk_setPalette background [ttk::style lookup . -background] foreground [ttk::style lookup . -foreground] highlightColor [ttk::style lookup . -focuscolor] selectBackground [ttk::style lookup . -selectbackground] selectForeground [ttk::style lookup . -selectforeground] activeBackground [ttk::style lookup . -selectbackground] activeForeground [ttk::style lookup . -selectforeground]
ttk::style map . -foreground [list disabled $c(c)]
option add *font [ttk::style lookup . -font]
option add *Menu.selectcolor $c(a)
option add *Menu.background #2f2f2f
} elseif {$m == "light"} {
ttk::style theme use "sun-valley-light"
array set c {a #202020 b #fafafa c #a0a0a0 d #ffffff e #2f60d8}
ttk::style configure . -background $c(b) -foreground $c(a) -troughcolor $c(b) -focuscolor $c(e) -selectbackground $c(e) -selectforeground $c(d) -insertwidth 1 -insertcolor $c(a) -fieldbackground $c(e) -font {"Microsoft YaHei UI" 10} -borderwidth 0 -relief flat
tk_setPalette background [ttk::style lookup . -background] foreground [ttk::style lookup . -foreground] highlightColor [ttk::style lookup . -focuscolor] selectBackground [ttk::style lookup . -selectbackground] selectForeground [ttk::style lookup . -selectforeground] activeBackground [ttk::style lookup . -selectbackground] activeForeground [ttk::style lookup . -selectforeground]
ttk::style map . -foreground [list disabled $c(c)]
option add *font [ttk::style lookup . -font]
option add *Menu.selectcolor $c(a)
option add *Menu.background #e7e7e7
}}
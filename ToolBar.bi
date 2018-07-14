﻿'###############################################################################
'#  ToolBar.bi                                                                 #
'#  This file is part of MyFBFramework                                            #
'#  Version 1.0.0                                                              #
'###############################################################################

#Include Once "Control.bi"

Namespace My.Sys.Forms
    #DEFINE QToolBar(__Ptr__) *Cast(ToolBar Ptr,__Ptr__)
    #DEFINE QToolButton(__Ptr__) *Cast(ToolButton Ptr,__Ptr__)

    '#DEFINE TBSTYLE_TRANSPARENT &H8000
    '#DEFINE TBN_DROPDOWN (TBN_FIRST - 10)

    Enum ToolButtonStyle
        tbsAutosize           = TBSTYLE_AUTOSIZE
        tbsButton             = TBSTYLE_BUTTON
        tbsCheck              = TBSTYLE_CHECK
        tbsCheckGroup         = TBSTYLE_CHECKGROUP
        tbsGroup             = TBSTYLE_GROUP
        tbsDropDown           = TBSTYLE_DROPDOWN
        tbsNoPrefix              = TBSTYLE_NOPREFIX
        tbsSeparator          = TBSTYLE_SEP
        tbsShowText           = BTNS_SHOWTEXT
        tbsWholeDropdown     = BTNS_WHOLEDROPDOWN
    End Enum
    
    Enum ToolButtonState    
        tstIndeterminate    = TBSTATE_INDETERMINATE
        tstEnabled           = TBSTATE_ENABLED
        tstHidden           = TBSTATE_HIDDEN
        tstEllipses           = TBSTATE_ELLIPSES
        tstChecked               = TBSTATE_CHECKED
        tstPressed           = TBSTATE_PRESSED
        tstMarked           = TBSTATE_MARKED
        tstWrap                  = TBSTATE_WRAP
    End Enum

    Type ToolButton Extends My.Sys.Object
        Private:
            FCaption      As WString Ptr
            FImageIndex   As Integer
            FImageKey     As WString Ptr
            FStyle        As Integer
            FState        As Integer
            FHint         As WString Ptr
            FShowHint     As Boolean
            FDown         As Boolean
            FWidth        As Integer
            FHeight       As Integer
            FVisible      As Boolean
            FEnabled      As Boolean
            FChecked      As Boolean
            FCommandID    As Integer
            FButtonLeft   As Integer
            FButtonTop    As Integer
            FButtonWidth  As Integer
            FButtonHeight As Integer
        Public:
            DropDownMenu  As PopupMenu
            Tag           As Any Ptr
            Ctrl       As Control Ptr
            Declare Property Caption ByRef As WString
            Declare Property Caption(ByRef Value As WString)
            Declare Property Hint ByRef As WString
            Declare Property Hint(ByRef Value As WString)
            Declare Property ShowHint As Boolean
            Declare Property ShowHint(Value As Boolean)
            Declare Property ImageIndex As Integer
            Declare Property ImageIndex(Value As Integer)
            Declare Property ImageKey ByRef As WString
            Declare Property ImageKey(ByRef Value As WString)
            Declare Property Style As Integer 
            Declare Property Style(Value As Integer) 
            Declare Property State As Integer
            Declare Property State(Value As Integer) 
            Declare Property CommandID As Integer 
            Declare Property CommandID(Value As Integer)
            Declare Property Left As Integer
            Declare Property Left(Value As Integer)
            Declare Property Top As Integer
            Declare Property Top(Value As Integer)
            Declare Property Width As Integer
            Declare Property Width(Value As Integer)
            Declare Property Height As Integer
            Declare Property Height(Value As Integer)
            Declare Property Visible As Boolean
            Declare Property Visible(Value As Boolean)
            Declare Property Checked As Boolean
            Declare Property Checked(Value As Boolean)
            Declare Property Enabled As Boolean
            Declare Property Enabled(Value As Boolean)
            Declare Operator Cast As Any Ptr
            Declare Constructor
            Declare Destructor
            OnClick As Sub(BYREF Sender As My.Sys.Object)
    End Type

    Type ToolButtons
        Private:
            FButtons As List
        Public:
            Parent   As Control Ptr
            Declare Property Count As Integer
            Declare Property Count(Value As Integer)
            Declare Property Item(Index As Integer) As ToolButton Ptr
            Declare Property Item(ByRef Key As WString) As ToolButton Ptr
            Declare Property Item(Index As Integer, Value As ToolButton Ptr)
            Declare Function Add(FStyle As Integer = tbsAutosize, FImageIndex As Integer = -1, Index As Integer = -1, FClick As Any Ptr = NULL, ByRef FKey As WString = "", ByRef FCaption As WString = "", ByRef FHint As WString = "", FShowHint As Boolean = False, FState As Integer = tstEnabled) As ToolButton Ptr
            Declare Function Add(FStyle As Integer = tbsAutosize, ByRef ImageKey As WString, Index As Integer = -1, FClick As Any Ptr = NULL, ByRef FKey As WString = "", ByRef FCaption As WString = "", ByRef FHint As WString = "", FShowHint As Boolean = False, FState As Integer = tstEnabled) As ToolButton Ptr
            Declare Sub Remove(Index As Integer)
            Declare Function IndexOf(BYREF FButton As ToolButton Ptr) As Integer
            Declare Function IndexOf(ByRef Key As WString) As Integer
            Declare Sub Clear
            Declare Operator Cast As Any Ptr
            Declare Constructor
            Declare Destructor
    End Type

    Type ToolBar Extends Control
        Private:
            FButtonWidth    As Integer
            FButtonHeight   As Integer
            FColor          As Integer
            FAutosize       As Boolean
            FFlat           As Boolean
            FList           As Boolean
            FDivider        As Boolean
            FVisible        As Boolean
            FEnabled        As Boolean
            FTransparent    As Boolean
            FWrapable       As Integer
            ATransparent(2) As Integer
            AFlat(2)        As Integer
            ADivider(2)     As Integer
            AAutosize(2)    As Integer
            AList(2)        As Integer
            AState(6)       As Integer
            AWrap(2)        As Integer
            FButtons        As List
            Declare Static Sub WndProc(BYREF Message As Message)
            Declare Static Sub HandleIsAllocated(BYREF Sender As Control)
            Declare Static Sub HandleIsDestroyed(BYREF Sender As Control)
            Declare Sub ProcessMessage(BYREF Message As Message)
            Declare Sub GetDropDownMenuItems
        Public:
            Buttons         As ToolButtons
            ImagesList      As ImageList Ptr
            HotImagesList   As ImageList Ptr
            DisabledImagesList As ImageList Ptr
            'Declare Function Buttons(Index As Integer) As ToolButton
            Declare Property Caption ByRef As WString
            Declare Property Caption(ByRef Value As WString)
            Declare Property AutoSize As Boolean
            Declare Property AutoSize(Value As Boolean)
            Declare Property Flat As Boolean
            Declare Property Flat(Value As Boolean)
            Declare Property List As Boolean
            Declare Property List(Value As Boolean)
            Declare Property Wrapable As Boolean
            Declare Property Wrapable(Value As Boolean)
            Declare Property Transparency As Boolean
            Declare Property Transparency(Value As Boolean)
            Declare Property Divider As Boolean
            Declare Property Divider(Value As Boolean)
            Declare Property ButtonWidth As Integer
            Declare Property ButtonWidth(Value As Integer)
            Declare Property ButtonHeight As Integer
            Declare Property ButtonHeight(Value As Integer)
            Declare Operator Cast As Control Ptr 
            Declare Constructor
            Declare Destructor
            OnButtonClick As Sub(BYREF Sender As ToolBar,BYREF Button As ToolButton)
    End Type

    Sub ToolBar.GetDropDownMenuItems
        FPopupMenuItems.Clear
        For j As Integer = 0 To Buttons.Count - 1
            For i As Integer = 0 To Buttons.Item(j)->DropDownMenu.Count -1
                EnumPopupMenuItems *Buttons.Item(j)->DropDownMenu.Item(i)
            Next i
        Next j
    End Sub
    
    Property ToolButton.Caption ByRef As WString
        Return *FCaption
    End Property

    Property ToolButton.Caption(ByRef Value As WString)
        Dim As TBBUTTON TB
        Dim As Integer i
        If Value <> *FCaption Then
            WLet FCaption, Value
            If Ctrl Then
                With QControl(Ctrl)
                    i = .Perform(TB_COMMANDTOINDEX,FCommandID,0)
                    .Perform(TB_GETBUTTON,i,CInt(@TB))
                    If *FCaption <> "" Then 
                       TB.iString = CInt(FCaption)
                    Else
                       TB.iString = 0
                    End If
                    .Perform(TB_INSERTBUTTON, i, CInt(@TB))
                    .Perform(TB_DELETEBUTTON, i + 1, 0)
                End With
            End If
        End If 
    End Property

    Property ToolButton.Hint ByRef As WString
        Return *FHint
    End Property

    Property ToolButton.Hint(ByRef Value As WString)
        FHint = ReAllocate(FHint, (Len(Value) + 1) * SizeOf(WString))
        *FHint = Value
    End Property

    Property ToolButton.ShowHint As Boolean
        Return FShowHint
    End Property

    Property ToolButton.ShowHint(Value As Boolean)
        FShowHint = Value
    End Property

    Property ToolButton.ImageIndex As Integer
        Return FImageIndex
    End Property

    Property ToolButton.ImageIndex(Value As Integer)
        If Value <> FImageIndex Then
            FImageIndex = Value
            If Ctrl Then 
                With QControl(Ctrl)
                    .Perform(TB_CHANGEBITMAP, FCommandID, MakeLong(FImageIndex, 0))
                End With
            End If
        End If
    End Property

    Property ToolButton.ImageKey ByRef As WString
        Return *FImageKey
    End Property

    Property ToolButton.ImageKey(ByRef Value As WString)
        If Value <> *FImageKey Then
            WLet FImageKey, Value
            If Ctrl AndAlso QToolBar(Ctrl).ImagesList Then
                ImageIndex = QToolBar(Ctrl).ImagesList->IndexOf(Value)
            End If
        End If
    End Property

    Property ToolButton.Style As Integer
        Return FStyle
    End Property

    Property ToolButton.Style(Value As Integer) 
        If Value <> FStyle Then
            FStyle = Value
            If Ctrl Then QControl(Ctrl).RecreateWnd
        End If
    End Property

    Property ToolButton.State As Integer
        Return FState
    End Property

    Property ToolButton.State(Value As Integer) 
        If Value <> FState Then
            FState = Value
            If Ctrl Then QControl(Ctrl).RecreateWnd
        End If
    End Property

    Property ToolButton.CommandID As Integer
        Return FCommandID
    End Property

    Property ToolButton.CommandID(Value As Integer)
        Dim As Integer i
        If Value <> FCommandID Then
            FCommandID = Value
            If Ctrl Then 
                With QControl(Ctrl)
                    i = .Perform(TB_COMMANDTOINDEX,FCommandID,0)
                    .Perform(TB_SETCMDID,i,FCommandID)
                End With
            End If
        End If
    End Property

    Property ToolButton.Left As Integer
        Dim As Rect R
        Dim As Integer i
        If Ctrl Then
            With QControl(Ctrl)
                If .Handle Then
                    i = .Perform(TB_COMMANDTOINDEX,FCommandID,0)
                    .Perform(TB_GETITEMRECT,I,CInt(@R))
                    FButtonLeft = R.Left
                End If
            End With
        End If
        Return FButtonLeft
    End Property

    Property ToolButton.Left(Value As Integer)
    End Property

    Property ToolButton.Top As Integer
        Dim As Rect R
        Dim As Integer i
        If Ctrl Then
            With QControl(Ctrl)
                If .Handle Then
                    i = .Perform(TB_COMMANDTOINDEX,FCommandID,0)
                    .Perform(TB_GETITEMRECT,I,CInt(@R))
                    FButtonTop = R.Top
                End If
            End With
        End If
        Return FButtonTop
    End Property

    Property ToolButton.Top(Value As Integer)
    End Property

    Property ToolButton.Width As Integer
        Dim As Rect R
        Dim As Integer i
        If Ctrl Then
            With QControl(Ctrl)
                If .Handle Then
                    i = .Perform(TB_COMMANDTOINDEX,FCommandID,0)
                    .Perform(TB_GETITEMRECT,I,CInt(@R))
                    FButtonWidth = R.Right - R.Left
                End If
            End With
        End If
        Return FButtonWidth
    End Property

    Property ToolButton.Width(Value As Integer)
        FButtonWidth = Value
    End Property

    Property ToolButton.Height As Integer
        Dim As Rect R
        Dim As Integer i
        If Ctrl Then
           With QControl(Ctrl)
                If .Handle Then
                    i = .Perform(TB_COMMANDTOINDEX,FCommandID,0)
                    .Perform(TB_GETITEMRECT,I,CInt(@R))
                    FButtonHeight = R.Bottom - R.Top
                End If
            End With
        End If
        Return FButtonHeight
    End Property

    Property ToolButton.Height(Value As Integer)
    End Property

    Property ToolButton.Visible As Boolean
        Return FVisible
    End Property

    Property ToolButton.Visible(Value As Boolean)
        If Value <> FVisible Then
            FVisible = Value
            If Ctrl Then 
                With QControl(Ctrl)
                    .Perform(TB_HIDEBUTTON, FCommandID, MakeLong(NOT FVisible, 0))
                End With
            End If
        End If
    End Property

    Property ToolButton.Enabled As Boolean
        Return FEnabled
    End Property

    Property ToolButton.Enabled(Value As Boolean)
        If Value <> FEnabled Then
            FEnabled = Value
            If Ctrl Then
                With QControl(Ctrl)
                    .Perform(TB_ENABLEBUTTON, FCommandID, MakeLong(FEnabled, 0))
                    .Perform(TB_CHANGEBITMAP, FCommandID, MakeLong(FImageIndex,0))
                End With
            End If
        End If
    End Property

    Property ToolButton.Checked As Boolean
        If Ctrl Then
            With QControl(Ctrl)
                FChecked = (.Perform(TB_GETSTATE, FCommandID, 0) And TBSTATE_CHECKED) = TBSTATE_CHECKED
            End With
        End If        
        Return FChecked
    End Property

    Property ToolButton.Checked(Value As Boolean)
        'If Value <> Checked Then
            FChecked = Value
            If Ctrl Then
                With QControl(Ctrl)
                    .Perform(TB_CHECKBUTTON, FCommandID, MakeLong(FChecked, 0))
                    If OnClick Then OnClick(This)
                End With
            End If
        'End If
    End Property
    
    Operator ToolButton.Cast As Any Ptr
        Return @This
    End Operator

    Constructor ToolButton
        FHint = CAllocate(0)
        FCaption = CAllocate(0)
        FStyle      = tbsButton
        FEnabled    = 1
        FVisible    = 1
        Caption    = ""
        Hint       = ""
        FShowHint   = 0
        FImageIndex = -1
    End Constructor

    Destructor ToolButton
        If DropDownMenu.Handle Then DestroyMenu DropDownMenu.Handle
        Deallocate FHint
        Deallocate FCaption
    End Destructor

    Property ToolButtons.Count As Integer
        Return FButtons.Count
    End Property

    Property ToolButtons.Count(Value As Integer)
    End Property

    Property ToolButtons.Item(Index As Integer) As ToolButton Ptr
        Return Cast(ToolButton Ptr, FButtons.Items[Index])
    End Property
    
    Property ToolButtons.Item(ByRef Key As WString) As ToolButton Ptr
        If IndexOf(Key) <> -1 Then Return Cast(ToolButton Ptr, FButtons.Items[IndexOf(Key)])
        Return 0
    End Property

    Property ToolButtons.Item(Index As Integer, Value As ToolButton Ptr)
       'QToolButton(FButtons.Items[Index]) = Value 
    End Property

    Function ToolButtons.Add(FStyle As Integer = tbsAutosize, FImageIndex As Integer = -1, Index As Integer = -1, FClick As Any Ptr = NULL, ByRef FKey As WString = "", ByRef FCaption As WString = "", ByRef FHint As WString = "", FShowHint As Boolean = False, FState As Integer = tstEnabled) As ToolButton Ptr
        Dim As ToolButton Ptr PButton
        Dim As TBBUTTON TB
        PButton = New ToolButton
        FButtons.Add PButton
        With *PButton
            .Style          = FStyle 
            .State        = FState
            .ImageIndex     = FImageIndex
            .Hint           = FHint
            .ShowHint       = FShowHint
            .Name         = FKey
            .Caption        = FCaption
            .CommandID      = 10 + FButtons.Count
            .OnClick        = FClick
        End With
        TB.fsState   = FState
        TB.fsStyle   = FStyle
        TB.iBitmap   = PButton->ImageIndex
        TB.idCommand = PButton->CommandID
        If FCaption <> "" Then 
            TB.iString = CInt(@FCaption)
        Else
            TB.iString = 0
        End If
        TB.dwData = Cast(DWord_Ptr,@PButton->DropDownMenu)
        If Parent Then
               PButton->Ctrl = Parent
            If Index <> -1 Then
                Parent->Perform(TB_INSERTBUTTON,Index,CInt(@TB))
            Else
                   Parent->Perform(TB_ADDBUTTONS,1,CInt(@TB))
            End If
        End If
        Return PButton
    End Function

    Function ToolButtons.Add(FStyle As Integer = tbsAutosize, ByRef ImageKey As WString, Index As Integer = -1, FClick As Any Ptr = NULL, ByRef FKey As WString = "", ByRef FCaption As WString = "", ByRef FHint As WString = "", FShowHint As Boolean = False, FState As Integer = tstEnabled) As ToolButton Ptr
        Dim As ToolButton Ptr PButton
        If Parent AndAlso Cast(ToolBar Ptr, Parent)->ImagesList Then
            With *Cast(ToolBar Ptr, Parent)->ImagesList
                PButton = Add(FStyle, .IndexOf(ImageKey), Index, FClick, FKey, FCaption, FHint, FShowHint, FState)
            End With
        Else
            PButton = Add(FStyle, -1, Index, FClick, FKey, FCaption, FHint, FShowHint, FState)
        End If
        If PButton Then PButton->ImageKey         = ImageKey
        Return PButton
    End Function
    
    Sub ToolButtons.Remove(Index As Integer)
        FButtons.Remove Index
        If Parent Then
            Parent->Perform(TB_DELETEBUTTON,Index,0)
        End If
    End Sub

    Function ToolButtons.IndexOf(BYREF FButton As ToolButton Ptr) As Integer
        Return FButtons.IndexOF(FButton) 
    End Function

    Function ToolButtons.IndexOf(ByRef Key As WString) As Integer
        For i As Integer = 0 To Count - 1
            If QToolButton(FButtons.Items[i]).Name = Key Then Return i
        Next i
        Return -1
    End Function

    Sub ToolButtons.Clear
        For i As Integer = Count -1 To 0 Step -1
            Delete @QToolButton(FButtons.Items[i])
        Next i
        FButtons.Clear
    End Sub

    Operator ToolButtons.Cast As Any Ptr
        Return @This
    End Operator

    Constructor ToolButtons
        This.Clear
    End Constructor

    Destructor ToolButtons
         This.Clear
    End Destructor

    Property ToolBar.AutoSize As Boolean
        FAutoSize = StyleExists(TBSTYLE_AUTOSIZE)
        Return FAutoSize
    End Property

    Property ToolBar.AutoSize(Value As Boolean)
        FAutoSize = Value
        ChangeStyle TBSTYLE_AUTOSIZE, Value
        If FHandle Then if FAutosize Then Perform(TB_AUTOSIZE, 0, 0)
    End Property

    Property ToolBar.Flat As Boolean
        FFlat = StyleExists(TBSTYLE_FLAT)
        Return FFlat
    End Property

    Property ToolBar.Flat(Value As Boolean)
        FFlat = Value
        ChangeStyle TBSTYLE_FLAT, Value
    End Property
    
    Property ToolBar.List As Boolean
        FList = StyleExists(TBSTYLE_LIST)
        Return FList
    End Property

    Property ToolBar.List(Value As Boolean)
        FList = Value
        ChangeStyle TBSTYLE_LIST, Value
    End Property
    

    Property ToolBar.Divider As Boolean
        FDivider = Not StyleExists(CCS_NODIVIDER)
        Return FDivider
    End Property

    Property ToolBar.Divider(Value As Boolean)
        FDivider = Value
        ChangeStyle CCS_NODIVIDER, Not Value
    End Property

    Property ToolBar.Transparency As Boolean
        FTransparent = StyleExists(TBSTYLE_TRANSPARENT)
        Return FTransparent
    End Property

    Property ToolBar.Transparency(Value As Boolean)
        FTransparent = Value
        ChangeStyle TBSTYLE_TRANSPARENT, Value
    End Property

    Property ToolBar.ButtonWidth As Integer
        Return FButtonWidth
    End Property

    Property ToolBar.ButtonWidth(Value As Integer)
        FButtonWidth = Value
        If Handle Then Perform(TB_SETBUTTONSIZE,0,MakeLong(FButtonWidth,FButtonHeight))
    End Property

    Property ToolBar.ButtonHeight As Integer
        Return FButtonHeight
    End Property

    Property ToolBar.ButtonHeight(Value As Integer)
        FButtonHeight = Value
        If Handle Then Perform(TB_SETBUTTONSIZE,0,MakeLong(FButtonWidth,FButtonHeight))
    End Property

    Property ToolBar.Wrapable As Boolean
        FWrapable = StyleExists(TBSTYLE_WRAPABLE)
        Return FWrapable
    End Property

    Property ToolBar.Wrapable(Value As Boolean)
        FWrapable = Value
        ChangeStyle TBSTYLE_WRAPABLE, Value
    End Property

    Property ToolBar.Caption ByRef As WString
        Return Text
    End Property

    Property ToolBar.Caption(ByRef Value As WString)
        Text = Value
    End Property

    Sub ToolBar.WndProc(BYREF Message As Message)
    End Sub

    Sub ToolBar.ProcessMessage(BYREF Message As Message)
        Select Case Message.Msg
        Case WM_PAINT
            Message.Result = 0
        Case WM_SIZE
            If AutoSize Then
                Dim As Rect R
                GetWindowRect Handle,@R
                FHeight = R.Bottom - R.Top
            End If
        Case WM_COMMAND
            GetDropDownMenuItems
            For i As Integer = 0 To FPopupMenuItems.Count -1
                If QMenuItem(FPopupMenuItems.Items[i]).Command = Message.wParamLo Then
                    If QMenuItem(FPopupMenuItems.Items[i]).OnClick Then QMenuItem(FPopupMenuItems.Items[i]).OnClick(QMenuItem(FPopupMenuItems.Items[i]))
                    Exit For
                End If
            Next i
        Case CM_COMMAND
            Dim As Integer Index
            Dim As TBBUTTON TB
            If Message.wParam <> 0 Then
               Index = Perform(TB_COMMANDTOINDEX, Message.wParam, 0)
               If Perform(TB_GETBUTTON, Index, CInt(@TB)) Then
                   If Buttons.Item(Index)->OnClick Then (Buttons.Item(Index))->OnClick(*Buttons.Item(Index))
               End If 
            End If
        Case CM_NOTIFY
            Dim As TBNOTIFY PTR Tbn
            Dim As TBBUTTON TB
            Dim As RECT R
            Dim As Integer i
            Tbn = Cast(TBNOTIFY PTR,Message.lParam) 
            Select Case Tbn->hdr.Code
            Case TBN_DROPDOWN
                 If Tbn->iItem <> -1 Then 
                     SendMessage(Tbn->hdr.hwndFrom,TB_GETRECT,Tbn->iItem,CInt(@R))
                     MapWindowPoints(Tbn->hdr.hwndFrom,0,Cast(Point Ptr,@R),2)
                     i = SendMessage(Tbn->hdr.hwndFrom,TB_COMMANDTOINDEX,Tbn->iItem,0)
                     If SendMessage(Tbn->hdr.hwndFrom,TB_GETBUTTON,i,CInt(@TB)) Then
                         TrackPopupMenu(Buttons.Item(i)->DropDownMenu.Handle,0,R.Left,R.Bottom,0,Tbn->hdr.hwndFrom,NULL)
                     End If 
                 End If
            End Select
        Case CM_NEEDTEXT       
            Dim As LPTOOLTIPTEXT TTX
            TTX = Cast(LPTOOLTIPTEXT,Message.lParam)
            TTX->hInst = GetModuleHandle(NULL)
            If TTX->hdr.idFrom Then
                Dim As TBButton TB
                Dim As Integer Index
                Index = Perform(TB_COMMANDTOINDEX,TTX->hdr.idFrom,0)
                If Perform(TB_GETBUTTON,Index,CInt(@TB)) Then
                   If Buttons.Item(Index)->ShowHint Then
                      If Buttons.Item(Index)->Hint <> "" Then
                          'Dim As UString s 
                          's = Buttons.Button(Index).Hint
                          TTX->lpszText = @(Buttons.Item(Index)->Hint)
                      End If
                   End If
                End If
            End If
        End Select
        Base.ProcessMessage(message)
    End Sub

    Sub ToolBar.HandleIsDestroyed(BYREF Sender As Control)
    End Sub

    Sub ToolBar.HandleIsAllocated(BYREF Sender As Control)
        If Sender.Child Then
            With QToolBar(Sender.Child)
                If .ImagesList Then .ImagesList->ParentWindow = .Handle: If .ImagesList->Handle Then .Perform(TB_SETIMAGELIST,0,CInt(.ImagesList->Handle))
                If .HotImagesList Then .HotImagesList->ParentWindow = .Handle: If .HotImagesList->Handle Then .Perform(TB_SETHOTIMAGELIST,0,CInt(.HotImagesList->Handle))
                If .DisabledImagesList Then .DisabledImagesList->ParentWindow = .Handle: If .DisabledImagesList->Handle Then .Perform(TB_SETDISABLEDIMAGELIST,0,CInt(.DisabledImagesList->Handle))
                .Perform(TB_BUTTONSTRUCTSIZE,SizeOF(TBBUTTON),0)
                .Perform(TB_SETEXTENDEDSTYLE, 0, .Perform(TB_GETEXTENDEDSTYLE, 0, 0) OR TBSTYLE_EX_DRAWDDARROWS)
                .Perform(TB_SETBUTTONSIZE,0,MakeLong(.ButtonWidth,.ButtonHeight))
                .Perform(TB_SETBITMAPSIZE,0,MakeLong(.ButtonWidth,.ButtonHeight))
                For i As Integer = 0 To .Buttons.Count -1
                    Dim As TBBUTTON TB
                    'Dim As WString Ptr s = .Buttons.Button(i)->Caption
                    TB.fsState   = .Buttons.Item(i)->State
                    TB.fsStyle   = .Buttons.Item(i)->Style
                    TB.iBitmap   = .Buttons.Item(i)->ImageIndex
                    TB.idCommand = .Buttons.Item(i)->CommandID
                    If .Buttons.Item(i)->Caption <> "" Then
                        TB.iString   = CInt(@.Buttons.Item(i)->Caption)
                    Else
                        TB.iString   = 0
                    End If
                    TB.dwData    = Cast(DWord_Ptr,@.Buttons.Item(i)->DropDownMenu)
                    .Perform(TB_ADDBUTTONS,1,CInt(@TB))
                Next i
                If .AutoSize Then .Perform(TB_AUTOSIZE,0,0)
            End With
        End If
    End Sub

    Operator ToolBar.Cast As Control Ptr 
        Return @This
    End Operator

    Constructor ToolBar
        FButtonWidth    = 16
        FButtonHeight   = 16
        AFlat(0)        = 0
        AFlat(1)        = TBSTYLE_FLAT
        ADivider(0)     = CCS_NODIVIDER
        ADivider(1)     = 0
        AAutosize(0)    = 0
        AAutosize(1)    = TBSTYLE_AUTOSIZE
        AList(0)        = 0
        AList(1)        = TBSTYLE_LIST
        AState(0)       = TBSTATE_INDETERMINATE
        AState(1)       = TBSTATE_ENABLED
        AState(2)       = TBSTATE_HIDDEN
        AState(3)       = TBSTATE_CHECKED
        AState(4)       = TBSTATE_PRESSED
        AState(5)       = TBSTATE_WRAP
        AWrap(0)        = 0
        AWrap(1)        = TBSTYLE_WRAPABLE
        ATransparent(0) = 0
        ATransparent(1) = TBSTYLE_TRANSPARENT
        FTransparent    = 1
        FAutosize       = 1
        FButtonWidth    = 16
        FButtonHeight   = 16
        Buttons.Parent  = This
        FEnabled = True
        With This
            .OnHandleIsAllocated = @HandleIsAllocated
            .OnHandleIsDestroyed = @HandleIsDestroyed
            .RegisterClass "ToolBar", "ToolBarWindow32"
            .Child             = @This
            .ChildProc         = @WndProc
            .ClassName         = "ToolBar"
            .ClassAncestor     = "ToolBarWindow32"
            .ExStyle           = 0
            .Style             = WS_CHILD OR TBSTYLE_TOOLTIPS OR CCS_NOPARENTALIGN OR CCS_NOMOVEY OR AList(FList) Or AAutosize(_Abs(FAutosize)) OR AFlat(_Abs(FFlat)) OR ADivider(_Abs(FDivider)) OR AWrap(_Abs(FWrapable)) OR ATransparent(_Abs(FTransparent))
            .Width             = 121
            .Height            = 26
            '.Font              = @Font
            '.Cursor            = @Cursor
        End With 
    End Constructor

    Destructor ToolBar
        UnregisterClass "ToolBar", GetmoduleHandle(NULL)
    End Destructor
End Namespace

﻿#Include Once "Object.bi"
#Include Once "Bitmap.bi"

Namespace My.Sys.Drawing
    Type Icon Extends My.Sys.Object
        Private:
            FWidth  As Integer
            FHeight As Integer
        Public:
            Graphic As Any Ptr
            Handle  As HICON
            Declare Property Width As Integer
            Declare Property Width(Value As Integer)
            Declare Property Height As Integer
            Declare Property Height(Value As Integer)
            Declare Sub LoadFromFile(ByRef File As WString)
            Declare Sub SaveToFile(ByRef File As WString)
            Declare Sub LoadFromResourceName(ByRef ResName As WString)
            Declare Sub LoadFromResourceID(ResID As Integer)
            Declare Function ToBitmap() As hBitmap
            Declare Operator Cast As Any Ptr
            Declare Operator Let(ByRef Value As WString)
            Declare Operator Let(Value As HICON)
            Declare Constructor
            Declare Destructor
            Changed As Sub(BYREF Sender As Icon)
    End Type

    Property Icon.Width As Integer
        Return FWidth
    End Property

    Property Icon.Width(Value As Integer)
    End Property

    Property Icon.Height As Integer
        Return FWidth
    End Property

    Property Icon.Height(Value As Integer)
    End Property

    Function Icon.ToBitmap() As hBitmap
        Dim As HWND desktop = GetDesktopWindow()
        if (desktop = NULL) Then
            return NULL
        End If
        
        Dim As HDC screen_dev = GetDC(desktop)
        if (screen_dev = NULL) Then
            return NULL
        End If

        ' Create a compatible DC
        Dim As HDC dst_hdc = CreateCompatibleDC(screen_dev)
        if (dst_hdc = NULL) Then
            ReleaseDC(desktop, screen_dev)
            return NULL
        End If

        ' Create a new bitmap of icon size
        Dim As HBITMAP bmp = CreateCompatibleBitmap(screen_dev, 16, 16)
        If (bmp = NULL) Then
            DeleteDC(dst_hdc)
            ReleaseDC(desktop, screen_dev)
            Return NULL
        End If

        'Select it into the compatible DC
        Dim As HBITMAP old_dst_bmp = Cast(HBITMAP, SelectObject(dst_hdc, bmp))
        if (old_dst_bmp = NULL) Then
            return NULL
        End If

        ' Fill the background of the compatible DC with the given colour
        'SetBkColor(dst_hdc, RGB(255, 255, 255))
        'ExtTextOut(dst_hdc, 0, 0, ETO_OPAQUE, @rect, NULL, 0, NULL)

        ' Draw the icon into the compatible DC
        DrawIconEx(dst_hdc, 0, 0, Handle, 16, 16, 0, GetSysColorBrush( COLOR_MENU ), DI_NORMAL)

        ' Restore settings
        SelectObject(dst_hdc, old_dst_bmp)
        DeleteDC(dst_hdc)
        ReleaseDC(desktop, screen_dev)
        'DestroyIcon(hIcon)
        return bmp
    End Function

    Sub Icon.LoadFromFile(ByRef File As WString)
        Dim As ICONINFO ICIF
        Dim As BITMAP BMP
        Handle = LoadImage(0, File, IMAGE_CURSOR, 0, 0, LR_LOADFROMFILE)
        GetIconInfo(Handle, @ICIF)
        GetObject(ICIF.hbmColor, SizeOF(BMP), @BMP)
        FWidth  = BMP.bmWidth
        FHeight = BMP.bmHeight
        If Changed Then Changed(This)
    End Sub

    Sub Icon.SaveToFile(ByRef File As WString)
    End Sub

    Sub Icon.LoadFromResourceName(ByRef ResName As WString)
        Dim As ICONINFO ICIF
        Dim As BITMAP BMP
        Handle = LoadImage(GetModuleHandle(NULL), ResName, IMAGE_ICON, 0, 0, LR_COPYFROMRESOURCE)
        GetIconInfo(Handle, @ICIF)
        GetObject(ICIF.hbmColor, SizeOF(BMP), @BMP)
        FWidth  = BMP.bmWidth
        FHeight = BMP.bmHeight
        If Changed Then Changed(This)
    End Sub

    Sub Icon.LoadFromResourceID(ResID As Integer)
        Dim As ICONINFO ICIF
        Dim As BITMAP BMP
        Handle = LoadImage(GetModuleHandle(NULL), MAKEINTRESOURCE(ResID), IMAGE_ICON, 0, 0, LR_COPYFROMRESOURCE)
        GetIconInfo(Handle, @ICIF)
        GetObject(ICIF.hbmColor, SizeOF(BMP), @BMP)
        FWidth  = BMP.bmWidth
        FHeight = BMP.bmHeight
        If Changed Then Changed(This)
    End Sub

    Operator Icon.Cast As Any Ptr
        Return @This
    End Operator

    Operator Icon.Let(ByRef Value As WString)
        If FindResource(GetModuleHandle(NULL), Value, RT_ICON) Then
           LoadFromResourceName(Value) 
        Else
           LoadFromFile(Value) 
        End If
    End Operator

    Operator Icon.Let(Value As HICON)
        Handle = Value
    End Operator

    Constructor Icon
    End Constructor

    Destructor Icon
    End Destructor
End namespace
﻿'#############################################################################
'#  Menus.bi                                                                 #
'#  MenuItem, MainMenu, PopupMenu                                    #
'#  This file is part of MyFBFramework                                         #
'#  Version 1.0.0                                                            #
'#############################################################################

#Include Once "Component.bi"
#Include Once "ImageList.bi"
#Include Once "win/uxtheme.bi"

type BP_PAINTPARAMS
        cbSize as DWORD
        dwFlags as DWORD
        prcExclude as const RECT ptr
        pBlendFunction as const BLENDFUNCTION ptr
    end type

Using My.Sys.ComponentModel

namespace My.Sys.Forms
type PMenu      as Menu ptr
type PMainMenu  as MainMenu ptr
type PPopupMenu as PopupMenu ptr
type PMenuItem  as MenuItem ptr

    #define QMenuItem(__Ptr__)  *cast(PMenuItem,__Ptr__)
    #define QMenu(__Ptr__)      *cast(PMenu,__Ptr__)
    #define QPopupMenu(__Ptr__) *cast(PPopupMenu,__Ptr__)
    #DEFINE QMainMenu(__Ptr__)     *Cast(PMainMenu,__Ptr__)

    const MIM_BACKGROUND      = &H2
    const MIM_APPLYTOSUBMENUS = &H80000000
    const MIM_MENUDATA        = &H00000008

    type MenuItem extends My.Sys.Object
        Private:
            FInfo       As MENUITEMINFO
            FCount      As integer
            FItems      As PMenuItem ptr
            FCaption    As WString Ptr
            FChecked    As boolean
            FRadioItem  As boolean
            FParent     As PMenuItem
            FEnabled    As boolean
            FVisible    As boolean
            FCommand    As integer
            FMenuIndex  As integer
            FImage     As My.Sys.Drawing.BitmapType
            FImageIndex As Integer
            FImageKey     As WString Ptr
            FOwnerDraw  As integer
        Protected:
            FHandle         As HMENU
            FMenu           As HMENU
            FOwner          As PMenu
        Public:
            Tag As Any Ptr
            declare property Owner as PMenu
            declare property Owner(value as PMenu)
            declare property Menu as HMENU
            declare property Menu(value as HMENU)
            declare property Parent as PMenuItem
            declare property Parent(value as PMenuItem)
            declare property Command as integer
            declare property Command(value as integer)
            declare property MenuIndex as integer
            declare property MenuIndex(value as integer)
            declare property Image as My.Sys.Drawing.BitmapType
            declare property Image(value As My.Sys.Drawing.BitmapType)
            declare property ImageIndex as Integer
            declare property ImageIndex(value As Integer)
            declare property ImageKey ByRef As WString
            declare property ImageKey(ByRef value As WString)
            declare property Handle as HMENU
            declare property Handle(value as HMENU)
            declare property Caption ByRef As WString
            declare property Caption(ByRef value As WString)
            declare property Checked as boolean
            declare property Checked(value as boolean)
            declare property RadioItem as boolean
            declare property RadioItem(value as boolean)
            declare property Enabled as boolean
            declare property Enabled(value as boolean)
            declare property Visible as boolean
            declare property Visible(value As boolean)
            declare property Count as integer
            declare property Count(value as integer)
            declare property Item(index as integer) as PMenuItem
            declare property Item(index as integer, value as PMenuItem)
            declare sub Click
            declare Function Add(ByRef sCaption As WString) As MenuItem Ptr
            declare Function Add(ByRef sCaption As WString, iImage As My.Sys.Drawing.BitmapType, sKey As String = "", eClick As NotifyEvent = Null) As MenuItem Ptr
            declare Function Add(ByRef sCaption As WString, iImageIndex As Integer, sKey As String = "", eClick As NotifyEvent = Null) As MenuItem Ptr
            declare Function Add(ByRef sCaption As WString, ByRef sImageKey As WString, sKey As String = "", eClick As NotifyEvent = Null) As MenuItem Ptr
            declare sub Add(value as PMenuItem)
            declare sub Add(value() As PMenuItem)
            declare sub AddRange Cdecl(CountArgs As Integer, ...)
            declare sub Remove(value as PMenuItem)
            declare sub Insert(index as integer, value as PMenuItem)
            declare sub Clear
            declare sub SetInfo(byref value as MENUITEMINFO)
            declare sub SetItemInfo(byref value as MENUITEMINFO)
            declare function IndexOf(value as PMenuItem) as integer
            declare function Find(value  as integer) as PMenuItem
            declare operator cast as any ptr
            declare constructor
            declare destructor
            OnClick as NotifyEvent
    End Type

    Type Menu Extends Component
        Private:
            FCount   as integer
            FItems   as PMenuItem ptr
        Protected:
            FInfo    as MENUINFO
            FHandle  as HMENU
            FStyle   as integer
            FColor   as integer
            FParentWindow as HWND
            FIncSubItems  as integer
            declare sub ProcessMessage(byref message as Message)
        Public:
            ImagesList       As ImageList Ptr
            declare property ParentWindow as hwnd
            declare property ParentWindow(value as hwnd)
            declare property Handle as HMENU
            declare property Handle(value as HMENU)
            declare property Style as integer
            declare property Style(value as integer)
            declare property ColorizeEntire as integer
            declare property ColorizeEntire(value as integer)
            declare property Color as integer
            declare property Color(value as integer)
            declare property Count as integer
            declare property Count(value as integer)
            declare property Item(index as integer) as PMenuItem
            declare property Item(index as integer, value as PMenuItem)
            declare Function Add(ByRef sCaption As WString) As MenuItem Ptr
            declare Function Add(ByRef sCaption As WString, iImage As My.Sys.Drawing.BitmapType, sKey As String = "", eClick As NotifyEvent = Null) As MenuItem Ptr
            declare Function Add(ByRef sCaption As WString, iImageIndex As Integer, sKey As String = "", eClick As NotifyEvent = Null) As MenuItem Ptr
            declare Function Add(ByRef sCaption As WString, ByRef sImageKey As WString, sKey As String = "", eClick As NotifyEvent = Null) As MenuItem Ptr
            declare sub Add(value as PMenuItem)
            declare sub Add(value() As PMenuItem)
            declare sub AddRange Cdecl(CountArgs As Integer, ...)
            declare sub Remove(value as PMenuItem)
            declare sub Insert(index as integer, value as PMenuItem)
            declare sub Clear
            declare function IndexOf(value as PMenuItem) as integer
            declare function Find(value  as integer) as PMenuItem
            declare operator cast as any ptr
            declare constructor
            declare destructor
            OnActivate as NotifyEvent
    End Type

    Type MainMenu Extends Menu
        Private:
            FParent As hwnd
        Protected:
        Public:
            declare sub ProcessMessages(byref message as Message)
            declare property Parent as hwnd
            declare property Parent(value as hwnd)
            declare operator cast as any ptr
            declare constructor
            declare destructor
    End Type

    Type PopupMenu Extends Menu
        Private:
            FWindow as hwnd
        Protected:
        Public:
            declare property Window as hwnd
            declare property Window(value as hwnd)
            declare sub Popup(x as integer, y as integer)
            declare sub ProcessMessages(byref message as Message)
            declare operator cast as any ptr
            declare constructor
            declare destructor
            OnPopup As NotifyEvent
            OnDropDown As NotifyEvent
    End Type

    /' Global '/
    Sub AllocateCommand(value as PMenuItem)
        Static as integer uniqueId
        If uniqueId = 0 Then uniqueId = 999
        If value Then
            if(value->Command <= 0) then
                value->Command = uniqueId + 1
                uniqueId = value->Command
            End If   
        End If   
    End Sub

    Sub TraverseItems(Item As MenuItem)
        Dim As MenuItemInfo mii
        mii.cbsize = SizeOf(mii)
        mii.fMask  = MIIM_TYPE
        For i As Integer = 0 To Item.Count-1
            GetMenuItemInfo(Item.Handle,Item.Item(i)->MenuIndex,true,@mii)
            mii.fType = iif((mii.fType and MFT_SEPARATOR),MFT_SEPARATOR,MFT_OWNERDRAW)
            SetMenuItemInfo(Item.Handle,Item.Item(i)->MenuIndex,true,@mii)
            TraverseItems(*Item.Item(i))
        Next i
    End Sub

    /' MenuItem '/
    Sub MenuItem.SetInfo(ByRef value As MENUITEMINFO)
        If *FCaption = "" Then
            *FCaption = Chr(0)
        End If
        value.cbSize      = SizeOf(value)
        value.fMask       = iif(Handle,MIIM_SUBMENU,MIIM_ID) or MIIM_FTYPE Or MIIM_BITMAP Or MIIM_STRING Or MIIM_DATA or MIIM_STATE
        value.hSubMenu    = Handle
        value.fType       = iif(*FCaption = "-", MFT_SEPARATOR, MFT_STRING)
        value.fState      = iif(FEnabled, MFS_ENABLED, MFS_DISABLED) or iif(FChecked, MFS_CHECKED, MFS_UNCHECKED)
        value.wID         = iif(Handle, -1, This.Command)
        If FImageIndex <> - 1 AndAlso owner AndAlso owner->imageslist Then FImage = owner->imageslist->GetIcon(FImageIndex).ToBitmap
        Value.hbmpItem     = FImage.Handle 'IIf(FImageIndex <> - 1, HBMMENU_CALLBACK, FImage.Handle)
        value.dwItemData  = Cast(dword_Ptr, Cast(Any Ptr, @this))
        value.dwTypeData  = FCaption
        value.cch         = Len(*FCaption)
    end sub

    Sub MenuItem.SetItemInfo(ByRef value As MENUITEMINFO)
        If Parent AndAlso Parent->Handle Then
            SetMenuItemInfo(Parent->Handle, FMenuIndex, True, @value)
        Else
            SetMenuItemInfo(This.Menu, FMenuIndex, True, @value)
        End If
    End Sub

    property MenuItem.MenuIndex as integer
        return FMenuIndex
    end property

    property MenuItem.MenuIndex(value as integer)
        FMenuIndex = value
    end property

'    declare function BeginPanningFeedback(byval hwnd as HWND) as WINBOOL
'    declare function UpdatePanningFeedback(byval hwnd as HWND, byval lTotalOverpanOffsetX as LONG, byval lTotalOverpanOffsetY as LONG, byval fInInertia as WINBOOL) as WINBOOL
'    declare function EndPanningFeedback(byval hwnd as HWND, byval fAnimateBack a-s WINBOOL) as WINBOOL
'
'    const GBF_DIRECT = &h00000001
'    const GBF_COPY = &h00000002
'    const GBF_VALIDBITS = GBF_DIRECT or GBF_COPY
'
'    declare function GetThemeBitmap(byval hTheme as HTHEME, byval iPartId as long, byval iStateId as long, byval iPropId as long, byval dwFlags as ULONG, byval phBitmap as HBITMAP ptr) as HRESULT
'    declare function GetThemeStream(byval hTheme as HTHEME, byval iPartId as long, byval iStateId as long, byval iPropId as long, byval ppvStream as any ptr ptr, byval pcbStream as DWORD ptr, byval hInst as HINSTANCE) as HRESULT
'    declare function GetThemeTransitionDuration(byval hTheme as HTHEME, byval iPartId as long, byval iStateIdFrom as long, byval iStateIdTo as long, byval iPropId as long, byval pdwDuration as DWORD ptr) as HRESULT
'
'    type HPAINTBUFFER__
'        unused as long
'    end type
'
'    type HPAINTBUFFER as HPAINTBUFFER__ ptr
'
'    type _BP_BUFFERFORMAT as long
'    enum
'        BPBF_COMPATIBLEBITMAP
'        BPBF_DIB
'        BPBF_TOPDOWNDIB
'        BPBF_TOPDOWNMONODIB
'    end enum
'
'    type BP_BUFFERFORMAT as _BP_BUFFERFORMAT
'    const BPPF_ERASE = &h00000001
'    const BPPF_NOCLIP = &h00000002
'    const BPPF_NONCLIENT = &h00000004
'
'    type _BP_PAINTPARAMS
'        cbSize as DWORD
'        dwFlags as DWORD
'        prcExclude as const RECT ptr
'        pBlendFunction as const BLENDFUNCTION ptr
'    end type
'
'    type BP_PAINTPARAMS as _BP_PAINTPARAMS
'    type PBP_PAINTPARAMS as _BP_PAINTPARAMS ptr
'    declare function BeginBufferedPaint(byval hdcTarget as HDC, byval prcTarget as const RECT ptr, byval dwFormat as BP_BUFFERFORMAT, byval pPaintParams as BP_PAINTPARAMS ptr, byval phdc as HDC ptr) as HPAINTBUFFER
'    declare function EndBufferedPaint(byval hBufferedPaint as HPAINTBUFFER, byval fUpdateTarget as WINBOOL) as HRESULT
'    declare function GetBufferedPaintTargetRect(byval hBufferedPaint as HPAINTBUFFER, byval prc as RECT ptr) as HRESULT
'    declare function GetBufferedPaintTargetDC(byval hBufferedPaint as HPAINTBUFFER) as HDC
'    declare function GetBufferedPaintDC(byval hBufferedPaint as HPAINTBUFFER) as HDC
'    declare function GetBufferedPaintBits(byval hBufferedPaint as HPAINTBUFFER, byval ppbBuffer as RGBQUAD ptr ptr, byval pcxRow as long ptr) as HRESULT
'    declare function BufferedPaintClear(byval hBufferedPaint as HPAINTBUFFER, byval prc as const RECT ptr) as HRESULT
'    declare function BufferedPaintSetAlpha(byval hBufferedPaint as HPAINTBUFFER, byval prc as const RECT ptr, byval alpha as UBYTE) as HRESULT
'    declare function BufferedPaintInit() as HRESULT
'    declare function BufferedPaintUnInit() as HRESULT
'
'    type HANIMATIONBUFFER__
'        unused as long
'    end type
'
'    type HANIMATIONBUFFER as HANIMATIONBUFFER__ ptr
'
'    type _BP_ANIMATIONSTYLE as long
'    enum
'        BPAS_NONE
'        BPAS_LINEAR
'        BPAS_CUBIC
'        BPAS_SINE
'    end enum
'
'    type BP_ANIMATIONSTYLE as _BP_ANIMATIONSTYLE
'
'    type _BP_ANIMATIONPARAMS
'        cbSize as DWORD
'        dwFlags as DWORD
'        style as BP_ANIMATIONSTYLE
'        dwDuration as DWORD
'    end type
'
'    type BP_ANIMATIONPARAMS as _BP_ANIMATIONPARAMS
'    type PBP_ANIMATIONPARAMS as _BP_ANIMATIONPARAMS ptr
'    declare function BeginBufferedAnimation(byval hwnd as HWND, byval hdcTarget as HDC, byval rcTarget as const RECT ptr, byval dwFormat as BP_BUFFERFORMAT, byval pPaintParams as BP_PAINTPARAMS ptr, byval pAnimationParams as BP_ANIMATIONPARAMS ptr, byval phdcFrom as HDC ptr, byval phdcTo as HDC ptr) as HANIMATIONBUFFER
'    declare function EndBufferedAnimation(byval hbpAnimation as HANIMATIONBUFFER, byval fUpdateTarget as WINBOOL) as HRESULT
'    declare function BufferedPaintRenderAnimation(byval hwnd as HWND, byval hdcTarget as HDC) as WINBOOL
'    declare function BufferedPaintStopAllAnimations(byval hwnd as HWND) as HRESULT
'    declare function IsCompositionActive() as WINBOOL
'
'    type WINDOWTHEMEATTRIBUTETYPE as long
'    enum
'        WTA_NONCLIENT = 1
'    end enum
'
'    type WTA_OPTIONS
'        dwFlags as DWORD
'        dwMask as DWORD
'    end type
'
'    type PWTA_OPTIONS as WTA_OPTIONS ptr
'    const WTNCA_NODRAWCAPTION = &h00000001
'    const WTNCA_NODRAWICON = &h00000002
'    const WTNCA_NOSYSMENU = &h00000004
'    const WTNCA_NOMIRRORHELP = &h00000008
'    const WTNCA_VALIDBITS = ((WTNCA_NODRAWCAPTION or WTNCA_NODRAWICON) or WTNCA_NOSYSMENU) or WTNCA_NOMIRRORHELP
'    declare function SetWindowThemeAttribute(byval hwnd as HWND, byval eAttribute as WINDOWTHEMEATTRIBUTETYPE, byval pvAttribute as PVOID, byval cbAttribute as DWORD) as HRESULT
'
'    private function SetWindowThemeNonClientAttributes cdecl(byval hwnd as HWND, byval dwMask as DWORD, byval dwAttributes as DWORD) as HRESULT
'        dim wta as WTA_OPTIONS = (dwAttributes, dwMask)
'        return SetWindowThemeAttribute(hwnd, WTA_NONCLIENT, @wta, sizeof(WTA_OPTIONS))
'    end function
'    
'    Sub InitBitmapInfo(pbmi As BITMAPINFO Ptr, cbInfo As ULONG, cx As LONG, cy As LONG, bpp As WORD)
'            ZeroMemory(pbmi, cbInfo)
'            pbmi->bmiHeader.biSize = sizeof(BITMAPINFOHEADER)
'            pbmi->bmiHeader.biPlanes = 1
'            pbmi->bmiHeader.biCompression = BI_RGB
'
'            pbmi->bmiHeader.biWidth = cx
'            pbmi->bmiHeader.biHeight = cy
'            pbmi->bmiHeader.biBitCount = bpp
'    End Sub
'
'    Function Create32BitHBITMAP(hdc1 As HDC, psize As SIZE Ptr, ppvBits as any ptr ptr, phBmp As HBITMAP Ptr) As HRESULT
'            *phBmp = NULL
'
'            Dim As BITMAPINFO bmi
'            InitBitmapInfo(@bmi, sizeof(bmi), psize->cx, psize->cy, 32)
'
'            Dim As HDC hdcUsed = IIF(hdc1, hdc1, GetDC(NULL))
'            if (hdcUsed) Then
'                *phBmp = CreateDIBSection(hdcUsed, @bmi, DIB_RGB_COLORS, ppvBits, NULL, 0)
'                if (Not hdc1 = hdcUsed) Then
'                    ReleaseDC(NULL, hdcUsed)
'                End IF
'            End If
'            return IIF(NULL = *phBmp, E_OUTOFMEMORY, S_OK)
'    End Function
'    
'    type ARGB as DWORD
'
'    Function ConvertToPARGB32(hdc As HDC, pargb As ARGB Ptr, hbmp As HBITMAP, sizImage As SIZE, cxRow As Integer) As HRESULT
'        Dim As BITMAPINFO bmi
'        InitBitmapInfo(@bmi, sizeof(bmi), sizImage.cx, sizImage.cy, 32)
'    
'        Dim As HRESULT hr = E_OUTOFMEMORY
'        Dim As HANDLE hHeap = GetProcessHeap()
'        Var pvBits = HeapAlloc(hHeap, 0, bmi.bmiHeader.biWidth * 4 * bmi.bmiHeader.biHeight)
'        if (pvBits) Then
'            hr = E_UNEXPECTED
'            if (GetDIBits(hdc, hbmp, 0, bmi.bmiHeader.biHeight, pvBits, @bmi, DIB_RGB_COLORS) = bmi.bmiHeader.biHeight) Then
'                Dim As ULONG cxDelta = cxRow - bmi.bmiHeader.biWidth
'                Dim As ARGB Ptr pargbMask = Cast(ARGB Ptr, pvBits)
'    
'                for y As ULong = bmi.bmiHeader.biHeight To 1 Step -1
'                    for x As ULong = bmi.bmiHeader.biWidth To 1 Step -1
'                    *pargbMask += 1
'                    *pargb += 1
'                        if *pargbMask Then
'                            ' transparent pixel
'                            *pargb = 0
'                        else
'                            ' opaque pixel
'                            *pargb Or= -16777216
'                        End If
'                    Next
'    
'                    pargb += cxDelta
'                Next
'    
'                hr = S_OK
'            End If
'    
'            HeapFree(hHeap, 0, pvBits)
'        End If
'    
'        return hr
'    End Function
'    
'    Function HasAlpha(pargb As ARGB Ptr, sizImage As SIZE, cxRow As Integer) As Boolean
'        Dim As ULONG cxDelta = cxRow - sizImage.cx
'        for y As ULONG = sizImage.cy To 1 Step -1
'            for x As ULONG = sizImage.cx To 1 Step -1
'            *pargb += 1
'                if (*pargb And -16777216) Then
'                    return true
'                End If
'            Next
'    
'            pargb += cxDelta
'        Next
'    
'        return false
'    End Function
'    
'    Function ConvertBufferToPARGB32(hPaintBuffer As HPAINTBUFFER, hdc As HDC, hicon As HICON, sizIcon As SIZE) As HRESULT
'        Dim As RGBQUAD Ptr prgbQuad
'        Dim As integer cxRow
'        Dim As HRESULT hr = GetBufferedPaintBits(hPaintBuffer, @prgbQuad, @cxRow)
'        if (SUCCEEDED(hr)) Then
'            Dim As ARGB Ptr pargb = Cast(ARGB Ptr, prgbQuad)
'            if (Not HasAlpha(pargb, sizIcon, cxRow)) Then
'                Dim As ICONINFO info
'                if (GetIconInfo(hicon, @info)) Then
'                    if (info.hbmMask) Then
'                        hr = ConvertToPARGB32(hdc, pargb, info.hbmMask, sizIcon, cxRow)
'                    End If
'    
'                    DeleteObject(info.hbmColor)
'                    DeleteObject(info.hbmMask)
'                End If
'            End If
'        End If
'    
'        return hr
'    End Function
'
'    Function MyIcon As Boolean
'        Dim As HRESULT hr = E_OUTOFMEMORY
'        Dim As HBITMAP hbmp = NULL
'        Dim As HICON hicon
'            Dim As SIZE sizIcon
'            sizIcon.cx = GetSystemMetrics(SM_CXSMICON)
'            sizIcon.cy = GetSystemMetrics(SM_CYSMICON)
'
'            Dim As RECT rcIcon
'            SetRect(@rcIcon, 0, 0, sizIcon.cx, sizIcon.cy)
'
'            Dim As HDC hdcDest = CreateCompatibleDC(NULL)
'        if (hdcDest) Then
'            hr = Create32BitHBITMAP(hdcDest, @sizIcon, NULL, @hbmp)
'            if (SUCCEEDED(hr)) Then
'                    hr = E_FAIL
'
'                    Dim As HBITMAP hbmpOld = Cast(HBITMAP, SelectObject(hdcDest, hbmp))
'                    if (hbmpOld) Then
'                            Dim As BLENDFUNCTION bfAlpha
'                    bfAlpha.BlendOp = AC_SRC_OVER
'                    bfAlpha.SourceConstantAlpha = 255
'                    bfAlpha.AlphaFormat = AC_SRC_ALPHA
'                            Dim paintParams As BP_PAINTPARAMS
'                        paintParams.cbSize = sizeof(paintParams)
'                        paintParams.dwFlags = BPPF_ERASE
'                        paintParams.pBlendFunction = @bfAlpha
'
'                        Dim As HDC hdcBuffer
'                        Dim As HPAINTBUFFER hPaintBuffer = BeginBufferedPaint(hdcDest, @rcIcon, BPBF_DIB, @paintParams, @hdcBuffer)
'                        if (hPaintBuffer) Then
'                            if (DrawIconEx(hdcBuffer, 0, 0, hicon, sizIcon.cx, sizIcon.cy, 0, NULL, DI_NORMAL)) Then
'                                hr = ConvertBufferToPARGB32(hPaintBuffer, hdcDest, hicon, sizIcon)
'                              End If
'
'                            EndBufferedPaint(hPaintBuffer, TRUE)
'                            End If
'
'                            SelectObject(hdcDest, hbmpOld)
'                    End If
'                End If
'
'                    DeleteDC(hdcDest)
'                End if
'
'        if (SUCCEEDED(hr)) Then
'                'hr = AddBitmapToMenuItem(hmenu, iMenuItem, fByPosition, hbmp)
'        End If
'
'            if (FAILED(hr)) Then
'                DeleteObject(hbmp)
'                hbmp = NULL
'            End If
'
'            DestroyIcon(hicon)
'
'            'if (phbmp) Then *phbmp = hbmp
'
'            return hr
'    End Function

    property MenuItem.Image As My.Sys.Drawing.BitmapType
        return FImage
    end property
        
    property MenuItem.Image(value As My.Sys.Drawing.BitmapType)
        FImage = value
        DIM mii AS MENUITEMINFOW
        mii.cbSize = SIZEOF(mii)
        mii.fMask = MIIM_BITMAP
        mii.hbmpItem = value.Handle
               
        SetItemInfo mii
    end property

    property MenuItem.ImageIndex As Integer
        return FImageIndex
    end property

    property MenuItem.ImageIndex(value As Integer)
        FImageIndex = value
        If value <> -1 AndAlso owner AndAlso owner->imageslist Then
            FImage = owner->imageslist->GetIcon(value).ToBitmap
    
            DIM mii AS MENUITEMINFOW
            mii.cbSize = SIZEOF(mii)
            mii.fMask = MIIM_BITMAP
            mii.hbmpItem = FImage 'HBMMENU_CALLBACK
               
            SetItemInfo mii
        End if
    end property

    property MenuItem.ImageKey ByRef As WString
        return *FImageKey
    end property

    property MenuItem.ImageKey(ByRef value As WString)
        WLet FImageKey, value
        If value <> "" AndAlso owner AndAlso owner->imageslist Then
            ImageIndex = owner->imageslist->IndexOf(value)
        End if
    end property

    property MenuItem.Command as integer
        return FCommand
    end property

    property MenuItem.Command(value as integer)
        FCommand = value
    end property

    property MenuItem.Handle as HMENU
        return FHandle
    end property

    property MenuItem.Handle(value as HMENU)
        FHandle = value
    end property

    property MenuItem.Owner as PMenu
        return FOwner
    end property

    property MenuItem.Owner(value as PMenu)
        FOwner = value
    end property

    property MenuItem.Menu as HMENU
        return FMenu
    end property

    property MenuItem.Menu(value as HMENU)
        FMenu = value
    end property

    property MenuItem.Parent as PMenuItem
        return FParent
    end property

    property MenuItem.Parent(value as PMenuItem)
        dim as PMenuItem SaveParent = FParent
        FParent = value
        if SaveParent then SaveParent->Remove(this)
        if FParent then FParent->Add(this)
    end property

    property MenuItem.Caption ByRef As WString
        return *FCaption
    end property

    property MenuItem.Caption(ByRef value As WString)
        FCaption = ReAllocate(FCaption, (Len(value) + 1) * SizeOf(WString))
        *FCaption = value
        FInfo.dwTypeData = FCaption
        FInfo.cch        = Len(*FCaption)
        if Parent then
            SetMenuItemInfo(Parent->Handle, MenuIndex, true, @FInfo)
        else
            SetMenuItemInfo(This.Menu, MenuIndex, true, @FInfo)
        end if
        If Owner Then
            DrawMenuBar(Owner->Parentwindow)
        End if
    end property

    property MenuItem.Checked as boolean
        return FChecked
    end property

    property MenuItem.Checked(value as boolean)
        Dim As Integer FCheck(-1 to 1) =>{MF_CHECKED, MF_UNCHECKED, MF_CHECKED}
        FChecked = value
        If Parent Then
            If Handle Then
                CheckMenuItem(Parent->Handle,cint(Handle),MF_POPUP or FCheck(FChecked))
            Else
                CheckMenuItem(Parent->Handle,MenuIndex,MF_BYPOSITION or FCheck(FChecked))
            End If
        End If
    End Property

    Property MenuItem.RadioItem As Boolean
        Return FRadioItem
    End Property

    property MenuItem.RadioItem(value as boolean)
        FRadioItem = value
        dim as integer First,Last
        if Parent then
           First = Parent->Item(0)->MenuIndex
           Last  = Parent->Item(Parent->Count-1)->MenuIndex
           CheckMenuRadioItem(Parent->Handle, First, Last, MenuIndex, MF_BYPOSITION)
        end if
    end property

    property MenuItem.Enabled as boolean
        return FEnabled
    end property

    property MenuItem.Enabled(value as boolean)
        dim as integer FEnable(0 to 1) => {MF_DISABLED Or MF_GRAYED, MF_ENABLED}
        FEnabled = value
        if Parent then
            EnableMenuItem(Parent->Handle, MenuIndex, mf_byposition Or FEnable(Abs_(FEnabled)))
        else
            EnableMenuItem(This.Menu, MenuIndex, mf_byposition Or FEnable(Abs_(FEnabled)))
        end if
        If Owner Then
            DrawMenuBar(Owner->Parentwindow)
        End if
    end property

    property MenuItem.Visible as boolean
        return FVisible
    end property

    property MenuItem.Visible(value as boolean)
        if fvisible = value then exit property
        FVisible = value
        if FVisible = false then
           if Parent then
              RemoveMenu(Parent->Handle,MenuIndex,MF_BYPOSITION)
           else
              RemoveMenu(This.Menu,MenuIndex,MF_BYPOSITION)
           end if
        else
           SetInfo(FInfo)
           SetItemInfo(FInfo)
        end if
    end property

    property MenuItem.Count as integer
        return FCount
    end property

    property MenuItem.Count(value as integer)
    end property

    property MenuItem.Item(index as integer) as PMenuItem
        if (index > -1) and (index  <FCount) then
            return FItems[index]
        end if
        return NULL
    end property

    property MenuItem.Item(index as integer,value as PMenuItem)
    end property

    sub MenuItem.Click
        if onClick then onClick(this)
    end sub
    
    sub MenuItem.Add(value as PMenuItem)
        if IndexOf(value) = -1 then
            FCount += 1
               FItems = reallocate(FItems, sizeof(PMenuItem)*FCount)
               FItems[FCount-1] = value
               value->Parent    = @this
               value->MenuIndex = FCount -1
               value->Owner     = Owner
               value->Menu      = This.Menu
               AllocateCommand(value)
               if FCount > 0 then
                if Handle = 0 then
                    Handle = CreatePopupMenu
                       dim as menuinfo mif
                       mif.cbSize     = sizeof(mif)
                       mif.dwmenudata = cast(dword_Ptr,cast(any ptr,@this))
                       mif.fMask      = MIM_MENUDATA
                       .SetMenuInfo(Handle, @mif)
                       SetInfo(FInfo)
                       SetItemInfo(FInfo)
               end if
           end if
           value->SetInfo(FInfo)
           InsertMenuItem(Handle, FCount - 1, true, @FInfo)
        end if
    end sub

    Function MenuItem.Add(ByRef sCaption As WString) As MenuItem Ptr
        Dim As MenuItem Ptr Value = New MenuItem
        WLet Value->FCaption, sCaption
        Add(Value)
        Return Value
    End Function
    
    Function MenuItem.Add(ByRef sCaption As WString, iImage As My.Sys.Drawing.BitmapType, sKey As String = "", eClick As NotifyEvent = Null) As MenuItem Ptr
        Dim As MenuItem Ptr Value = New MenuItem
        WLet Value->FCaption, sCaption
        Value->FImage     = iImage
        Value->Name     = sKey
        Value->OnClick     = eClick
        Add(Value)
        Return Value
    End Function
    
    Function MenuItem.Add(ByRef sCaption As WString, iImageIndex As Integer, sKey As String = "", eClick As NotifyEvent = Null) As MenuItem Ptr
        Dim As MenuItem Ptr Value = New MenuItem
        WLet Value->FCaption, sCaption
        Value->FImageIndex = iImageIndex
        Value->Name     = sKey
        Value->OnClick     = eClick
        Add(Value)
        Return Value
    End Function

    Function MenuItem.Add(ByRef sCaption As WString, ByRef sImageKey As WString, sKey As String = "", eClick As NotifyEvent = Null) As MenuItem Ptr
        Dim As MenuItem Ptr Value = New MenuItem
        WLet Value->FCaption, sCaption
        WLet Value->FImageKey, sImageKey
        If Owner AndAlso Owner->ImagesList Then Value->FImageIndex = Owner->ImagesList->IndexOf(sImageKey)
        Value->Name     = sKey
        Value->OnClick     = eClick
        Add(Value)
        Return Value
    End Function

    sub MenuItem.Add(value() As PMenuItem)
        For i as integer = 0 to Ubound(value)
            Add(value(i))
        Next
    end sub

    #IfnDef __FB_64BIT__
    sub MenuItem.AddRange Cdecl(CountArgs As Integer, ...)
        Dim value As Any Ptr
        value = Va_first()
        For i as integer = 1 to CountArgs
            Add(Va_arg(value, PMenuItem))
            value = Va_next(value, Long)
        Next
    end sub
    #EndIf
    
    sub MenuItem.Insert(Index as Integer, value as PMenuItem)
        if IndexOf(value) = -1 then
           if (Index>-1) and (Index<FCount) then
              FCount += 1
              FItems = reallocate(FItems,sizeof(PMenuItem)*FCount)
              for i as integer = Index+1 to FCount-1
                 FItems[i] = FItems[i-1]
              next i
              FItems[Index]            = value
              FItems[Index]->MenuIndex = Index
              FItems[Index]->Parent    = @this
              FItems[Index]->Owner     = Owner
              FItems[Index]->Menu      = This.Menu
              AllocateCommand(value)
              if FCount > 0 then
                 if Handle = 0 then
                    Handle = CreatePopupMenu
                    dim as menuinfo mif
                    mif.cbSize     = sizeof(mif)
                    mif.dwmenudata = cast(dword_Ptr,cast(any ptr,@this))
                    mif.fMask      = MIM_MENUDATA
                    .SetMenuInfo(Handle,@mif)
                    SetInfo(FInfo)
                    if Parent then
                       SetMenuItemInfo(Parent->Handle,MenuIndex,true,@FInfo)
                    end if
                 end if
             end if
             value->SetInfo(FInfo)
             InsertMenuItem(Handle,Index,true,@FInfo)
             for i as integer = 0 to FCount-1
                FItems[i]->MenuIndex = i
             next i
          end if
       end if
    end sub

    sub MenuItem.Remove(value as PMenuItem)
        dim as integer Index,i
        dim as PMenuItem FItem
        Index = IndexOf(value)
        if Index <> -1  then
            for i = Index+1 to FCount-1
                FItem = FItems[i]
                FItems[i-1] = FItem
            next i
            FCount -= 1
            FItems  = reallocate(FItems,FCount*sizeof(PMenuItem))
            for i as integer = 0 to FCount-1
                FItems[i]->MenuIndex = i
            next i
        end if
    end sub

    sub MenuItem.Clear
        for i as integer = Count-1 to 0 step -1
            FItems[i] = NULL
        next i
        FItems = callocate(0)
        FCount = 0
    end sub

    function MenuItem.IndexOf(value as PMenuItem) as integer
        dim as Integer i
        for i = 0 to FCount -1
            if FItems[i] = value then return i
        next i
        return -1
    end function

    function MenuItem.Find(value as integer) as PMenuItem
        dim as PMenuItem FItem
        for i as integer = 0 to FCount -1
            if Item(i)->Command = value then return Item(i)
            FItem = Item(i)->Find(value)
            if FItem then if FItem->Command = value then return FItem
        next i
        return NULL
    end function

    operator MenuItem.cast as any ptr
        return @this
    end operator

    constructor MenuItem
        FVisible    = True
        FEnabled    = True
        FChecked    = False
        WLet FCaption, ""
        FImage = 0
        FImageIndex = -1
        WLet FImageKey, ""
    end constructor

    destructor MenuItem
        if FParent then
            FParent->Remove(@this)
        end if
        if FItems then
            delete [] FItems
            FItems = callocate(0)
        end if
        If FCaption Then Deallocate FCaption
        if FHandle then
            DestroyMenu(FHandle)
            FHandle = 0
        end if
    end destructor

    /' Menu '/
    property Menu.Handle as HMENU
        return FHandle
    end property

    property Menu.Handle(value as HMENU)
        FHandle = value
    end property

    property Menu.ParentWindow as hwnd
        return FParentWindow
    end property

    property Menu.ParentWindow(value as hwnd)
        dim as HWND SaveHandle = FParentWindow
        FParentWindow = value
        if value <> SaveHandle then
            SetClassLongPtr(SaveHandle,GCLP_MENUNAME,0)
            SetMenu(SaveHandle,0)
        end if   
        if FHandle then
            SetMenu(ParentWindow,Handle)
            DrawMenuBar(FParentWindow)
            If ImagesList Then ImagesList->ParentWindow = FParentWindow
        end if
    end property

    property Menu.Style as integer
        return FStyle
    end property

    property Menu.Style(value as integer)
        FStyle = value
        if Handle then
            if value then
                for i as integer = 0 to FCount-1
                   TraverseItems(*Item(i))
                next i
            /'else
               for i as integer = 0 to FCount-1
                   TraverseItems(*Item(i))
                next i '/
            end if
            if IsWindow(FParentWindow) then
               SetMenu(FParentWindow,Handle)
               DrawMenuBar(FParentWindow)
            end if
        end if
    end property

    property Menu.Color as integer
        if handle then
            dim as menuinfo mif
            mif.cbSize = sizeof(mif)
            mif.fMask  = MIM_BACKGROUND
            if GetMenuInfo(Handle,@mif) then
                dim as LOGBRUSH lb
                GetObject(mif.hbrBack,sizeof(lb),@lb)
                FColor = lb.lbColor
                return FColor
            end if   
        end if
        return FColor
    end property

    property Menu.Color(value as integer)
        FColor = value
        if Handle then
            dim as menuinfo mif
            mif.cbSize = sizeof(mif)
            GetMenuInfo(Handle,@mif)
            if mif.hbrBack then
                DeleteObject(mif.hbrBack)
            end if   
            mif.hbrBack = CreateSolidBrush(FColor)
            mif.fMask   = MIM_BACKGROUND or iif(FIncSubItems,MIM_APPLYTOSUBMENUS,0)
            SetMenuInfo(Handle,@mif)
            if FParentWindow then
                DrawMenuBar(FParentWindow)
                RedrawWindow(FParentWindow,0,0,rdw_invalidate or rdw_erase)
                UpdateWindow(FParentWindow)
            end if   
        end if   
    end property

    property Menu.ColorizeEntire as integer
        return FIncSubitems
    end property

    property Menu.ColorizeEntire(value as integer)
        FIncSubitems = value
        Color = FColor
    end property

    property Menu.Count as integer
        return FCount
    end property

    property Menu.Count(value as integer)
    end property

    property Menu.Item(index as integer) as MenuItem ptr
         if (index>-1) and (index<FCount) then
             return FItems[Index]
         end if   
         return NULL
    end property

    property Menu.Item(index as integer,value as MenuItem ptr)
        if (index > -1) and (index < FCount) then
            FItems[Index] = value
        end if   
    end property

    sub Menu.Add(value as PMenuItem)
        Dim As MenuItemInfo FInfo
        if IndexOf(value) = -1 then
            FCount          +=1
               FItems           = reallocate(FItems,sizeof(PMenuItem)*FCount)
               FItems[FCount-1] = value
               value->Parent    = Null
               value->MenuIndex = FCount -1
               value->Menu      = Handle
               value->Owner     = @this
               AllocateCommand(value)
               value->SetInfo(FInfo)
            InsertMenuItem(Handle,-1,true,@FInfo)
           for i as integer = 0 to value->Count-1
               value->item(i)->Owner = value->Owner
               value->item(i)->Menu  = Handle
           next i  
           if IsWindow(FParentWindow) then DrawMenuBar(FParentWindow)
        end if
    end sub

    Function Menu.Add(ByRef sCaption As WString) As MenuItem Ptr
        Dim As MenuItem Ptr Value = New MenuItem
        Value->Caption     = sCaption
        Add(Value)
        Return Value
    End Function
    
    Function Menu.Add(ByRef sCaption As WString, iImage As My.Sys.Drawing.BitmapType, sKey As String = "", eClick As NotifyEvent = Null) As MenuItem Ptr
        Dim As MenuItem Ptr Value = New MenuItem
        Value->Image     = iImage
        Value->Caption     = sCaption
        Value->Name     = sKey
        Value->OnClick     = eClick
        Add(Value)
        Return Value
    End Function
    
    Function Menu.Add(ByRef sCaption As WString, iImageIndex As Integer, sKey As String = "", eClick As NotifyEvent = Null) As MenuItem Ptr
        Dim As MenuItem Ptr Value = New MenuItem
        Value->ImageIndex = iImageIndex
        Value->Caption     = sCaption
        Value->Name     = sKey
        Value->OnClick     = eClick
        Add(Value)
        Return Value
    End Function

    Function Menu.Add(ByRef sCaption As WString, ByRef sImageKey As WString, sKey As String = "", eClick As NotifyEvent = Null) As MenuItem Ptr
        Dim As MenuItem Ptr Value = New MenuItem
        If ImagesList Then Value->ImageIndex = ImagesList->IndexOf(sImageKey)
        Value->ImageKey = sImageKey
        Value->Caption = sCaption
        Value->Name     = sKey
        Value->OnClick     = eClick
        Add(Value)
        Return Value
    End Function
        
    sub Menu.Add(value() As PMenuItem)
        For i as integer = 0 to ubound(value)
            Add(value(i))
        next        
    end sub

    #IfnDef __FB_64BIT__
    sub Menu.AddRange Cdecl(CountArgs As Integer, ...)
        Dim value As Any Ptr
        value = Va_first()
        For i as integer = 1 to CountArgs
            Add(Va_arg(value, PMenuItem))
            value = Va_next(value, Long)
        Next
    end sub
    #EndIf

    sub Menu.Insert(Index as integer,value as PMenuItem)
        dim as MenuItemInfo FInfo
        if IndexOf(value) = -1 then
           if (Index>-1) and (Index<FCount) then
              FCount +=1
              FItems = reallocate(FItems,sizeof(PMenuItem)*FCount)
              for i as integer = Index +1 to FCount-1
                 FItems[i] = FItems[i-1]
              next i
              FItems[Index]    = value
              value->MenuIndex = Index
              value->Parent    = NULL
              value->Handle    = iif(value->Handle,value->Handle,CreatePopupMenu)
              value->Menu      = Handle
              value->Owner     = this
              AllocateCommand(value)
                 value->SetInfo(FInfo)
              InsertMenuItem(Handle,Index,true,@FInfo)
              for i as integer = 0 to FCount-1
                  FItems[i]->MenuIndex = i
              next i
              for i as integer = 0 to value->Count-1
                  value->item(i)->Owner = value->Owner
                  value->item(i)->Menu  = Handle
              next i
              if IsWindow(FParentWindow) then DrawMenuBar(FParentWindow)
          end if
       end if
    end sub

    sub Menu.Remove(value as PMenuItem)
        dim as integer Index,i
        dim as PMenuItem FItem
        Index = IndexOf(value)
        if Index <> -1  then
            for i = Index+1 to FCount-1
                FItem      = FItems[i]
                FItems[i-1] = FItem
            next i
            FCount -= 1
            FItems  = reallocate(FItems,FCount*sizeof(PMenuItem))
            for i as integer = 0 to FCount-1
                FItems[i]->MenuIndex = i
            next i
            if IsWindow(FParentWindow) then DrawMenuBar(FParentWindow)
        end if
    end sub

    function Menu.IndexOf(value as PMenuItem) as integer
        for i as integer = 0 to FCount-1
            if FItems[i] = value then return i
        next i
        return -1
    end function

    function Menu.Find(value as integer) as MenuItem ptr
        dim as MenuItem ptr FItem
        for i as integer = 0 to FCount-1
            if Item(i)->Command = value then return Item(i)
            FItem = Item(i)->Find(value)
            if FItem then if FItem->Command = value then return FItem
        next i
        return NULL
    end function

    sub Menu.Clear
        if FItems then
            delete [] FItems
            FItems = callocate(0)
        end if
    end sub

    sub Menu.ProcessMessage(byref message as Message)
        
    end sub

    operator Menu.cast as any ptr
        return @this
    end operator

    constructor Menu
    end constructor

    destructor Menu
        Clear
        if FInfo.hbrBack then DeleteObject(FInfo.hbrBack)
        if FHandle then
            DestroyMenu(FHandle)
            FHandle = 0
        end if   
    end destructor


    /' MainMenu '/
    property MainMenu.Parent As HWND
        return FParent
    end property

    property MainMenu.Parent(value As HWND)
        FParent = value
        if value then
           FParentWindow = value
           if not IsMenu(FHandle) then
               FHandle = CreateMenu
           end if
           if IsWindow(FParentWindow) then
               SetMenu(FParentWindow, FHandle)
               DrawMenuBar(FParentWindow)
           end if
        end if
    end  property

    sub MainMenu.ProcessMessages(byref message as Message)
        dim As PMenuItem I = Find(loword(message.wparam))
        if I then I->Click
    end sub

    operator MainMenu.cast as any ptr
        return @this
    end operator

    constructor MainMenu
        FHandle      = CreateMenu
        ClassName = "MainMenu"
        FIncSubItems = 1
        FColor       = GetSysColor(color_menu)
        FInfo.cbSize = sizeof(FInfo)
        if FInfo.hbrBack then DeleteObject(FInfo.hbrBack)
        FInfo.hbrBack    = CreateSolidBrush(FColor)
        FInfo.dwmenudata = cast(dword_Ptr,cast(any ptr,@this))
        FInfo.fMask      = MIM_BACKGROUND or iif(FIncSubItems,MIM_APPLYTOSUBMENUS,0) or mim_menudata
        SetMenuInfo(FHandle,@FInfo)
    end constructor

    destructor MainMenu
    end destructor


    /' PopupMenu '/
    property PopupMenu.Window as hwnd
        return FWindow
    end  property

    property PopupMenu.Window(value as hwnd)
        FWindow = value
    end  property

    sub PopupMenu.Popup(x as integer,y as integer)
        if FWindow then
            TrackPopupMenuEx(FHandle,0,x,y,FWindow,0)
        end if
    end sub

    sub PopupMenu.ProcessMessages(byref message as Message)
        dim As PMenuItem I = Find(loword(message.wparam))
        if I then I->Click
    end sub

    operator PopupMenu.cast as any ptr
        return @this
    end operator

    constructor PopupMenu
        FHandle = CreatePopupMenu
        ClassName = "PopUpMenu"
        FInfo.cbsize     = sizeof(FInfo)
        FInfo.fmask      = MIM_MENUDATA
        FInfo.dwmenudata = cast(dword_Ptr,cast(any ptr,@this))
        SetMenuInfo(Handle,@FInfo)
    end constructor

    destructor PopupMenu
    end destructor
End namespace

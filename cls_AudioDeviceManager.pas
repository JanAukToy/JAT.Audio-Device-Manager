// ******************************************************************************
// Created by JanAukToy
// [Github] https://github.com/JanAukToy
// ******************************************************************************
unit cls_AudioDeviceManager;

interface

uses
  System.SysUtils, System.Classes, System.Win.ComObj, System.SyncObjs,
  System.Generics.Collections,
  Winapi.Windows, Winapi.ActiveX,

  JanAukToy.MMDeviceAPI;

type
  TAudioDeviceManager = class
  private
    f_DeviceEnumerator: IMMDeviceEnumerator;
    f_DeviceCollection: IMMDeviceCollection;

    f_DeviceCount: Cardinal;

    function GetDeviceByIndex(const a_Index: Integer;
      const a_pDevice: PIMMDevice): Boolean;
    function GetDeviceByID(const a_ID: PWideChar;
      const a_pDevice: PIMMDevice): Boolean;
  public
    constructor Create(const a_CoInitializeExFlag
      : ShortInt = COINIT_APARTMENTTHREADED);
    destructor Destroy; override;

    function GetDeviceCollection(): Boolean;

  end;

implementation

uses
  System.StrUtils, Winapi.PropSys;

{ TAudioDevices }

// *****************************************************************************
// Constructor
constructor TAudioDeviceManager.Create(const a_CoInitializeExFlag
  : ShortInt = COINIT_APARTMENTTHREADED);
begin
  f_DeviceCount := 0;

  // Get COM Class�@https://learn.microsoft.com/ja-jp/windows/win32/coreaudio/enumerating-audio-devices
  if CoCreateInstance(CLSID_IMMDeviceEnumerator, nil, CLSCTX_INPROC_SERVER,
    IID_IMMDeviceEnumerator, f_DeviceEnumerator) <> S_OK then
  begin
    f_DeviceEnumerator := nil;
  end;
end;

// *****************************************************************************
// Destructor
destructor TAudioDeviceManager.Destroy;
begin
  CoUninitialize();

  inherited;
end;

// *****************************************************************************
// Get Device Collection
function TAudioDeviceManager.GetDeviceCollection: Boolean;
var
  ii: Integer;
  l_Device: IMMDevice;
  l_AudioClient: IAudioClient;
  l_State: DWORD;
  l_ID: PWideChar;
  l_pProperty: IPropertyStore;
  l_AudioEndpointVolume: IAudioEndpointVolume;
begin
  Result := False;

  // Init Device Count
  f_DeviceCount := 0;

  // Check Already Get Class
  if Assigned(f_DeviceEnumerator) then
  begin
    // Get Audio Device Collection (Render = Output Sound)
    if (f_DeviceEnumerator.EnumAudioEndpoints(eRender, DEVICE_STATE_ACTIVE,
      f_DeviceCollection) = S_OK) and
    // Get Count on Collection
      (f_DeviceCollection.GetCount(f_DeviceCount) = S_OK) then
    begin


      if GetDeviceByIndex(0, @l_Device) then
      begin
        if l_Device.Activate(IID_IAudioEndpointVolume, CLSCTX_INPROC_SERVER, nil, l_AudioEndpointVolume) = S_OK then
        begin
          Result := True;
        end;
      end;
    end;
  end;
end;

// *****************************************************************************
// Get Device By Collection Index
function TAudioDeviceManager.GetDeviceByIndex(const a_Index: Integer;
  const a_pDevice: PIMMDevice): Boolean;
begin
  if not Assigned(f_DeviceCollection) then
  begin
    Result := False;
    Exit;
  end;

  Result := f_DeviceCollection.Item(a_Index, a_pDevice^) = S_OK;
end;

// *****************************************************************************
// Get Device By ID
function TAudioDeviceManager.GetDeviceByID(const a_ID: PWideChar;
  const a_pDevice: PIMMDevice): Boolean;
begin
  if not Assigned(f_DeviceEnumerator) then
  begin
    Result := False;
    Exit;
  end;

  Result := f_DeviceEnumerator.GetDevice(a_ID, a_pDevice^) = S_OK;
end;

end.

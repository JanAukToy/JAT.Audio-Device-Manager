// *****************************************************************************
// Created by JanAukToy
// [Github] https://github.com/JanAukToy
// *****************************************************************************
unit cmp_PropertiesBox;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.ExtCtrls,

  cls_AudioDevice, cmp_PropertyPanel;

type
  // Language Type
  TLanguageType = (ltEnglish, ltJapanese);

  // Properties Box
  TPropertiesBox = class(TGroupBox)
  private
    f_Device: TAudioDevice;

    procedure SetLanguage(const a_LanguageType: TLanguageType);
      virtual; abstract;
  public
    constructor Create(AOwner: TComponent; const a_Device: TAudioDevice;
      const a_LanguageType: TLanguageType); reintroduce;
    destructor Destroy; override;
    property Language: TLanguageType write SetLanguage;
    procedure RefreshProperties(); virtual; abstract;
  end;

  // Properties Box - Device
  TDevicePropertiesBox = class(TPropertiesBox)
  private
    f_InterfaceFriendlyNamePanel: TPropertyPanel;
    f_DeviceDescPanel: TPropertyPanel;
    f_FriendlyNamePanel: TPropertyPanel;

    procedure SetLanguage(const a_LanguageType: TLanguageType); override;
    procedure OnChangeDeviceDesc(const a_Value: string);
  public
    procedure RefreshProperties(); override;
  end;

  // Properties Box - Audio
  TAdudioPropertiesBox = class(TPropertiesBox)
  private
    f_MasterLevel: TPropertyPanel;
    f_Mute: TPropertyPanel;

    procedure SetLanguage(const a_LanguageType: TLanguageType); override;
    procedure OnChangeMasterLevel(const a_Value: Integer);
    procedure OnChangeMute(const a_Value: Boolean);
  public
    procedure RefreshProperties(); override;
  end;

const
  PITCH_SIZE: Integer = 10;

implementation

uses
  System.StrUtils;

{ TAdudioPropertiesBox }

// *****************************************************************************
// Set LanguageType
procedure TAdudioPropertiesBox.SetLanguage(const a_LanguageType: TLanguageType);
begin
  Self.Caption := IfThen(a_LanguageType = ltEnglish, 'Audio Properties',
    'オーディオ設定');
  f_MasterLevel.PropertyLabel := IfThen(a_LanguageType = ltEnglish,
    'MasterLevel', 'マスターレベル');
  f_Mute.PropertyLabel := IfThen(a_LanguageType = ltEnglish, 'Mute', 'ミュート');
end;

// *****************************************************************************
// OnChange Event - MasterLevel
procedure TAdudioPropertiesBox.OnChangeMasterLevel(const a_Value: Integer);
begin
  f_Device.MasterLevel := a_Value / 100;
end;

// *****************************************************************************
// OnChange Event - Mute
procedure TAdudioPropertiesBox.OnChangeMute(const a_Value: Boolean);
begin
  f_Device.Mute := a_Value;
end;

// *****************************************************************************
// Refresh Props
procedure TAdudioPropertiesBox.RefreshProperties;
begin
  // Destroying
  if Assigned(f_MasterLevel) then
    FreeAndNil(f_MasterLevel);
  if Assigned(f_Mute) then
    FreeAndNil(f_Mute);

  // Create Panels
  f_MasterLevel := TPropertyPanel.Create(Self, 'MasterLevel');
  f_Mute := TPropertyPanel.Create(Self, 'Mute');

  // Set Property
  f_MasterLevel.SetSpinProperty(Round(f_Device.MasterLevel * 100), False,
    OnChangeMasterLevel);
  f_Mute.SetCheckBoxProperty(f_Device.Mute, False, OnChangeMute);

  // Set Parent
  f_MasterLevel.Parent := Self;
  f_Mute.Parent := Self;
end;

{ TDevicePropertiesBox }

// *****************************************************************************
// Set LanguageType
procedure TDevicePropertiesBox.SetLanguage(const a_LanguageType: TLanguageType);
begin
  Self.Caption := IfThen(a_LanguageType = ltEnglish, 'Device Properties',
    'デバイス設定');
  f_InterfaceFriendlyNamePanel.PropertyLabel :=
    IfThen(a_LanguageType = ltEnglish, 'InterfaceFriendlyName', 'アダプター名');
  f_DeviceDescPanel.PropertyLabel := IfThen(a_LanguageType = ltEnglish,
    'DeviceDesc', '説明');
  f_FriendlyNamePanel.PropertyLabel := IfThen(a_LanguageType = ltEnglish,
    'FriendlyName', 'デバイス名');
end;

// *****************************************************************************
// OnChange Event - DeviceDesc
procedure TDevicePropertiesBox.OnChangeDeviceDesc(const a_Value: string);
begin
  f_Device.DeviceDesc := a_Value;
end;

// *****************************************************************************
// Refresh Props
procedure TDevicePropertiesBox.RefreshProperties;
begin
  // Destroying
  if Assigned(f_InterfaceFriendlyNamePanel) then
    FreeAndNil(f_InterfaceFriendlyNamePanel);
  if Assigned(f_DeviceDescPanel) then
    FreeAndNil(f_DeviceDescPanel);
  if Assigned(f_FriendlyNamePanel) then
    FreeAndNil(f_FriendlyNamePanel);

  // Create Panels
  f_InterfaceFriendlyNamePanel := TPropertyPanel.Create(Self,
    'InterfaceFriendlyName');
  f_DeviceDescPanel := TPropertyPanel.Create(Self, 'DeviceDesc');
  f_FriendlyNamePanel := TPropertyPanel.Create(Self, 'FriendlyName');

  // Set Property
  f_InterfaceFriendlyNamePanel.SetTextProperty(f_Device.InterfaceFriendlyName,
    True, nil);
  f_DeviceDescPanel.SetTextProperty(f_Device.DeviceDesc, False,
    OnChangeDeviceDesc);
  f_FriendlyNamePanel.SetTextProperty(f_Device.FriendlyName, True, nil);

  // Set Parent
  f_InterfaceFriendlyNamePanel.Parent := Self;
  f_DeviceDescPanel.Parent := Self;
  f_FriendlyNamePanel.Parent := Self;
end;

{ TPropertiesBox }

// *****************************************************************************
// Constructor
constructor TPropertiesBox.Create(AOwner: TComponent;
  const a_Device: TAudioDevice; const a_LanguageType: TLanguageType);
begin
  inherited Create(AOwner);

  // Setting
  Self.Align := alLeft;
  Self.AlignWithMargins := True;
  Self.Margins.SetBounds(PITCH_SIZE, PITCH_SIZE, PITCH_SIZE, PITCH_SIZE);
  Self.Padding.SetBounds(PITCH_SIZE, PITCH_SIZE, PITCH_SIZE, PITCH_SIZE);

  // Store Argments
  f_Device := a_Device;

  // Refresh Properties
  RefreshProperties();

  // Set Language
  SetLanguage(a_LanguageType);
end;

// *****************************************************************************
// Destructor
destructor TPropertiesBox.Destroy;
begin
  inherited;
end;

end.

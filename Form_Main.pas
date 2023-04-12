//******************************************************************************
// Created by JanAukToy
// [Github] https://github.com/JanAukToy
//******************************************************************************
unit Form_Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,

  cls_SoundDevices;

type
  TFormMain = class(TForm)
    TrayIcon1: TTrayIcon;
    pnl_Client: TPanel;
    GroupBox1: TGroupBox;
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private 宣言 }
    f_SoundDevices: TSoundDevices;
  public
    { Public 宣言 }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

//******************************************************************************
// コンストラクター
procedure TFormMain.FormCreate(Sender: TObject);
begin
  // サウンドデバイスインスタンス生成
  f_SoundDevices := TSoundDevices.Create;

  // デバイスコレクション取得
  if f_SoundDevices.GetDeviceCollection then
  begin

  end;
end;

//******************************************************************************
// デストラクター
procedure TFormMain.FormDestroy(Sender: TObject);
begin
  ;
end;

end.

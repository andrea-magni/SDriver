(*
  Copyright 2016, Andrea Magni
  https://github.com/andrea-magni/SlackDriver
*)
unit SlackDriver.Interfaces;

interface

uses
  Classes, SysUtils, System.JSON
;

type
  IFields = interface ['{24B67E58-373C-4783-A3C5-AF56456041AA}']
    function GetTitle: string;
    function GetValue: string;
    function GetShort: string;
    procedure SetTitle(const ATitle: string);
    procedure SetValue(const AValue: string);
    procedure SetShort(const AShort: string);

    function ToJSON: TJSONObject;

    property Title: string read GetTitle write SetTitle;
    property Value: string read GetValue write SetValue;
    property Short: string read GetShort write SetShort;
  end;

  IAttachment = interface ['{6C976A99-90F1-4A23-8936-A0E50B5F64B9}']
    function GetFallback: string;
    function GetPretext: string;
    function GetColor: string;
    procedure SetFallback(const AFallback: string);
    procedure SetPretext(const APretext: string);
    procedure SetColor(const AColor: string);
    function GetFields: IFields;

    property Fallback: string read GetFallback write SetFallback;
    property Pretext: string read GetPretext write SetPretext;
    property Color: string read GetColor write SetColor;
    property Fields: IFields read GetFields;

    function ToJSON: TJSONObject;
  end;

  IMessage = interface ['{63E2C097-90FE-4AFB-AD8D-84C2E8E99038}']
    function GetText: string;
    function GetUserName: string;
    function GetIcon_URL: string;
    function GetIcon_Emoji: string;
    function GetChannel: string;
    procedure SetText(const AText: string);
    procedure SetUserName(const AUserName: string);
    procedure SetIcon_URL(const AIcon_URL: string);
    procedure SetIcon_Emoji(const AIcon_Emoji: string);
    procedure SetChannel(const AChannel: string);
    function GetAttachments: TArray<IAttachment>;
    function AddAttachment: IAttachment;

    property Text: string read GetText write SetText;
    property UserName: string read GetUserName write SetUserName;
    property Icon_URL: string read GetIcon_URL write SetIcon_URL;
    property Icon_Emoji: string read GetIcon_Emoji write SetIcon_Emoji;
    property Channel: string read GetChannel write SetChannel;
    property Attachments: TArray<IAttachment> read GetAttachments;

    function ToJSON: TJSONObject;
  end;

  IMessageBuffer = interface ['{607C886E-C336-4D3C-A5C4-B8E82C7FD7DF}']
    procedure Push(const AMessage: IMessage);
    function Pop: IMessage;
    function MessageCount: Integer;
    procedure Flush;
  end;

  TOnErrorProc = TProc<IMessage, Integer, string, string>;
  TOnSuccessProc = TProc<IMessage>;

  IExecutor = interface ['{351093FD-BAEB-4F3A-B371-3BF6C00E17A9}']
    procedure Send(AMessage: IMessage; const AOnSuccess: TOnSuccessProc = nil;
      const AOnError: TOnErrorProc = nil);
  end;


implementation

end.

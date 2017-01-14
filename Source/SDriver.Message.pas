(*
  Copyright 2016, Andrea Magni
  https://github.com/andrea-magni/SDriver
*)
unit SDriver.Message;

interface

uses
  System.JSON
, SDriver.Interfaces, SDriver.Attachment
;

type
  TMessage = class(TInterfacedObject, IMessage)
  private
    FText: string;
    FUserName: string;
    FIcon_URL: string;
    FIcon_Emoji: string;
    FChannel: string;
    FAttachments: TArray<IAttachment>;
  public
    // IMessage
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

    function ToJSON: TJSONObject;

    constructor Create(const AText: string); virtual;
  end;

implementation

{ TMessage }

function TMessage.AddAttachment: IAttachment;
begin
  Result := TAttachment.Create;
  FAttachments := FAttachments + [Result];
end;

constructor TMessage.Create(const AText: string);
begin
  inherited Create;
  SetText(AText);
  FAttachments := [];
end;

function TMessage.GetAttachments: TArray<IAttachment>;
begin
  Result := FAttachments;
end;

function TMessage.GetChannel: string;
begin
  Result := FChannel;
end;

function TMessage.GetIcon_Emoji: string;
begin
  Result := FIcon_Emoji;
end;

function TMessage.GetIcon_URL: string;
begin
  Result := FIcon_URL;
end;

function TMessage.GetText: string;
begin
  Result := FText;
end;

function TMessage.GetUserName: string;
begin
  Result := FUserName;
end;

procedure TMessage.SetChannel(const AChannel: string);
begin
  FChannel := AChannel;
end;

procedure TMessage.SetIcon_Emoji(const AIcon_Emoji: string);
begin
  FIcon_Emoji := AIcon_Emoji;
end;

procedure TMessage.SetIcon_URL(const AIcon_URL: string);
begin
  FIcon_URL := AIcon_URL;
end;

procedure TMessage.SetText(const AText: string);
begin
  FText := AText;
end;

procedure TMessage.SetUserName(const AUserName: string);
begin
  FUserName := AUserName;
end;

function TMessage.ToJSON: TJSONObject;
var
  LAttachment: IAttachment;
  LAttachments: TJSONArray;
begin
  Result := TJSONObject.Create;
  try
    Result.AddPair('text', TJSONString.Create(FText));
    Result.AddPair('username', TJSONString.Create(FUserName));
    Result.AddPair('icon_url', TJSONString.Create(FIcon_URL));
    Result.AddPair('icon_emoji', TJSONString.Create(FIcon_Emoji));
    Result.AddPair('channel', TJSONString.Create(FChannel));
    if Length(FAttachments) > 0 then
    begin
      LAttachments := TJSONArray.Create;
      try
        for LAttachment in FAttachments do
          LAttachments.Add(LAttachment.ToJSON);
      except
        LAttachments.Free;
        raise;
      end;
      Result.AddPair('attachments', LAttachments);
    end;
  except
    Result.Free;
    raise;
  end;
end;

end.

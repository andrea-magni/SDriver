(*
  Copyright 2016, Andrea Magni
  https://github.com/andrea-magni/SlackDriver
*)
unit SlackDriver.Attachment;

interface

uses
  Classes, SysUtils, System.JSON
, SlackDriver.Interfaces, SlackDriver.Fields
;

type
  TAttachment = class(TInterfacedObject, IAttachment)
  private
    FColor: string;
    FFallback: string;
    FPretext: string;
    FFields: IFields;
  public
    function GetColor: string;
    function GetFallback: string;
    function GetPretext: string;
    procedure SetColor(const AColor: string);
    procedure SetFallback(const AFallback: string);
    procedure SetPretext(const APretext: string);
    function GetFields: IFields;

    function ToJSON: TJSONObject;
    constructor Create; virtual;
  end;

implementation

{ TAttachment }

constructor TAttachment.Create;
begin
  inherited Create;
  FFields := TFields.Create;
end;

function TAttachment.GetColor: string;
begin
  Result := FColor;
end;

function TAttachment.GetFallback: string;
begin
  Result := FFallback;
end;

function TAttachment.GetFields: IFields;
begin
  Result := FFields;
end;

function TAttachment.GetPretext: string;
begin
  Result := FPretext;
end;

procedure TAttachment.SetColor(const AColor: string);
begin
  FColor := AColor;
end;

procedure TAttachment.SetFallback(const AFallback: string);
begin
  FFallback := AFallback;
end;

procedure TAttachment.SetPretext(const APretext: string);
begin
  FPretext := APretext;
end;

function TAttachment.ToJSON: TJSONObject;
var
  LFields: TJSONArray;
begin
  Result := TJSONObject.Create;
  Result.AddPair('color', FColor);
  Result.AddPair('pretext', FPretext);
  Result.AddPair('fallback', FFallback);
  if not (FFields.Title.IsEmpty and FFields.Value.IsEmpty and FFields.Short.IsEmpty) then
  begin
    LFields := TJSONArray.Create;
    try
      LFields.Add(FFields.ToJSON);
      Result.AddPair('fields', LFields)
    except
      LFields.Free;
      raise;
    end;
  end;
end;

end.

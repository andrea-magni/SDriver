(*
  Copyright 2016, Andrea Magni
  https://github.com/andrea-magni/SDriver
*)
unit SDriver.Attachment;

interface

uses
  Classes, SysUtils, System.JSON
, SDriver.Interfaces, SDriver.Fields
;

type
  TAttachment = class(TInterfacedObject, IAttachment)
  private
    FColor: string;
    FFallback: string;
    FPretext: string;
    FFields: TArray<IFields>;
  public
    function GetColor: string;
    function GetFallback: string;
    function GetPretext: string;
    procedure SetColor(const AColor: string);
    procedure SetFallback(const AFallback: string);
    procedure SetPretext(const APretext: string);
    function GetFields: TArray<IFields>;
    function AddFields: IFields;

    function ToJSON: TJSONObject;
    constructor Create; virtual;
  end;

implementation

{ TAttachment }

function TAttachment.AddFields: IFields;
begin
  Result := TFields.Create;
  FFields := FFields + [Result];
end;

constructor TAttachment.Create;
begin
  inherited Create;
  FFields := [];
end;

function TAttachment.GetColor: string;
begin
  Result := FColor;
end;

function TAttachment.GetFallback: string;
begin
  Result := FFallback;
end;

function TAttachment.GetFields: TArray<IFields>;
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
  LField: IFields;
begin
  Result := TJSONObject.Create;
  Result.AddPair('color', FColor);
  Result.AddPair('pretext', FPretext);
  Result.AddPair('fallback', FFallback);

  if Length(FFields) > 0 then
  begin
    LFields := TJSONArray.Create;
    try
      for LField in FFields do
        LFields.Add(LField.ToJSON);
      Result.AddPair('fields', LFields)
    except
      LFields.Free;
      raise;
    end;
  end;
end;

end.

(*
  Copyright 2016, Andrea Magni
  https://github.com/andrea-magni/SlackDriver
*)
unit SlackDriver.Fields;

interface

uses
  Classes, SysUtils, System.JSON
, SlackDriver.Interfaces
;

type
  TFields = class(TInterfacedObject, IFields)
  private
    FShort: string;
    FTitle: string;
    FValue: string;
  public
    function GetShort: string;
    function GetTitle: string;
    function GetValue: string;
    procedure SetShort(const AShort: string);
    procedure SetTitle(const ATitle: string);
    procedure SetValue(const AValue: string);

    function ToJSON: TJSONObject;
    constructor Create; virtual;
  end;

implementation

{ TFields }

constructor TFields.Create;
begin
  inherited Create;
end;

function TFields.GetShort: string;
begin
  Result := FShort;
end;

function TFields.GetTitle: string;
begin
  Result := FTitle;
end;

function TFields.GetValue: string;
begin
  Result := FValue;
end;

procedure TFields.SetShort(const AShort: string);
begin
  FShort := AShort;
end;

procedure TFields.SetTitle(const ATitle: string);
begin
  FTitle := ATitle;
end;

procedure TFields.SetValue(const AValue: string);
begin
  FValue := AValue;
end;

function TFields.ToJSON: TJSONObject;
begin
  Result := TJSONObject.Create;
  try
    Result.AddPair('short', FShort);
    Result.AddPair('title', FTitle);
    Result.AddPair('value', FValue);
  except
    Result.Free;
    raise;
  end;
end;

end.

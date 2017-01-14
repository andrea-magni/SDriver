(*
  Copyright 2016, Andrea Magni
  https://github.com/andrea-magni/SDriver
*)
unit SDriver.Fields;

interface

uses
  Classes, SysUtils, System.JSON
, SDriver.Interfaces
;

type
  TFields = class(TInterfacedObject, IFields)
  private
    FShort: Boolean;
    FTitle: string;
    FValue: string;
  public
    function GetShort: Boolean;
    function GetTitle: string;
    function GetValue: string;
    procedure SetShort(const AShort: Boolean);
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

function TFields.GetShort: Boolean;
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

procedure TFields.SetShort(const AShort: Boolean);
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
    Result.AddPair('short', TJSONBool.Create(FShort));
    Result.AddPair('title', FTitle);
    Result.AddPair('value', FValue);
  except
    Result.Free;
    raise;
  end;
end;

end.

(*
  Copyright 2016, Andrea Magni
  https://github.com/andrea-magni/SDriver
*)
unit SDriver.Utils;

interface

uses
  SysUtils
;

type
  TLink = class
  public
    const LINK_PREFIX = '<';
    const LINK_SUFFIX = '>';
    const URL_TEXT_SEPARATOR = '|';
    class function Make(const AURL: string; const ALinkedText: string = ''): string;
  end;

implementation

{ TLink }

class function TLink.Make(const AURL, ALinkedText: string): string;
var
  LLinkedText: string;
begin
  Result := '';
  if not (AURL.IsEmpty and ALinkedText.IsEmpty) then
  begin
    LLinkedText := ALinkedText;
    if not LLinkedText.IsEmpty then
      LLinkedText := URL_TEXT_SEPARATOR + LLinkedText;

    Result := LINK_PREFIX + AURL + LLinkedText + LINK_SUFFIX;
  end;
end;

end.
